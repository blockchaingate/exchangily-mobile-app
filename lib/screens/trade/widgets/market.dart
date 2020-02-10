/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com, barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/models/order-model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import '../../../models/orders.dart';
import '../../../models/trade-model.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;

class Trademarket extends StatefulWidget {
  Trademarket({Key key}) : super(key: key);

  @override
  TrademarketState createState() => TrademarketState();
}

class TrademarketState extends State<Trademarket> {
  String tabName;
  List<OrderModel> sell;
  List<OrderModel> buy;
  List<TradeModel> trade;
  @override
  void initState() {
    super.initState();
    this.tabName = 'orders';
    this.sell = [];
    this.buy = [];
    this.trade = [];
  }

  updateOrders(Orders orders) {
    if (!listEquals(orders.buy, this.buy) ||
        !listEquals(orders.sell, this.sell)) {
      setState(() => {this.sell = orders.sell, this.buy = orders.buy});
    }
  }

  updateTrades(List<TradeModel> trades) {
    if (!listEquals(this.trade, trades)) {
      setState(() => {this.trade = trades});
    }
  }

  timeFormatted(timeStamp) {
    var time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return time.hour.toString() +
        ':' +
        time.minute.toString() +
        ':' +
        time.second.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          padding: EdgeInsets.all(15.0),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 0.5, color: Color(0xFF4c5684)),
              bottom: BorderSide(width: 0.15, color: Color(0xFF4c5684)),
            ),
            color: Color(0xFF2c2c4c),
          ),
          // Order Book and Market Trades Row
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                  onTap: () => {
                        setState(() => {this.tabName = 'orders'})
                      },
                  child: Text(AppLocalizations.of(context).orderBook,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: tabName == 'orders'
                              ? Color(0xFF871fff)
                              : Colors.white70))),
              GestureDetector(
                  onTap: () => {
                        setState(() => {this.tabName = 'trades'})
                      },
                  child: Text(AppLocalizations.of(context).marketTrades,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: tabName == 'trades'
                              ? Color(0xFF871fff)
                              : Colors.white70)))
            ],
          )), // Orderbook and Market Trades Row ends here

//  Visibilty Order Book
      Visibility(
          visible: tabName == 'orders',
          child: Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Heading Buy Sell Row
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(AppLocalizations.of(context).sellOrders,
                            style:
                                TextStyle(fontSize: 15, color: Colors.white70)),
                        Text(AppLocalizations.of(context).buyOrders,
                            style:
                                TextStyle(fontSize: 15, color: Colors.white70)),
                      ]),
                  UIHelper.horizontalSpaceSmall,

                  // Actual Orders Row Includes 2 Columns Contains Sell and Buy orders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(children: <Widget>[
                        for (var item in sell)
                          Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF264559)),
                                      padding:
                                          EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(item.price.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF0da88b)))),
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      child: Text(item.orderQuantity.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF5e617f))))
                                ],
                              )),
                        SizedBox(height: 10)
                      ]),
                      // Column Buy Orders
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5.0),
                            color: globals.walletCardColor,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 0, right: 10),
                                    child: Text('Qty',
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text('Price',
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2),
                                  ),
                                ]),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          for (var item in buy)
                            Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFF472a4a)),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 10),
                                        child: Text(item.price.toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFe2103c)))),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 10),
                                        child: Text(
                                            item.orderQuantity.toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF5e617f))))
                                  ],
                                )),
                          SizedBox(height: 10)
                        ],
                      )
                    ],
                  )
                ],
              ))),

      //  Visibilty Market Trades
      Visibility(
          visible: tabName == 'trades',
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Quantity',
                          style: Theme.of(context).textTheme.headline),
                      Text('Price',
                          style: Theme.of(context).textTheme.headline),
                      Text('Date', style: Theme.of(context).textTheme.headline)
                    ],
                  ),
                  UIHelper.horizontalSpaceSmall,
                  for (var item in trade)
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xFF264559)),
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Text(item.price.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(item.bidOrAsk
                                          ? 0xFF0da88b
                                          : 0xFFe2103c)))),
                          Container(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Text(item.amount.toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xFF5e617f)))),
                          Container(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Text(timeFormatted(item.time),
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xFF5e617f)))),
                        ],
                      ),
                    ),
                ]),
          )),
    ]);
  }
}
