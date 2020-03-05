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

import 'package:exchangilymobileapp/services/trade_service.dart';
import "package:flutter/material.dart";
import 'orders_list.dart';
import 'assets_list.dart';
import 'package:exchangilymobileapp/localizations.dart';

class MyOrders extends StatefulWidget {
  MyOrders({Key key}) : super(key: key);
  @override
  MyOrdersState createState() => MyOrdersState();
}

class MyOrdersState extends State<MyOrders>
    with SingleTickerProviderStateMixin, TradeService {
  TabController _tabController;

  List<Map<String, dynamic>> openOrders = [
    /*
    { "block":  "absdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "absdda...", "type": "Sell", "pair": "EXG/USDT", "price": 1.2, "amount": 1000.00},
    { "block":  "absdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "absdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "absdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00}

     */
  ];

  List<Map<String, dynamic>> closedOrders = [
    /*
    { "block":  "cbsdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "cbsdda...", "type": "Sell", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "cbsdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "cbsdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "cbsdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00}

     */
  ];

  List<Map<String, dynamic>> balance = [
    /*
    { "coin":  "EXG", "amount": 120.1, "lockedAmount": 110.1},
    { "coin":  "EXG", "amount": 120.1, "lockedAmount": 110.1},
    { "coin":  "EXG", "amount": 120.1, "lockedAmount": 110.1},
    { "coin":  "EXG", "amount": 120.1, "lockedAmount": 110.1},
    { "coin":  "EXG", "amount": 120.1, "lockedAmount": 110.1}

     */
  ];

  String exgAddress;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  refreshBalOrds(newbals, newOpenOrds, newCloseOrds, exgAddress) {
    if (this.mounted) {
      setState(() => {
            this.balance = newbals,
            this.openOrders = newOpenOrds,
            this.closedOrders = newCloseOrds,
            this.exgAddress = exgAddress
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
/*-----------------------------------------------------------------
                      Orders Tabs
-----------------------------------------------------------------*/
        child: Column(
          children: <Widget>[
            TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0XFF871fff)),
              tabs: [
                Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                    child: Text(AppLocalizations.of(context).openOrders)),
                Text(AppLocalizations.of(context).closeOrders),
                Text(AppLocalizations.of(context).assets)
              ],
              controller: _tabController,
              indicatorColor: Colors.white,
            ),
            Container(
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1.0, color: Colors.white24)),
                ),
                padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0),
                margin: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0),
                height: 330,
                child: TabBarView(
                  children: [
                    OrdersList(openOrders, 'open', exgAddress),
                    OrdersList(closedOrders, 'close', exgAddress),
                    AssetssList(balance)
                  ],
                  controller: _tabController,
                ))
          ],
        ));
  }
}
