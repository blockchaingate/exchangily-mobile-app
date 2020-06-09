import 'dart:convert';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/trade/order-model.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/models/trade/trade-model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/market_pairs_tab_view.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TradeViewModel extends MultipleStreamViewModel {
  final Price pairPriceByRoute;
  TradeViewModel({this.pairPriceByRoute});

  final log = getLogger('TradeViewModal');

  BuildContext context;

  NavigationService navigationService = locator<NavigationService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  ApiService apiService = locator<ApiService>();
  TradeService tradeService = locator<TradeService>();

  List<PairDecimalConfig> pairDecimalConfigList = [];
  List<OrderModel> buyOrderBookList = [];
  List<OrderModel> sellOrderBookList = [];
  List orderBook = [];
  List<TradeModel> marketTradesList = [];
  List<OrderModel> myOrders = [];
  Price currentPairPrice;
  List<dynamic> ordersViewTabBody = [];
  bool marketTradeStreamSource = false;
  List<String> tabNames = ['Order Book', 'Market Trades', 'My Orders'];

  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];
  String allPriceStreamKey = 'allPrices';
  String orderBookStreamKey = 'orderBookList';
  String marketTradesStreamKey = 'marketTradesList';
  @override
  Map<String, StreamData> get streamsMap => {
        'allPrices': StreamData<dynamic>(tradeService.getAllCoinPriceStream()),
        'orderBookList': StreamData<dynamic>(
            tradeService.getOrdersStreamByTickerName(pairPriceByRoute.symbol)),
        'marketTradesList': StreamData<dynamic>(tradeService
            .getMarketTradesStreamByTickerName(pairPriceByRoute.symbol))
      };
  // Map<String, StreamData> res =
  //     tradeService.getMultipleStreams(pairPriceByRoute.symbol);

// Change/update stream data before displaying on UI
  @override
  void onData(String key, data) {
    if (hasError(key)) onCancel(key);
  }

  /// Transform stream data before notifying to view modal
  @override
  dynamic transformData(String key, data) {
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
        log.e('pair price length ${priceList.prices.length}');
        Map<String, dynamic> res =
            tradeService.marketPairPriceGroups(pairPriceList);
        marketPairsTabBar = res['marketPairsGroupList'];
      } // all prices ends

      /// Order list
      else if (key == orderBookStreamKey) {
        // Buy order
        List<dynamic> jsonDynamicList = jsonDecode(data)['buy'] as List;
        //  log.w('OrderBook jsonDynamicList length ${jsonDynamicList}');
        OrderList orderList = OrderList.fromJson(jsonDynamicList);
        buyOrderBookList = orderList.orders;

        // Sell orders
        List<dynamic> jsonDynamicSellList = jsonDecode(data)['sell'] as List;
        OrderList sellOrderList = OrderList.fromJson(jsonDynamicSellList);
        sellOrderBookList = sellOrderList.orders;

        // Fill orderBook list
        orderBook = [buyOrderBookList, sellOrderBookList];
      }

      /// Market trade list
      else if (key == marketTradesStreamKey) {
        List<dynamic> jsonDynamicList = jsonDecode(data) as List;
        TradeList tradeList = TradeList.fromJson(jsonDynamicList);
        log.w('trades length ${tradeList.trades.length}');
        marketTradesList = tradeList.trades;
      }
    } catch (err) {
      log.e('Catch error $err');
    }
  }

  @override
  void onError(String key, error) {
    log.e('In onError $key $error');
    getSubscriptionForKey(key).cancel();
  }

  @override
  void onCancel(String key) {
    log.e('Stream $key closed');
    getSubscriptionForKey(key).cancel();
  }

  /// Initialize when model ready
  init() {
    getDecimalPairConfig();
  }

  /// Get Decimal Pair Configuration
  getDecimalPairConfig() async {
    await apiService.getPairDecimalConfig().then((res) {
      pairDecimalConfigList = res;
    });
    print(pairDecimalConfigList.length);
  }

  /// Bottom sheet to show market pair price
  showBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return Container(
              width: 200,
              height: MediaQuery.of(context).size.height - 50,
              child: MarketPairsTabView(marketPairsTabBar: marketPairsTabBar));
        });
  }

  /// Switch Streams
  void switchStreams(int index) async {
    print('in switch streams trade view model $index');
    var marketTradesStream = getSubscriptionForKey('marketTradesList');
    var orderBookStream = getSubscriptionForKey('orderBookList');

    /// if user click on order book tab then check if market trades stream
    /// is running or pause, if not pause then pause it and check if order book
    /// stream is paused, if paused then resume it

    if (index == 0) {
      marketTradesStream.pause();
      orderBookStream.resume();
    } else if (index == 1) {
      orderBookStream.pause();
      marketTradesStream.resume();
    } else if (index == 2) {
      orderBookStream.pause();
      marketTradesStream.pause();
      // await getMyOrders();
    }
  }

  void pauseAllStreams() {
    getSubscriptionForKey('marketTradesList').pause();
    getSubscriptionForKey('orderBookList').pause();
    log.i('market trades and order book stream paused');
  }

  void resumeAllStreams() {
    getSubscriptionForKey('marketTradesList').resume();
    getSubscriptionForKey('orderBookList').resume();
    log.i('market trades and order book stream resumed');
  }

  void cancelSingleStreamByKey(String key) {
    var stream = getSubscriptionForKey(key);
    stream.cancel();
    log.e('Stream $key cancelled');
  }

  String updateTickerName(String tickerName) {
    return tradeService.seperateBasePair(tickerName);
  }

  getMyOrders() async {
    setBusy(true);
    String exgAddress = await getExgAddress();
    myOrders = await tradeService.getMyOrders(exgAddress);
    setBusy(false);
    log.w('My orders $myOrders');
  }

  Future<String> getExgAddress() async {
    var exgWallet = await walletDataBaseService.getBytickerName('EXG');
    return exgWallet.address;
  }
}
