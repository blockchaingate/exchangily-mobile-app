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
  List<OrderModel> pairOrderList = [];
  List<TradeModel> pairMarketTradeList = [];
  List myOrders = [];
  Price currentPairPrice;
  List<dynamic> ordersViewTabBody = [];

  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];
  @override
  Map<String, StreamData> get streamsMap =>
      tradeService.getMultipleStreams(tickerName);

// Change/update stream data before displaying on UI
  @override
  void onData(String key, data) {
    ordersViewTabBody = [pairOrderList, pairMarketTradeList, myOrders];
    log.w(ordersViewTabBody);
  }

  /// Transform stream data before notifying to view modal
  @override
  dynamic transformData(String key, data) {
    try {
      /// Order list
      if (key == 'orderList') {
        List<dynamic> jsonDynamicList = jsonDecode(data)['buy'] as List;
        log.e('order $data');
        OrderList orderList = OrderList.fromJson(jsonDynamicList);
        // log.i('pair order list ${orderList.orders}');

        pairOrderList = orderList.orders;
        pairOrderList.forEach((element) {});
      }

      /// Market trade list
      else if (key == 'marketTradeList') {
        List<dynamic> jsonDynamicList = jsonDecode(data) as List;
        log.e('TRADE list d $jsonDynamicList');
        TradeList tradeList = TradeList.fromJson(jsonDynamicList);
        pairMarketTradeList = tradeList.trades;
      }

      /// All prices list
      else if (key == 'allPrices') {
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
      }
    } catch (err) {
      log.e('Catch error $err');
      log.e('Cancelling $key Stream Subsciption');

      /// cancel stream subcription
      getSubscriptionForKey(key).cancel();
    }
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

  @override
  void onCancel(String key) {
    log.e('Stream $key closed');
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
}
