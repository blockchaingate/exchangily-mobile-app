import 'dart:convert';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/market_trades/market_trade_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/stoppable_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String _tickerStreamKey = 'ticker';
const String _marketTradesStreamKey = 'marketTradesList';
const String _orderbookStreamKey = 'orderbook';

class TradeViewModel extends MultipleStreamViewModel with StoppableService {
  final Price pairPriceByRoute;
  TradeViewModel({this.pairPriceByRoute});

  final log = getLogger('TradeViewModal');

  BuildContext context;

  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();

  ApiService apiService = locator<ApiService>();
  final TradeService _tradeService = locator<TradeService>();
  WalletService walletService = locator<WalletService>();
  ConfigService configService = locator<ConfigService>();
  List<PairDecimalConfig> pairDecimalConfigList = [];

  //List<Order> buyOrderBookList = [];
  //List<Order> sellOrderBookList = [];
  Orderbook orderbook;

  List<MarketTrades> marketTradesList = [];

  bool get hasStreamTickerData => dataReady(_tickerStreamKey);
  bool get hasStreamMarketTrades => dataReady(_marketTradesStreamKey);
  bool get hasStreamOrderbook => dataReady(_orderbookStreamKey);

  Price currentPairPrice = Price();
  List<dynamic> ordersViewTabBody = [];

  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];

  List myExchangeAssets = [];
  PairDecimalConfig singlePairDecimalConfig = PairDecimalConfig();
  bool isDisposing = false;
  double usdValue = 0.0;
  String pairSymbolWithSlash = '';
  String get interval => _tradeService.interval;

  WebViewController webViewController;
  bool isStreamDataNull = false;
  @override
  Map<String, StreamData> get streamsMap => {
        _tickerStreamKey: StreamData<dynamic>(
            _tradeService.getTickerDataStream(pairPriceByRoute.symbol)),
        _orderbookStreamKey: StreamData<dynamic>(_tradeService
            .getOrderBookStreamByTickerName(pairPriceByRoute.symbol)),
        _marketTradesStreamKey: StreamData<dynamic>(_tradeService
            .getMarketTradesStreamByTickerName(pairPriceByRoute.symbol))
      };
  // Map<String, StreamData> res =
  //     tradeService.getMultipleStreams(pairPriceByRoute.symbol);

  /// Initialize when model ready
  init() async {
    await getDecimalPairConfig();
    //   await getExchangeAssets();
    String holder = updateTickerName(pairPriceByRoute.symbol);
    pairSymbolWithSlash = holder;
    if (pairSymbolWithSlash.split('/')[1] == 'USDT' ||
        pairSymbolWithSlash.split('/')[1] == 'DUSD') {
      usdValue = dataReady('allPrices')
          ? currentPairPrice.price
          : pairPriceByRoute.price;
    } else {
      String tickerWithoutBasePair = pairSymbolWithSlash.split('/')[0];
      usdValue = await apiService
          .getCoinMarketPriceByTickerName(tickerWithoutBasePair);
    }
  }

  @override
  void onSubscribed(String key) {
    log.w('$key Stream subscribed ');
  }

// Change/update stream data before displaying on UI
  @override
  void onData(String key, data) async {
    log.w('On data $data - key $key');

    // if (data == []) {
    //   log.e('in if data $key');
    //   getSubscriptionForKey(key).cancel().then((value) {
    //     if (key == tickerStreamKey)
    //       tradeService
    //           .tickerDataChannel(pairPriceByRoute.symbol, interval: interval)
    //           .sink
    //           .close();
    //     if (key == marketTradesStreamKey)
    //       getSubscriptionForKey(key).cancel().then((value) => tradeService
    //           .marketTradesChannel(pairPriceByRoute.symbol)
    //           .sink
    //           .close());
    //   });
    //   log.e('stream $key and channel closed');
    //   setBusy(false);
    //   return;
    // }
  }

