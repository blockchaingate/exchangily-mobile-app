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

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/material.dart';

class WalletFeaturesViewModel extends BaseState {
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

  List<WalletFeatureName> features = new List();

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
          Icons.layers, 'transactionHistory', Colors.lightBlue),
    ];
  }

  refreshErrDeposit() async {}

  Future getErrDeposit() async {
    var address = await this.sharedService.getExgAddressFromWalletDatabase();
    var result = await walletService.getErrDeposit(address);
    log.i('getErrDeposit $result');
    return result;
  }

  refreshBalance() async {
    setState(ViewState.Busy);
    await walletService
        .coinBalanceByAddress(
            walletInfo.tickerName, walletInfo.address, walletInfo.tokenType)
        .then((data) async {
      if (data != null) {
        log.e('data $data');

        walletBalance = data['balance'];
        double walletLockedBal = data['lockbalance'];
        walletInfo.availableBalance = walletBalance;
        double currentUsdValue = await walletService
            .getCoinMarketPriceByTickerName(walletInfo.tickerName);
        walletService.calculateCoinUsdBalance(
            currentUsdValue, walletBalance, walletLockedBal);
        walletInfo.usdValue = walletService.coinUsdBalance;
      }
        await getExchangeBal();
    }).catchError((err) {
      log.e(err);
      setState(ViewState.Idle);
      throw Exception(err);
    });
    setState(ViewState.Idle);
  }

  // get exchange balance for single coin
  getExchangeBal() async {
    await apiService
        .getSingleCoinExchangeBalance(walletInfo.tickerName)
        .then((res) {
      if (res != null) {
        walletInfo.inExchange = res.unlockedAmount;
        log.w('exchange bal ${walletInfo.inExchange}');
      }
    });
  }
}
