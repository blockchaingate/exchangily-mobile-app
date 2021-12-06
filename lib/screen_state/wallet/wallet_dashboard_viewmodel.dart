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
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/enums/connectivity_status.dart';
import 'package:exchangilymobileapp/environments/coins.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/token.dart';
import 'package:exchangilymobileapp/models/wallet/user_settings_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_balance.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/decimal_config_database_service.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/shared/globalLang.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';

import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/tron_util/trx_generate_address_util.dart'
    as TronAddressUtil;
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stacked/stacked.dart';

import 'package:json_diff/json_diff.dart';

class WalletDashboardViewModel extends BaseViewModel {
  final log = getLogger('WalletDashboardViewModel');

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
  final dialogService = locator<DialogService>();
  final userDatabaseService = locator<UserSettingsDatabaseService>();

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

  var lang;

  var top = 0.0;
  final freeFabAnswerTextController = TextEditingController();
  String postFreeFabResult = '';
  bool isFreeFabNotUsed = false;
  double fabBalance = 0.0;
  // List<String> formattedUsdValueList = [];
  // List<String> formattedUsdValueListCopy = [];

  final searchCoinTextController = TextEditingController();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  //vars for announcement
  bool hasApiError = false;
  List announceList;
  GlobalKey globalKeyOne;
  GlobalKey globalKeyTwo;
  double totalBalanceContainerWidth = 100.0;

  bool _isShowCaseView = false;
  get isShowCaseView => _isShowCaseView;

  int unreadMsgNum = 0;
  bool isUpdateWallet = false;
  List<WalletInfo> favWalletInfoList = [];
  bool isShowFavCoins = false;
  int currentTabSelection = 0;
  ScrollController walletsScrollController = ScrollController();
  int minusHeight = 25;

  bool isBottomOfTheList = false;
  bool isTopOfTheList = true;
  final fabUtils = FabUtils();
  List<Map<String, int>> walletDecimalList = [];
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
    //  getDecimalPairConfig();
    getConfirmDepositStatus();
    buildFavCoinList();
    currentTabSelection = storageService.isFavCoinTabSelected ? 1 : 0;
    // walletsScrollController.addListener(_scrollListener());
    //   await storeWalletDecimalData();
    refreshController = new RefreshController();

    setBusy(false);
  }
