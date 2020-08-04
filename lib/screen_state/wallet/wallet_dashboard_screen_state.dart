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

import 'dart:io';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../environments/coins.dart' as coinList;
import 'package:intl/intl.dart';

class WalletDashboardScreenState extends BaseState {
  final log = getLogger('WalletDahsboardScreenState');

  BuildContext context;
  List<WalletInfo> walletInfo;
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();

  final NavigationService navigationService = locator<NavigationService>();
  ApiService apiService = locator<ApiService>();
  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
  final double elevation = 5;
  String totalUsdBalance = '';

  double gasAmount = 0;
  String exgAddress = '';
  String wallets;
  List<WalletInfo> walletInfoCopy = [];
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
  final freeFabAnswerTextController = TextEditingController();
  String postFreeFabResult = '';
  bool isFreeFabNotUsed = false;
  double fabBalance = 0.0;
  List<String> formattedUsdValueList = [];

/*----------------------------------------------------------------------
                    INIT
----------------------------------------------------------------------*/

  init() async {
    setBusy(true);
    sharedService.context = context;
    //  await getDecimalPairConfig();
    await refreshBalance();
    getConfirmDepositStatus();
    showDialogWarning();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('lang');

    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Get app version
----------------------------------------------------------------------*/

  getAppVersion() async {
    setBusy(true);
    String localAppVersion = await sharedService.getLocalAppVersion();
    String store = '';
    if (Platform.isIOS) {
      store = 'App Store';
    } else {
      store = 'Google Play Store';
    }
    await apiService.getApiAppVersion().then((apiAppVersion) {
      if (apiAppVersion != null) {
        log.i(
            'api app version $apiAppVersion -- local version $localAppVersion');
        if (localAppVersion != apiAppVersion) {
          sharedService.alertDialog(
              AppLocalizations.of(context).appUpdateNotice,
              '${AppLocalizations.of(context).pleaseUpdateYourAppFrom} $localAppVersion ${AppLocalizations.of(context).toLatestBuild} $apiAppVersion ${AppLocalizations.of(context).inText} $store',
              isUpdate: true,
              isLater: true);
        }
      }
    }).catchError((err) {
      log.e('get app version catch $err');
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    get free fab
----------------------------------------------------------------------*/

  getFreeFab() async {
    setBusy(true);
    String address = await getExgAddressFromWalletDatabase();
    await apiService.getFreeFab(address).then((res) {
      if (res != null) {
        if (res['ok']) {
          isFreeFabNotUsed = res['ok'];
          print(res['_body']['question']);
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: Container(
                    height: 250,
                    child: ListView(
                      children: [
                        AlertDialog(
                          titlePadding: EdgeInsets.symmetric(vertical: 5),
                          actionsPadding: EdgeInsets.all(0),
                          elevation: 5,
                          titleTextStyle: Theme.of(context).textTheme.headline4,
                          contentTextStyle: TextStyle(color: grey),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor: walletCardColor.withOpacity(0.95),
                          title: Text(
                            AppLocalizations.of(context).question,
                            textAlign: TextAlign.center,
                          ),
                          content: Column(
                            children: <Widget>[
                              UIHelper.verticalSpaceSmall,
                              Text(
                                res['_body']['question'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: red),
                              ),
                              TextField(
                                minLines: 1,
                                style: TextStyle(color: white),
                                controller: freeFabAnswerTextController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.question_answer,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              UIHelper.verticalSpaceSmall,
                              postFreeFabResult != ''
                                  ? Text(postFreeFabResult)
                                  : Container()
                            ],
                          ),
                          actions: [
                            Container(
                                margin: EdgeInsetsDirectional.only(bottom: 10),
                                child: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Cancel
                                      OutlineButton(
                                          color: primaryColor,
                                          padding: EdgeInsets.all(0),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .close,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                            setState(() =>
                                                freeFabAnswerTextController
                                                    .text = '');
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          }),
                                      UIHelper.horizontalSpaceSmall,
                                      // Confirm
                                      FlatButton(
                                          color: primaryColor,
                                          padding: EdgeInsets.all(0),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .confirm,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          onPressed: () async {
                                            postFreeFabResult = '';
                                            Map data = {
                                              "address": address,
                                              "questionair_id": res['_body']
                                                  ['_id'],
                                              "answer":
                                                  freeFabAnswerTextController
                                                      .text
                                            };
                                            log.e(data);
                                            await apiService
                                                .postFreeFab(data)
                                                .then(
                                              (res) {
                                                if (res != null) {
                                                  log.w(res['ok']);

                                                  if (res['ok']) {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                    setState(() =>
                                                        isFreeFabNotUsed =
                                                            false);
                                                    walletService
                                                        .showInfoFlushbar(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .freeFabUpdate,
                                                            AppLocalizations.of(
                                                                    context)
                                                                .freeFabSuccess,
                                                            Icons
                                                                .account_balance,
                                                            green,
                                                            context);
                                                  } else {
                                                    walletService
                                                        .showInfoFlushbar(
                                                            AppLocalizations
                                                                    .of(context)
                                                                .freeFabUpdate,
                                                            AppLocalizations.of(
                                                                    context)
                                                                .incorrectAnswer,
                                                            Icons
                                                                .account_balance,
                                                            red,
                                                            context);
                                                  }
                                                } else {
                                                  walletService
                                                      .showInfoFlushbar(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .notice,
                                                          AppLocalizations.of(
                                                                  context)
                                                              .genericError,
                                                          Icons.cancel,
                                                          red,
                                                          context);
                                                }
                                              },
                                            );
                                            //  navigationService.goBack();
                                            freeFabAnswerTextController.text =
                                                '';
                                            postFreeFabResult = '';
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          }),
                                    ],
                                  );
                                })),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        } else {
          print(isFreeFabNotUsed);
          isFreeFabNotUsed = res['ok'];
          print(isFreeFabNotUsed);

          print(isFreeFabNotUsed);
          walletService.showInfoFlushbar(
              AppLocalizations.of(context).notice,
              AppLocalizations.of(context).freeFabUsedAlready,
              Icons.notification_important,
              yellow,
              context);
        }
      }
    });
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
    totalUsdBalance = '';
    double holder = 0.0;
    for (var i = 0; i < walletInfo.length; i++) {
      holder = holder + walletInfo[i].usdValue;
    }
    totalUsdBalance = currencyFormat(holder, 2);
    // totalUsdBalance =
    //     NumberFormat.simpleCurrency(decimalDigits: 2).format(holder);
    // totalUsdBalance = totalUsdBalance.substring(1);
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
              arguments: confirmDepositCoinWallet,
              isWarning: true);
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
      formattedUsdValueList = [];
      walletInfoCopy = walletList;
    });
    walletInfo = [];

    int coinTickersLength = walletService.coinTickers.length;
    await getGas();
    //await getDecimalPairConfig();

    /// Check if wallet database coins are same as wallet service list
    /// if not then call create offline wallet in the wallet service
    // print('${walletService.coinTickers.length} -- ${walletInfoCopy.length}');
    // if (coinTickersLength != walletInfoCopy.length) {
    //   print('$coinTickersLength -- ${walletInfoCopy.length}');
    //   await walletService.createOfflineWallets(
    //       'culture sound obey clean pretty medal churn behind chief cactus alley ready');
    //   await walletDatabaseService.getAll().then((walletList) {
    //     walletInfoCopy = [];
    //     walletInfoCopy = walletList;
    //   });
    // }

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
          // Loop wallet balance list from api
          for (var j = 0; j <= walletBalanceList.length; j++) {
            String walletTickerName = wallet.tickerName;
            String walletBalanceCoinName = walletBalanceList[j].coin;

            // Compare wallet ticker name to wallet balance coin name
            if (walletTickerName == walletBalanceCoinName) {
              double marketPrice = walletBalanceList[j].usdValue.usd ?? 0.0;
              double availableBal = walletBalanceList[j].balance ?? 0.0;
              double lockedBal = walletBalanceList[j].lockBalance ?? 0.0;

              // Check if market price error from api then show the notification with ticker name
              // so that user know why USD val for that ticker is 0

              // removed getCoinPriceByTickername from here and use the market price value only now
              if (marketPrice.isNegative) {
                marketPrice = 0.0;
              }
              if (availableBal.isNegative) {
                print(availableBal);
                availableBal = 0.0;
              }

              // Calculating individual coin USD val
              double usdValue = walletService.calculateCoinUsdBalance(
                  marketPrice, availableBal, lockedBal);
              String holder = currencyFormat(usdValue, 2);
              formattedUsdValueList.add(holder);

// get Pair decimal config
              // if (pairDecimalConfigList != null ||
              //     pairDecimalConfigList != []) {
              //   for (PairDecimalConfig pair in pairDecimalConfigList) {
              //     log.e('pair ${pair.toJson()}');
              //     if (pair.name == walletTickerName + 'USDT') {
              //       String holder = walletBalanceList[j]
              //           .balance
              //           .toStringAsFixed(pair.qtyDecimal);
              //       print(holder);
              //       availableBal = double.parse(holder);
              //     }
              //     break;
              //   }
              // }

              WalletInfo wi = new WalletInfo(
                  id: wallet.id,
                  tickerName: walletTickerName,
                  tokenType: wallet.tokenType,
                  address: wallet.address,
                  availableBalance: availableBal,
                  lockedBalance: lockedBal,
                  usdValue: usdValue,
                  name: wallet.name,
                  inExchange: walletBalanceList[j].unlockedExchangeBalance);
              walletInfo.add(wi);
              print(wi.toJson());
              if (walletTickerName == 'FAB') {
                fabBalance = 0.0;
                fabBalance = wi.availableBalance;
              }
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
        await getAppVersion();

        // get exg address to get free fab
        String address = await getExgAddressFromWalletDatabase();

        // check gas and fab balance if 0 then ask for free fab
        if (gasAmount == 0.0 && fabBalance == 0.0) {
          await apiService.getFreeFab(address).then((res) {
            if (res != null) {
              isFreeFabNotUsed = res['ok'];
            }
          });
        } else {
          log.i('Fab or gas balance available already');
        }
      } // if wallet balance list != null ends

      // in else if walletBalances is null then check balance with old method
      else if (walletBalanceList == null) {
        log.e('---------------------ELSE old way-----------------------');
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
    formattedUsdValueList = [];
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
        walletBal = balance['balance'] == -1 ? 0.0 : balance['balance'];
        walletLockedBal =
            balance['lockbalance'] == -1 ? 0.0 : balance['lockbalance'];

        // Get coin market price by name
        double marketPrice =
            await walletService.getCoinMarketPriceByTickerName(tickerName);

        // Calculate usd balance
        double usdValue = walletService.calculateCoinUsdBalance(
            marketPrice, walletBal, walletLockedBal);
        String holder = currencyFormat(usdValue, 2);
        formattedUsdValueList.add(holder);
        // Adding each coin details in the wallet
        WalletInfo wi = WalletInfo(
            id: walletInfoCopy[i].id,
            tickerName: tickerName,
            tokenType: coinTokenType[i],
            address: address,
            availableBalance: walletBal,
            lockedBalance: walletLockedBal,
            usdValue: usdValue,
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

    calcTotalBal();
    await getExchangeAssetsBalance();
    await updateWalletDatabase();
    if (!isProduction) debugVersionPopup();
    if (walletInfo != null) {
      walletInfoCopy = [];
      walletInfoCopy = walletInfo.map((element) => element).toList();
    }
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
