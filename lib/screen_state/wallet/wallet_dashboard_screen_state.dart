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
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../environments/coins.dart' as coinList;

class WalletDashboardScreenState extends BaseState {
  final log = getLogger('WalletDahsboardScreenState');

  List<WalletInfo> walletInfo;
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();

  final NavigationService navigationService = locator<NavigationService>();
  ApiService apiService = locator<ApiService>();
  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
  final double elevation = 5;
  double totalUsdBalance = 0;
  double coinUsdBalance;
  double gasAmount = 0;
  String exgAddress = '';
  String wallets;
  List<WalletInfo> walletInfoCopy = [];
  BuildContext context;
  bool isHideSmallAmountAssets = false;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isConfirmDeposit = false;
  WalletInfo confirmDepositCoinWallet;
  List<PairDecimalConfig> pairDecimalConfigList = [];
  int priceDecimalConfig = 0;
  int quantityDecimalConfig = 0;
  var lang;

  var top = 0.0;

  init() async {
    setBusy(true);
    // await getDecimalPairConfig();
    await refreshBalance();
    await getConfirmDepositStatus();
    showDialogWarning();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('lang');
    setBusy(false);
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
    for (var i = 0; i < walletInfo.length; i++) {
      totalUsdBalance = totalUsdBalance + walletInfo[i].usdValue;
    }
    log.i('Total usd balance $totalUsdBalance');
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
    String address = await walletService.getExgAddressFromWalletDatabase();
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

  // Retrive Wallets From local DB

  retrieveWalletsFromLocalDatabase() async {
    setBusy(true);
    await walletDatabaseService.getAll().then((res) {
      walletInfo = res;
      calcTotalBal();
      walletInfoCopy = walletInfo.map((element) => element).toList();
    }).catchError((error) {
      log.e('Catch Error retrieveWallets $error');
      setBusy(false);
    });
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                          Refresh Balances
-------------------------------------------------------------------------------------*/

  Future refreshBalance() async {
    setBusy(true);

    await walletDatabaseService.getAll().then((walletList) {
      walletInfoCopy = [];
      walletInfoCopy = walletList;
    });

    int coinTickersLength = walletService.coinTickers.length;
    walletInfo = [];
    await getGas();
    //await getDecimalPairConfig();

    Map<String, dynamic> walletBalancesBody = {
      'btcAddress': '',
      'ethAddress': '',
      'fabAddress': '',
      'ltcAddress': '',
      'dogeAddress': '',
      'bchAddress': '',
      "showEXGAssets": "true"
    };
    walletInfoCopy.forEach((wallet) {
      if (wallet.tickerName == 'BTC') {
        walletBalancesBody['btcAddress'] = wallet.address;
      } else if (wallet.tickerName == 'ETH') {
        walletBalancesBody['ethAddress'] = wallet.address;
      } else if (wallet.tickerName == 'FAB') {
        walletBalancesBody['fabAddress'] = wallet.address;
      } else if (wallet.tickerName == 'LTC') {
        walletBalancesBody['ltcAddress'] = wallet.address;
      } else if (wallet.tickerName == 'DOGE') {
        walletBalancesBody['dogeAddress'] = wallet.address;
      } else if (wallet.tickerName == 'BCH') {
        walletBalancesBody['bchAddress'] = wallet.address;
      }
    });

    log.i('Coin address $walletBalancesBody');

    // ----------------------------------------
    // Calling walletBalances in wallet service
    // ----------------------------------------
    await this
        .apiService
        .getWalletBalance(walletBalancesBody)
        .then((walletBalanceList) async {
      if (walletBalanceList != null) {
        // Loop wallet info list to udpate balances
        // log.e(
        //     'copy length ${walletInfoCopy.length} -- balance list length ${walletBalanceList.length}');
        walletInfoCopy.forEach((wallet) async {
          log.w('wallet balance from api ${wallet.toJson()}}');
          // Loop wallet balance list from api
          for (var j = 0; j <= walletBalanceList.length; j++) {
            String walletTickerName = wallet.tickerName;
            String walletBalanceCoinName = walletBalanceList[j].coin;

            // Compare wallet ticker name to wallet balance coin name
            if (walletTickerName == walletBalanceCoinName) {
              double marketPrice = walletBalanceList[j].usdValue.usd ?? 0.0;
              double availableBal = walletBalanceList[j].balance ?? 0.0;
              double lockedBal = walletBalanceList[j].lockBalance ?? 0.0;
              log.e('available bal $walletTickerName -- $availableBal');
              // Check if market price error from api then show the notification with ticker name
              // so that user know why USD val for that ticker is 0

              // removed getCoinPriceByTickername from here and use the market price value only now
              if (marketPrice.isNegative) {
                marketPrice = 0.0;
              }

              // // If passing any negative value to UI then that pair won't show up in the list
              if (availableBal.isNegative) walletBalanceList[j].balance = 0.0;
              if (lockedBal.isNegative) walletBalanceList[j].lockBalance = 0.0;

              // Calculating individual coin USD val
              double usdValue = walletService.calculateCoinUsdBalance(
                  marketPrice,
                  walletBalanceList[j].balance,
                  walletBalanceList[j].lockBalance);

              // if (pairDecimalConfigList != null ||
              //     pairDecimalConfigList != []) {
              //   log.e(
              //       'get pair decimal length, ${pairDecimalConfigList.length}');
              //   for (PairDecimalConfig pair in pairDecimalConfigList) {
              //     String fullWalletTickerName = walletTickerName + 'USDT';

              //     if (pair.name == fullWalletTickerName) {
              //       // walletInfo[i].pairDecimalConfig.priceDecimal =
              //       //     pair.priceDecimal;
              //       // walletInfo[i].pairDecimalConfig.priceDecimal =
              //       //     pair.qtyDecimal;

              //       break;
              //     }
              //   }
              // }
              WalletInfo wi = new WalletInfo(
                  id: wallet.id,
                  tickerName: walletTickerName,
                  tokenType: wallet.tokenType,
                  address: wallet.address,
                  availableBalance: walletBalanceList[j].balance,
                  lockedBalance: walletBalanceList[j].lockBalance,
                  usdValue: usdValue,
                  name: wallet.name,
                  inExchange: walletBalanceList[j].unlockedExchangeBalance);
              walletInfo.add(wi);

              // break the second j loop of wallet balance list when match found
              break;
            } // If ends

          } // For loop j ends
        }); // wallet info copy for each ends

        // Test to find unique wallet objects
        final seen = Set<WalletInfo>();
        //   walletInfo = walletInfo.where((wallet) => seen.add(wallet)).toList();

        //  walletInfo = Set.of(wallets).toList();

        // Observable.fromIterable(walletInfo).distinct().doOnData((event) {
        //   log.e('DISTINCT ${event.tickerName}');
        //   walletInfo.add(event);
        // });
        // walletInfo = wallets.toSet().toList();

        calcTotalBal();
        await updateWalletDatabase();
        if (!isProduction) debugVersionPopup();
      } // if wallet balance list != null ends

      // in else if walletBalances is null then check balance with old method
      else if (walletBalanceList == null) {
        log.e('ELSE old way');
        await oldWayToGetBalances(coinTickersLength);
      }
    }).catchError((err) async {
      log.e('Wallet balance CATCH $err');
      setBusy(false);
    });

    if (walletInfo != null) {
      walletInfoCopy = [];
      walletInfoCopy = walletInfo.map((element) => element).toList();
    }
    setBusy(false);
  }

  // Old way to get balances
  oldWayToGetBalances(int walletInfoCopyLength) async {
    walletInfo = [];
    List<String> coinTokenType = walletService.tokenType;

    double walletBal = 0.0;
    double walletLockedBal = 0.0;

    // For loop starts
    for (var i = 0; i < walletInfoCopyLength; i++) {
      String tickerName = walletInfoCopy[i].tickerName;
      String address = walletInfoCopy[i].address;
      String name = walletInfoCopy[i].name;
      // Get coin balance by address
      await walletService
          .coinBalanceByAddress(tickerName, address, coinTokenType[i])
          .then((balance) async {
        log.e('bal $balance');
        walletBal = balance['balance'];
        walletLockedBal = balance['lockbalance'];

        // Get coin market price by name
        double marketPrice =
            await walletService.getCoinMarketPriceByTickerName(tickerName);

        // Calculate usd balance
        coinUsdBalance = walletService.calculateCoinUsdBalance(
            marketPrice, walletBal, walletLockedBal);
        // Adding each coin details in the wallet
        WalletInfo wi = WalletInfo(
            id: walletInfoCopy[i].id,
            tickerName: tickerName,
            tokenType: coinTokenType[i],
            address: address,
            availableBalance: walletBal,
            lockedBalance: walletLockedBal,
            usdValue: coinUsdBalance,
            name: name);
        walletInfo.add(wi);
      }).
          // .timeout(Duration(seconds: 25), onTimeout: () async {
          //   sharedService.alertDialog(
          //       '', AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater);
          //   await retrieveWallets();
          //   log.e('Timeout');
          //   return;
          // })

          catchError((error) async {
        setState(ViewState.Idle);
        sharedService.alertDialog(
            '', AppLocalizations.of(context).genericError);
        await retrieveWalletsFromLocalDatabase();
        log.e('Something went wrong  - $error');
        return;
      });
    } // For loop ends

    // bool hasDUSD = false;
    // String exgAddress = '';
    // String exgTokenType = '';

    // for (var i = 0; i < walletInfo.length; i++) {
    //   String tickerName = walletInfo[i].tickerName;
    //   if (tickerName == 'DUSD') {
    //     hasDUSD = true;
    //   }
    //   if (tickerName == 'EXG') {
    //     exgAddress = walletInfo[i].address;
    //     exgTokenType = walletInfo[i].tokenType;
    //   }
    // }
    // if (!hasDUSD) {
    //   var dusdWalletInfo = new WalletInfo(
    //       tickerName: 'DUSD',
    //       tokenType: exgTokenType,
    //       address: exgAddress,
    //       availableBalance: 0.0,
    //       lockedBalance: 0.0,
    //       usdValue: 0.0,
    //       name: 'dusd',
    //       inExchange: 0.0);
    //   walletInfo.add(dusdWalletInfo);
    // }
    calcTotalBal();
    await getExchangeAssetsBalance();
    await updateWalletDatabase();
    if (!isProduction) debugVersionPopup();
    log.w('Fetched wallet data using old methods');
  }

  // get exchange asset balance
  getExchangeAssetsBalance() async {
    String address = await getExgAddressFromWalletDatabase();
    var res = await walletService.assetsBalance(address);
    if (res != null) {
      var length = res.length;
      // For loop over asset balance result
      for (var i = 0; i < length; i++) {
        // Get their tickerName to compare with walletInfo tickerName
        String coin = res[i]['coin'];
        // Second For Loop To check WalletInfo TickerName According to its length and
        // compare it with the same coin tickername from asset balance result until the match or loop ends
        for (var j = 0; j < walletInfo.length; j++) {
          String tickerName = walletInfo[j].tickerName;
          if (coin == tickerName) {
            walletInfo[j].inExchange = res[i]['amount'];
            break;
          }
        }
      }
    }
  }

  // Update wallet database
  updateWalletDatabase() async {
    for (int i = 0; i < walletInfo.length; i++) {
      await walletDatabaseService.update(walletInfo[i]);
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

  updateAppbarHeight(h) {
    top = h;
  }

  getAppbarHeight() {
    return top;
  }
}
