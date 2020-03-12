/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import "package:flutter/material.dart";
import 'package:exchangilymobileapp/localizations.dart';
import '../../../shared/globals.dart' as globals;

class AssetssList extends StatelessWidget {
  final List<Map<String, dynamic>> assetsArray;

  AssetssList(this.assetsArray);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(AppLocalizations.of(context).coin,
                style: TextStyle(
                  color: globals.primaryColor,
                  fontSize: 14.0,
                )),
            for (var item in assetsArray)
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: Text(item["coin"],
                      style: TextStyle(color: Colors.white70, fontSize: 14.0)))
          ],
        ),
        Column(
          children: <Widget>[
            Text(AppLocalizations.of(context).amount,
                style: TextStyle(
                  color: globals.primaryColor,
                  fontSize: 14.0,
                )),
            for (var item in assetsArray)
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: Text(item["amount"].toString(),
                      style:
                          new TextStyle(color: Colors.white70, fontSize: 14.0)))
          ],
        ),
        Column(
          children: <Widget>[
            Text(AppLocalizations.of(context).lockedAmount,
                style: TextStyle(
                  color: globals.primaryColor,
                  fontSize: 14.0,
                )),
            for (var item in assetsArray)
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: Text(item["lockedAmount"].toString(),
                      style:
                          new TextStyle(color: Colors.white70, fontSize: 14.0)))
          ],
        )
      ],
    );
  }
}
