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

import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import "package:flutter/material.dart";
import 'package:exchangilymobileapp/localizations.dart';
import '../../../shared/globals.dart' as globals;

class AssetssList extends StatelessWidget {
  final List<Map<String, dynamic>> assetsArray;

  AssetssList(this.assetsArray);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(AppLocalizations.of(context).coin,
                      style: TextStyle(
                        color: globals.grey,
                        fontSize: 11.0,
                      ))),
              Expanded(
                  flex: 3,
                  child: Text(AppLocalizations.of(context).amount,
                      style: TextStyle(
                        color: globals.grey,
                        fontSize: 11.0,
                      ))),
              Expanded(
                  flex: 3,
                  child: Text(AppLocalizations.of(context).lockedAmount,
                      style: TextStyle(
                        color: globals.grey,
                        fontSize: 11.0,
                      )))
            ],
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: assetsArray.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      UIHelper.horizontalSpaceSmall,
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                            child: Text(assetsArray[index]["coin"],
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14.0))),
                      ),
                      Expanded(
                          flex: 3,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                              child: Text(
                                  assetsArray[index]["amount"].toString(),
                                  style: new TextStyle(
                                      color: Colors.white70, fontSize: 14.0)))),
                      Expanded(
                          flex: 3,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                              child: Text(
                                  assetsArray[index]["lockedAmount"].toString(),
                                  style: new TextStyle(
                                      color: Colors.white70, fontSize: 14.0))))
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
