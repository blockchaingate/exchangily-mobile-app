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
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/utils/decoder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MarketsViewModel extends StreamViewModel<dynamic> {
  final log = getLogger('MarketsViewModal');

  String errorMessage = '';
  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];
  List<Price> btcFabExgUsdtPriceList = [];
  SharedService sharedService = locator<SharedService>();
  TradeService tradeService = locator<TradeService>();

  final NavigationService navigationService = locator<NavigationService>();
  BuildContext context;
  List<String> tabNames = ['USDT', 'DUSD', 'BTC', 'ETH', 'EXG'];

  @override
  Stream<dynamic> get stream {
    Stream<dynamic> res;

    res = tradeService.getAllCoinPriceStream();
    return res;
  }

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
      pairPriceList = priceList.prices;
      log.w('pair price list length ${pairPriceList.length}');
      pairPriceList.forEach((element) {
        if (element.change.isNaN) element.change = 0.0;
      });
    } catch (err) {
      log.e('transformData Catch error $err');
      print('Cancelling Stream Subsciption');
      streamSubscription.cancel();
    }
  }

  @override
  void onError(error) {
    log.e('In onError $error');
    errorMessage = error.toString();

    sharedService.alertDialog(AppLocalizations.of(context).serverError,
        AppLocalizations.of(context).marketPriceFetchFailed + errorMessage,
        path: '/dashboard', isWarning: false);
  }

  @override
  void onCancel() {
    log.e('Stream closed');
  }

  onBackButtonPressed() async {
    navigationService.navigateUsingpopAndPushedNamed('/dashboard');
  }
}
