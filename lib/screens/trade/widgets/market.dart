import 'package:exchangilymobileapp/models/order-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import '../../../models/orders.dart';
import '../../../models/trade-model.dart';
import 'package:exchangilymobileapp/localizations.dart';

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
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Color(0xFF4c5684)),
              bottom: BorderSide(width: 1.0, color: Color(0xFF4c5684)),
            ),
            color: Color(0xFF2c2c4c),
          ),
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: GestureDetector(
                      onTap: () => {
                            setState(() => {this.tabName = 'orders'})
                          },
                      child: Text(AppLocalizations.of(context).orderBook,
                          style: TextStyle(
                              fontSize: 18,
                              color: tabName == 'orders'
                                  ? Color(0xFF871fff)
                                  : Colors.white70)))),
              GestureDetector(
                  onTap: () => {
                        setState(() => {this.tabName = 'trades'})
                      },
                  child: Text(AppLocalizations.of(context).marketTrades,
                      style: TextStyle(
                          fontSize: 18,
                          color: tabName == 'trades'
                              ? Color(0xFF871fff)
                              : Colors.white70)))
            ],
          )),
      Visibility(
          visible: tabName == 'orders',
          child: Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Text(AppLocalizations.of(context).sellOrders,
                            style: TextStyle(
                                fontSize: 18, color: Colors.white70))),
                    for (var item in sell)
                      Column(children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Row(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFF264559)),
                                    padding:
                                        EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
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
                  ]),
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Text(AppLocalizations.of(context).buyOrders,
                            style:
                                TextStyle(fontSize: 18, color: Colors.white70)),
                      ),
                      for (var item in buy)
                        Column(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * 0.45,
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
              )
              /*
            Column(
            children:[
              for(var item in sell )
                Column(
                  children: <Widget>[
                  Row(
                    children:

                    <Widget>[

                      Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF264559)
                          ),
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child:Text(item.price.toString(), style: TextStyle(fontSize: 18,color: Color(0xFF0da88b)))
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child:Text(item.orderQuantity.toString(), style: TextStyle(fontSize: 18,color: Color(0xFF5e617f)))
                      )

                    ],

                  ),
                  SizedBox(height: 10)
              ]),

                  for(var item in buy )
                  Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(
                                color: Color(0xFF472a4a)
                            ),
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child:Text(item.price.toString(), style: TextStyle(fontSize: 18,color: Color(0xFFe2103c)))
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child:Text(item.orderQuantity.toString(), style: TextStyle(fontSize: 18,color: Color(0xFF5e617f)))
                        )
                      ],
                    ),
                    SizedBox(height: 10)
                    ],

                    ),

                    ])
              */

              )),
      Visibility(
          visible: tabName == 'trades',
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(children: [
              for (var item in trade)
                Column(
                  children: <Widget>[
                    Row(
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
                                    fontSize: 18, color: Color(0xFF5e617f))))
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                )

              /*
                      Row(
                        children: <Widget>[
                          Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xFF472a4a)
                              ),
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child:Text("8789", style: TextStyle(fontSize: 18,color: Color(0xFFe2103c)))
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child:Text("8000", style: TextStyle(fontSize: 18,color: Color(0xFF5e617f)))
                          )
                        ],
                      )

                       */
            ]),
          )),
    ]);
  }
}
