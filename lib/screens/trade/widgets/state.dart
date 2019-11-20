import "package:flutter/material.dart";
import "kline.dart";

class TradeState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(

        children: <Widget> [
          /*
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
                child:Text("Line", style: TextStyle(fontSize: 18,color: Color(0xFF871fff)))
              ),

              Text("Depth", style: TextStyle(fontSize: 18,color: Colors.white70))
            ],
          )
        ),

         */
          KlinePage()
        ]

    );
  }
}