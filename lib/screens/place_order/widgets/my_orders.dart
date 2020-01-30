import "package:flutter/material.dart";
import 'orders_list.dart';
import 'assets_list.dart';
import 'dart:async';
import '../../../services/trade_service.dart';
import '../../../environments/coins.dart';
import '../../../utils/string_util.dart';
import 'package:exchangilymobileapp/localizations.dart';
class MyOrders extends StatefulWidget {
  MyOrders({Key key}) : super(key: key);
  @override
  MyOrdersState createState() => MyOrdersState();
}


class MyOrdersState extends State<MyOrders> with SingleTickerProviderStateMixin, TradeService{
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

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);

    super.initState();
  }

  refresh(String address) {
    print('address is::::' + address);
    if(address == null) {
      return;
    }
    Timer.periodic(Duration(seconds: 3), (Timer time) async {
      // print("Yeah, this line is printed after 3 seconds");
      var balances = await getAssetsBalance(address);
      var orders = await getOrders(address);

      print(balances.length);
      List<Map<String, dynamic>> newbals = [];
      List<Map<String, dynamic>> openOrds = [];
      List<Map<String, dynamic>> closeOrds = [];

      for(var i = 0; i < balances.length; i++) {
        var bal = balances[i];
        var coinType = int.parse(bal['coinType']);
        var unlockedAmount = bigNum2Double(bal['unlockedAmount']);
        var lockedAmount = bigNum2Double(bal['lockedAmount']);
        var newbal = {
          "coin": coin_list[coinType]['name'],
          "amount": unlockedAmount,
          "lockedAmount": lockedAmount
        };
        newbals.add(newbal);
      }


      for (var i = 0; i < orders.length; i++) {
        var order = orders[i];
        var orderHash = order['orderHash'];
        var address = order['address'];
        var orderType = order['orderType'];
        var bidOrAsk = order['bidOrAsk'];
        var pairLeft = order['pairLeft'];
        var pairRight = order['pairRight'];
        var price = bigNum2Double(order['price']);
        var orderQuantity = bigNum2Double(order['orderQuantity']);
        var filledQuantity = bigNum2Double(order['filledQuantity']);
        var time = order['time'];
        var isActive = order['isActive'];

        //{ "block":  "absdda...", "type": "Buy", "pair": "EXG/USDT", "price": 1, "amount": 1000.00},
        var newOrd = {
          'orderHash': orderHash,
          'type': (bidOrAsk == true) ? 'Buy' : 'Sell',
          'pair': coin_list[pairLeft]['name'].toString() + '/' + coin_list[pairRight]['name'].toString(),
          'price': price,
          'amount': orderQuantity,
          'filledAmount': filledQuantity
        };

        if(isActive == true) {
          openOrds.add(newOrd);
        } else {
          closeOrds.add(newOrd);
        }
      }
      if (this.mounted) {
        setState(() =>
        {
          this.balance = newbals,
          this.openOrders =
          openOrds.length > 10 ? openOrds.sublist(0, 10) : openOrds,
          this.closedOrders =
          closeOrds.length > 10 ? closeOrds.sublist(0, 10) : closeOrds
        });
      }
    });
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
                      child:new Text(AppLocalizations.of(context).openOrders)
                  ),
                  new Text(AppLocalizations.of(context).closeOrders),
                  new Text(AppLocalizations.of(context).assets)
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
                  height: 330,
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