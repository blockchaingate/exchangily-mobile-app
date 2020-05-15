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
import 'package:exchangilymobileapp/utils/string_util.dart';
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
  int priceDecimalConfig = 0;
  int quantityDecimalConfig = 0;

  init() async {
    await getDecimalPairConfig();
    await refreshBalance();
    await getConfirmDepositStatus();
    showDialogWarning();
  }

/*----------------------------------------------------------------------
                    Get Pair decimal Config
----------------------------------------------------------------------*/

  getDecimalPairConfig() async {
    setBusy(true);
    pairDecimalConfigList.clear();
    await apiService.getPairDecimalConfig().then((res) {
      if (res != null) {
        pairDecimalConfigList = res;
        log.w('getDecimalPairConfig ${pairDecimalConfigList.length}');
      }
    }).catchError((err) => log.e('In get decimal config CATCH. $err'));
    setBusy(false);
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
  calcTotalBal() {
    totalUsdBalance = 0;
    for (var i = 0; i < walletInfo.length; i++) {}
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
      calcTotalBal();
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
    setBusy(true);
    totalUsdBalance = 0;
    await getGas();
    await getDecimalPairConfig();

    Map<String, String> coinAddresses = {
      'btcAddress': '',
      'ethAddress': '',
      'fabAddress': ''
    };
    walletInfo.forEach((wallet) {
      if (wallet.tickerName == 'BTC') {
        coinAddresses['btcAddress'] = wallet.address;
      } else if (wallet.tickerName == 'ETH') {
        coinAddresses['ethAddress'] = wallet.address;
      } else if (wallet.tickerName == 'FAB') {
        coinAddresses['fabAddress'] = wallet.address;
      }
    });
    await this
        .apiService
        .getWalletBalance(coinAddresses)
        .then((walletBalanceList) async {
      if (walletBalanceList != null) {
        // Loop wallet info list to udpate balances
        for (var i = 0; i < walletInfo.length; i++) {
          // Loop wallet balance list from api
          for (var j = 0; j < walletBalanceList.length; j++) {
            //  log.w('Wallet balance ${walletBalanceList[j].toJson()}');

            String walletTickerName = walletInfo[i].tickerName;
            String walletBalanceCoinName = walletBalanceList[j].coin;

            // Compare wallet ticker name to wallet balance coin name
            if (walletTickerName == walletBalanceCoinName) {
              walletInfo[i].availableBalance = walletBalanceList[j].balance;
              walletInfo[i].lockedBalance = walletBalanceList[j].lockBalance;
              walletInfo[i].inExchange =
                  walletBalanceList[j].unlockedExchangeBalance;
              double marketPrice = walletBalanceList[j].usdValue.usd;

              // Check if market price error from api then show the notification with ticker name
              // so that user know why USD val for that ticker is 0
              if (marketPrice == -1) {
                marketPrice = 0.0;
                sharedService.showInfoFlushbar(
                    '$walletTickerName Notice',
                    'Could not fetch the market price at the moment, please try again later',
                    Icons.cancel,
                    Colors.red,
                    context);
              }
              // Calculating individual coin USD val
              double usdValue = walletService.calculateCoinUsdBalance(
                  marketPrice,
                  walletInfo[i].availableBalance,
                  walletInfo[i].lockedBalance);

              // Adding USD val in the walletInfo instance
              walletInfo[i].usdValue = usdValue;
              if (pairDecimalConfigList != null) {
                log.e(
                    'get pair decimal length, ${pairDecimalConfigList.length}');
                for (PairDecimalConfig pair in pairDecimalConfigList) {
                  String fullWalletTickerName = walletTickerName + 'USDT';
                  log.e('fullWalletTickerName $fullWalletTickerName');
                  if (pair.name == fullWalletTickerName) {
                    // walletInfo[i].pairDecimalConfig.priceDecimal =
                    //     pair.priceDecimal;
                    // walletInfo[i].pairDecimalConfig.priceDecimal =
                    //     pair.qtyDecimal;
                    log.e(
                        'Price and quantity decimal $priceDecimalConfig -- $quantityDecimalConfig');
                    break;
                  }
                }
              }
              log.w('Wallet info single ${walletInfo[i].toJson()}');
              // break the second j loop of wallet balance list when match found
              break;
            } // If ends
          } // For loop j ends
          totalUsdBalance = totalUsdBalance + walletInfo[i].usdValue;
          log.w('total usd  bal $totalUsdBalance');
          walletInfoCopy = walletInfo.map((element) => element).toList();
        } // For loop i ends

        await updateWalletDatabase();
        if (!isProduction) debugVersionPopup();
      } // if wallet balance list != null ends
    }).catchError((err) {
      log.e('Wallet balance CATCH $err');
      setBusy(false);
    });
    setBusy(false);
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

  onBackButtonPressed() async {
    sharedService.context = context;
    await sharedService.closeApp();
  }
}
