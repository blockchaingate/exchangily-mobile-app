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

import "package:flutter/material.dart";
import '../../../localizations.dart';
import '../../../shared/globals.dart' as globals;

class Gas extends StatelessWidget {
  final double gasAmount;
  Gas({Key key, this.gasAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/addGas');
            },
            child: Icon(
              Icons.add_circle_outline,
              semanticLabel: 'Add gas',
              color: globals.primaryColor,
            )),
        Container(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            "${AppLocalizations.of(context).gas}: $gasAmount",
            style: Theme.of(context)
                .textTheme
                .display2
                .copyWith(wordSpacing: 1.25),
          ),
        )
      ],
    );
  }
}
