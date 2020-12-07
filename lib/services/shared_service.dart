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
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:url_launcher/url_launcher.dart';

import '../localizations.dart';
import '../shared/globals.dart' as globals;

class SharedService {
  BuildContext context;
  final storageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  final log = getLogger('SharedService');

/*---------------------------------------------------
      Get EXG address from wallet database
--------------------------------------------------- */

  Future<String> getExgAddressFromWalletDatabase() async {
    String address = '';
    await walletDataBaseService
        .getBytickerName('EXG')
        .then((res) => address = res.address);
    return address;
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
                    color: grey.withAlpha(125),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 30,
                height: 30,
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

  Future<String> getLocalAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    return versionName;
  }

/*-------------------------------------------------------------------------------------
                          getCurrentRouteName
-------------------------------------------------------------------------------------*/

  String getCurrentRouteName(BuildContext context) {
    String routeName = '';
    routeName = ModalRoute.of(context).settings.name;
    print('$routeName in bottom Nav');
    return routeName;
  }

/*-------------------------------------------------------------------------------------
                          Physical Back Button pressed
-------------------------------------------------------------------------------------*/

  onBackButtonPressed(String route) async {
    log.w(
        'back button pressed, is final route ${navigationService.isFinalRoute()}');

    navigationService.navigateUsingpopAndPushedNamed(route);
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
                  ? RaisedButton(
                      child:
                          Text(AppLocalizations.of(context).taphereToCopyTxId),
                      onPressed: () {
                        Clipboard.setData(new ClipboardData(text: message));
                      })
                  // RichText(
                  //     text: TextSpan(
                  //         text: AppLocalizations.of(context).taphereToCopyTxId,
                  //         style: TextStyle(
                  //             decoration: TextDecoration.underline,
                  //             color: globals.primaryColor),
                  //         recognizer: TapGestureRecognizer()
                  //           ..onTap = () {
                  //             Clipboard.setData(
                  //                 new ClipboardData(text: message));
                  //           }),
                  //   )
                  : Container(),
              isDismissible
                  ? Container(
                      margin: EdgeInsetsDirectional.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlineButton(
                            color: globals.red,
                            padding: EdgeInsets.all(0),
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
                                navigationService
                                    .navigateUsingpopAndPushedNamed(path,
                                        arguments: arguments);
                                Navigator.of(context).pop(false);
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
