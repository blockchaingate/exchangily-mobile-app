import "package:flutter/material.dart";
import "../../trade/main.dart";
import 'package:exchangilymobileapp/localizations.dart';
import '../../../shared/globals.dart' as globals;

class DetailPair extends StatelessWidget {
  String pair;
  double volume;
  double price;
  double change;
  double low;
  double high;
  DetailPair(
      this.pair, this.volume, this.price, this.change, this.low, this.high);
  @override
  Widget build(BuildContext context) {
    var coinsArray = pair.split("/");

    String targetCoinName = coinsArray[0];
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Trade(this.pair)),
          );
        },
        child: Container(
            color: globals.walletCardColor,
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(targetCoinName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(color: globals.primaryColor)),
                            Text(
                                //  AppLocalizations.of(context).price +
                                //  ": " +
                                price.toStringAsFixed(2),
                                // textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    // Price High Low Column
                    Expanded(
                      flex: 1,
                      child: Text(price.toString(),
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(high.toString(),
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(low.toString(),
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),

                    // Change Container
                    Expanded(
                      flex: 1,
                      child: Text(
                          change >= 0
                              ? "+" + change.toStringAsFixed(2) + '%'
                              : change.toStringAsFixed(2) + '%',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color:
                                  Color(change >= 0 ? 0XFF0da88b : 0XFFe2103c),
                              fontSize: 14)),
                    )
                  ],
                ),
                Divider(color: globals.grey, thickness: 1)
              ],
            )));
  }
}
