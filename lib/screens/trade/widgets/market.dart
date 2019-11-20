import "package:flutter/material.dart";

class Trademarket extends StatelessWidget {
  Trademarket();

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget> [
          Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Color(0xFF4c5684)),
                  bottom: BorderSide(width: 1.0, color: Color(0xFF4c5684)),
                ),
                color: Color(0xFF2c2c4c),
              ),

              padding: EdgeInsets.all(15.0),
              child:
              Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child:Text("Order Book", style: TextStyle(fontSize: 18,color: Color(0xFF871fff)))
                  ),
                  Text("Market Trades", style: TextStyle(fontSize: 18,color: Colors.white70))
                ],
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Row(
              children: <Widget>[
                Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF264559)
                    ),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child:Text("8710", style: TextStyle(fontSize: 18,color: Color(0xFF0da88b)))
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child:Text("8000", style: TextStyle(fontSize: 18,color: Color(0xFF5e617f)))
                )

              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFF472a4a)
                      ),
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child:Text("8789", style: TextStyle(fontSize: 18,color: Color(0xFFe2103c)))
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child:Text("8000", style: TextStyle(fontSize: 18,color: Color(0xFF5e617f)))
                  )
                ],
              )
          )
        ]

    );
  }
}