// TODO add decimalLimit property in the wallet info and fill it in the refresh balance from local stored decimal data

  storeWalletDecimalData() async {
    walletDecimalList = [];
    await apiService.getTokenList().then((token) {
      token.forEach((token) {
        walletDecimalList.add({token.tickerName: token.decimal});
      });
    });

    await apiService.getTokenListUpdates().then((token) {
      token.forEach((token) async {
        walletDecimalList.add({token.tickerName: token.decimal});
      });
    });

    // walletInfo.forEach((wallet) async {
    //   int decimalLimit = 0;
    //   for (var i = 0; i < walletDecimalList.length; i++) {
    //     if (decimalLimit == null || decimalLimit == 0) decimalLimit = 8;
    //     Map<String, int> dataToAdd = {};
    //     dataToAdd = {wallet.tickerName: decimalLimit};
    //     walletDecimalList.add(dataToAdd);
    //   }
    // });
    log.i('walletDecimalList $walletDecimalList');
    int storedDecimalListLength =
        storageService.getStoredListLength(storageService.walletDecimalList);

    if (walletDecimalList.length != storedDecimalListLength) {
      log.w('clearing storedDecimalList');
      if (storedDecimalListLength != 0) storageService.walletDecimalList = '';

      var t = {walletDecimalList.map((e) => jsonEncode(e)).toList()};
      log.w('json encode decimal data before storing $t');
      storageService.walletDecimalList = t.toString();
    }
    log.i('latest storedDecimalList ${storageService.walletDecimalList}');
  }

  // moveDown() {
  //   walletsScrollController.animateTo(
  //       walletsScrollController.offset +
  //           walletsScrollController.position.maxScrollExtent,
  //       curve: Curves.linear,
  //       duration: Duration(milliseconds: 500));
  // }

  // moveUp() {
  //   walletsScrollController.animateTo(
  //       walletsScrollController.offset +
  //           walletsScrollController.position.minScrollExtent,
  //       curve: Curves.linear,
  //       duration: Duration(milliseconds: 500));
  // }

  _scrollListener() {
    walletsScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (walletsScrollController.hasClients) {
        if (walletsScrollController.offset >=
                walletsScrollController.position.maxScrollExtent &&
            !walletsScrollController.position.outOfRange) {
          setBusy(true);
          print('bottom');

          isBottomOfTheList = true;
          isTopOfTheList = false;
          minusHeight = 50;
          setBusy(false);
        }
        if (walletsScrollController.offset <=
                walletsScrollController.position.minScrollExtent &&
            !walletsScrollController.position.outOfRange) {
          setBusy(true);
          print('top');
          isTopOfTheList = true;
          isBottomOfTheList = false;
          minusHeight = 25;
          setBusy(false);
        }
        if (walletsScrollController.position.outOfRange) {
          print('bot in');
        }
      }
    });
  }

  updateTabSelection(int tabIndex) {
    setBusy(true);
    if (tabIndex == 0)
      isShowFavCoins = false;
    else
      isShowFavCoins = true;

    currentTabSelection = tabIndex;
    storageService.isFavCoinTabSelected = isShowFavCoins ? true : false;
    print(
        'current tab sel $currentTabSelection -- isShowFavCoins $isShowFavCoins');
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Search Coins By TickerName
----------------------------------------------------------------------*/

  searchFavCoinsByTickerName(String value) async {
    setBusyForObject(favWalletInfoList, true);
    var favWalletInfoListCopy = favWalletInfoList;
    print('length ${favWalletInfoList.length} -- value $value');
    try {
      for (var i = 0; i < favWalletInfoListCopy.length; i++) {
        print(
            'favWalletInfoList ${favWalletInfoList[i].tickerName == value.toUpperCase()}');
        if (favWalletInfoListCopy[i].tickerName == value.toUpperCase() ||
            favWalletInfoListCopy[i].name == value) {
          favWalletInfoList = [];
          log.i('favWalletInfoListCopy ${favWalletInfoListCopy[i].toJson()}');
          favWalletInfoList.add(favWalletInfoListCopy[i]);
          setBusyForObject(favWalletInfoList, false);
          break;
        } else {
          favWalletInfoList = [];
          favWalletInfoList = favWalletInfoListCopy;
          break;
        }
      }
      // tabBarViewHeight = MediaQuery.of(context).viewInsets.bottom == 0
      //     ? MediaQuery.of(context).size.height / 2 - 250
      //     : MediaQuery.of(context).size.height / 2;
      print('favWalletInfoList length ${favWalletInfoList.length}');
    } catch (err) {
      setBusyForObject(favWalletInfoList, false);
      log.e('searchFavCoinsByTickerName CATCH');
    }

    setBusyForObject(favWalletInfoList, false);
  }

/*----------------------------------------------------------------------
                    Build Fav Coins List
----------------------------------------------------------------------*/

  buildFavCoinList() async {
    setBusyForObject(favWalletInfoList, true);

    favWalletInfoList.clear();
    String favCoinsJson = storageService.favWalletCoins;
    if (favCoinsJson != null && favCoinsJson != '') {
      List<String> favWalletCoins =
          (jsonDecode(favCoinsJson) as List<dynamic>).cast<String>();

      List<WalletInfo> walletsFromDb = [];
      await walletDatabaseService
          .getAll()
          .then((wallets) => walletsFromDb = wallets);

      //  try {
      for (var i = 0; i < favWalletCoins.length; i++) {
        for (var j = 0; j < walletsFromDb.length; j++) {
          if (walletsFromDb[j].tickerName == favWalletCoins[i].toString()) {
            favWalletInfoList.add(walletsFromDb[j]);
            break;
          }
        }
        // log.i('favWalletInfoList ${favWalletInfoList[i].toJson()}');
      }
      log.w('favWalletInfoList length ${favWalletInfoList.length}');
      //  setBusy(false);
      //   return;
      // } catch (err) {
      //   log.e('favWalletCoins CATCH');
      //   setBusyForObject(favWalletInfoList, false);
      // }
    }
    setBusyForObject(favWalletInfoList, false);
  }

/*----------------------------------------------------------------------
                            Move Trx Usdt
----------------------------------------------------------------------*/
  moveTronUsdt() async {
    try {
      var tronUsdtWalletObj =
          walletInfo.singleWhere((element) => element.tickerName == 'USDTX');
      if (tronUsdtWalletObj != null) {
        int tronUsdtIndex = walletInfo.indexOf(tronUsdtWalletObj);
        if (tronUsdtIndex != 5) {
          walletInfo.removeAt(tronUsdtIndex);
          walletInfo.insert(5, tronUsdtWalletObj);
        } else {
          log.i('2nd else move tronusdt tron usdt already at #5');
        }
      } else {
        log.w('1st else move tronusdt can\'t find tron usdt');
      }
    } catch (err) {
      log.e('movetronusdt Catch $err');
    }
  }

  moveTron() {
    try {
      var tronWalletObj =
          walletInfo.singleWhere((element) => element.tickerName == 'TRX');
      if (tronWalletObj != null) {
        int tronUsdtIndex = walletInfo.indexOf(tronWalletObj);
        if (tronUsdtIndex != 7) {
          walletInfo.removeAt(tronUsdtIndex);
          walletInfo.insert(7, tronWalletObj);
        } else {
          log.i('2nd else moveTron tron usdt already at #7');
        }
      } else {
        log.w('1st else moveTron cant find tron usdt');
      }
    } catch (err) {
      log.e('moveTron Catch $err');
    }
  }

/*----------------------------------------------------------------------
                            Fav Tab
----------------------------------------------------------------------*/

/*----------------------------------------------------------------------
                Update wallet with new native coins
----------------------------------------------------------------------*/

  checkToUpdateWallet() async {
    setBusy(true);
    await walletDatabaseService.getWalletBytickerName('TRX').then((wallet) {
      if (wallet != null) {
        log.w('${wallet.tickerName} present');
        isUpdateWallet = false;
      } else {
        isUpdateWallet = true;
        // updateWallet();
        // showUpdateWalletDialog();
      }
    });
    setBusy(false);
  }

/*---------------------------------------------------
          Update Info dialog
--------------------------------------------------- */

  showUpdateWalletDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? Theme(
                data: ThemeData.dark(),
                child: CupertinoAlertDialog(
                  title: Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Center(
                        child: Text(
                      '${AppLocalizations.of(context).appUpdateNotice}',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: primaryColor, fontWeight: FontWeight.w500),
                    )),
                  ),
                  content: Container(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            updateWallet();
                          },
                          child: Text(AppLocalizations.of(context).updateNow))),
                  actions: <Widget>[],
                ))
            : AlertDialog(
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.all(5.0),
                elevation: 5,
                backgroundColor: walletCardColor.withOpacity(0.85),
                title: Container(
                  padding: EdgeInsets.all(10.0),
                  color: secondaryColor.withOpacity(0.5),
                  child: Center(
                      child: Text(
                          '${AppLocalizations.of(context).appUpdateNotice}')),
                ),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontWeight: FontWeight.bold),
                contentTextStyle: TextStyle(color: grey),
                content: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor)),
                          onPressed: () async {
                            //  Navigator.of(context).pop();
                            await updateWallet().then((res) {
                              if (res) Navigator.of(context).pop();
                            });
                          },
                          child: Text(AppLocalizations.of(context).updateNow,
                              style: Theme.of(context).textTheme.headline5),
                        ),
                      ]),
                ));
      },
    );
  }

  // add trx if not present in wallet
  //Future<bool>
  updateWallet() async {
    setBusy(true);
    //  bool isSuccess = false;
    String mnemonic = '';
    await dialogService
        .showDialog(
            title: AppLocalizations.of(context).enterPassword,
            description:
                AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
            buttonTitle: AppLocalizations.of(context).confirm)
        .then((res) async {
      if (res.confirmed) {
        mnemonic = res.returnedText;
        var address = TronAddressUtil.generateTrxAddress(mnemonic);
        WalletInfo wi = new WalletInfo(
            id: null,
            tickerName: 'TRX',
            tokenType: '',
            address: address,
            availableBalance: 0.0,
            lockedBalance: 0.0,
            usdValue: 0.0,
            name: 'Tron');

        log.i("new wallet trx generated in update wallet ${wi.toJson()}");
        isUpdateWallet = false;
        await walletDatabaseService.insert(wi);
        await refreshBalance();
        //   isSuccess = true;
      } else if (res.returnedText == 'Closed') {
        //  showUpdateWalletDialog();
        setBusy(false);
      }
    });
    setBusy(false);
    //return isSuccess;
  }
