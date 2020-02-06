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
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Trade(this.pair)),
          );
        },
        child: Container(
            color: globals.walletCardColor,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(pair,
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0)),
                      ),
                      Text(
                          AppLocalizations.of(context).volume +
                              ": " +
                              volume.toString(),
                          style: TextStyle(color: globals.red, fontSize: 16.0))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          AppLocalizations.of(context).price +
                              ": " +
                              price.toString(),
                          style:
                              TextStyle(color: Colors.white38, fontSize: 16.0)),
                      Text(
                          AppLocalizations.of(context).high +
                              ": " +
                              high.toString(),
                          style:
                              TextStyle(color: Colors.white38, fontSize: 16.0)),
                      Text(
                          AppLocalizations.of(context).low +
                              ": " +
                              low.toString(),
                          style:
                              TextStyle(color: Colors.white38, fontSize: 16.0)),
                    ],
                  ),
                  Container(
                      width: 57,
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                      color:
                          change >= 0 ? Color(0xFF264559) : Color(0xFF472a4a),
                      child: Text(
                          change >= 0
                              ? "+" + change.toString()
                              : change.toString(),
                          style: TextStyle(
                              color:
                                  Color(change >= 0 ? 0XFF0da88b : 0XFFe2103c),
                              fontSize: 16)))
                ],
              ),
            )));
  }
}
