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
import 'package:flutter/cupertino.dart';
import "widgets/buy_sell.dart";

class PlaceOrder extends StatelessWidget {
  PlaceOrder({Key key, this.pair, this.bidOrAsk}) : super(key: key);

  final String pair;
  final bool bidOrAsk;

  @override
  Widget build(BuildContext context) {
    var coinsArray = pair.split("/");
    String baseCoinName = coinsArray[1];
    String targetCoinName = coinsArray[0];
    return Scaffold(
        appBar: CupertinoNavigationBar(
          padding: EdgeInsetsDirectional.only(start: 0),
          leading: CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          middle: Text(
            pair,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body: ListView(
          children: <Widget>[
            BuySell(
              bidOrAsk: bidOrAsk,
            )
          ],
        ));
  }
}
