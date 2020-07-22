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

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localizations.dart';
import '../shared/globals.dart' as globals;

class SharedService {
  BuildContext context;
  NavigationService navigationService = locator<NavigationService>();
  final log = getLogger('SharedService');

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
      bool isDismissible = true,
      bool isUpdate = false,
      bool isLater = false}) async {
    print(' is dismissible $isDismissible');
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
            titleTextStyle: Theme.of(context).textTheme.headline4,
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
                        message, textAlign: TextAlign.left,
                        style: title == ""
                            ? Theme.of(context).textTheme.headline6
                            : Theme.of(context).textTheme.headline5,
                      ),
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
                                // user click on do not show which is negative means false so to make it work it needs to be opposite to the orginal value
                                await setDialogWarningsStatus(!checkBoxValue);
                              }),
                          Text(
                            AppLocalizations.of(context).doNotShowTheseWarnings,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    // Container(
                    //   margin: EdgeInsetsDirectional.only(bottom: 10),
                    //   child: FlatButton(
                    //     // color: globals.primaryColor,
                    //     padding: EdgeInsets.all(0),
                    //     child: Text(
                    //       AppLocalizations.of(context).close,
                    //       style:
                    //           TextStyle(color: Colors.white, fontSize: 14),
                    //     ),
                    //     onPressed: () {
                    //       if (path == '' || path == null) {
                    //         Navigator.of(context).pop(false);
                    //       } else {
                    //         navigationService.navigateTo(path,
                    //             arguments: arguments);
                    //         Navigator.of(context).pop(false);
                    //       }
                    //     },
                    //   ),
                    // ),
                  ],
                );
              }),
            ),
            // actions: [],
            actions: <Widget>[
              isDismissible
                  ? Container(
                      margin: EdgeInsetsDirectional.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlineButton(
                            color: globals.primaryColor,
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
                                navigationService.navigateTo(path,
                                    arguments: arguments);
                                Navigator.of(context).pop(false);
                              }
                            },
                          ),
                          UIHelper.horizontalSpaceSmall,
                          isUpdate
                              ? FlatButton(
                                  color: globals.primaryColor,
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('lang');
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
      backgroundColor: globals.secondaryColor.withOpacity(0.75),
      title: title,
      message: message,
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
                get/set DialogWarningsStatus
    -------------------------------------------------- */

  Future<bool> getDialogWarningsStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var holder = prefs.getBool('isDialogDisplay');
    log.w('in getDialogWarningsStatus $holder');
    // when app doesn't find the value in the local storage then by default its true to show dialog warnings
    if (holder == null) return true;
    return holder;
  }

  setDialogWarningsStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDialogDisplay', value);
  }

/* ---------------------------------------------------
                Copy Address
--------------------------------------------------- */

  void copyAddress(context, text) {
    Clipboard.setData(new ClipboardData(text: text));
    alertDialog(AppLocalizations.of(context).transactionId,
        AppLocalizations.of(context).copiedSuccessfully,
        isWarning: false);
  }
}
