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

import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import "package:flutter/material.dart";
import '../../../localizations.dart';
import '../../../shared/globals.dart' as globals;

class Gas extends StatelessWidget {
  final double gasAmount;
  Gas({Key key, this.gasAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Icon(
            Icons.donut_large,
            size: 18,
            color: globals.primaryColor,
          ),
        ),
        UIHelper.horizontalSpaceSmall,
        Text(
          "${AppLocalizations.of(context).gas}: ${gasAmount.toStringAsFixed(2)}",
          style:
              Theme.of(context).textTheme.headline5.copyWith(wordSpacing: 1.25),
        ),
        UIHelper.horizontalSpaceSmall,
        MaterialButton(
          minWidth: 70.0,
          height: 24,
          color: globals.primaryColor,
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pushNamed(context, '/addGas');
          },
          child: Text(
            AppLocalizations.of(context).addGas,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }
}
