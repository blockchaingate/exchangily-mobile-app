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

import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../environments/coins.dart' as coinList;

class WalletDashboardScreenState extends BaseState {
  final log = getLogger('WalletDahsboardScreenState');
  List<WalletInfo> walletInfo;
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  ApiService apiService = locator<ApiService>();
  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
  final double elevation = 5;
  double totalUsdBalance = 0;
  double coinUsdBalance;
  double gasAmount = 0;
  String exgAddress = '';
  String wallets;
  List walletInfoCopy = [];
  BuildContext context;
  bool isHideSmallAmountAssets = false;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isConfirmDeposit = false;
  WalletInfo confirmDepositCoinWallet;
  List<PairDecimalConfig> pairDecimalConfigList = [];

  init() async {
    await refreshBalance();
    await getConfirmDepositStatus();
    showDialogWarning();
    await getDecimalPairConfig();
  }

// Get decimal pair config
  getDecimalPairConfig() async {
    await apiService.getPairDecimalConfig().then((res) {
      pairDecimalConfigList = res;
    });
    log.w(pairDecimalConfigList.length);
  }

  // Pull to refresh
  void onRefresh() async {
    await refreshBalance();
    refreshController.refreshCompleted();
  }

// Hide Small Amount Assets

  hideSmallAmountAssets() {
    setState(ViewState.Busy);
    isHideSmallAmountAssets = !isHideSmallAmountAssets;
    setState(ViewState.Idle);
  }

// Calculate Total Usd Balance of Coins
  calcTotalBal(numberOfCoins) {
    totalUsdBalance = 0;
    for (var i = 0; i < numberOfCoins; i++) {
      totalUsdBalance = totalUsdBalance + walletInfo[i].usdValue;
    }
    setState(ViewState.Idle);
  }

  // Get EXG address from wallet database
  Future<String> getExgAddressFromWalletDatabase() async {
    String address = '';
    await walletDatabaseService
        .getBytickerName('EXG')
        .then((res) => address = res.address);
    return address;
  }

  getGas() async {
    String address = await getExgAddressFromWalletDatabase();
    await walletService
        .gasBalance(address)
        .then((data) => gasAmount = data)
        .catchError((onError) => log.e(onError));

    return gasAmount;
  }

  // Get Confirm deposit err
  getConfirmDepositStatus() async {
    String address = await walletService.getExgAddress();
    await walletService.getErrDeposit(address).then((res) async {
      log.w('getConfirmDepositStatus $res');
      if (res != null) {
        if (res.length <= 0) return;
        var singleTransaction = res[0];
        //  log.e('1 $singleTransaction');
        int coinType = singleTransaction['coinType'];

        //  log.w('2 $coinType');
        isConfirmDeposit = true;
        String name = coinList.coin_list[coinType]['name'];
        //  log.e(name);
        await walletDatabaseService.getBytickerName(name).then((res) {
          if (res != null) {
            confirmDepositCoinWallet = res;
          }
        });
      }
    });
  }

  // Show dialog warning

  showDialogWarning() {
    if (gasAmount < 0.5) {
      sharedService.getDialogWarningsStatus().then((value) {
        {
          if (value)
            sharedService.alertDialog(
                AppLocalizations.of(context).insufficientGasAmount,
                AppLocalizations.of(context).pleaseAddGasToTrade);
        }
      });
    }
    if (isConfirmDeposit) {
      sharedService.getDialogWarningsStatus().then((value) {
        if (value)
          sharedService.alertDialog(
              AppLocalizations.of(context).pendingConfirmDeposit,
              '${AppLocalizations.of(context).pleaseConfirmYour} ${confirmDepositCoinWallet.tickerName} ${AppLocalizations.of(context).deposit}',
              path: '/walletFeatures',
              arguments: confirmDepositCoinWallet);
      });
    }
  }

  // Retrive Wallets Object From Storage

  retrieveWallets() async {
    setState(ViewState.Busy);
    await walletDatabaseService.getAll().then((res) {
      walletInfo = res;
      calcTotalBal(walletInfo.length);
      walletInfoCopy = walletInfo.map((element) => element).toList();
      setState(ViewState.Idle);
    }).catchError((error) {
      log.e('Catch Error $error');
      setState(ViewState.Idle);
    });
  }

/*-------------------------------------------------------------------------------------
                          Refresh Balances
-------------------------------------------------------------------------------------*/

