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
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Heading Buy Sell Orders Row
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                  child: Text(AppLocalizations.of(context).buyOrders,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white70)),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text(AppLocalizations.of(context).sellOrders,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white70)),
                ),
              ]),
              UIHelper.horizontalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Column Buy Orders
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        color: globals.walletCardColor,
                        width: MediaQuery.of(context).size.width * 0.45,
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(AppLocalizations.of(context).quantity,
                                  style: TextStyle(
                                      fontSize: 12, color: globals.grey)),
                              Text(AppLocalizations.of(context).price,
                                  style: TextStyle(
                                      fontSize: 12, color: globals.grey))
                            ]),
                      ),
                      // Buy Orders For Loop
                      for (var item in buy)
                        Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            margin: EdgeInsets.only(bottom: 5.0),
                            color: Color(0xFF264559),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                // Quantity Container
                                Container(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    child: Text(item.orderQuantity.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF5e617f)))),
                                // Price Container
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    padding:
                                        EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    child: Text(item.price.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: globals.green))),
                              ],
                            )),
                      SizedBox(height: 10)
                    ],
                  ),
                  // Column Sell Orders
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: globals.walletCardColor,
                          width: MediaQuery.of(context).size.width * 0.45,
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(AppLocalizations.of(context).price,
                                    style: TextStyle(
                                        fontSize: 12, color: globals.grey)),
                                Text(AppLocalizations.of(context).quantity,
                                    style: TextStyle(
                                        fontSize: 12, color: globals.grey)),
                              ]),
                        ),

                        // Sell Orders For Loop
                        for (var item in sell)
                          Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 0.5, color: Color(0xFF4c5684)),
                                  bottom: BorderSide(
                                      width: 0.15, color: Color(0xFF4c5684)),
                                ),
                                color: Color(0xFF472a4a),
                              ),
                              width: MediaQuery.of(context).size.width * 0.45,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(item.price.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: globals.sellPrice))),
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
                      Text(AppLocalizations.of(context).price,
                          style: TextStyle(fontSize: 14, color: globals.grey)),
                      Text(AppLocalizations.of(context).quantity,
                          style: TextStyle(fontSize: 14, color: globals.grey)),
                      Text(AppLocalizations.of(context).date,
                          style: TextStyle(fontSize: 14, color: globals.grey))
                    ],
                  ),
                  UIHelper.horizontalSpaceSmall,
                  for (var item in trade)
                    Container(
                      padding: EdgeInsets.all(5.0),
                      color: Color(item.bidOrAsk ? 0xFF264559 : 0xFF472a4a),
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              child: Text(item.price.toString(),
                                  style: TextStyle(
                                      fontSize: 14, color: globals.white))),
                          Container(
                              child: Text(item.amount.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF5e617f)))),
                          Container(
                              child: Text(timeFormatted(item.time),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF5e617f)))),
                        ],
                      ),
                    ),
                ]),
          )),
    ]);
  }
}
