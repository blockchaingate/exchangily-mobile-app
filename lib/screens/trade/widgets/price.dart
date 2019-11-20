import "package:flutter/material.dart";

class TradePrice extends StatelessWidget {
  TradePrice();
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
                    Text("8718", style: TextStyle(fontSize: 30,color: Color(0xFF0da88b)))
                ),
                Text("\$8718.79", style: TextStyle(fontSize: 16,color: Color(0xFF5e617f)))
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 5, 10),
                    child:
                    Text("0.02", style: TextStyle(fontSize: 18,color: Color(0xFF0da88b)))
                ),

                Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 10.0, 10),
                    child:
                    Text("0.17%", style: TextStyle(fontSize: 18,color: Color(0xFF0da88b)))
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10, 5),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Low 8659", style: TextStyle(fontSize: 15,color: Color(0xFF5e617f))),
                    Text("Vol 9.9991.98 USDT", style: TextStyle(fontSize: 15,color: Color(0xFF5e617f))),
                    Text("High 8857", style: TextStyle(fontSize: 15,color: Color(0xFF5e617f)))
                  ],
                )
            )
          ],
        )
    );
  }
}