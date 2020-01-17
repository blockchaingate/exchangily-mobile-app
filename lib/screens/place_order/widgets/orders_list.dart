import "package:flutter/material.dart";

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
                    "Type",
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
                "Pair",
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
                "Price",
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
                "Amount(Filled)",
                style:  new TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0)
            ),
            for(var item in orderArray)
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child:
                  Text(
                      (item["amount"] + item["filledAmount"]).toString() + "(" + item["filledAmount"].toString() + ")",
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