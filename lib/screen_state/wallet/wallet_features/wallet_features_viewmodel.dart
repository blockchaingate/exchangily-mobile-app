/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com, ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/environments/coins.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';

class WalletFeaturesViewModel extends BaseViewModel {
  final log = getLogger('WalletFeaturesViewModel');

  WalletInfo walletInfo;
  WalletService walletService = locator<WalletService>();
  ApiService apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  NavigationService navigationService = locator<NavigationService>();
  DialogService dialogService = locator<DialogService>();

  final double elevation = 5;
  double containerWidth = 150;
  double containerHeight = 115;
  double walletBalance;
  BuildContext context;
  var errDepositItem;
  String specialTicker = '';
  PairDecimalConfig singlePairDecimalConfig = new PairDecimalConfig();
  List<WalletFeatureName> features = new List();

  init() {
    getWalletFeatures();
    getErrDeposit();
    specialTicker = walletService.updateSpecialTokensTickerNameForTxHistory(
        walletInfo.tickerName)["tickerName"];
    log.i('wi object to check name ${walletInfo.toJson()}');
    refreshBalance();
  }

  getDecimalData() async {
    setBusy(true);
    singlePairDecimalConfig =
        await sharedService.getSinglePairDecimalConfig(walletInfo.tickerName);
    log.i('singlePairDecimalConfig ${singlePairDecimalConfig.toJson()}');
    setBusy(false);
  }

  getWalletFeatures() {
    return features = [
      WalletFeatureName(AppLocalizations.of(context).receive,
          Icons.arrow_downward, 'receive', Colors.redAccent),
      WalletFeatureName(AppLocalizations.of(context).send, Icons.arrow_upward,
          'send', Colors.lightBlue),
      // move and trade = move to exchange
      WalletFeatureName(AppLocalizations.of(context).moveAndTrade,
          Icons.equalizer, 'deposit', Colors.purple),
      // withdraw to wallet  = move to wallet
      WalletFeatureName(AppLocalizations.of(context).withdrawToWallet,
          Icons.exit_to_app, 'withdraw', Colors.cyan),
      WalletFeatureName(AppLocalizations.of(context).confirmDeposit,
          Icons.vertical_align_bottom, 'redeposit', Colors.redAccent),
      WalletFeatureName(AppLocalizations.of(context).smartContract,
          Icons.layers, 'smartContract', Colors.lightBlue),
      WalletFeatureName(AppLocalizations.of(context).transactionHistory,
          Icons.history, TransactionHistoryViewRoute, Colors.lightBlue),
    ];
  }

  Future getErrDeposit() async {
    var address = await this.sharedService.getExgAddressFromWalletDatabase();
    await walletService.getErrDeposit(address).then((result) {
      if (result != null) {
        for (var i = 0; i < result.length; i++) {
          var item = result[i];
          var coinType = item['coinType'];
          String tickerNameByCointype = newCoinTypeMap[coinType];
          log.w('tickerNameByCointype $tickerNameByCointype');
          if (tickerNameByCointype == walletInfo.tickerName) {
            setBusy(true);
            errDepositItem = item;
            log.w('err deposit item $errDepositItem');
            setBusy(false);
            break;
          }
        }

        log.i('getErrDeposit $result');
      }
    });
  }

  refreshBalance() async {
    setBusy(true);

    String fabAddress = await sharedService.getFABAddressFromWalletDatabase();
    //  await getExchangeBal();
    await apiService
        .getSingleWalletBalance(
            fabAddress, walletInfo.tickerName, walletInfo.address)
        .then((walletBalance) async {
      log.e(walletBalance[0].coin);
      var availableBalance = walletBalance[0].balance;
      walletInfo.availableBalance = availableBalance;
      var lockedBalance = walletBalance[0].lockBalance;
      walletInfo.lockedBalance = lockedBalance;
      if (!specialTicker.contains('('))
        walletInfo.inExchange = walletBalance[0].unlockedExchangeBalance;
      else
        await getExchangeBalForSpecialTokens();
      double currentUsdValue = walletBalance[0].usdValue.usd;
      log.e(
          'market price $currentUsdValue -- available bal $availableBalance -- inExchange ${walletInfo.inExchange} -- locked bal $lockedBalance');
      walletInfo.usdValue = walletService.calculateCoinUsdBalance(
          currentUsdValue, availableBalance, lockedBalance);
      log.w(walletInfo.toJson());
    })
        // await walletService
        //     .coinBalanceByAddress(
        //         walletInfo.tickerName, walletInfo.address, walletInfo.tokenType)
        //     .then((data) async {
        //   if (data != null) {
        //     log.e('data $data');

        //     walletBalance = data['tokenBalanceIe18'];
        //     double walletLockedBal = data['lockbalance'];
        //     walletInfo.availableBalance = walletBalance;
        //     double currentUsdValue = await walletService
        //         .getCoinMarketPriceByTickerName(walletInfo.tickerName);
        //     walletService.calculateCoinUsdBalance(
        //         currentUsdValue, walletBalance, walletLockedBal);
        //     walletInfo.usdValue = walletService.coinUsdBalance;
        //   }
        //   await getExchangeBal();
        // })
        .catchError((err) {
      log.e(err);
      setBusy(false);
      throw Exception(err);
    });
    setBusy(false);
  }

  // get exchange balance for single coin
  getExchangeBalForSpecialTokens() async {
    String tickerName = '';
    if (walletInfo.tickerName == 'DSCE' || walletInfo.tickerName == 'DSC') {
      tickerName = 'DSC';
    } else if (walletInfo.tickerName == 'BSTE' ||
        walletInfo.tickerName == 'BST') {
      tickerName = 'BST';
    } else if (walletInfo.tickerName == 'FABE' ||
        walletInfo.tickerName == 'FAB') {
      tickerName = 'FAB';
    } else if (walletInfo.tickerName == 'EXGE' ||
        walletInfo.tickerName == 'EXG') {
      tickerName = 'EXG';
    } else if (walletInfo.tickerName == 'USDT') {
      tickerName = 'USDT';
    } else if (walletInfo.tickerName == 'USDTX') {
      tickerName = 'USDT';
    } else
      tickerName = walletInfo.tickerName;
    await apiService.getSingleCoinExchangeBalance(tickerName).then((res) {
      if (res != null) {
        walletInfo.inExchange = res.unlockedAmount;
        log.w('exchange bal ${walletInfo.inExchange}');
      }
    });
  }
}
