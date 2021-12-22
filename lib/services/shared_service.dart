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
import 'dart:typed_data';
import 'dart:ui';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/font_style.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/decimal_config_database_service.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:package_info/package_info.dart';
//import 'package:url_launcher/url_launcher.dart';

import 'package:exchangilymobileapp/environments/environment.dart';

import '../localizations.dart';
import '../shared/globals.dart' as globals;

class SharedService {
  BuildContext context;
  final log = getLogger('SharedService');
  final storageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  final tokenListDatabaseService = locator<TokenListDatabaseService>();
  DecimalConfigDatabaseService decimalConfigDatabaseService =
      locator<DecimalConfigDatabaseService>();
  final coreWalletDatabaseService = locator<CoreWalletDatabaseService>();

/*--------------------------------------------------------------------------
                  Show Simple Notification
------------------------------------------------------------------------- */
  sharedSimpleNotification(String content,
      {String subtitle = '', bool isError = true, int durationInSeconds = 3}) {
    return showSimpleNotification(
        Text(firstCharToUppercase(content),
            textAlign: subtitle.isEmpty ? TextAlign.center : TextAlign.start,
            style: headText3.copyWith(
                color: isError ? red : green, fontWeight: FontWeight.w500)),
        position: NotificationPosition.top,
        background: white,
        duration: Duration(seconds: durationInSeconds),
        slideDismissDirection: DismissDirection.startToEnd,
        subtitle: Text(subtitle,
            style: headText5.copyWith(
                color: isError ? red : green, fontWeight: FontWeight.w400)));
  }

/*----------------------------------------------------------------------
                    ShowNotification
----------------------------------------------------------------------*/

  showNotification(context) {
    showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        red,
        context);
  }

/*--------------------------------------------------------------------------
                  Get contract address from database
------------------------------------------------------------------------- */
  getContractAddressFromDatabase(String tickerName) async {
    String smartContractAddress = '';
    if (smartContractAddress == null) {
      print('$tickerName contract is null so fetching from token database');
      await tokenListDatabaseService
          .getContractAddressByTickerName(tickerName)
          .then((value) {
        if (value != null) {
          if (!value.startsWith('0x'))
            smartContractAddress = '0x' + value;
          else
            smartContractAddress = value;
        }
      });
      print('official smart contract address $smartContractAddress');
    }
    return smartContractAddress;
  }

/*--------------------------------------------------------------------------
                        getPairDecimalConfig
------------------------------------------------------------------------- */

  Future<PairDecimalConfig> getSinglePairDecimalConfig(String pairName,
      {String base = ''}) async {
    PairDecimalConfig singlePairDecimalConfig = new PairDecimalConfig();
    log.i('tickername $pairName -- endswith usdt ${pairName.endsWith('USDT')}');

    // if (pairName == 'BTC' || pairName == 'ETH' || pairName == 'EXG')
    //   base = 'USDT';
    // else
    if ((pairName == 'BTC' || pairName == 'ETH' || pairName == 'EXG') ||
        !pairName.endsWith('USDT') &&
            !pairName.endsWith('DUSD') &&
            !pairName.endsWith('BTC') &&
            !pairName.endsWith('ETH') &&
            !pairName.endsWith("EXG")) base = 'USDT';

    if (pairName == 'USDT' || pairName == 'DUSD') {
      return singlePairDecimalConfig =
          new PairDecimalConfig(name: pairName, priceDecimal: 2, qtyDecimal: 2);
    } else {
      log.i('base $base');
      await getAllPairDecimalConfig().then((res) {
        if (res != null) {
          singlePairDecimalConfig =
              res.firstWhere((element) => element.name == pairName + base);
          log.i(
              'returning result $singlePairDecimalConfig -- name $pairName -- base $base');

          // if firstWhere fails
          if (singlePairDecimalConfig != null) {
            log.w(
                'single pair decimal config for $pairName result ${singlePairDecimalConfig.toJson()}');
            return singlePairDecimalConfig;
          } else {
            log.i('single pair config using for loop');
            for (PairDecimalConfig pair in res) {
              if (pair.name == pairName) {
                singlePairDecimalConfig = PairDecimalConfig(
                    priceDecimal: pair.priceDecimal,
                    qtyDecimal: pair.qtyDecimal);
              }
            }
          }
        }
      }).catchError((err) => log.e('getSinglePairDecimalConfig CATCH $err'));
    }
    return singlePairDecimalConfig;
  }

// -------------- all pair ---------------------

  Future<List<PairDecimalConfig>> getAllPairDecimalConfig() async {
    ApiService apiService = locator<ApiService>();
    List<PairDecimalConfig> result = [];
    result = await decimalConfigDatabaseService.getAll();
    log.e('decimal configs length in db ${result.length}');
    if (result == null || result.isEmpty) {
      await apiService.getPairDecimalConfig().then((res) async {
        if (res == null)
          return null;
        else
          result = res;
      });
    }
    print('returning result');
    return result;
  }
