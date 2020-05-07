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
import 'package:shared_preferences/shared_preferences.dart';

import '../localizations.dart';
import '../shared/globals.dart' as globals;

class SharedService {
  BuildContext context;
  NavigationService navigationService = locator<NavigationService>();
  final log = getLogger('SharedService');

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
                  style: TextStyle(fontSize: 16),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      AppLocalizations.of(context).no,
                      style: TextStyle(color: globals.white, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text(AppLocalizations.of(context).yes,
                        style: TextStyle(color: globals.white, fontSize: 16)),
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

  Future<bool> alertResponse(String title, String message,
      {String path, dynamic arguments}) async {
    bool checkBoxValue = false;
    return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 10,
                backgroundColor: globals.walletCardColor.withOpacity(0.95),
                title: Text(title),
                titleTextStyle: Theme.of(context).textTheme.headline4,
                contentTextStyle: TextStyle(color: globals.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 25),
                content: StatefulBuilder(
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
                          message, textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      //  UIHelper.verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: checkBoxValue,
                              activeColor: globals.primaryColor,
                              onChanged: (bool value) async {
                                setState(() => checkBoxValue = value);
                                print(checkBoxValue);

                                await setDialogWarningsStatus(checkBoxValue);
                              }),
                          Text(
                            AppLocalizations.of(context).doNotShowTheseWarnings,
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
                    ],
                  );
                }),
                actions: <Widget>[
                  Container(
                    margin: EdgeInsetsDirectional.only(bottom: 10),
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        AppLocalizations.of(context).close,
                        style: TextStyle(color: globals.grey, fontSize: 14),
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
                  ),
                ],
              );
            }) ??
        false;
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
      icon: Icon(
        iconData,
        size: 24,
        color: globals.primaryColor,
      ),
      leftBarIndicatorColor: leftBarColor,
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
    if (holder == null) return false;
    return holder;
  }

  setDialogWarningsStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDialogDisplay', value);
  }
}
