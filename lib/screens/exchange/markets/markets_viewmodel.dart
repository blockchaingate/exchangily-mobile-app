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

import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/local_auth_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/stoppable_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MarketsViewModel extends StreamViewModel<dynamic> with StoppableService {
  final log = getLogger('MarketsViewModal');

  String errorMessage = '';
  List<Price> pairPriceList = [];
  List<List<Price>> marketPairsTabBar = [];
  List<Price> btcFabExgUsdtPriceList = [];
  SharedService sharedService = locator<SharedService>();
  TradeService tradeService = locator<TradeService>();
  LocalAuthService localAuthService = locator<LocalAuthService>();
  LocalStorageService storageService = locator<LocalStorageService>();

  final NavigationService navigationService = locator<NavigationService>();
  BuildContext context;
  List<String> tabNames = ['USDT', 'DUSD', 'BTC', 'ETH', 'EXG'];

  @override
  void start() async {
    super.start();
    log.w(
        'market view model starting service -- hasAppGoneInTheBackgroundKey = ${storageService.hasAppGoneInTheBackgroundKey} -- auth in progress ${localAuthService.authInProgress}');

    if (storageService.hasInAppBiometricAuthEnabled) {
      // bool canCheckBiometrics = await localAuthService.canCheckBiometrics();
      if (!storageService.IsCameraOpen) {
        if (!localAuthService.authInProgress &&
            storageService.hasAppGoneInTheBackgroundKey)
          await localAuthService.authenticateApp();
      }
    }
    storageService.hasAppGoneInTheBackgroundKey = false;
    storageService.IsCameraOpen = false;
    // start subscription again
    // if (streamSubscription != null && streamSubscription.isPaused)
    //   streamSubscription.resume();
    // if (streamSubscription != null)
    //   log.w(
    //       'market view model starting service ${streamSubscription.isPaused}');
    // else {
    //   print(streamSubscription);
    // }
  }

  @override
  void stop() async {
    super.stop();
    log.w(' mvm stopping service');
    storageService.hasAppGoneInTheBackgroundKey = true;
    //var isEmptyValue = await stream.isEmpty.then((value) => value);
    //log.e('is empty $isEmptyValue -- is broadcasr ${stream.isBroadcast}');
    // print(streamSubscription);
    // // if (streamSubscription != null && !streamSubscription.isPaused)
    // streamSubscription.pause();

    // if (streamSubscription != null)
    //   log.w('mvm all price closed ${streamSubscription.isPaused}');
    // else {
    //   print(streamSubscription);
    // }
    // cancel stream subscription
  }

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

      log.e(' priceList.prices length before ${priceList.prices.length}');
      List<String> coinsToRemove = [
        'IOST',
        'REPUSDT',
        'WINGSUSDT',
        'INBUSDT',
        'GNOUSDT',
        'GVTUSDT',
        'MTLUSDT',
        'POWRUSDT',
        'ELFUSDT',
        'HOTUSDT'
      ];
      priceList.prices.forEach((t) {
        coinsToRemove.forEach((coin) {
          if (t.symbol.contains(coin)) log.i(t.toJson());
        });
      });

      coinsToRemove.forEach((coin) {
        priceList.prices.removeWhere((item) => item.symbol.contains(coin));
      });
      log.e(' priceList.prices length after ${priceList.prices.length}');
      pairPriceList = priceList.prices;

      // pairPriceList.forEach((element) {
      //   //  print(element.toJson());
      //   if (element.change.isNaN) element.change = 0.0;
      // });
    } catch (err) {
      log.e('transformData Catch error $err');
      print('Cancelling Stream Subsciption');
      streamSubscription.cancel();
    }
  }

  @override
  void onError(error) {
    log.e('In onError $error');
    setBusy(false);
    errorMessage = error.toString();

    sharedService.alertDialog(AppLocalizations.of(context).serverError,
        AppLocalizations.of(context).marketPriceFetchFailed,
        path: DashboardViewRoute, isWarning: false);
  }

  @override
  void onCancel() {
    tradeService
        .getAllPriceChannel()
        .sink
        .close()
        .then((value) => log.i('all prices channel closed'));
  }

  onBackButtonPressed() async {
    navigationService.navigateUsingpopAndPushedNamed(DashboardViewRoute);
  }
}
