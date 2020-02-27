import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import "package:flutter/material.dart";
import '../../../shared/globals.dart' as globals;

class MarketOverviewBlock extends StatelessWidget {
  final String pair;
  final double price;
  final double change;
  MarketOverviewBlock(this.pair, this.price, this.change);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Text(pair, style: Theme.of(context).textTheme.headline4),
        UIHelper.horizontalSpaceSmall,
        Text(price.toString(),
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: globals.primaryColor)),
        Text(
            (((change != null) && (change >= 0)) ? "+" : "") +
                change.toString() +
                "%",
            style: TextStyle(
                color: Color(((change != null) && (change >= 0))
                    ? 0XFF0da88b
                    : 0XFFe2103c),
                fontSize: 14))
      ],
    ));
  }
}
