import 'dart:convert';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/decimal_config.dart';
import 'package:exchangilymobileapp/models/trade/orderbook_model.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/models/trade/trade-model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TradeViewModel extends MultipleStreamViewModel {
  final Price pairPriceByRoute;
  TradeViewModel({this.pairPriceByRoute});

  final log = getLogger('TradeViewModal');

  BuildContext context;

  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  ApiService apiService = locator<ApiService>();
  TradeService tradeService = locator<TradeService>();
  WalletService walletService = locator<WalletService>();

  List<PairDecimalConfig> pairDecimalConfigList = [];

  //List<Order> buyOrderBookList = [];
  //List<Order> sellOrderBookList = [];
  Orderbook orderbook;

  List<Trade> marketTradesList = [];

  // List<Order> myOrders = [];

  Price currentPairPrice;
  List<dynamic> ordersViewTabBody = [];

  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];
  String allPriceStreamKey = 'allPrices';
  String orderBookStreamKey = 'orderBookList';
  String marketTradesStreamKey = 'marketTradesList';

  List myExchangeAssets = [];
  DecimalConfig singlePairDecimalConfig = new DecimalConfig();
  bool isDisposing = false;

  @override
  Map<String, StreamData> get streamsMap => {
        allPriceStreamKey:
            StreamData<dynamic>(tradeService.getAllCoinPriceStream()),
        orderBookStreamKey: StreamData<dynamic>(tradeService
            .getOrderBookStreamByTickerName(pairPriceByRoute.symbol)),
        marketTradesStreamKey: StreamData<dynamic>(tradeService
            .getMarketTradesStreamByTickerName(pairPriceByRoute.symbol))
      };
  // Map<String, StreamData> res =
  //     tradeService.getMultipleStreams(pairPriceByRoute.symbol);

  @override
  @mustCallSuper
  dispose() async {
    setBusy(true);
    isDisposing = true;
    await tradeService.closeIOWebSocketConnections(pairPriceByRoute.symbol);
    log.i('Close all IOWebsocket connections');
    navigationService.goBack();
    super.dispose();
    isDisposing = false;
    setBusy(false);
  }

  /// Initialize when model ready
  init() async {
    await getDecimalPairConfig();
    await getExchangeAssets();
  }

