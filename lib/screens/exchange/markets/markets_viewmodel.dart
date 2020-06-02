/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'dart:async';
import 'dart:convert';

import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/utils/decoder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MarketsViewModal extends StreamViewModel<dynamic> {
  final log = getLogger('MarketsViewModal');
  bool isError = false;
  String errorMessage = '';
  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];
  List<Price> btcFabExgUsdtPriceList = [];
  SharedService sharedService = locator<SharedService>();
  TradeService tradeService = locator<TradeService>();
  BuildContext context;
  List<String> tabNames = ['USDT', 'DUSD', 'BTC', 'ETH', 'EXG'];

  @override
  Stream<dynamic> get stream => tradeService.getAllCoinPriceByWebSocket();

  @override
  void onData(data) {
    Map<String, dynamic> res =
        tradeService.marketPairPriceGroups(pairPriceList);
    marketPairsTabBar = res['marketPairsGroupList'];
    btcFabExgUsdtPriceList = res['btcFabExgUsdtPriceList'];
  }

  @override
  transformData(data) {
    try {
      List<dynamic> jsonDynamicList = jsonDecode(data) as List;
      PriceList priceList = PriceList.fromJson(jsonDynamicList);
      log.i('pair price list ${priceList.prices.length}');
      pairPriceList = priceList.prices;
      pairPriceList.forEach((element) {
        if (element.change.isNaN) element.change = 0.0;
      });
      isError = false;
    } catch (err) {
      log.e('Catch error $err');
      print('Cancelling Stream Subsciption');
      streamSubscription.cancel();
      isError = true;
      error != null
          ? errorMessage = error.message
          : errorMessage = err.toString();
    }
  }

  @override
  void onError(error) {
    log.e('In onError $error');
    sharedService.alertDialog(AppLocalizations.of(context).serverError,
        AppLocalizations.of(context).marketPriceFetchFailed,
        path: '/dashboard', isWarning: false);
    setBusy(false);
  }

  @override
  void onCancel() {
    log.e('Stream closed');
  }
}