/*----------------------------------------------------------------------
          Transform stream data before notifying to view modal
----------------------------------------------------------------------*/

  @override
  dynamic transformData(String key, dynamic data) {
    log.w('transformData key $key  -- data $data');
    try {
      /// Ticker WS
      if (key == _tickerStreamKey) {
        if (data != null && data != []) {
          var jsonDynamic = jsonDecode(data);
          // log.i('ticker json data $jsonDynamic');
          currentPairPrice = Price.fromJson(jsonDynamic);
        } else {
          log.i('$key Data is null or empty');
        }
        // log.w('TICKER PRICE ${currentPairPrice.toJson()}');

      } else if (key == _orderbookStreamKey) {
        log.w('transformData -- data $data');
        var jsonDynamic = jsonDecode(data);
        orderbook = Orderbook.fromJson(jsonDynamic);
        log.e(
            'OrderBook result  -- ${orderbook.buyOrders.length} ${orderbook.sellOrders.length}');
      }
/*----------------------------------------------------------------------
                    Market trade list
----------------------------------------------------------------------*/

      else if (key == _marketTradesStreamKey) {
        if (data != null && data != []) {
          List<dynamic> jsonDynamicList = jsonDecode(data) as List;
          MarketTradeList tradeList = MarketTradeList.fromJson(jsonDynamicList);
          marketTradesList = tradeList.trades;
        } else {
          log.i('$key Data is null or empty');
        }
      }
    } catch (err) {
      log.e('Catch error $err');
      //   setBusy(true);
      //  isStreamDataNull = true;
      //   closeConnections();
      setBusy(false);
    }
  }

  // @override
  // void dispose() {
  //   debugPrint('dispose $streamsMap');
  //   streamsMap.forEach((key, value) {
  //     //  value.dispose();
  //     getSubscriptionForKey(key).cancel().then((x) {
  //       log.w('$key stream cancelled');
  //       onCancel(key);
  //     });
  //   });
  //   super.dispose();
  // }

/*----------------------------------------------------------------------
                onError
----------------------------------------------------------------------*/
  @override
  void onError(String key, error) {
    log.e('In onError $key $error');
    // getSubscriptionForKey(key).cancel();
    // getSubscriptionForKey(key).resume();
  }

/*----------------------------------------------------------------------
                  On Cancel gets called while disposing
----------------------------------------------------------------------*/
  @override
  void onCancel(String key) {
    // log.e('on cancel Stream $key closed');

    if (key == _tickerStreamKey) {
      getSubscriptionForKey(key).cancel().whenComplete(() {
        log.e('on cancel Stream $key closed');
        _tradeService
            .tickerDataChannel(pairPriceByRoute.symbol)
            .sink
            .close()
            .then((value) => log.i('tickerDataChannel closed'));
      });
    }
    if (key == _marketTradesStreamKey) {
      getSubscriptionForKey(key).cancel().whenComplete(() {
        log.e('on cancel Stream $key closed');
        _tradeService
            .marketTradesChannel(pairPriceByRoute.symbol)
            .sink
            .close()
            .then((value) => log.i('marketTradesChannel closed'));
      });
    }
    if (key == _orderbookStreamKey) {
      getSubscriptionForKey(key).cancel().whenComplete(() {
        log.e('on cancel Stream $key closed');
        _tradeService
            .orderbookChannel(pairPriceByRoute.symbol)
            .sink
            .close()
            .then((value) => log.i('orderbookChannel closed'));
      });
    }
  }

/*----------------------------------------------------------------------
                  Order aggregation
----------------------------------------------------------------------*/

  List<Orderbook> orderAggregation(List<Orderbook> passedOrders) {
    List<Orderbook> result = [];
    debugPrint('passed orders length ${passedOrders.length}');
    double prevQuantity = 0.0;
    List<int> indexArray = [];
    double prevPrice = 0;

    // for each
    for (var currentOrder in passedOrders) {
      debugPrint('single order ${currentOrder.toJson()}');
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
    }
    return result;
  }

/*----------------------------------------------------------------------
                  Get Decimal Pair Configuration
----------------------------------------------------------------------*/

  getDecimalPairConfig() async {
    await sharedService
        .getSinglePairDecimalConfig(pairPriceByRoute.symbol)
        .then((decimalValues) {
      singlePairDecimalConfig = decimalValues;
      log.i(
          'decimal values, quantity: ${singlePairDecimalConfig.qtyDecimal} -- price: ${singlePairDecimalConfig.priceDecimal}');
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
    debugPrint('Pause/Resume streams $index');

    if (index == 0) {
      pauseStream(_marketTradesStreamKey);
      //  getSubscriptionForKey(orderBookStreamKey).resume();
      notifyListeners();
    } else if (index == 1) {
      //  pauseStream(orderBookStreamKey);
      getSubscriptionForKey(_marketTradesStreamKey).resume();
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
    getSubscriptionForKey(_marketTradesStreamKey).pause();
    // getSubscriptionForKey(orderBookStreamKey).pause();
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
    if (!getSubscriptionForKey(key).isPaused) {
      getSubscriptionForKey(key).pause();
    }
    log.i(getSubscriptionForKey(key).isPaused);
  }

  void cancelSingleStreamByKey(String key) {
    var stream = getSubscriptionForKey(key);
    stream.cancel();
    log.e('Stream $key cancelled');
  }

  String updateTickerName(String tickerName) {
    return _tradeService.seperateBasePair(tickerName);
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

  onBackButtonPressed() {
    navigationService.navigateUsingPushReplacementNamed(MarketsViewRoute,
        arguments: false);
  }
}
