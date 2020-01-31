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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localizations.dart';
import '../shared/globals.dart' as globals;

class SharedService {
  BuildContext context;

  Future<bool> closeApp() async {
    return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 10,
                backgroundColor: globals.walletCardColor.withOpacity(0.85),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .display3
                    .copyWith(fontWeight: FontWeight.bold),
                contentTextStyle: TextStyle(color: globals.grey),
                content: Text(
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
}
