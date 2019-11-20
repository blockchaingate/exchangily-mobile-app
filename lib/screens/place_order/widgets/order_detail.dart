import "package:flutter/material.dart";

class OrderDetail extends StatelessWidget {
  List<Map<String, dynamic>> orderArray;
  bool bidOrAsk;

  OrderDetail(this.orderArray, this.bidOrAsk);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        for(var item in orderArray)
          Padding(
              padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      item["price"].toString(),
                      style:  new TextStyle(
                          color: Color(bidOrAsk?0xFF0da88b:0xFFe2103c),
                          fontSize: 18.0)
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                      color: Color(bidOrAsk?0xFF264559:0xFF502649),
                      child:
                      Text(
                          item["quantity"].toString(),
                          style:  new TextStyle(
                              color: Colors.white,
                              fontSize: 18.0)
                      )
                  )
                ],
              )
          )
      ],
    );
  }
}