  Future refreshBalance() async {
    setState(ViewState.Busy);
    // Make a copy of walletInfo as after refresh its count doubled so this way we seperate the UI walletinfo from state
    // also copy wallet keep the previous balance when loading shows shimmers instead of blank screen or zero bal
    await getGas();
    int length = walletInfoCopy.length;
    List<String> coinTokenType = walletService.tokenType;
    walletInfo.clear();
    double walletBal = 0.0;
    double walletLockedBal = 0.0;

    // For loop starts
    for (var i = 0; i < length; i++) {
      int id = i + 1;

      String tickerName = walletInfoCopy[i].tickerName;
      String address = walletInfoCopy[i].address;
      String name = walletInfoCopy[i].name;
      // Get coin balance by address
      await walletService
          .coinBalanceByAddress(tickerName, address, coinTokenType[i])
          .then((balance) async {
        log.e('bal $balance');
        walletBal = balance['balance'];
        // walletLockedBal = balance['lockbalance'];
      }).timeout(Duration(seconds: 25), onTimeout: () async {
        setState(ViewState.Idle);
        sharedService.alertDialog(
            '', AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater);
        await retrieveWallets();
        log.e('Timeout');
      }).catchError((error) async {
        setState(ViewState.Idle);
        sharedService.alertDialog(
            '', AppLocalizations.of(context).genericError);
        await retrieveWallets();
        log.e('Something went wrong  - $error');
      });

      // Get coin market price by name
      // double marketPrice = await walletService.getCoinMarketPrice(name);

      // // Calculate usd balance
      // coinUsdBalance = walletService.calculateCoinUsdBalance(
      //     marketPrice, walletBal, walletLockedBal);
      // Adding each coin details in the wallet
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
    } // For loop ends

    bool hasDUSD = false;
    String exgAddress = '';
    String exgTokenType = '';

    for (var i = 0; i < walletInfo.length; i++) {
      String tickerName = walletInfo[i].tickerName;
      if (tickerName == 'DUSD') {
        hasDUSD = true;
      }
      if (tickerName == 'EXG') {
        exgAddress = walletInfo[i].address;
        exgTokenType = walletInfo[i].tokenType;
      }
    }
    if (!hasDUSD) {
      var dusdWalletInfo = new WalletInfo(
          tickerName: 'DUSD',
          tokenType: exgTokenType,
          address: exgAddress,
          availableBalance: 0.0,
          lockedBalance: 0.0,
          usdValue: 0.0,
          name: 'dusd',
          inExchange: 0.0);
      walletInfo.add(dusdWalletInfo);
    }
    await getExchangeAssets();

    calcTotalBal(length);
    await updateWalletDatabase();
    if (!isProduction) debugVersionPopup();
    setState(ViewState.Idle);
    return walletInfo;
  }

  // Update wallet database
  updateWalletDatabase() async {
    for (int i = 0; i < walletInfo.length; i++) {
      await walletDatabaseService.update(walletInfo[i]);
      await walletDatabaseService.getById(walletInfo[i].id);
    }
  }

// test version pop up
  debugVersionPopup() {
    sharedService.alertDialog(AppLocalizations.of(context).notice,
        AppLocalizations.of(context).testVersion,
        isWarning: false);
  }

  // Get Exchange Assets
  getExchangeAssets() async {
    String address = await getExgAddressFromWalletDatabase();
    var res = await walletService.assetsBalance(address);
    var length = res.length;
    for (var i = 0; i < length; i++) {
      // Get assetBalance coin to compare with walletInfo tickernName
      String coin = res[i]['coin'];
      // Second For loop to check walletInfo tickerName according to its length and
      // compare it with the same coin tickername from service until the match or loop ends
      for (var j = 0; j < walletInfo.length; j++) {
        String tickerName = walletInfo[j].tickerName;
        //String name = walletInfo[j].name;
        if (coin == walletInfo[j].tickerName) {
          walletInfo[j].inExchange = res[i]['amount'];
          walletInfo[j].lockedBalance = res[i]['lockedAmount'];
          double marketPrice =
              await walletService.getCoinMarketPriceByName(tickerName);
          log.e(
              'wallet dashboard state -- tickername $tickerName - market price $marketPrice - balance: ${walletInfo[j].availableBalance} - Locked balance: ${walletInfo[j].lockedBalance}');
          double usdValue = walletService.calculateCoinUsdBalance(marketPrice,
              walletInfo[j].availableBalance, walletInfo[j].lockedBalance);
          walletInfo[j].usdValue = usdValue;
          log.w('wallet screen state Usd val $tickerName - $usdValue');
          break;
        }
      }
    }
    walletInfoCopy = walletInfo.map((element) => element).toList();
  }

  onBackButtonPressed() async {
    sharedService.context = context;
    await sharedService.closeApp();
  }
}
