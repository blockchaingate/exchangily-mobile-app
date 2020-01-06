import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import "widgets//price.dart";
import "widgets/market.dart";
import "../place_order/main.dart";
import 'package:web_socket_channel/io.dart';
import '../../services/trade_service.dart';
import "widgets/kline.dart";

enum SingingCharacter { lafayette, jefferson }
class Trade extends StatefulWidget {
  String pair;

  Trade(this.pair);

  @override
  _TradeState createState() => _TradeState();
}

class _TradeState extends State<Trade>  with TradeService {
  IOWebSocketChannel allTradesChannel;
  IOWebSocketChannel allOrdersChannel;

  @override
  void initState() {
    super.initState();
    var pair = widget.pair.replaceAll(RegExp('/'), '');
    print('pair = ' + pair);
    allTradesChannel = getTradeListChannel(pair);
    allTradesChannel.stream.listen(
            (trades) {
              //print('trades=');
              //print(trades);
        }
    );

    allOrdersChannel = getOrderListChannel(pair);
    allOrdersChannel.stream.listen(
            (orders) {
             // print('orders=');
          // print(orders);
        }
    );
  }

  @override
  void dispose() {
    allTradesChannel.sink.close();
    allOrdersChannel.sink.close();
    super.dispose();
  }

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
        middle: Text(widget.pair,style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0XFF1f2233),
      ),
      backgroundColor: Color(0xFF1F2233),
      body:ListView(
        children: <Widget>[
          TradePrice(),
          KlinePage(pair: widget.pair),
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
                      MaterialPageRoute(builder: (context) => PlaceOrder(pair: widget.pair, bidOrAsk: true)),
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
                      MaterialPageRoute(builder: (context) => PlaceOrder(pair: widget.pair, bidOrAsk: false)),
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