import "package:flutter/material.dart";
import "../../trade/main.dart";
class DetailPair extends StatelessWidget {
  String pair;
  double volume;
  double price;
  double change;
  double low;
  double high;
  DetailPair(this.pair,this.volume, this.price, this.change, this.low, this.high);
  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Trade(this.pair)),
            );
          },
          child:
          Container(
              color: Color(0xFF1a243f),
              padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
              margin: new EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(pair,style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18.0)),
                      Text("volume:" + volume.toString(),style: new TextStyle(
                          color: Colors.white38,
                          fontSize: 16.0))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("price:" + price.toString(),style: new TextStyle(
                          color: Colors.white38,
                          fontSize: 16.0)),
                      Text("high:" + high.toString(),style: new TextStyle(
                          color: Colors.white38,
                          fontSize: 16.0)),
                      Text("low:" + low.toString(),style: new TextStyle(
                          color: Colors.white38,
                          fontSize: 16.0)),
                    ],
                  ),
                  Container(
                      width: 57,
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                      color:change >= 0 ? Color(0xFF264559): Color(0xFF472a4a),
                      child:
                      Text(
                          change >= 0 ? "+" + change.toString() : change.toString(),
                          style: TextStyle(color: Color(change >= 0 ? 0XFF0da88b : 0XFFe2103c),fontSize: 16))
                  )

                ],
              )
          )
      );
  }
}

