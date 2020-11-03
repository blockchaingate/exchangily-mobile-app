import 'dart:convert';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/decimal_config.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/market_trades/market_trade_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_model.dart';
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

  List<MarketTrades> marketTradesList = [];

  // List<Order> myOrders = [];

  Price currentPairPrice;
  List<dynamic> ordersViewTabBody = [];

  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];
  String allPricesStreamKey = 'allPrices';
  String tickerStreamKey = 'ticker';
  String orderBookStreamKey = 'orderBookList';
  String marketTradesStreamKey = 'marketTradesList';

  List myExchangeAssets = [];
  DecimalConfig singlePairDecimalConfig = new DecimalConfig();
  bool isDisposing = false;
  double usdValue = 0.0;
  String pairSymbolWithSlash = '';

  @override
  Map<String, StreamData> get streamsMap => {
        tickerStreamKey: StreamData<dynamic>(
            tradeService.getTickerDataStream(pairPriceByRoute.symbol)),
        orderBookStreamKey: StreamData<dynamic>(tradeService
            .getOrderBookStreamByTickerName(pairPriceByRoute.symbol)),
        marketTradesStreamKey: StreamData<dynamic>(tradeService
            .getMarketTradesStreamByTickerName(pairPriceByRoute.symbol))
      };
  // Map<String, StreamData> res =
  //     tradeService.getMultipleStreams(pairPriceByRoute.symbol);

  // @override
  // @mustCallSuper
  // dispose() async {
  //   setBusy(true);
  //   isDisposing = true;
  //   await tradeService.closeIOWebSocketConnections(pairPriceByRoute.symbol);
  //   log.i('Close all IOWebsocket connections');
  //   isDisposing = false;
  //   setBusy(false);
  //   navigationService.goBack();
  //   super.dispose();
  // }

  closeConnections() async {
    setBusy(true);
    isDisposing = true;
    await tradeService.closeIOWebSocketConnections(pairPriceByRoute.symbol);
    // log.i('Close all IOWebsocket connections');
    // isDisposing = false;
    // setBusy(false);
  }

  /// Initialize when model ready
  init() async {
    await getDecimalPairConfig();
    //   await getExchangeAssets();
    String holder = updateTickerName(pairPriceByRoute.symbol);
    pairSymbolWithSlash = holder;
    String tickerWithoutBasePair = holder.split('/')[0];
    if (holder.split('/')[1] == 'USDT' || holder.split('/')[1] == 'DUSD') {
      usdValue = dataReady('allPrices')
          ? currentPairPrice.price
          : pairPriceByRoute.price;
    } else {
      usdValue = await apiService
          .getCoinMarketPriceByTickerName(tickerWithoutBasePair);
    }
  }

// Change/update stream data before displaying on UI
  @override
  void onData(String key, data) {
    // orderBook = [buyOrderBookList, sellOrderBookList];
    // cancelSingleStreamByKey(allPricesStreamKey);
  }

/*----------------------------------------------------------------------
          Transform stream data before notifying to view modal
----------------------------------------------------------------------*/

  @override
  dynamic transformData(String key, data) {
    try {
      /// All prices list
      if (key == tickerStreamKey) {
        var jsonDynamic = jsonDecode(data);
        currentPairPrice = Price.fromJson(jsonDynamic);
        log.w('TICKER PRICE ${currentPairPrice.toJson()}');
        // Map<String, dynamic> res =
        //     tradeService.marketPairPriceGroups(pairPriceList);
        // marketPairsTabBar = res['marketPairsGroupList'];
        // notifyListeners();
      } // all prices ends

/*----------------------------------------------------------------------
                        Orderbook
----------------------------------------------------------------------*/

      else if (key == orderBookStreamKey) {
        var jsonDynamic = jsonDecode(data);
        print('Orderbook $jsonDynamic');
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
        log.w(
            'OrderBook result  -- ${orderbook.buyOrders.length} ${orderbook.sellOrders.length}');
      }

/*----------------------------------------------------------------------
                    Market trade list
----------------------------------------------------------------------*/

      else if (key == marketTradesStreamKey) {
        List<dynamic> jsonDynamicList = jsonDecode(data) as List;
        MarketTradeList tradeList = MarketTradeList.fromJson(jsonDynamicList);
        marketTradesList = tradeList.trades;
        marketTradesList.forEach((element) {});
      }
    } catch (err) {
      log.e('Catch error $err');
    }
  }

/*----------------------------------------------------------------------
                onError
----------------------------------------------------------------------*/
  @override
  void onError(String key, error) {
    log.e('In onError $key $error');
    getSubscriptionForKey(key).cancel();
    getSubscriptionForKey(key).resume();
  }

  @override
  void onCancel(String key) {
    log.e('Stream $key closed');
  }

/*----------------------------------------------------------------------
                  Order aggregation
----------------------------------------------------------------------*/

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
            ' currentOrder qty ${currentOrder.quantity} -- prevQuantity $prevQuantity');
        currentOrder.quantity += prevQuantity;
        //  aggrQty = currentOrder.orderQuantity + prevQuantity;
        prevPrice = currentOrder.price;
        log.e(' currentOrder.orderQuantity  ${currentOrder.quantity}');
        indexArray.add(passedOrders.indexOf(currentOrder));
        result.removeWhere((order) => order.price == prevPrice);
        result.add(currentOrder);
      } else {
        prevPrice = currentOrder.price;
        prevQuantity = currentOrder.quantity;
        log.w('price NOT matched so prevprice: $prevPrice');
        result.add(currentOrder);
      }
    });
    return result;
  }

/*----------------------------------------------------------------------
                  Get Decimal Pair Configuration
----------------------------------------------------------------------*/

  getDecimalPairConfig() async {
    await tradeService
        .getSinglePairDecimalConfig(pairPriceByRoute.symbol)
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
      // await getExchangeAssets();
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

  Future<String> getExgAddress() async {
    var exgWallet = await walletDataBaseService.getBytickerName('EXG');
    return exgWallet.address;
  }

  onBackButtonPressed() async {
    navigationService.navigateUsingpopAndPushedNamed('/dashboard');
  }
}
