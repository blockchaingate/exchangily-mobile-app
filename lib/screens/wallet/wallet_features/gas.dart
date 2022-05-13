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

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import "package:flutter/material.dart";
import '../../../localizations.dart';
import '../../../shared/globals.dart' as globals;

class GasBalanceWidget extends StatelessWidget {
  final Decimal gasAmount;
  const GasBalanceWidget({Key key, this.gasAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Container(
                  decoration: const BoxDecoration(
                      color: globals.iconBackgroundColor,
                      shape: BoxShape.circle),
                  width: 25,
                  height: 25,
                  child: Icon(
                    Icons.local_gas_station,
                    color: isProduction
                        ? globals.secondaryColor
                        : globals.red.withAlpha(200),
                    size: 18,
                  )),
            ),
            UIHelper.horizontalSpaceSmall,
            Text(
              "${AppLocalizations.of(context).gas}: ${NumberUtil.decimalLimiter(gasAmount, decimalPrecision: 6)}",
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
        UIHelper.horizontalSpaceSmall,
        MaterialButton(
          minWidth: 68.0,
          height: 24,
          color: globals.primaryColor,
          padding: const EdgeInsets.all(0),
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