/*---------------------------------------------------
      Get EXG address from wallet database
--------------------------------------------------- */

  Future<String> getExgAddressFromWalletDatabase() async {
    return await coreWalletDatabaseService.getWalletAddressByTickerName('EXG');
  }
/*---------------------------------------------------
      Get FAB address from wallet database
--------------------------------------------------- */

  Future<String> getFabAddressFromCoreWalletDatabase() async {
    return await coreWalletDatabaseService.getWalletAddressByTickerName('FAB');
  }

/*---------------------------------------------------
      Get EXG Official address
--------------------------------------------------- */

  String getEXGOfficialAddress() {
    return environment['addresses']['exchangilyOfficial'][0]['address'];
  }

/*---------------------------------------------------
      Rounded gradient button box decoration
--------------------------------------------------- */

  Decoration gradientBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(25)),
      gradient: LinearGradient(
        colors: [Colors.redAccent, Colors.yellow],
        begin: FractionalOffset.topLeft,
        end: FractionalOffset.bottomRight,
      ),
    );
  }

/*---------------------------------------------------
            Launch link urls
--------------------------------------------------- */

  // launchURL(String url) async {
  //   log.i('launchURL $url');
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

/* ---------------------------------------------------
            Full screen Stack loading indicator
--------------------------------------------------- */

  Widget stackFullScreenLoadingIndicator() {
    return Container(
        height: UIHelper.getScreenFullHeight(context),
        width: UIHelper.getScreenFullWidth(context),
        color: primaryColor.withOpacity(0.5),
        child: loadingIndicator());
  }

/* ---------------------------------------------------
        Loading indicator platform specific
--------------------------------------------------- */
  Widget loadingIndicator() {
    return Center(
        child: Platform.isIOS
            ? Container(
                decoration: BoxDecoration(
                    color: white.withAlpha(175),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 25,
                height: 25,
                child: CupertinoActivityIndicator())
            : SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  backgroundColor: primaryColor,
                  semanticsLabel: 'Loading',
                  strokeWidth: 1.5,
                  //  valueColor: AlwaysStoppedAnimation<Color>(secondaryColor)
                ),
              ));
  }

/* ---------------------------------------------------
                Get app version Code
--------------------------------------------------- */

  Future<Map<String, String>> getLocalAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    Map<String, String> versionInfo = {
      "name": versionName,
      "buildNumber": buildNumber
    };
    return versionInfo;
  }

/*-------------------------------------------------------------------------------------
                          getCurrentRouteName
-------------------------------------------------------------------------------------*/

  String getCurrentRouteName(BuildContext context) {
    String routeName = '';
    routeName = ModalRoute.of(context).settings.name;
    log.w('$routeName in getCurrentRouteName');
    return routeName;
  }

/*-------------------------------------------------------------------------------------
                          Physical Back Button pressed
-------------------------------------------------------------------------------------*/

  onBackButtonPressed(String route) async {
    log.w(
        'back button pressed, is final route ${navigationService.isFinalRoute()} - $route');

    navigationService.navigateUsingpopAndPushedNamed(route);
  }

  Future<bool> dialogAcceptOrReject(
      String title, String acceptButton, String rejectButton) async {
    return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 10,
                backgroundColor: globals.walletCardColor.withOpacity(0.85),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
                contentTextStyle: TextStyle(color: globals.grey),
                content: Text(
                  // add here cupertino widget to check in these small widgets first then the entire app
                  title,
                  style: TextStyle(fontSize: 14),
                ),
                actions: <Widget>[
                  rejectButton.isEmpty
                      ? Container()
                      : TextButton(
                          child: Text(
                            rejectButton,
                            style:
                                TextStyle(color: globals.white, fontSize: 12),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                            return false;
                          },
                        ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(red)),
                    child: Text(acceptButton,
                        style: TextStyle(color: white, fontSize: 14)),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      return true;
                    },
                  )
                ],
              );
            }) ??
        false;
  }

  Future<bool> closeApp() async {
    return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 10,
                backgroundColor: globals.walletCardColor.withOpacity(0.85),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
                contentTextStyle: TextStyle(color: globals.grey),
                content: Text(
                  // add here cupertino widget to check in these small widgets first then the entire app
                  '${AppLocalizations.of(context).closeTheApp}?',
                  style: TextStyle(fontSize: 14),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      AppLocalizations.of(context).no,
                      style: TextStyle(color: globals.white, fontSize: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text(AppLocalizations.of(context).yes,
                        style: TextStyle(color: globals.white, fontSize: 12)),
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                  )
                ],
              );
            }) ??
        false;
  }

