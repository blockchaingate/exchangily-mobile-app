import 'dart:convert';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/trade/order-model.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/pairs/market_pairs_tab_view.dart';
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

  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];
  @override
  Map<String, StreamData> get streamsMap =>
      tradeService.getMultipleStreams(tickerName);

// Change/update stream data before displaying on UI
  @override
  void onData(String key, data) {
    if (key == 'allPrices') {}
  }

  /// Transform stream data before notifying to view modal
  @override
  dynamic transformData(String key, data) {
    log.i('Transform data');
    log.i(key);
    log.w(data);
    try {
      if (key == 'orderList') {
        List<dynamic> jsonDynamicList = jsonDecode(data)['buy'] as List;
        log.i(jsonDynamicList);
        OrderList orderList = OrderList.fromJson(jsonDynamicList);
        log.i('pair price list ${orderList.orders.length}');

        pairOrderList = orderList.orders;
        pairOrderList.forEach((element) {});
      } else if (key == 'tradeList') {
      } else if (key == 'allPrices') {
        List<dynamic> jsonDynamicList = jsonDecode(data) as List;
        //   log.i(jsonDynamicList.length);
        PriceList priceList = PriceList.fromJson(jsonDynamicList);
        log.i('pair price list ${priceList.prices.length}');

        pairPriceList = priceList.prices;
        pairPriceList.forEach((element) {
          if (element.change.isNaN) element.change = 0.0;
          //  log.w("Change after${element.symbol} ${element.change}");
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
              height: 500,
              child: MarketPairsTabView(marketPairsTabBar: marketPairsTabBar));
        });
  }
}
