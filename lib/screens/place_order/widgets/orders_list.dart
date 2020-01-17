import "package:flutter/material.dart";
import 'package:exchangilymobileapp/localizations.dart';

class OrdersList extends StatelessWidget {
  List<Map<String, dynamic>> orderArray;

  OrdersList(this.orderArray);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                child:
                Text(
                    AppLocalizations.of(context).type,
                    style:  new TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0)
                ))
            ,
            for(var item in orderArray)
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child:
                  Text(
                      item["type"],
                      style:  new TextStyle(
                          color: Color((item["type"] =='Buy')?0xFF0da88b:0xFFe2103c),
                          fontSize: 16.0)
                  )
              )
          ],
        ),
        Column(
          children: <Widget>[

            Text(
                AppLocalizations.of(context).pair,
                style:  new TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0)
            ),
            for(var item in orderArray)
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child:
                  Text(
                      item["pair"],
                      style:  new TextStyle(
                          color: Colors.white70,
                          fontSize: 16.0)
                  )
              )
          ],
        ),
        Column(
          children: <Widget>[
            Text(
                AppLocalizations.of(context).price,
                style:  new TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0)
            ),
            for(var item in orderArray)

              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child:
                  Text(
                      item["price"].toString(),
                      style:  new TextStyle(
                          color: Colors.white70,
                          fontSize: 16.0)
                  )
              )
          ],
        ),
        Column(
          children: <Widget>[
            Text(
                AppLocalizations.of(context).amount + "(" + AppLocalizations.of(context).filledAmount + ")",
                style:  new TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0)
            ),
            for(var item in orderArray)
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child:
                  Text(
                      (item["amount"] + item["filledAmount"]).toString() + "(" + (item["filledAmount"] * 100 / (item["filledAmount"] + item["amount"])).toStringAsFixed(2)  + "%)",
                      style:  new TextStyle(
                          color: Colors.white70,
                          fontSize: 16.0)
                  )
              )
          ],
        )
      ],
    );
  }

}