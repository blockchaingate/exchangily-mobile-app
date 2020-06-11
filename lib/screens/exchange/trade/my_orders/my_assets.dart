import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter/material.dart';

class MyAssets extends StatelessWidget {
  const MyAssets({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(AppLocalizations.of(context).coin,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14.0,
                )),
            for (var item in assetsArray)
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: Text(item["coin"],
                      style: TextStyle(color: Colors.white70, fontSize: 14.0)))
          ],
        ),
        Column(
          children: <Widget>[
            Text(AppLocalizations.of(context).amount,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14.0,
                )),
            for (var item in assetsArray)
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: Text(item["amount"].toString(),
                      style:
                          new TextStyle(color: Colors.white70, fontSize: 14.0)))
          ],
        ),
        Column(
          children: <Widget>[
            Text(AppLocalizations.of(context).lockedAmount,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14.0,
                )),
            for (var item in assetsArray)
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: Text(item["lockedAmount"].toString(),
                      style:
                          new TextStyle(color: Colors.white70, fontSize: 14.0)))
          ],
        )
      ],
    );,
    );
  }
}