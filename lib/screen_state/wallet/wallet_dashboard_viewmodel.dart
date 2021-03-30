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

import 'dart:convert';
import 'dart:io';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/enums/connectivity_status.dart';
import 'package:exchangilymobileapp/environments/coins.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/models/wallet/token.dart';
import 'package:exchangilymobileapp/models/wallet/user_settings_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_balance.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/decimal_config_database_service.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/shared/globalLang.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';

import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

import 'package:flutter/material.dart';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:protoc_plugin/protoc.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stacked/stacked.dart';

import 'package:json_diff/json_diff.dart';

class WalletDashboardViewModel extends BaseViewModel {
  final log = getLogger('WalletDahsboardScreenState');

  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();

  final NavigationService navigationService = locator<NavigationService>();
  final DecimalConfigDatabaseService decimalConfigDatabaseService =
      locator<DecimalConfigDatabaseService>();
  ApiService apiService = locator<ApiService>();
  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  var storageService = locator<LocalStorageService>();

  BuildContext context;
  List<WalletInfo> walletInfo;
  List<WalletInfo> walletInfoCopy = [];

  final double elevation = 5;
  String totalUsdBalance = '';

  double gasAmount = 0;
  String exgAddress = '';
  String wallets;
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
  List<String> formattedUsdValueListCopy = [];

  final searchCoinTextController = TextEditingController();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  //vars for announcement
  bool hasApiError = false;
  List announceList;
  GlobalKey globalKeyOne;
  GlobalKey globalKeyTwo;
  double totalBalanceContainerWidth = 100.0;
  final scrollController = ScrollController();

  bool _isShowCaseView = false;
  get isShowCaseView => _isShowCaseView;

  int unreadMsgNum = 0;
/*----------------------------------------------------------------------
                    INIT
----------------------------------------------------------------------*/

