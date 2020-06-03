import 'dart:convert';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/trade/order-model.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/models/trade/trade-model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/market_pairs_tab_view.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TradeViewModal extends MultipleStreamViewModel {
  final String tickerName;
  TradeViewModal({this.tickerName});

  final log = getLogger('TradeViewModal');

  BuildContext context;
  NavigationService navigationService = locator<NavigationService>();
  TradeService tradeService = locator<TradeService>();
  ApiService apiService = locator<ApiService>();
  List<PairDecimalConfig> pairDecimalConfigList = [];
  List<OrderModel> orderBookList = [];
  List<TradeModel> marketTradesList = [];
  List myOrders = [];
  Price currentPairPrice;
  List<dynamic> ordersViewTabBody = [];
  bool marketTradeStreamSource = false;

  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];
  @override
  Map<String, StreamData> get streamsMap =>
      tradeService.getMultipleStreams(tickerName);

// Change/update stream data before displaying on UI
  @override
  void onData(String key, data) {
    ordersViewTabBody = [orderBookList, marketTradesList, myOrders];
    log.w('ordersViewTabBody $ordersViewTabBody');
  }

  /// Transform stream data before notifying to view modal
  @override
  dynamic transformData(String key, data) {
    try {
      /// All prices list
      if (key == 'allPrices') {
        List<dynamic> jsonDynamicList = jsonDecode(data) as List;
        PriceList priceList = PriceList.fromJson(jsonDynamicList);
        log.i('pair price list ${priceList.prices.length}');

        pairPriceList = priceList.prices;
        pairPriceList.forEach((element) {
          if (element.change.isNaN) element.change = 0.0;
          if (element.symbol == tickerName) {
            currentPairPrice = element;
          }
        });
        Map<String, dynamic> res =
            tradeService.marketPairPriceGroups(pairPriceList);
        marketPairsTabBar = res['marketPairsGroupList'];
      } // all prices ends

      /// Order list
      else if (key == 'orderBookList') {
        List<dynamic> jsonDynamicList = jsonDecode(data)['buy'] as List;
        log.w('$key $data');
        OrderList orderList = OrderList.fromJson(jsonDynamicList);
        // log.i('pair order list ${orderList.orders}');

        orderBookList = orderList.orders;
        orderBookList.forEach((element) {});
      }

      /// Market trade list
      else if (key == 'marketTradesList') {
        List<dynamic> jsonDynamicList = jsonDecode(data) as List;
        log.i('$key $data');
        TradeList tradeList = TradeList.fromJson(jsonDynamicList);
        marketTradesList = tradeList.trades;
      }
    } catch (err) {
      log.e('Catch error $err');
      log.e('Cancelling $key Stream Subsciption');
      getSubscriptionForKey(key).cancel();
    }
  }

  @override
  void onCancel(String key) {
    log.e('Stream $key closed');
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
  void switchStreams(int index) {
    var marketTradesStream = getSubscriptionForKey('marketTradesList');
    var orderBookStream = getSubscriptionForKey('orderBookList');

    /// if user click on order book tab then check if market trades stream
    /// is running or pause, if not pause then pause it and check if order book
    /// stream is paused, if paused then resume it

    if (index == 0) {
      log.i('marketTradesList status ${marketTradesStream.isPaused}');
      !marketTradesStream.isPaused ?? marketTradesStream.pause();
      log.i('marketTradesList status ${marketTradesStream.isPaused}');
      log.i('orderBookList status ${orderBookStream.isPaused}');
      orderBookStream.isPaused ?? orderBookStream.resume();
      log.i('orderBookList status ${orderBookStream.isPaused}');
    } else if (index == 1) {
      !orderBookStream.isPaused ?? orderBookStream.pause();
      log.i('marketTradesList status ${marketTradesStream.isPaused}');
      marketTradesStream.isPaused ?? marketTradesStream.resume();
    }
  }
}
