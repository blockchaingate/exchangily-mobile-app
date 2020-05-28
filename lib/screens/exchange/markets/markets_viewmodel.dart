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
  List<Price> pairPriceDetails = [];
  List<List<Price>> marketPairsTabBar = [];
  List<Price> btcFabExgUsdtPriceList = [];
  SharedService sharedService = locator<SharedService>();
  BuildContext context;

  @override
  Stream<dynamic> get stream =>
      locator<TradeService>().getAllCoinPriceByWebSocket();

  @override
  void onData(data) {
    List<List<Price>> marketPairsGroupList = [];
    List<Price> usdtPairsList = [];
    btcFabExgUsdtPriceList = [];
    List<Price> dusdPairsList = [];
    List<Price> btcPairsList = [];
    List<Price> ethPairsList = [];
    List<Price> exgPairsList = [];
    for (var pair in pairPriceDetails) {
      if (pair.symbol.endsWith("USDT")) {
        if (pair.symbol == 'BTCUSDT' ||
            pair.symbol == 'FABUSDT' ||
            pair.symbol == 'EXGUSDT') btcFabExgUsdtPriceList.add(pair);
        pair.symbol = pair.symbol.replaceAll('USDT', '/USDT');
        usdtPairsList.add(pair);
      } else if (pair.symbol.endsWith("DUSD")) {
        pair.symbol = pair.symbol.replaceAll('DUSD', '/DUSD');
        dusdPairsList.add(pair);
      } else if (pair.symbol.endsWith("BTC")) {
        pair.symbol = pair.symbol.replaceAll('BTC', '/BTC');
        btcPairsList.add(pair);
      } else if (pair.symbol.endsWith("ETH")) {
        pair.symbol = pair.symbol.replaceAll('ETH', '/ETH');
        ethPairsList.add(pair);
      } else if (pair.symbol.endsWith("EXG")) {
        pair.symbol = pair.symbol.replaceAll('EXG', '/EXG');
        exgPairsList.add(pair);
      }
    }
    marketPairsGroupList.add(usdtPairsList);
    marketPairsGroupList.add(dusdPairsList);
    marketPairsGroupList.add(btcPairsList);
    marketPairsGroupList.add(ethPairsList);
    marketPairsGroupList.add(exgPairsList);
    marketPairsTabBar = marketPairsGroupList;
  }

  @override
  transformData(data) {
    // coinPriceDetails = Decoder.fromJsonArray(data);
    // setBusy(true);
    try {
      List<dynamic> jsonDynamicList = jsonDecode(data) as List;
      //   log.i(jsonDynamicList.length);
      PriceList priceList = PriceList.fromJson(jsonDynamicList);
      // print('price list ${priceList.prices.length}');

      pairPriceDetails = priceList.prices;
      pairPriceDetails.forEach((element) {
        //  log.w("Price ${element.toJson()}");
      });
      isError = false;
      // setBusy(false);
    } catch (err) {
      log.e('Catch error $err');
      print('Cancelling Stream Subsciption');
      streamSubscription.cancel();
      isError = true;
      error != null
          ? errorMessage = error.message
          : errorMessage = err.toString();
      //  setBusy(false);
      // throw Exception('$err');
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