  init() async {
    setBusy(true);

    sharedService.context = context;
    await refreshBalance();

    totalBalanceContainerWidth = 270.0;
    checkAnnouncement();
    showDialogWarning();
    getDecimalPairConfig();
    getConfirmDepositStatus();
    setBusy(false);
  }

// not in use
  void endOfCoinList() async {
    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

/*----------------------------------------------------------------------
                        Check Announcement
----------------------------------------------------------------------*/

  checkAnnouncement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = storageService.language;
    if (lang == '') lang = 'en';
    setlangGlobal(lang);
    // log.w('langGlobal: ' + getlangGlobal());

    var announceContent;

    announceContent = await apiService.getAnnouncement(lang);

    if (announceContent == "error") {
      hasApiError = true;
    } else {
      // test code///////////////////////////////
      // prefs.remove("announceData");
      // log.wtf("announcement: remove cache!!!!");
      // test code end///////////////////////////////
      // test code end///////////////////////////////

      bool checkValue = prefs.containsKey('announceData');
      List tempAnnounceData = [];
      if (checkValue) {
        //log.i("announcement: has cache!!!");
        // var x = prefs.getStringList('announceData');
        List tempdata = prefs.getStringList('announceData');
        // tempdata.forEach((e) {
        //   e = json.decode(e);
        // });

        tempdata.forEach((element) {
          tempAnnounceData.add(jsonDecode(element));
          //   print('tempAnnounceData $tempAnnounceData');
        });
        // log.i("announceData from prefs: ");

        // print(tempAnnounceData);
        // log.i("prefs 0: ");
        // print(tempAnnounceData[0].toString());
        // log.i("prefs 0 id: ");
        // print(tempAnnounceData[0]['_id']);

        // tempAnnounceData = tempdata;
        if (announceContent.length != 0) {
          //   log.i("Data from api: ");
          // print(announceContent);
          // log.i("Data 0: ");
          // print(announceContent[0].toString());
          // log.w("Going to map!!");
          announceContent.map((annNew) {
            //    print("Start map");
            bool hasId = false;
            // log.i("annNew['_id']: " + annNew['_id']);
            tempAnnounceData.asMap().entries.map((tempAnn) {
              int idx = tempAnn.key;
              var val = tempAnn.value;
              // log.i("val['_id']: " + val['_id']);
              if (val['_id'].toString() == annNew['_id'].toString()) {
                // log.i('has id!!!!');
                // log.i('Ann id: ' + val['_id']);
                hasId = true;
                final differ = JsonDiffer.fromJson(val, annNew);
                DiffNode diff = differ.diff();
                // print(diff.changed);
                // print("Lenght: " + diff.changed.toString().length.toString());

                if (diff.changed != null &&
                    diff.changed.toString().length > 3) {
                  //   log.w('ann data diff!!!!');
                  tempAnnounceData[idx] = annNew;
                  tempAnnounceData[idx]['isRead'] = false;
                }
              }
            }).toList();
            if (!hasId) {
              // log.i('no id!!!!');
              // log.i('Ann id: ' + annNew['_id']);
              annNew['isRead'] = false;
              tempAnnounceData.insert(0, annNew);
            }
          }).toList();

          log.w("tempAnnounceData(from cache): ");
          // List tempAnnounceData2 = json.decode(json.encode(tempAnnounceData));
          // log.i(tempAnnounceData2);

        }

        // prefs.setString('announceData', tempAnnounceData.toString());
        List<String> jsonData = [];
        int readedNum = 0;
        tempAnnounceData.forEach((element) {
          element["isRead"] == false ? readedNum++ : readedNum = readedNum;
          jsonData.add(jsonEncode(element));
          //   print('jsonData $jsonData');
        });
        setunReadAnnouncement(readedNum);
        unreadMsgNum = readedNum;
        // print("check status: " + prefs.containsKey('announceData').toString());
        prefs.setStringList('announceData', jsonData);

        announceList = tempAnnounceData;
      } else {
        log.i("announcement: no cache!!!");

        tempAnnounceData = announceContent;

        if (tempAnnounceData.length != 0) {
          tempAnnounceData.asMap().entries.map((announ) {
            int idx = announ.key;
            var val = announ.value;
            // tempAnnounceData[idx]['isRead']=false;
            // var tempString = val.toString();
            // tempString = tempString.substring(0, tempString.length - 1) + 'isRead:false';
            tempAnnounceData[idx]['isRead'] = false;
          }).toList();

          prefs.remove("announceData");
          List<String> jsonData = [];
          int readedNum = 0;
          tempAnnounceData.forEach((element) {
            element["isRead"] == false ? readedNum++ : readedNum = readedNum;
            jsonData.add(jsonEncode(element));
            //    print('jsonData $jsonData');
          });
          setunReadAnnouncement(readedNum);
          unreadMsgNum = readedNum;
          // print(
          //     "check status: " + prefs.containsKey('announceData').toString());
          prefs.setStringList('announceData', jsonData);
          //     print("prefs saved");
          // print("check status saved: " +
          //     prefs.containsKey('announceData').toString());
          // print("prefs announcement data: " + prefs.getString('announceData'));
        }
        // tempAnnounceData.map((announ) {
        //   // announ.add["isRead"] = false;
        //   announ.addAll({'isRead':false});
        // });

        // //test code
        // tempAnnounceData[0]['isRead']=true;
        // tempAnnounceData[1]['isRead']=false;
        // tempAnnounceData[2]['isRead']=true;

        // log.i("tempAnnounceData[0]['isRead']: " +
        //     tempAnnounceData[0]['isRead'].toString());

        announceList = tempAnnounceData;
        log.i("announcement: exit!!!");
      }
      (context as Element).markNeedsBuild();
    }
  }

