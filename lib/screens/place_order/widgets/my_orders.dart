import "package:flutter/material.dart";
import 'orders_list.dart';
import 'assets_list.dart';
class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}


class _MyOrdersState extends State<MyOrders> with SingleTickerProviderStateMixin{
  TabController _tabController;

  List<Map<String, dynamic>> openOrders = [
    { "block":  "absdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "absdda...", "type": "Sell", "pair": "EXG/USDT", "price": 1.2, "amount": 1000.00},
    { "block":  "absdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "absdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "absdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00}
  ];

  List<Map<String, dynamic>> closedOrders = [
    { "block":  "cbsdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "cbsdda...", "type": "Sell", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "cbsdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "cbsdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
    { "block":  "cbsdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00}
  ];

  List<Map<String, dynamic>> balance = [
    { "coin":  "EXG", "amount": 120.1, "lockedAmount": 110.1},
    { "coin":  "EXG", "amount": 120.1, "lockedAmount": 110.1},
    { "coin":  "EXG", "amount": 120.1, "lockedAmount": 110.1},
    { "coin":  "EXG", "amount": 120.1, "lockedAmount": 110.1},
    { "coin":  "EXG", "amount": 120.1, "lockedAmount": 110.1}
  ];
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child:
          Column(
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
                      child:new Text("Open")
                  ),
                  new Text("Close"),
                  new Text("Assets")
                ],
                controller: _tabController,
                indicatorColor: Colors.white,
              ),
              Container(

                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1.0, color: Colors.white24)
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0),
                  margin: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0),
                  height: 530,
                  child:TabBarView(
                    children: [
                      OrdersList(openOrders),
                      OrdersList(closedOrders),
                      AssetssList(balance)
                    ],
                    controller: _tabController,)
              )
            ],
          )
      );
  }
}