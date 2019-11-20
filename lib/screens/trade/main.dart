import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import "widgets//price.dart";
import "widgets/state.dart";
import "widgets/market.dart";
import "../place_order/main.dart";

enum SingingCharacter { lafayette, jefferson }
class Trade extends StatelessWidget {
  String pair;
  Trade(this.pair);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CupertinoNavigationBar(
        padding: EdgeInsetsDirectional.only(start: 0),
        leading: CupertinoButton(
          padding: EdgeInsets.all(0),
          child: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        middle: Text(this.pair,style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0XFF1f2233),
      ),
      backgroundColor: Color(0xFF1F2233),
      body:ListView(
        children: <Widget>[
          TradePrice(),
          TradeState(),
          Trademarket()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: Color(0xFF1c1c2d),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Flexible(
              child:
                FlatButton(
                  color: Color(0xFF0da88b),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlaceOrder(pair: pair, bidOrAsk: true)),
                    );
                  },
                  child: Text(
                      "Buy", style: TextStyle(fontSize: 16,color: Colors.white)
                  ),
                )
              ),
              Flexible(
              child:
                FlatButton(
                  color: Color(0xFFe2103c),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlaceOrder(pair: pair, bidOrAsk: false)),
                    );
                  },
                  child: Text(
                      "Sell",style: TextStyle(fontSize: 16,color: Colors.white)
                  ),
                )
              )
            ],
          )
      ),
    );
  }
}