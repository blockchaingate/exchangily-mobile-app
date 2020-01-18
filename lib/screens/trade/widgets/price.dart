import "package:flutter/material.dart";
import 'package:exchangilymobileapp/models/price.dart';
import 'package:exchangilymobileapp/localizations.dart';

class TradePrice extends StatefulWidget  {
  TradePrice({Key key}) : super(key: key);

  @override
  TradePriceState createState() => TradePriceState();
}

class TradePriceState extends State<TradePrice>{
  Price currentPrice;
  double currentUsdPrice;
  @override
  void initState() {
    super.initState();

  }

  showPrice(Price price, double usdPrice) {

    setState(() => {
      this.currentPrice = price,
      this.currentUsdPrice = usdPrice
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFF2c2c4c),
        padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10, 30.0, 10),
                    child:
                    Text(currentPrice?.price.toString(), style: TextStyle(fontSize: 30,color: Color(0xFF0da88b)))
                ),
                Text("\$" + ((currentPrice!=null) ? (currentPrice.price * currentUsdPrice) : 0).toString(), style: TextStyle(fontSize: 16,color: Color(0xFF5e617f)))
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 5, 10),
                    child:
                    Text(currentPrice?.changeValue.toString(), style: TextStyle(fontSize: 18,color: Color(0xFF0da88b)))
                ),

                Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 10.0, 10),
                    child:
                    Text( currentPrice?.change.toString() + "%", style: TextStyle(fontSize: 18,color: Color(0xFF0da88b)))
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10, 5),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).low + " " + currentPrice?.low.toString(), style: TextStyle(fontSize: 15,color: Color(0xFF5e617f))),
                    Text(AppLocalizations.of(context).volume + " " + currentPrice?.volume.toString(), style: TextStyle(fontSize: 15,color: Color(0xFF5e617f))),
                    Text(AppLocalizations.of(context).high + " " + currentPrice?.high.toString(), style: TextStyle(fontSize: 15,color: Color(0xFF5e617f)))
                  ],
                )
            )
          ],
        )
    );
  }
}