/*----------------------------------------------------------------------
                        Check Announcement
----------------------------------------------------------------------*/

  checkAnnouncement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userSettingsDatabaseService = locator<UserSettingsDatabaseService>();
    var lang = await userSettingsDatabaseService.getLanguage();
    // lang = storageService.language;
    if (lang == '' || lang == null)
      lang = Platform.localeName.substring(0, 2) ?? 'en';
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

  updateShowCaseViewStatus() {
    _isShowCaseView = false;
  }

/*----------------------------------------------------------------------
                        On Single Coin Card Click
----------------------------------------------------------------------*/

  onSingleCoinCardClick(index) {
    FocusScope.of(context).requestFocus(FocusNode());
    navigationService.navigateTo(WalletFeaturesViewRoute,
        arguments: walletInfo[index]);
    searchCoinTextController.clear();
    resetWalletInfoObject();
  }

/*----------------------------------------------------------------------
                    Search Coins By TickerName
----------------------------------------------------------------------*/

  searchCoinsByTickerName(String value) async {
    setBusy(true);

    print('length ${walletInfoCopy.length} -- value $value');
    for (var i = 0; i < walletInfoCopy.length; i++)
      if (walletInfoCopy[i].tickerName == value.toUpperCase() ||
              walletInfoCopy[i].name == value
          //||          isFirstCharacterMatched(value, i)
          ) {
        setBusy(true);
        walletInfo = [];
        // formattedUsdValueList = [];
        log.e('copy ${walletInfoCopy[i].toJson()}');

        // String holder =
        //     NumberUtil.currencyFormat(walletInfoCopy[i].usdValue, 2);
        // formattedUsdValueList.add(holder);
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
    // tabBarViewHeight = MediaQuery.of(context).viewInsets.bottom != 0
    //     ? MediaQuery.of(context).size.height / 2 - 250
    //     : MediaQuery.of(context).size.height / 2;
    setBusy(false);
  }

  resetWalletInfoObject() {
    walletInfo = [];
    //formattedUsdValueList = [];
    walletInfo = walletInfoCopy;
//    formattedUsdValueList = formattedUsdValueListCopy;
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
                          titlePadding: EdgeInsets.symmetric(vertical: 0),
                          actionsPadding: EdgeInsets.all(0),
                          elevation: 5,
                          titleTextStyle: Theme.of(context).textTheme.headline4,
                          contentTextStyle: TextStyle(color: grey),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor: walletCardColor.withOpacity(0.95),
                          title: Container(
                            color: primaryColor,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              AppLocalizations.of(context).question,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          content: Column(
                            children: <Widget>[
                              UIHelper.verticalSpaceSmall,
                              Text(
                                res['_body']['question'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: red,
                                        fontWeight: FontWeight.bold),
                              ),
                              UIHelper.verticalSpaceSmall,
                              TextField(
                                minLines: 1,
                                style: TextStyle(color: white),
                                controller: freeFabAnswerTextController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: white, width: 1)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 1)),
                                  focusColor: primaryColor,
                                  isDense: true,
                                  icon: Icon(
                                    Icons.question_answer,
                                    color: white,
                                  ),
                                ),
                                cursorColor: white,
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
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Cancel
                                      OutlinedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(grey),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(0)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .cancel,
                                              style: TextStyle(
                                                  color: Colors.black,
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
                                      TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    primaryColor),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(0)),
                                          ),
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
                                            String fabAddress = await sharedService
                                                .getFABAddressFromWalletDatabase();
                                            postFreeFabResult = '';
                                            Map data = {
                                              "address": fabAddress,
                                              "questionair_id": res['_body']
                                                  ['_id'],
                                              "answer":
                                                  freeFabAnswerTextController
                                                      .text
                                            };
                                            log.e('free fab post data $data');
                                            await fabUtils
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
      if (!walletInfo[i].usdValue.isNegative) holder += walletInfo[i].usdValue;
    }
    totalUsdBalance = NumberUtil.currencyFormat(holder, 2);
    log.i('Total usd balance $totalUsdBalance');
  }

  // Get EXG address from wallet database
  Future<String> getExgAddressFromWalletDatabase() async {
    String address = '';
    await walletDatabaseService
        .getWalletBytickerName('EXG')
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
// mpvWdFb91gYN1Q1UBfhMEmGn1Amw3BNthZ
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
                    .firstWhere((element) => element.coinType == coinType)
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
    if (gasAmount == 0.0) {
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

  buildFavWalletCoinsList(String tickerName) async {
    List<String> favWalletCoins = [];
    favWalletCoins.add(tickerName);
    // UserSettings userSettings = UserSettings(favWalletCoins: [tickerName]);
    // await userDatabaseService.update(userSettings);

    storageService.favWalletCoins = json.encode(favWalletCoins);
  }

/*----------------------------------------------------------------------
                      Build coin list
----------------------------------------------------------------------*/

  buildNewWalletObject(
      TokenModel newToken, WalletBalance newTokenWalletBalance) async {
    String newCoinAddress = '';

    newCoinAddress = assignNewTokenAddress(newToken);
    double marketPrice = newTokenWalletBalance.usdValue.usd ?? 0.0;
    double availableBal = newTokenWalletBalance.balance ?? 0.0;
    double lockedBal = newTokenWalletBalance.lockBalance ?? 0.0;

    double usdValue = walletService.calculateCoinUsdBalance(
        marketPrice, availableBal, lockedBal);
    // String holder = NumberUtil.currencyFormat(usdValue, 2);
    // formattedUsdValueList.add(holder);

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

  insertToken(TokenModel newToken) async {
    if (newToken.chainName == 'FAB') {
      newToken.contract = '0x' + newToken.contract;
    }
    await tokenListDatabaseService.insert(newToken);
  }

/*----------------------------------------------------------------------
                      Assign New Token Address
----------------------------------------------------------------------*/
  String assignNewTokenAddress(TokenModel newToken) {
    String newCoinAddress = '';
    walletInfo.firstWhere((wallet) {
      if (wallet.tickerName == newToken.chainName) {
        if (newToken.chainName == 'FAB')
          newCoinAddress = fabUtils.fabToExgAddress(wallet.address);
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
    setBusy(true);
    List<String> tickerNamesFromWalletInfoCopy = [];

    await walletDatabaseService.getAll().then((walletList) async {
      walletInfoCopy = [];
      // formattedUsdValueList = [];
      log.e('wallet list from db length ${walletList.length}');
      final dbWalletLength = walletList.length;
      final tickers = walletList.map((e) => e.tickerName).toSet();

      walletList.retainWhere((element) => tickers.remove(element.tickerName));
      walletInfoCopy = walletList;
      if (walletList.length != dbWalletLength) {
        await walletDatabaseService.deleteDb();
        walletInfoCopy.forEach((wallet) async {
          await walletDatabaseService.insert(wallet);
        });
      }
    });
    log.i('walletInfo copy list  length ${walletInfoCopy.length}');

    walletInfo = [];

    Map<String, dynamic> walletBalancesBody = {};
    try {
      walletBalancesBody = jsonDecode(storageService.walletBalancesBody) ?? {};
    } catch (err) {
      log.e(err);
      bool isWalletBalanceBodyFromStorageEmpty =
          walletBalancesBody['btcAddress'] == '' || walletBalancesBody.isEmpty;
      if (isWalletBalanceBodyFromStorageEmpty) {
        Map<String, dynamic> wbb = {
          'btcAddress': '',
          'ethAddress': '',
          'fabAddress': '',
          'ltcAddress': '',
          'dogeAddress': '',
          'bchAddress': '',
          'trxAddress': '',
          "showEXGAssets": "true"
        };
        walletInfoCopy.forEach((wallet) {
          if (wallet.tickerName == 'BTC') {
            wbb['btcAddress'] = wallet.address;
          } else if (wallet.tickerName == 'ETH') {
            wbb['ethAddress'] = wallet.address;
          } else if (wallet.tickerName == 'FAB') {
            wbb['fabAddress'] = wallet.address;
          } else if (wallet.tickerName == 'LTC') {
            wbb['ltcAddress'] = wallet.address;
          } else if (wallet.tickerName == 'DOGE') {
            wbb['dogeAddress'] = wallet.address;
          } else if (wallet.tickerName == 'BCH') {
            wbb['bchAddress'] = wallet.address;
          } else if (wallet.tickerName == 'TRX') {
            wbb['trxAddress'] = wallet.address;
          }
        });
        storageService.walletBalancesBody = json.encode(wbb);
        walletBalancesBody = jsonDecode(storageService.walletBalancesBody);
      }
    }

    // ----------------------------------------
    // Calling walletBalances in wallet service
    // ----------------------------------------
    bool isLocalWalletLengthEqualApiWallets = false;
    List<WalletBalance> walletBalanceList = [];
    walletBalanceList =
        await this.apiService.getWalletBalance(walletBalancesBody);
    //     .then(() async {

    // }).timeout(Duration(seconds: 60), onTimeout: () {
    //   log.e('time out');
    //   walletInfo = walletInfoCopy;
    //   setBusy(false);
    // }).catchError((err) {
    //   log.e('Wallet balance CATCH $err');
    //   sharedService.alertDialog(AppLocalizations.of(context).notice,
    //       AppLocalizations.of(context).networkIssue);
    //   setBusy(false);
    // });

    if (walletBalanceList != null) {
      // Loop wallet info list to udpate balances
      log.e(
          'walletInfoCopy length ${walletInfoCopy.length} -- balance list length ${walletBalanceList.length}');
      isLocalWalletLengthEqualApiWallets =
          walletInfoCopy.length == walletBalanceList.length;
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
            // String holder = NumberUtil.currencyFormat(usdValue, 2);
            // formattedUsdValueList.add(holder);

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
            log.i('single wallet info object${wi.toJson()}');
            if (!tickerNamesFromWalletInfoCopy.contains(walletInfoTickerName)) {
              tickerNamesFromWalletInfoCopy.add(walletInfoTickerName);
            }
            log.i(
                'wallet info copy tickerNames length ${tickerNamesFromWalletInfoCopy.length} -- $tickerNamesFromWalletInfoCopy');
            await walletDatabaseService.update(wi);
            break;
            // break the second j loop of wallet balance list when match found
          } // If ends
        } // For loop j ends
      });
      // walletInfo for each ends
    }
    List<WalletBalance> newTokenListFromWalletBalances = [];
    log.i(
        'isLocalWalletLengthEqualApiWallets $isLocalWalletLengthEqualApiWallets --  tickerNamesFromWalletInfoCopy.isNotEmpty ${tickerNamesFromWalletInfoCopy.isNotEmpty}');
    if (!isLocalWalletLengthEqualApiWallets &&
        tickerNamesFromWalletInfoCopy.isNotEmpty) {
      walletBalanceList.forEach((walletBalanceObj) {
        bool isOldTicker =
            tickerNamesFromWalletInfoCopy.contains(walletBalanceObj.coin);
        print('wallet info contains ${walletBalanceObj.coin}? => $isOldTicker');
        if (!isOldTicker) {
          //  newTokenList.add(walletBalanceObj.coin);
          newTokenListFromWalletBalances.add(walletBalanceObj);
          log.i('new coin to add ${walletBalanceObj.toJson()}');
        }
      });
    }

    /// if new token list from wallet balances is not empty
    /// then call token list update api

    if (newTokenListFromWalletBalances.isNotEmpty) {
      await walletService
          .getTokenListUpdates()
          .then((newTokenListFromTokenUpdateApi) async {
        if (newTokenListFromTokenUpdateApi != null &&
            newTokenListFromTokenUpdateApi.isNotEmpty) {
          var existingTokensInTokenDatabase =
              await tokenListDatabaseService.getAll();
          if (existingTokensInTokenDatabase != null) {
            log.i(
                'new token update list length ${newTokenListFromTokenUpdateApi.length} -- token list database list length ${existingTokensInTokenDatabase.length}');
            //  if length of token list db and token update list is not same
            // then delete the db
            if (existingTokensInTokenDatabase.length !=
                newTokenListFromTokenUpdateApi.length) {
              await tokenListDatabaseService.deleteDb().whenComplete(() => log.e(
                  'token list database cleared before inserting updated token data from api'));
              print(
                  'existingTokensInTokenDatabase length ${existingTokensInTokenDatabase.length}');

              /// Fill the token list database with new data from the api

              newTokenListFromTokenUpdateApi.forEach((singleNewToken) async {
                await tokenListDatabaseService.insert(singleNewToken);
              });
            }
            // print the new token list database length
            var t = await tokenListDatabaseService.getAll();
            log.i(
                'tokenListDatabase filled with new tokens: length ${t.length}');
          }
        }
        newTokenListFromWalletBalances.forEach((newTokenWalletBalance) async {
          // compare tickername of wallet balance api token against tokenListUpdate api token tickername
          newTokenListFromTokenUpdateApi
              .forEach((singleNewTokenFromTokenUpdateApi) async {
            if (newTokenWalletBalance.coin ==
                singleNewTokenFromTokenUpdateApi.tickerName) {
              log.i('----- Building new wallet object -----');
              await buildNewWalletObject(
                  singleNewTokenFromTokenUpdateApi, newTokenWalletBalance);
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
      // try {
      //   int i = 1;
      //   t.forEach((element) {
      //     log.i('$i -- ${element.toJson()}');
      //     i++;
      //   });
      // } catch (err) {
      //   log.e('something break $err');
      // }
      print('tokenListDatabaseService length ${t.length}');
    }

    calcTotalBal();

    if (walletInfo != null && walletInfo.isNotEmpty) {
      walletInfoCopy = [];
      walletInfoCopy = walletInfo.map((element) => element).toList();
    }

    // if (formattedUsdValueList != null) {
    //   formattedUsdValueListCopy = [];
    //   formattedUsdValueListCopy =
    //       formattedUsdValueList.map((element) => element).toList();
    // }
    // await walletDatabaseService.deleteWalletByTickerName('TRX');
    await checkToUpdateWallet();
    moveTronUsdt();
    moveTron();
    // get exg address to get free fab
    await getGas();
    // check gas and fab balance if 0 then ask for free fab
    if (gasAmount == 0.0 && fabBalance == 0.0) {
      String address = await sharedService.getFABAddressFromWalletDatabase();
      if (storageService.isShowCaseView != null) {
        if (storageService.isShowCaseView) {
          storageService.isShowCaseView = true;
          _isShowCaseView = true;
        }
      } else {
        storageService.isShowCaseView = true;
        _isShowCaseView = true;
      }
      var res = await apiService.getFreeFab(address);
      if (res != null) {
        isFreeFabNotUsed = res['ok'];
      }
    } else {
      log.i('Fab or gas balance available already');
      // storageService.isShowCaseView = false;
    }
    // buildFavCoinList();
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                          Get exchange asset balance
-------------------------------------------------------------------------------------*/

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