  updateAnnce() {
    setBusy(true);
    unreadMsgNum = getunReadAnnouncement();

    print("Update unread annmoucement number:" + unreadMsgNum.toString());
    (context as Element).markNeedsBuild();
    setBusy(false);
  }

/*----------------------------------------------------------------------
                        Showcase Feature
----------------------------------------------------------------------*/
  showcaseEvent(BuildContext ctx) async {
    log.e(
        'Is showvcase: ${storageService.isShowCaseView} --- gas amount: $gasAmount');
    // if (!isBusy) setBusyForObject(isShowCaseView, true);
    _isShowCaseView = storageService.isShowCaseView;
    // if (!isBusy) setBusyForObject(isShowCaseView, false);
    if (isShowCaseView && !isBusy)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(ctx).startShowCase([globalKeyOne, globalKeyTwo]);
      });
  }

/*----------------------------------------------------------------------
                        On Single Coin Card Click
----------------------------------------------------------------------*/

  onSingleCoinCardClick(index) {
    FocusScope.of(context).requestFocus(FocusNode());
    navigationService.navigateTo('/walletFeatures',
        arguments: walletInfo[index]);
    searchCoinTextController.clear();
    resetWalletInfoObject();
  }

/*----------------------------------------------------------------------
                    Search Coins By TickerName
----------------------------------------------------------------------*/

  searchCoinsByTickerName(String value) async {
    setBusy(true);
    // await apiService.getTokenList().then((tokenList) {
    //   if (tokenList != null) {
    //     tokenList.forEach((token) {
    //       log.w('token ${token.toJson()}');
    //       if (token.name == value) {
    //         print('name ${token.name}');
    //       }
    //     });
    //   } else {
    //     log.e('token list null');
    //   }
    // }).catchError((err) {
    //   log.e('SearchCoinsByTickerName Catch $err');
    // });
    //value = value.toUpperCase();
    print('length ${walletInfoCopy.length} -- value $value');
    for (var i = 0; i < walletInfoCopy.length; i++)
      if (walletInfoCopy[i].tickerName == value.toUpperCase() ||
              walletInfoCopy[i].name == value
          //||          isFirstCharacterMatched(value, i)
          ) {
        setBusy(true);
        walletInfo = [];
        formattedUsdValueList = [];
        log.e('copy ${walletInfoCopy[i].toJson()}');

        String holder =
            NumberUtil.currencyFormat(walletInfoCopy[i].usdValue, 2);
        formattedUsdValueList.add(holder);
        walletInfo.add(walletInfoCopy[i]);
        // print(
        //     'matched wallet ${walletInfoCopy[i].toJson()} --  wallet info length ${walletInfo.length}');
        setBusy(false);
        break;
      } else {
        // log.e(
        //     'in else ${walletInfoCopy[i].tickerName} == ${value.toUpperCase()}');
        resetWalletInfoObject();
      }
    setBusy(false);
  }

  resetWalletInfoObject() {
    walletInfo = [];
    formattedUsdValueList = [];
    walletInfo = walletInfoCopy;
    formattedUsdValueList = formattedUsdValueListCopy;
  }

  bool isFirstCharacterMatched(String value, int index) {
    print(
        'value 1st char ${value[0]} == first chracter ${walletInfoCopy[index].tickerName[0]}');
    log.w(value.startsWith(walletInfoCopy[index].tickerName[0]));
    return value.startsWith(walletInfoCopy[index].tickerName[0]);
  }

/*----------------------------------------------------------------------
                    Get app version
----------------------------------------------------------------------*/

  getAppVersion() async {
    setBusy(true);
    Map<String, String> localAppVersion =
        await sharedService.getLocalAppVersion();
    String store = '';
    String appDownloadLinkOnWebsite =
        'http://exchangily.com/download/latest.apk';
    if (Platform.isIOS) {
      store = 'App Store';
    } else {
      store = 'Google Play Store';
    }
    await apiService.getApiAppVersion().then((apiAppVersion) {
      if (apiAppVersion != null) {
        log.e('condition ${localAppVersion['name'].compareTo(apiAppVersion)}');

        log.i(
            'api app version $apiAppVersion -- local version $localAppVersion');

        if (localAppVersion['name'].compareTo(apiAppVersion) == -1) {
          sharedService.alertDialog(
              AppLocalizations.of(context).appUpdateNotice,
              '${AppLocalizations.of(context).pleaseUpdateYourAppFrom} $localAppVersion ${AppLocalizations.of(context).toLatestBuild} $apiAppVersion ${AppLocalizations.of(context).inText} $store ${AppLocalizations.of(context).clickOnWebsiteButton}',
              isUpdate: true,
              isLater: true,
              isWebsite: true,
              stringData: appDownloadLinkOnWebsite);
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
                                                            AppLocalizations.of(
                                                                    context)
                                                                .freeFabUpdate,
                                                            AppLocalizations.of(
                                                                    context)
                                                                .incorrectAnswer,
                                                            Icons.cancel,
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

          walletService.showInfoFlushbar(
              AppLocalizations.of(context).notice,
              AppLocalizations.of(context).freeFabUsedAlready,
              Icons.notification_important,
              yellow,
              context);
        }
      }
    });
  }