/*-------------------------------------------------------------------------------------
                          Alert dialog
-------------------------------------------------------------------------------------*/
  alertDialog(String title, String message,
      {bool isWarning = false,
      String path,
      dynamic arguments,
      bool isCopyTxId = false,
      bool isDismissible = true,
      bool isUpdate = false,
      bool isLater = false,
      bool isWebsite = false,
      String stringData}) async {
    bool checkBoxValue = false;
    showDialog(
        barrierDismissible: isDismissible,
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            elevation: 5,
            backgroundColor: globals.walletCardColor.withOpacity(0.95),
            title: title == ""
                ? Container()
                : Container(
                    color: globals.primaryColor.withOpacity(0.1),
                    padding: EdgeInsets.all(10),
                    child: Text(title),
                  ),
            titleTextStyle: Theme.of(context).textTheme.headline5,
            contentTextStyle: TextStyle(color: globals.grey),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            content: Visibility(
              visible: message != '',
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    UIHelper.verticalSpaceMedium,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      child: Text(
                          // add here cupertino widget to check in these small widgets first then the entire app
                          message,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    // Do not show checkbox and text does not require to show on all dialogs
                    Visibility(
                      visible: isWarning ?? true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: checkBoxValue,
                              activeColor: globals.primaryColor,
                              onChanged: (bool value) async {
                                setState(() => checkBoxValue = value);
                                print(!checkBoxValue);

                                /// user click on do not show which is negative means false
                                /// so to make it work it needs to be opposite of the orginal value
                                storageService.isNoticeDialogDisplay =
                                    !checkBoxValue;
                              }),
                          Text(
                            AppLocalizations.of(context).doNotShowTheseWarnings,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                  ],
                );
              }),
            ),
            // actions: [],
            actions: <Widget>[
              isCopyTxId
                  ?
                  //  RaisedButton(
                  //     child:
                  //         Text(AppLocalizations.of(context).taphereToCopyTxId,style:Theme.of(context).textTheme.headline5),
                  //     onPressed: () {
                  //       Clipboard.setData(new ClipboardData(text: message));
                  //     })
                  Center(
                      child: RichText(
                        text: TextSpan(
                            text:
                                AppLocalizations.of(context).taphereToCopyTxId,
                            style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                color: globals.primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Clipboard.setData(
                                    new ClipboardData(text: message));
                              }),
                      ),
                    )
                  : Container(),
              isDismissible
                  ? Container(
                      margin: EdgeInsetsDirectional.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(globals.red),
                              // padding:
                              //     MaterialStateProperty.all<EdgeInsetsGeometry>(
                              //         EdgeInsets.all(0)),
                            ),
                            child: Center(
                              child: Text(
                                isLater
                                    ? AppLocalizations.of(context).later
                                    : AppLocalizations.of(context).close,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            onPressed: () {
                              if (path == '' || path == null) {
                                Navigator.of(context).pop(false);
                              } else {
                                print('PATH $path');
                                Navigator.of(context).pop(false);
                                navigationService
                                    .navigateUsingpopAndPushedNamed(path,
                                        arguments: arguments);
                              }
                            },
                          ),
                          UIHelper.horizontalSpaceSmall,
                          isWebsite
                              ? FlatButton(
                                  color: primaryColor,
                                  padding: EdgeInsets.all(5),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context).website,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  onPressed: () {
                                    // launchURL(stringData);
                                    Navigator.of(context).pop(false);
                                  },
                                )
                              : Container(),
                          UIHelper.horizontalSpaceSmall,
                          isUpdate
                              ? FlatButton(
                                  color: green,
                                  padding: EdgeInsets.all(5),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context).updateNow,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  onPressed: () {
                                    LaunchReview.launch(
                                        androidAppId: "com.exchangily.wallet",
                                        iOSAppId: "com.exchangily.app",
                                        writeReview: false);
                                    Navigator.of(context).pop(false);
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Container(),
            ],
          );
        });
  }

  // Language
  Future checkLanguage() async {
    String lang = '';

    lang = storageService.language;
    if (lang == null || lang == '') {
      print('language empty');
    } else {
      Navigator.pushNamed(context, '/walletSetup');
    }
  }

  /* ---------------------------------------------------
                Flushbar Notification bar
    -------------------------------------------------- */

  void showInfoFlushbar(String title, String message, IconData iconData,
      Color leftBarColor, BuildContext context) {
    Flushbar(
      backgroundColor: globals.primaryColor,
      titleText: Text(title, style: Theme.of(context).textTheme.headline5),
      messageText: Text(message, style: Theme.of(context).textTheme.headline6),
      // icon: Icon(
      //   iconData,
      //   size: 24,
      //   color: globals.primaryColor,
      // ),
      // leftBarIndicatorColor: leftBarColor,
      duration: Duration(seconds: 5),
      isDismissible: true,
    ).show(context);
  }

/* ---------------------------------------------------
                Copy Address
--------------------------------------------------- */

  copyAddress(context, text) {
    Clipboard.setData(new ClipboardData(text: text));
    Flushbar(
      backgroundColor: globals.secondaryColor.withOpacity(0.75),
      message: AppLocalizations.of(context).addressCopied,
      icon: Icon(
        Icons.done,
        size: 24,
        color: globals.primaryColor,
      ),
      leftBarIndicatorColor: globals.green,
      duration: Duration(seconds: 4),
    ).show(context);
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------
                  Save and Share PNG
  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Future<Uint8List> capturePng({GlobalKey globalKey}) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      return null;
    }
  }
}
