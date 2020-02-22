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
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: EdgeInsets.only(top: 5),
            child: Container(
              //    padding: EdgeInsets.symmetric(vertical: 5),
              // margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(targetCoinName,
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0)),
                        Text(
                            AppLocalizations.of(context).volume +
                                ": " +
                                volume.toStringAsFixed(2),
                            style:
                                TextStyle(color: globals.red, fontSize: 14.0))
                      ],
                    ),
                  ),
                  // Price High Low Column
                  Container(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            AppLocalizations.of(context).price +
                                ": " +
                                price.toString(),
                            style: Theme.of(context).textTheme.bodyText1),
                        Text(
                            AppLocalizations.of(context).high +
                                ": " +
                                high.toString(),
                            style: Theme.of(context).textTheme.bodyText1),
                        Text(
                            AppLocalizations.of(context).low +
                                ": " +
                                low.toString(),
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  ),
                  // Change Container
                  Container(
                      width: 70,
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                      color:
                          change >= 0 ? Color(0xFF264559) : Color(0xFF472a4a),
                      child: Text(
                          change >= 0
                              ? "+" + change.toStringAsFixed(2)
                              : change.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:
                                  Color(change >= 0 ? 0XFF0da88b : 0XFFe2103c),
                              fontSize: 16)))
                ],
              ),
            )));
  }
}