// Change/update stream data before displaying on UI
  @override
  void onData(String key, data) {
    // orderBook = [buyOrderBookList, sellOrderBookList];
  }

  /// Transform stream data before notifying to view modal
  @override
  dynamic transformData(String key, data) {
    log.e('checking error ${error(key)}');
    try {
      /// All prices list
      if (key == allPriceStreamKey) {
        List<dynamic> jsonDynamicList = jsonDecode(data) as List;
        PriceList priceList = PriceList.fromJson(jsonDynamicList);
        pairPriceList = priceList.prices;
        pairPriceList.forEach((element) {
          if (element.change.isNaN) element.change = 0.0;
          if (element.symbol == pairPriceByRoute.symbol) {
            currentPairPrice = element;
          }
        });
        Map<String, dynamic> res =
            tradeService.marketPairPriceGroups(pairPriceList);
        marketPairsTabBar = res['marketPairsGroupList'];
        // notifyListeners();
      } // all prices ends

      /// Order list
      else if (key == orderBookStreamKey) {
        // Buy order
        var jsonDynamic = jsonDecode(data);
        orderbook = Orderbook.fromJson(jsonDynamic);
        //  OrderList orderList = OrderList.fromJson(jsonDynamicList);
        //  log.e('orderList.orders.length ${orderList.orders.length}');
        //  buyOrderBookList = orderAggregation(orderList.orders);

        // Sell orders
        //  List<dynamic> jsonDynamicSellList = jsonDecode(data)['sell'] as List;
        // OrderList sellOrderList = OrderList.fromJson(jsonDynamicSellList);
        //  List sellOrders = sellOrderList.orders.reversed
        //      .toList(); // reverse sell orders to show the list ascending

        //  sellOrderBookList = orderAggregation(sellOrderList.orders);

        log.w('OrderBook  -- ${orderbook.toJson()}');
      }

      /// Market trade list
      else if (key == marketTradesStreamKey) {
        List<dynamic> jsonDynamicList = jsonDecode(data) as List;
        TradeList tradeList = TradeList.fromJson(jsonDynamicList);
        log.w('trades length ${tradeList.trades.length}');
        marketTradesList = tradeList.trades;
        marketTradesList.forEach((element) {
          //   log.e(element.toJson());
        });
        //  notifyListeners();
      }
    } catch (err) {
      log.e('Catch error $err');
    }
  }

  @override
  void onError(String key, error) {
    log.e('In onError $key $error');
    getSubscriptionForKey(key).cancel();
    getSubscriptionForKey(key).resume();
  }

  @override
  void onCancel(String key) {
    log.e('Stream $key closed');
    // getSubscriptionForKey(key).cancel();
  }

  // Order aggregation

  List<Orderbook> orderAggregation(List<Orderbook> passedOrders) {
    List<Orderbook> result = [];
    print('passed orders length ${passedOrders.length}');
    double prevQuantity = 0.0;
    List<int> indexArray = [];
    double prevPrice = 0;

    // for each
    passedOrders.forEach((currentOrder) {
      print('single order ${currentOrder.toJson()}');
      int index = 0;
      double aggrQty = 0;
      index = passedOrders.indexOf(currentOrder);
      if (currentOrder.price == prevPrice) {
        log.i(
            'price matched with prev price ${currentOrder.price} -- $prevPrice');
        log.w(
            ' currentOrder qty ${currentOrder.orderQuantity} -- prevQuantity $prevQuantity');
        currentOrder.orderQuantity += prevQuantity;
        //  aggrQty = currentOrder.orderQuantity + prevQuantity;
        prevPrice = currentOrder.price;
        log.e(' currentOrder.orderQuantity  ${currentOrder.orderQuantity}');
        indexArray.add(passedOrders.indexOf(currentOrder));
        result.removeWhere((order) => order.price == prevPrice);
        result.add(currentOrder);
      } else {
        prevPrice = currentOrder.price;
        prevQuantity = currentOrder.orderQuantity;
        log.w('price NOT matched so prevprice: $prevPrice');
        result.add(currentOrder);
      }
    });
    return result;
  }

  /// Get Decimal Pair Configuration
  getDecimalPairConfig() async {
    await tradeService
        .getDecimalPairConfig(pairPriceByRoute.symbol)
        .then((decimalValues) {
      singlePairDecimalConfig = decimalValues;
      log.i(
          'decimal values, quantity: ${singlePairDecimalConfig.quantityDecimal} -- price: ${singlePairDecimalConfig.priceDecimal}');
    }).catchError((err) {
      log.e('getDecimalPairConfig $err');
    });
  }

  /// Bottom sheet to show market pair price
  // showBottomSheet() {
  //   showModalBottomSheet(
  //       backgroundColor: Colors.white,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //             width: 200,
  //             height: MediaQuery.of(context).size.height - 50,
  //             child:
  //                 MarketPairsTabView(marketPairsTabBarView: marketPairsTabBar));
  //       });
  // }

  /// Switch Streams
  void switchStreams(int index) async {
    print('Pause/Resume streams $index');

    if (index == 0) {
      pauseStream(marketTradesStreamKey);
      getSubscriptionForKey(orderBookStreamKey).resume();
      notifyListeners();
    } else if (index == 1) {
      pauseStream(orderBookStreamKey);
      getSubscriptionForKey(marketTradesStreamKey).resume();
      notifyListeners();
    } else if (index == 2) {
      pauseAllStreams();
    } else if (index == 3) {
      pauseAllStreams();
      await getExchangeAssets();
    }
  }

  pauseAllStreams() {
    log.e('Stream pause');
    getSubscriptionForKey(marketTradesStreamKey).pause();
    getSubscriptionForKey(orderBookStreamKey).pause();
    notifyListeners();
  }

  resumeAllStreams() {
    log.e('Stream resume');

    getSubscriptionForKey('marketTradesList').resume();
    getSubscriptionForKey('orderBookList').resume();
    notifyListeners();
  }

  pauseStream(String key) {
    // If the subscription is paused more than once,
    // an equal number of resumes must be performed to resume the stream
    log.e(getSubscriptionForKey(key).isPaused);
    if (!getSubscriptionForKey(key).isPaused)
      getSubscriptionForKey(key).pause();
    log.i(getSubscriptionForKey(key).isPaused);
  }

  void cancelSingleStreamByKey(String key) {
    var stream = getSubscriptionForKey(key);
    stream.cancel();
    log.e('Stream $key cancelled');
  }

  String updateTickerName(String tickerName) {
    return tradeService.seperateBasePair(tickerName);
  }

  // getMyOrders() async {
  //   setBusy(true);
  //   String exgAddress = await getExgAddress();
  //   myOrders = await tradeService.getMyOrders(exgAddress);
  //   setBusy(false);
  //   log.w('My orders $myOrders');
  // }

/*-------------------------------------------------------------------------------------
                                Get Exchange Assets
-------------------------------------------------------------------------------------*/

  getExchangeAssets() async {
    //  setBusy(true);
    //  notifyListeners();
    log.e('In get exchange assets');
    setBusyForObject(myExchangeAssets, true);
    String exgAddress = await getExgAddress();
    var res = await runBusyFuture(walletService.assetsBalance(exgAddress));
    log.w('Asset exchange $res');
    if (res != null) myExchangeAssets = res;
    // await walletService.assetsBalance(exgAddress).then((value) {
    //   // log.w('value $value');
    //   myExchangeAssets = value;
    //   // log.w('exchange assets $myExchangeAssets');
    // });
    //  setBusy(false);
    setBusyForObject(myExchangeAssets, false);
  }

  Future<String> getExgAddress() async {
    var exgWallet = await walletDataBaseService.getBytickerName('EXG');
    return exgWallet.address;
  }

  onBackButtonPressed() async {
    navigationService.navigateUsingpopAndPushedNamed('/dashboard');
  }
}
