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

import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import "package:flutter/material.dart";
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;
import 'package:exchangilymobileapp/screen_state/trade/place_order/order_list_screen_state.dart';

class OrdersList extends StatelessWidget {
  final List<Map<String, dynamic>> orderArray;
  final String type;
  final String exgAddress;

  OrdersList(this.orderArray, this.type, this.exgAddress);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<OrderListScreenState>(
      onModelReady: (model) {
        model.orderArray = orderArray;
        model.type = type;
        model.exgAddress = exgAddress;
      },
      builder: (context, model, child) => Table(children: [
        TableRow(children: [
          Text(AppLocalizations.of(context).type,
              style: Theme.of(context).textTheme.subtitle2),
          Text(AppLocalizations.of(context).pair,
              style: Theme.of(context).textTheme.subtitle2),
          Text(AppLocalizations.of(context).price,
              style: Theme.of(context).textTheme.subtitle2),
          Text(
              AppLocalizations.of(context).amount +
                  "(" +
                  AppLocalizations.of(context).filledAmount +
                  ")",
              style: Theme.of(context).textTheme.subtitle2),
          if (type == 'open') Text('')
        ]),
        for (var item in orderArray)
          TableRow(children: [
            Text(item["type"],
                style: TextStyle(
                    color: Color(
                        (item["type"] == 'Buy') ? 0xFF0da88b : 0xFFe2103c),
                    fontSize: 16.0)),
            Text(item["pair"], style: Theme.of(context).textTheme.headline5),
            Text(item["price"].toString(),
                style: Theme.of(context).textTheme.headline5),
            Text(
                doubleAdd(item["amount"], item["filledAmount"]).toString() +
                    "(" +
                    (item["filledAmount"] *
                            100 /
                            doubleAdd(item["filledAmount"], item["amount"]))
                        .toStringAsFixed(2) +
                    "%)",
                style: Theme.of(context).textTheme.headline5),
            if (type == 'open')
              GestureDetector(
                child: Icon(
                  Icons.clear,
                  color: Colors.white70,
                  size: 20.0,
                  semanticLabel: 'Cancel order',
                ),
                onTap: () {
                  model.checkPass(context, item["orderHash"]);
                },
              )
          ]),
      ]),
    );
  }
}