/*----------------------------------------------------------------------
                    Get Pair decimal Config
----------------------------------------------------------------------*/

  getDecimalPairConfig() async {
    setBusy(true);
    pairDecimalConfigList.clear();
    await apiService.getPairDecimalConfig().then((res) async {
      if (res != null) {
        pairDecimalConfigList = res;
        log.w('getDecimalPairConfig ${pairDecimalConfigList.length}');
        var data = await decimalConfigDatabaseService.getAll();
        if (data.length != pairDecimalConfigList.length) {
          await decimalConfigDatabaseService.deleteDb();

          pairDecimalConfigList.forEach((element) async {
            await decimalConfigDatabaseService.insert(element);
          });
        }
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
    setBusyForObject(isHideSmallAmountAssets, true);
    isHideSmallAmountAssets = !isHideSmallAmountAssets;
    setBusyForObject(isHideSmallAmountAssets, false);
  }

// Calculate Total Usd Balance of Coins
  calcTotalBal() {
    totalUsdBalance = '';
    double holder = 0.0;
    for (var i = 0; i < walletInfo.length; i++) {
      holder += walletInfo[i].usdValue;
    }
    totalUsdBalance = NumberUtil.currencyFormat(holder, 2);
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

/*---------------------------------------------------
                      Get gas
--------------------------------------------------- */

  getGas() async {
    String address = await getExgAddressFromWalletDatabase();
    await walletService
        .gasBalance(address)
        .then((data) => gasAmount = data)
        .catchError((onError) => log.e(onError));
    log.w('Gas Amount $gasAmount');
    return gasAmount;
  }

/*----------------------------------------------------------------------
                      Get Confirm deposit err
----------------------------------------------------------------------*/

  getConfirmDepositStatus() async {
    String address = await walletService.getExgAddressFromWalletDatabase();
    await walletService.getErrDeposit(address).then((result) async {
      List<String> pendingDepositCoins = [];
      if (result != null) {
        log.w('getConfirmDepositStatus reesult $result');
        for (var i = 0; i < result.length; i++) {
          var item = result[i];
          var coinType = item['coinType'];
          String tickerNameByCointype = newCoinTypeMap[coinType];
          if (tickerNameByCointype == null)
            await tokenListDatabaseService.getAll().then((tokenList) {
              if (tokenList != null)
                tickerNameByCointype = tokenList
                    .firstWhere((element) => element.tokenType == coinType)
                    .tickerName;
            });
          log.w('tickerNameByCointype $tickerNameByCointype');
          if (tickerNameByCointype != null &&
              !pendingDepositCoins.contains(tickerNameByCointype))
            pendingDepositCoins.add(tickerNameByCointype);
        }
        var json = jsonEncode(pendingDepositCoins);
        var listCoinsToString = jsonDecode(json);
        String holder = listCoinsToString.toString();
        String f = holder.substring(1, holder.length - 1);
        if (pendingDepositCoins.isNotEmpty)
          showSimpleNotification(
              Text('${AppLocalizations.of(context).requireRedeposit}: $f'),
              position: NotificationPosition.bottom,
              background: primaryColor);
      }
    }).catchError((err) {
      log.e('getConfirmDepositStatus Catch $err');
    });
  }
/*----------------------------------------------------------------------
                      Show dialog warning
----------------------------------------------------------------------*/

  showDialogWarning() {
    log.w('in showDialogWarning isConfirmDeposit $isConfirmDeposit');
    if (gasAmount < 0.5) {
      sharedService.alertDialog(
          AppLocalizations.of(context).insufficientGasAmount,
          AppLocalizations.of(context).pleaseAddGasToTrade);
    }
    if (isConfirmDeposit) {
      sharedService.alertDialog(
          AppLocalizations.of(context).pendingConfirmDeposit,
          '${AppLocalizations.of(context).pleaseConfirmYour} ${confirmDepositCoinWallet.tickerName} ${AppLocalizations.of(context).deposit}',
          path: '/walletFeatures',
          arguments: confirmDepositCoinWallet,
          isWarning: true);
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

  jsonTransformation() {
    var walletBalancesBody = jsonDecode(storageService.walletBalancesBody);
    log.i('Coin address body $walletBalancesBody');
  }

/*----------------------------------------------------------------------
                      Build coin list
----------------------------------------------------------------------*/

  buildNewWalletObject(
      Token newToken, WalletBalance newTokenWalletBalance) async {
    String newCoinAddress = '';

    newCoinAddress = assignNewTokenAddress(newToken);
    double marketPrice = newTokenWalletBalance.usdValue.usd ?? 0.0;
    double availableBal = newTokenWalletBalance.balance ?? 0.0;
    double lockedBal = newTokenWalletBalance.lockBalance ?? 0.0;

    double usdValue = walletService.calculateCoinUsdBalance(
        marketPrice, availableBal, lockedBal);
    String holder = NumberUtil.currencyFormat(usdValue, 2);
    formattedUsdValueList.add(holder);

    WalletInfo wi = WalletInfo(
        id: null,
        tickerName: newToken.tickerName,
        tokenType: newToken.chainName,
        address: newCoinAddress,
        availableBalance: newTokenWalletBalance.balance,
        lockedBalance: newTokenWalletBalance.lockedExchangeBalance,
        usdValue: usdValue,
        name: newToken.coinName,
        inExchange: newTokenWalletBalance.unlockedExchangeBalance);
    walletInfo.add(wi);
    log.e(
        'new coin ${wi.tickerName} added ${wi.toJson()} in wallet info object');
    await walletDatabaseService.insert(wi);

    // save data locally
    // List<String> tokenList = [];

    // var x = jsonEncode(newToken);

    // tokenList.add(x);
    // storageService.tokenList = tokenList;
  }

/*----------------------------------------------------------------------
                      Add New Token In Db
----------------------------------------------------------------------*/

  insertToken(Token newToken) async {
    if (newToken.chainName == 'FAB') {
      newToken.contract = '0x' + newToken.contract;
    }
    await tokenListDatabaseService.insert(newToken);
  }

/*----------------------------------------------------------------------
                      Assign New Token Address
----------------------------------------------------------------------*/
  String assignNewTokenAddress(Token newToken) {
    String newCoinAddress = '';
    walletInfo.firstWhere((wallet) {
      if (wallet.tickerName == newToken.chainName) {
        if (newToken.chainName == 'FAB')
          newCoinAddress = fabToExgAddress(wallet.address);
        else
          newCoinAddress = wallet.address;
        log.w('new token ${newToken.tickerName} address $newCoinAddress');
        return true;
      }
      return false;
    });
    return newCoinAddress;
  }

/*-------------------------------------------------------------------------------------
                          Refresh Balances
-------------------------------------------------------------------------------------*/

  Future refreshBalance() async {
    if (!isBusy) setBusy(true);
    List<String> tickerNamesFromWalletInfoCopy = [];

    await walletDatabaseService.getAll().then((walletList) {
      walletInfoCopy = [];
      formattedUsdValueList = [];
      log.e('wallet list from db length ${walletList.length}');
      final tickers = walletList.map((e) => e.tickerName).toSet();

      walletList.retainWhere((element) => tickers.remove(element.tickerName));
      walletInfoCopy = walletList;
    });
    log.i('walletInfo copy list  length ${walletInfoCopy.length}');

    // await walletDatabaseService.deleteDb();
    // walletInfo.forEach((element) async {
    //   await walletDatabaseService.insert(element);
    // });
    // var wd = await walletDatabaseService.getAll();
    // log.e('wallet list from db length after deleting and adding ${wd.length}');
    walletInfo = [];
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

    // UserSettingsDatabaseService userSettingsDatabaseService =
    //     locator<UserSettingsDatabaseService>();
    // await userSettingsDatabaseService
    //     .insert(UserSettings(walletBalancesBody: walletBalancesBody));

    //storageService.walletBalancesBody = json.encode(walletBalancesBody);

    // ----------------------------------------
    // Calling walletBalances in wallet service
    // ----------------------------------------
    await this
        .apiService
        .getWalletBalance(walletBalancesBody)
        .then((walletBalanceList) async {
      if (walletBalanceList != null) {
        // Loop wallet info list to udpate balances
        log.e(
            'walletInfoCopy length ${walletInfoCopy.length} -- balance list length ${walletBalanceList.length}');
        walletInfoCopy.removeWhere((element) => element.tickerName == 'TRX');
        walletInfoCopy.forEach((wallet) async {
          // Loop wallet balance list from api
          for (var j = 0; j <= walletBalanceList.length; j++) {
            // wallet info copy properties assigning to variables for easier use
            String walletInfoTickerName = wallet.tickerName;
            // wallet balance list properties assigning to variables for easier use
            String walletBalanceCoinName = walletBalanceList[j].coin;

            // Compare wallet info copy ticker name to wallet balance coin name
            if (walletInfoTickerName == walletBalanceCoinName) {
              double marketPrice = walletBalanceList[j].usdValue.usd ?? 0.0;
              double availableBal = walletBalanceList[j].balance ?? 0.0;
              double lockedBal = walletBalanceList[j].lockBalance ?? 0.0;

              // Check if market price error from api then show the notification with ticker name
              // so that user know why USD val for that ticker is 0

              if (marketPrice.isNegative) {
                marketPrice = 0.0;
              }
              if (availableBal.isNegative) {
                availableBal = 0.0;
              }
              // Calculating individual coin USD val
              double usdValue = walletService.calculateCoinUsdBalance(
                  marketPrice, availableBal, lockedBal);
              String holder = NumberUtil.currencyFormat(usdValue, 2);
              formattedUsdValueList.add(holder);

              WalletInfo wi = new WalletInfo(
                  id: wallet.id,
                  tickerName: walletInfoTickerName,
                  tokenType: wallet.tokenType,
                  address: wallet.address,
                  availableBalance: availableBal,
                  lockedBalance: lockedBal,
                  usdValue: usdValue,
                  name: wallet.name,
                  inExchange: walletBalanceList[j].unlockedExchangeBalance);
              walletInfo.add(wi);
              //   log.i('single wallet info object${wi.toJson()}');
              walletDatabaseService.update(wi);

              if (!tickerNamesFromWalletInfoCopy.contains(walletInfoTickerName))
                tickerNamesFromWalletInfoCopy.add(walletInfoTickerName);
              print(
                  'wallet info copy tickerNames length ${tickerNamesFromWalletInfoCopy.length} -- $tickerNamesFromWalletInfoCopy');
              // break the second j loop of wallet balance list when match found
              break;
            } // If ends

          } // For loop j ends
        }); // walletInfo for each ends

        //  second if -- starts to add new coins in wallet info list
        if (tickerNamesFromWalletInfoCopy.length != walletBalanceList.length) {
          log.e(
              'wallet info copy length is ${tickerNamesFromWalletInfoCopy.length} and wallet balances length ${walletBalanceList.length} ');
          List<WalletBalance> newTokenListFromWalletBalances = [];
          walletBalanceList.forEach((walletBalanceObj) async {
            bool isOldTicker =
                tickerNamesFromWalletInfoCopy.contains(walletBalanceObj.coin);
            print(
                'wallet info contains ${walletBalanceObj.coin}? => $isOldTicker');
            if (!isOldTicker &&
                walletBalanceObj.coin != 'TRX' &&
                walletBalanceObj.coin != 'USDTX') {
              //  newTokenList.add(walletBalanceObj.coin);
              newTokenListFromWalletBalances.add(walletBalanceObj);
              log.i('new coin to add ${walletBalanceObj.toJson()}');
            }
          });

          /// if new token list from wallet balances is not empty
          /// then call token list update api

          if (newTokenListFromWalletBalances.isNotEmpty) {
            await walletService
                .getTokenListUpdates()
                .then((newTokenListFromTokenUpdateApi) async {
              if (newTokenListFromTokenUpdateApi != null) {
                var existingTokensInTokenDatabase =
                    await tokenListDatabaseService.getAll();
                if (existingTokensInTokenDatabase != null) {
                  log.i(
                      'new token update list length ${newTokenListFromTokenUpdateApi.length} -- token list database list length ${existingTokensInTokenDatabase.length}');
                  //  if length of token list db and token update list is not same
                  // then delete the db
                  if (existingTokensInTokenDatabase.length !=
                      newTokenListFromTokenUpdateApi.length) {
                    await tokenListDatabaseService.deleteDb().whenComplete(() =>
                        log.e(
                            'ticker database cleared before inserting update token data from api'));
                    print('x ${existingTokensInTokenDatabase.length}');
                  }

                  /// Fill the token list database with new data from the api

                  newTokenListFromTokenUpdateApi
                      .forEach((singleNewToken) async {
                    if (singleNewToken.coinName != 'USDTX')
                      await tokenListDatabaseService.insert(singleNewToken);
                  });
                  // print the new token list database length
                  var t = await tokenListDatabaseService.getAll();
                  log.i('tokenListDatabaseService length ${t.length}');
                }
              }
              newTokenListFromWalletBalances
                  .forEach((newTokenWalletBalance) async {
                // compare tickername of wallet balance api token against tokenListUpdate api token tickername
                newTokenListFromTokenUpdateApi
                    .forEach((singleNewTokenFromTokenUpdateApi) async {
                  if (newTokenWalletBalance.coin !=
                      'USDTX') if (newTokenWalletBalance
                          .coin ==
                      singleNewTokenFromTokenUpdateApi.tickerName) {
                    log.i('----- Building new wallet object -----');
                    await buildNewWalletObject(singleNewTokenFromTokenUpdateApi,
                        newTokenWalletBalance);
                  }
                });
              });
              var allWalletDatabaseData = await walletDatabaseService.getAll();
              log.i(
                  'All wallet database data length ${allWalletDatabaseData.length}');
            }).catchError((err) {
              log.e('Token list api call fails in api service');
            });
          } else {
            log.w('No new tokens');
            print(walletInfoCopy.length);
            print(walletBalanceList.length);
            var t = await tokenListDatabaseService.getAll();
            try {
              int i = 1;
              t.forEach((element) {
                log.i('$i -- ${element.toJson()}');
                i++;
              });
            } catch (err) {
              log.e('something break $err');
            }
            print('tokenListDatabaseService length ${t.length}');
          }
        } // second if ends

        // get exg address to get free fab
        await getGas();
        // check gas and fab balance if 0 then ask for free fab
        if (gasAmount == 0.0 && fabBalance == 0.0) {
          String address = await getExgAddressFromWalletDatabase();
          storageService.isShowCaseView = true;
          _isShowCaseView = true;
          var res = await apiService.getFreeFab(address);
          if (res != null) {
            isFreeFabNotUsed = res['ok'];
          }
        } else {
          log.i('Fab or gas balance available already');
          // storageService.isShowCaseView = false;
        }

        calcTotalBal();

// check if any new coins added in api
        // await walletService.getTokenListUpdates();
      } // if wallet balance list != null ends

      // in else if walletBalances is null then check balance with old method
      else if (walletBalanceList == null) {
        log.e('---------------------ELSE old way-----------------------');
        //  await oldWayToGetBalances(walletService.coinTickers.length);
      }
    }).timeout(Duration(seconds: 60), onTimeout: () async {
      log.e('time out');
      walletInfo = walletInfoCopy;
      // sharedService.alertDialog(AppLocalizations.of(context).notice,
      //     AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater);
      //  await oldWayToGetBalances(walletService.coinTickers.length);
      setBusy(false);
      //return;
    }).catchError((err) async {
      log.e('Wallet balance CATCH $err');
      sharedService.alertDialog(AppLocalizations.of(context).notice,
          AppLocalizations.of(context).serverError);
      setBusy(false);
    });

    if (walletInfo != null) {
      walletInfoCopy = [];
      walletInfoCopy = walletInfo.map((element) => element).toList();
    }

    if (formattedUsdValueList != null) {
      formattedUsdValueListCopy = [];
      formattedUsdValueListCopy =
          formattedUsdValueList.map((element) => element).toList();
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                Save Locally
----------------------------------------------------------------------*/
  saveTokenLocally() async {
    // await tokenListDatabaseService.getByName('CNB').then((newToken) {
    //   List<String> tokenList = [];

    //   var x = jsonEncode(newToken);
    //   print('encode $x');
    //   tokenList.add(x);
    //   log.i('tokenList $tokenList');
    //   storageService.tokenList = tokenList;
    //   storageService.tokenList.forEach((element) {
    //     print(element);
    //     var t = jsonDecode(element);
    //     Token token = Token.fromJson(t);
    //     print(token.tickerName);
    //   });
    // });

    // var x = storageService.tokenList;
    // print(x);

    // storageService.tokenList.forEach((element) {
    //   print(element);
    //   var json = jsonDecode(element);
    //   Token token = Token.fromJson(json);
    //   if (token.tokenType == 131075) print(token.tickerName);
    // tickerName = token.tickerName;
    // });

    String mne = "";
    walletService.generateTrxAddress(mne);
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
        String holder = NumberUtil.currencyFormat(usdValue, 2);
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
        // })
        // .timeout(Duration(seconds: 25), onTimeout: () async {
        //   sharedService.alertDialog(
        //       '', AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater);
        //   //  await retrieveWallets();
        //   log.e('Timeout');
        //   return;
      }).catchError((error) async {
        setBusy(false);
        sharedService.alertDialog(
            '', AppLocalizations.of(context).genericError);
        await retrieveWalletsFromLocalDatabase();
        log.e('Something went wrong  - $error');
        return;
      });
    } // For loop ends

    calcTotalBal();
    await getExchangeAssetsBalance();
    // await updateWalletDatabase();
    String address = await getExgAddressFromWalletDatabase();
    await getGas();
    // check gas and fab balance if 0 then ask for free fab
    if (gasAmount == 0.0 && fabBalance == 0.0) {
      var res = await apiService.getFreeFab(address);
      if (res != null) {
        isFreeFabNotUsed = res['ok'];
      }
    } else {
      log.i('Fab or gas balance available already');
      //  storageService.isShowCaseView = true;
    }
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
    var res = await walletService.getAllExchangeBalances(address);
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
  // updateWalletDatabase() async {
  //   for (int i = 0; i < walletInfo.length; i++) {
  //     await walletDatabaseService.update(walletInfo[i]);
  //   }
  // }

// test version pop up
  debugVersionPopup() async {
    // await _showNotification();

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

// Future<void> _showNotification() async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'your channel id', 'your channel name', 'your channel description',
//       importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(0, 'Test Server Warning',
//       'You are using Test Server!', platformChannelSpecifics,
//       payload: 'item x');
// }
