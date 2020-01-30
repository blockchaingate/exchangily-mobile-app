/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Class Name: DashboardScreenState
*
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'dart:convert';
import 'package:exchangilymobileapp/services/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';

class DashboardScreenState extends BaseState {
  final log = getLogger('DahsboardScreenState');
  List<WalletInfo> walletInfo;
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  WalletDataBaseService databaseService = locator<WalletDataBaseService>();
  final double elevation = 5;
  double totalUsdBalance = 0;
  double coinUsdBalance;
  double gasAmount = 0;
  String exgAddress = '';
  List<double> assetsInExchange = [];
  String wallets;
  List walletInfoCopy = [];
  BuildContext context;

  final wallet = WalletInfo(
      name: 'bitcoin',
      tickerName: 'BTC',
      tokenType: '',
      address: 'fasdgasghasfdhgafhafh',
      availableBalance: 45767,
      lockedBalance: 236526.034,
      assetsInExchange: 12234);

  initDb() {
    databaseService.initDb();
  }

  deleteDb() async {
    var res = await databaseService.deleteDb();
    log.e(res);
  }

  deleteWallet() async {
    await databaseService.deleteWallet(1);
  }

  closeDB() async {
    await databaseService.closeDb();
  }

  create() async {
    var res = await databaseService.insert(wallet);
    log.w(res);
  }

  udpate() async {
    //  await databaseService.update(test);
  }

  getAll() {
    databaseService.getAll();
  }

  calcTotalBal(numberOfCoins) {
    totalUsdBalance = 0;
    for (var i = 0; i < numberOfCoins; i++) {
      log.e(walletInfo[i].usdValue);
      totalUsdBalance = totalUsdBalance + walletInfo[i].usdValue;
      log.i('Total ${totalUsdBalance.toStringAsFixed(2)}');
    }
    setState(ViewState.Idle);
  }

  getGas() async {
    setState(ViewState.Busy);
    for (var i = 0; i < walletInfo.length; i++) {
      String tName = walletInfo[i].tickerName;
      if (tName == 'EXG') {
        exgAddress = walletInfo[i].address;
        gasAmount = await walletService.gasBalance(exgAddress);
        log.w(gasAmount);
        setState(ViewState.Idle);
        return gasAmount;
      }
    }
    setState(ViewState.Idle);
  }

  // Retrive Wallets Object From Storage

  retrieveWallets() async {
    setState(ViewState.Busy);
    await databaseService.getAll().then((res) {
      walletInfo = res;
      calcTotalBal(walletInfo.length);
      walletInfoCopy = walletInfo.map((element) => element).toList();
      log.w('wallet info ${walletInfo.length}');
      setState(ViewState.Idle);
    }).catchError((error) {
      log.e('Catch Error $error');
      setState(ViewState.Idle);
    });
  }

  /* Get Exchange Assets */

  getExchangeAssets() async {
    setState(ViewState.Busy);
    assetsInExchange.clear();
    var res = await walletService.assetsBalance(exgAddress);
    var length = res.length;
    for (var i = 0; i < length; i++) {
      String coin = res[i]['coin'];
      for (var j = 0; j < length; j++) {
        if (coin == walletInfo[j].tickerName)
          walletInfo[j].assetsInExchange = res[i]['amount'];
      }
    }
    for (int i = 0; i < walletInfo.length; i++) {
      await databaseService.update(walletInfo[i]);
      await databaseService.getById(walletInfo[i].id);
    }
    walletInfoCopy = walletInfo.map((element) => element).toList();
    setState(ViewState.Idle);
  }

  Future refreshBalance() async {
    setState(ViewState.Busy);
    // Make a copy of walletInfo as after refresh its count doubled so this way we seperate the UI walletinfo from state
    walletInfoCopy = walletInfo.map((element) => element).toList();
    int length = walletInfoCopy.length;
    List<String> coinTokenType = walletService.tokenType;
    walletInfo.clear();
    double walletBal = 0;
    double walletLockedBal = 0;
    for (var i = 0; i < length; i++) {
      int id = i + 1;
      String tickerName = walletInfoCopy[i].tickerName;
      String address = walletInfoCopy[i].address;
      String name = walletInfoCopy[i].name;
      await walletService
          .coinBalanceByAddress(tickerName, address, coinTokenType[i])
          .then((balance) async {
        walletBal = balance['balance'];
        walletLockedBal = balance['lockbalance'];
        double marketPrice = await walletService.getCoinMarketPrice(name);
        coinUsdBalance =
            walletService.calculateCoinUsdBalance(marketPrice, walletBal);
        WalletInfo wi = WalletInfo(
            id: id,
            tickerName: tickerName,
            tokenType: coinTokenType[i],
            address: address,
            availableBalance: walletBal,
            lockedBalance: walletLockedBal,
            usdValue: coinUsdBalance,
            name: name);
        walletInfo.add(wi);
        // await databaseService.update(wi);
      }).catchError((error) {
        log.e('Something went wrong  - $error');
      });
    }
    calcTotalBal(length);
    await getGas();
    await getExchangeAssets();
    setState(ViewState.Idle);
    return walletInfo;
  }

  onBackButtonPressed() async {
    sharedService.context = context;
    await sharedService.closeApp();
  }
}
