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

import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import "package:flutter/material.dart";
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;

// This class is the top of trade tab when you first open it that contains price and change
class TradePrice extends StatefulWidget {
  TradePrice({Key key}) : super(key: key);

  @override
  TradePriceState createState() => TradePriceState();
}

class TradePriceState extends State<TradePrice> {
  Price currentPrice;
  double currentUsdPrice;
  @override
  void initState() {
    super.initState();
  }

  showPrice(Price price, double usdPrice) {
    setState(
        () => {this.currentPrice = price, this.currentUsdPrice = usdPrice});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            // Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10, 30.0, 10),
                    child: Text(
                        (currentPrice != null)
                            ? currentPrice.price.toStringAsFixed(2)
                            : '',
                        style: TextStyle(
                            fontSize: 40, color: globals.priceColor))),
                Text(
                    "\$" +
                        ((currentPrice != null)
                                ? (currentPrice.price * currentUsdPrice)
                                : 0)
                            .toStringAsFixed(2),
                    style: Theme.of(context).textTheme.headline3)
              ],
            ),
            // Change Price Value Row
            Container(
              padding: EdgeInsets.all(8.0),
              color: globals.walletCardColor,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).priceChange,
                            style: Theme.of(context).textTheme.headline4),
                        Text(currentPrice?.changeValue.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(color: globals.yellow)),
                        Text(currentPrice?.change.toString() + "%",
                            style: Theme.of(context).textTheme.headline4),
                      ],
                    ),
                    // Low Volume High Row
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            AppLocalizations.of(context).low +
                                " " +
                                currentPrice?.low.toString(),
                            style: Theme.of(context).textTheme.subtitle2),
                        Text(
                            AppLocalizations.of(context).volume +
                                " " +
                                currentPrice?.volume.toString(),
                            style: Theme.of(context).textTheme.subtitle2),
                        Text(
                            AppLocalizations.of(context).high +
                                " " +
                                currentPrice?.high.toString(),
                            style: Theme.of(context).textTheme.subtitle2)
                      ],
                    ),
                  ]),
            )
          ],
        ));
  }
}
