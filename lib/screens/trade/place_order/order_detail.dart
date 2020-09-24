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

import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_model.dart';
import "package:flutter/material.dart";

class OrderDetail extends StatelessWidget {
  final List<OrderType> orderArray;
  final bool bidOrAsk;

  OrderDetail(this.orderArray, this.bidOrAsk);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        for (var item in orderArray)
          Padding(
              padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(item.price.toString(),
                      style: TextStyle(
                          color: Color(bidOrAsk ? 0xFF0da88b : 0xFFe2103c),
                          fontSize: 13.0)),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      color: Color(bidOrAsk ? 0xFF264559 : 0xFF502649),
                      child: Text(item.quantity.toString(),
                          style:
                              TextStyle(color: Colors.white, fontSize: 13.0)))
                ],
              ))
      ],
    );
  }
}
