import "package:flutter/material.dart";

class MarketOverviewBlock extends StatelessWidget {
  String pair;
  double price;
  double change;
  MarketOverviewBlock(this.pair, this.price, this.change);
  @override
  Widget build(BuildContext context) {
    return Container(

        child:
        Column(
          children: <Widget>[
            Text(pair, style: TextStyle(color: Color(0XFFcecfd2),fontSize: 16)),
            Text(price.toString(), style: TextStyle(color: Color(0XFF871fff),fontSize: 18)),
            Text(
                (((change != null) && (change >= 0)) ? "+" :"") + change.toString() + "%",
                style: TextStyle(color: Color(((change != null) && (change >= 0)) ? 0XFF0da88b : 0XFFe2103c),fontSize: 16))
          ],
        )
    );
  }
}