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
import 'dart:ui';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/font_style.dart';
//import 'package:url_launcher/url_launcher.dart';

import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/db/decimal_config_database_service.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localizations.dart';
import '../shared/globals.dart' as globals;

class SharedService {
  BuildContext? context;
  final log = getLogger('SharedService');
  final LocalStorageService? storageService = locator<LocalStorageService>();
  NavigationService? navigationService = locator<NavigationService>();
  final TokenInfoDatabaseService? tokenListDatabaseService =
      locator<TokenInfoDatabaseService>();
  DecimalConfigDatabaseService? decimalConfigDatabaseService =
      locator<DecimalConfigDatabaseService>();
  final CoreWalletDatabaseService? coreWalletDatabaseService =
      locator<CoreWalletDatabaseService>();

  Future<ClipboardData?> pasteClipBoardData() async {
    ClipboardData? data;
    if (data != null) {
      data = (await Clipboard.getData(Clipboard.kTextPlain))!;
    }
    return data;
  }

/*--------------------------------------------------------------------------
                  Show Simple Notification
------------------------------------------------------------------------- */
  sharedSimpleNotification(String content,
      {String subtitle = '', bool isError = true, int durationInSeconds = 3}) {
    return showSimpleNotification(
        Text(firstCharToUppercase(content),
            textAlign: subtitle.isEmpty ? TextAlign.center : TextAlign.start,
            style: headText4.copyWith(
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

  inCorrectpasswordNotification(context) {
    sharedSimpleNotification(
      AppLocalizations.of(context)!.passwordMismatch,
      subtitle: AppLocalizations.of(context)!.pleaseProvideTheCorrectPassword,
    );
  }

/*--------------------------------------------------------------------------
                  Get contract address from database
------------------------------------------------------------------------- */
  getContractAddressFromDatabase(String tickerName) async {
    String smartContractAddress = '';
    if (smartContractAddress == null) {
      debugPrint(
          '$tickerName contract is null so fetching from token database');
      await tokenListDatabaseService!
          .getContractAddressByTickerName(tickerName)
          .then((value) {
        if (value != null) {
          if (!value.startsWith('0x')) {
            smartContractAddress = '0x$value';
          } else {
            smartContractAddress = value;
          }
        }
      });
      debugPrint('official smart contract address $smartContractAddress');
    }
    return smartContractAddress;
  }

/*--------------------------------------------------------------------------
                        getPairDecimalConfig
------------------------------------------------------------------------- */

  Future<PairDecimalConfig> getSinglePairDecimalConfig(String pairName,
      {String base = ''}) async {
    final ApiService apiService = locator<ApiService>();
    PairDecimalConfig singlePairDecimalConfig = PairDecimalConfig();
    log.i('tickername $pairName -- endswith usdt ${pairName.endsWith('USDT')}');

    // if (pairName == 'BTC' || pairName == 'ETH' || pairName == 'EXG')
    //   base = 'USDT';
    // else
    if ((pairName == 'BTC' || pairName == 'ETH' || pairName == 'EXG') ||
        !pairName.endsWith('USDT') &&
            !pairName.endsWith('DUSD') &&
            !pairName.endsWith('BTC') &&
            !pairName.endsWith('ETH') &&
            !pairName.endsWith('BNB') &&
            !pairName.endsWith("EXG")) base = 'USDT';

    if (pairName == 'USDT' || pairName == 'DUSD') {
      return singlePairDecimalConfig =
          PairDecimalConfig(name: pairName, priceDecimal: 2, qtyDecimal: 2);
    } else {
      log.i('base $base');
      await apiService.getPairDecimalConfig().then((res) {
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

  // refreshDecimalConfigDB() async {
  //   debugPrint(
  //       'Refreshh decimal data TIME START ${DateTime.now().toLocal().toIso8601String()}');
  //   ApiService apiService = locator<ApiService>();
  //   await decimalConfigDatabaseService
  //       .deleteDb()
  //       .whenComplete(() => log.w('decimalConfig DB deleted'));

  //   await apiService.getPairDecimalConfig().then((decimalPairDataApi) async {
  //     if (decimalPairDataApi != null) {
  //       log.i(
  //           'decimal config data fecthed from api length ${decimalPairDataApi.length}');
  //       for (var i = 0; i < decimalPairDataApi.length; i++) {
  //         decimalConfigDatabaseService.insert(decimalPairDataApi[i]);
  //       }
  //     }
  //   });
  //   var allDecimalStoredData = await decimalConfigDatabaseService.getAll();
  //   log.e('decimal configs length in db ${allDecimalStoredData.length}');
  //   debugPrint(
  //       'Refreshh decimal data TIME FINISH ${DateTime.now().toLocal().toIso8601String()}');
  // }
/*---------------------------------------------------
      Get EXG address from wallet database
--------------------------------------------------- */

  Future<String?> getExgAddressFromWalletDatabase() async {
    return await coreWalletDatabaseService!.getWalletAddressByTickerName('EXG');
  }
/*---------------------------------------------------
      Get FAB address from wallet database
--------------------------------------------------- */

  Future<String?> getFabAddressFromCoreWalletDatabase() async {
    return await coreWalletDatabaseService!.getWalletAddressByTickerName('FAB');
  }

/*---------------------------------------------------
      Get EXG Official address
--------------------------------------------------- */

  String? getExgOfficialAddress() {
    return environment['addresses']['exchangilyOfficial'][0]['address'];
  }

/*---------------------------------------------------
      Rounded gradient button box decoration
--------------------------------------------------- */

  Decoration gradientBoxDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(25)),
      gradient: LinearGradient(
        colors: [Colors.redAccent, Colors.yellow],
        begin: FractionalOffset.topLeft,
        end: FractionalOffset.bottomRight,
      ),
    );
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchInWebViewWithoutJavaScript(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    )) {
      throw 'Could not launch $url';
    }
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
        height: UIHelper.getScreenFullHeight(context!),
        width: UIHelper.getScreenFullWidth(context!),
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
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                width: 25,
                height: 25,
                child: const CupertinoActivityIndicator())
            : const SizedBox(
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

  String? getCurrentRouteName(BuildContext context) {
    String? routeName = '';
    routeName = ModalRoute.of(context)!.settings.name;
    log.w('$routeName in getCurrentRouteName');
    return routeName;
  }

/*-------------------------------------------------------------------------------------
                          Physical Back Button pressed
-------------------------------------------------------------------------------------*/

  onBackButtonPressed(String route) async {
    log.w(
        'back button pressed, is final route ${navigationService!.isFinalRoute()} - $route');

    navigationService!.navigateUsingpopAndPushedNamed(route);
  }

  // Future<bool> dialogAcceptOrReject(
  //     String title, String acceptButton, String rejectButton) async {
  //   return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           elevation: 10,
  //           backgroundColor: globals.walletCardColor.withOpacity(0.85),
  //           titleTextStyle: Theme.of(context)
  //               .textTheme
  //               .headline5
  //               .copyWith(fontWeight: FontWeight.bold),
  //           contentTextStyle: TextStyle(color: globals.grey),
  //           content: Text(
  //             // add here cupertino widget to check in these small widgets first then the entire app
  //             title,
  //             style: TextStyle(fontSize: 14),
  //           ),
  //           actions: <Widget>[
  //             rejectButton.isEmpty
  //                 ? Container()
  //                 : TextButton(
  //                     child: Text(
  //                       rejectButton,
  //                       style: TextStyle(color: globals.white, fontSize: 12),
  //                     ),
  //                     onPressed: () {
  //                       Navigator.of(context).pop(false);
  //                       debugPrint('res -- False');
  //                       return false;
  //                     },
  //                   ),
  //             ElevatedButton(
  //               style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all(red)),
  //               child: Text(acceptButton,
  //                   style: TextStyle(color: white, fontSize: 14)),
  //               onPressed: () {
  //                 Navigator.of(context).pop(false);
  //                 debugPrint('res -- True');
  //                 return true;
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  Future<bool?> closeApp() async {
    return showDialog(
        context: context!,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            backgroundColor: globals.walletCardColor.withOpacity(0.85),
            titleTextStyle: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
            contentTextStyle: const TextStyle(color: globals.grey),
            content: Text(
              // add here cupertino widget to check in these small widgets first then the entire app
              '${AppLocalizations.of(context)!.closeTheApp}?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.no,
                  style: TextStyle(color: white, fontSize: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.yes,
                    style: TextStyle(color: yellow, fontSize: 12)),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              )
            ],
          );
        });
  }

/*-------------------------------------------------------------------------------------
                          Alert dialog
-------------------------------------------------------------------------------------*/
  alertDialog(String title, String? message,
      {bool isWarning = false,
      String? path,
      dynamic arguments,
      bool isCopyTxId = false,
      bool isDismissible = true,
      bool isUpdate = false,
      bool isLater = false,
      bool isWebsite = false,
      String? stringData}) async {
    bool? checkBoxValue = false;
    showDialog(
        barrierDismissible: isDismissible,
        context: context!,
        builder: (context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            actionsPadding: const EdgeInsets.all(0),
            elevation: 5,
            backgroundColor: globals.walletCardColor.withOpacity(0.95),
            title: title == ""
                ? Container()
                : Container(
                    color: globals.primaryColor.withOpacity(0.1),
                    padding: const EdgeInsets.all(10),
                    child: Text(title),
                  ),
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            contentTextStyle: const TextStyle(color: globals.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                          message!,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    // Do not show checkbox and text does not require to show on all dialogs
                    Visibility(
                      visible: isWarning,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: checkBoxValue,
                              activeColor: globals.primaryColor,
                              onChanged: (bool? value) async {
                                setState(() => checkBoxValue = value);

                                /// user click on do not show which is negative means false
                                /// so to make it work it needs to be opposite of the orginal value
                                storageService!.isNoticeDialogDisplay =
                                    !checkBoxValue!;
                              }),
                          Text(
                            AppLocalizations.of(context)!
                                .doNotShowTheseWarnings,
                            style: Theme.of(context).textTheme.titleLarge,
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
                                AppLocalizations.of(context)!.taphereToCopyTxId,
                            style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                color: globals.primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Clipboard.setData(
                                    ClipboardData(text: message!));
                              }),
                      ),
                    )
                  : Container(),
              isDismissible
                  ? Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 10),
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
                                    ? AppLocalizations.of(context)!.later
                                    : AppLocalizations.of(context)!.close,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            onPressed: () {
                              if (path == '' || path == null) {
                                Navigator.of(context).pop(false);
                              } else {
                                debugPrint('PATH $path');
                                Navigator.of(context).pop(false);
                                navigationService!
                                    .navigateUsingpopAndPushedNamed(path,
                                        arguments: arguments);
                              }
                            },
                          ),
                          UIHelper.horizontalSpaceSmall,
                          isWebsite
                              ? TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            primaryColor),
                                    padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                        const EdgeInsets.all(5)),
                                  ),
                                  onPressed: () {
// launchURL(stringData);
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.website,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                )
                              : Container(),
                          UIHelper.horizontalSpaceSmall,
                          isUpdate
                              ? TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(green),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(5)),
                                  ),
                                  onPressed: () {
                                    LaunchReview.launch(
                                      androidAppId: "com.exchangily.wallet",
                                      iOSAppId: "com.exchangily.app",
                                      writeReview: false,
                                    );
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.updateNow,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
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
    String? lang = '';

    lang = storageService!.language;
    if (lang == null || lang == '') {
      debugPrint('language empty');
    } else {
      Navigator.pushNamed(context!, '/walletSetup');
    }
  }

  /* ---------------------------------------------------
                Flushbar Notification bar
    -------------------------------------------------- */

  // void showInfoFlushbar(String title, String message, IconData iconData,
  //     Color leftBarColor, BuildContext context) {
  //   Flushbar(
  //     backgroundColor: globals.primaryColor,
  //     titleText: Text(title, style: Theme.of(context).textTheme.headline5),
  //     messageText: Text(message, style: Theme.of(context).textTheme.headline6),
  //     // icon: Icon(
  //     //   iconData,
  //     //   size: 24,
  //     //   color: globals.primaryColor,
  //     // ),
  //     // leftBarIndicatorColor: leftBarColor,
  //     duration: const Duration(seconds: 5),
  //     isDismissible: true,
  //   ).show(context);
  // }

/* ---------------------------------------------------
                Copy Address
--------------------------------------------------- */

  copyAddress(context, text) {
    Clipboard.setData(ClipboardData(text: text));
    sharedSimpleNotification(AppLocalizations.of(context)!.addressCopied,
        isError: false);
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------
                  Save and Share PNG
  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Future<Uint8List?> capturePng({required GlobalKey globalKey}) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          (await image.toByteData(format: ImageByteFormat.png))!;
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      return null;
    }
  }
}
