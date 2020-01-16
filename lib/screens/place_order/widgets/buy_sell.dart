import 'package:exchangilymobileapp/screens/trade/main.dart';
import "package:flutter/material.dart";
import "./textfield_text.dart";
import "./order_detail.dart";
import "./my_orders.dart";
import 'package:web_socket_channel/io.dart';
import '../../../services/trade_service.dart';
import '../../../utils/decoder.dart';
import '../../../models/orders.dart';
import '../../../models/order-model.dart';
import '../../../models/trade-model.dart';
import 'package:flutter/foundation.dart';

class BuySell extends StatefulWidget {
  BuySell({Key key, this.bidOrAsk, this.baseCoinName, this.targetCoinName}) : super(key: key);
  final bool bidOrAsk;
  final String baseCoinName;
  final String targetCoinName;
  @override
  _BuySellState createState() => _BuySellState();
}

class _BuySellState extends State<BuySell> with SingleTickerProviderStateMixin, TradeService {

  bool bidOrAsk;

  List<OrderModel> sell;
  List<OrderModel> buy;

  double currentPrice = 5.5450;
  double currentQuantity = 210;
  double _sliderValue = 10.0;
  IOWebSocketChannel orderListChannel;
  IOWebSocketChannel tradeListChannel;

  double price;
  double quantity;

  @override
  void initState() {
    super.initState();
    this.sell = [];
    this.buy = [];
    bidOrAsk = widget.bidOrAsk;
    orderListChannel = getOrderListChannel(widget.targetCoinName + widget.baseCoinName);
    orderListChannel.stream.listen(
            (ordersString) {
          print('orders');
          print(ordersString);
          Orders orders = Decoder.fromOrdersJsonArray(ordersString);
          _showOrders(orders);
        }
    );

    tradeListChannel = getTradeListChannel(widget.targetCoinName + widget.baseCoinName);
    tradeListChannel.stream.listen(
            (tradesString) {
          //print('trades=');
          //print(trades);
              List<TradeModel> trades = Decoder.fromTradesJsonArray(tradesString);

          if(trades != null && trades.length > 0) {
            TradeModel latestTrade = trades[0];


            if (this.mounted) {
              setState(() =>
              {
                this.currentPrice = latestTrade.price
              });
            }
          }
        }
    );
  }

  _showOrders(Orders orders) {
    if(!listEquals(orders.buy, this.buy) || !listEquals(orders.sell, this.sell) ) {
      if (this.mounted) {
        setState(() =>
        {
          this.sell = orders.sell,
          this.buy = orders.buy
        });
      }
    }
  }

  @override
  void dispose() {
    orderListChannel.sink.close();
    super.dispose();
  }

  placeOrder() {

  }

  void HandleTextChanged(String labelText, String text) {
    print('labelText=' + labelText);
    print('text=' + text);
    if(labelText == 'Price') {
      try {
        this.price = double.parse(text);
      } catch(e) {}
    }
    if(labelText == 'Quantity') {
      try {
        this.quantity = double.parse(text);
      } catch(e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: bidOrAsk?BorderSide(width: 2.0, color: Color(0XFF871fff)):BorderSide.none
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child:
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            bidOrAsk = true;
                            placeOrder();
                          });
                        },
                        child:Text(
                          "BUY",
                          style:  new TextStyle(
                              color: bidOrAsk?Color(0XFF871fff):Colors.white,
                              fontSize: 18.0),
                        )
                    )
                )
                ,

                Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: bidOrAsk?BorderSide.none:BorderSide(width: 2.0, color: Color(0XFF871fff))
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child:
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            bidOrAsk = false;
                            placeOrder();
                          });
                        },
                        child:
                        Text(
                          "SELL",
                          style:  new TextStyle(
                              color: bidOrAsk?Colors.white:Color(0XFF871fff),
                              fontSize: 18.0),
                        )
                    )
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2c2c4c),
                border: Border(
                    top: BorderSide(width: 1.0, color: Colors.white10),
                    bottom: BorderSide(width: 1.0, color: Colors.white10)
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 6,
                      child:
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                            child: TextfieldText("Price",widget.baseCoinName, HandleTextChanged),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                            child: TextfieldText("Quantity","", HandleTextChanged),
                          ),
                          Slider(
                            activeColor: Colors.indigoAccent,
                            min: 0.0,
                            max: 15.0,
                            onChanged: (newRating) {
                              setState(() => _sliderValue = newRating);
                            },
                            value: _sliderValue,
                          ),

                          Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Transaction amount",
                                    style:  new TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.0),
                                  ),
                                  Text(
                                      "1000" + " " + widget.baseCoinName,
                                      style:  new TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0)
                                  )
                                ],
                              )
                          ),

                          Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      "Balance",
                                      style:  new TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0)
                                  ),
                                  Text(
                                      "0.0000" + " " + widget.baseCoinName,
                                      style:  new TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0)
                                  )
                                ],
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child:
                              new SizedBox(
                                  width: double.infinity,
                                  child:
                                  new RaisedButton(
                                    padding: const EdgeInsets.all(8.0),
                                    textColor: Colors.white,
                                    color: bidOrAsk?Color(0xFF0da88b):Color(0xFFe2103c),
                                    onPressed: () => {

                                    },
                                    child: new Text(
                                        bidOrAsk?"BUY":"SELL",
                                        style:  new TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0
                                        )
                                    ),
                                  )
                              )
                          )
                        ],
                      )
                  ),
                  Expanded(
                      flex: 4,
                      child:
                      Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child:
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 1.0, color: Colors.grey),
                                        ),
                                      ),
                                      child:
                                      Text(
                                          "Price",
                                          style:  new TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0
                                          )
                                      )
                                  ),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 1.0, color: Colors.grey),
                                        ),
                                      ),
                                      child:
                                      Text(
                                          "Quantity",
                                          style:  new TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0
                                          )
                                      )
                                  )
                                ],
                              ),
                              OrderDetail(sell, false),

                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),

                                          child:
                                          Text(
                                              currentPrice.toString(),
                                              style:  new TextStyle(
                                                  color: Color(0xFF17a2b8),
                                                  fontSize: 18.0
                                              )
                                          )
                                      )
                                    ],
                                  )
                              ),

                              OrderDetail(buy, true)
                            ],
                          )
                      )
                  )
                ],
              ),
            ),
            MyOrders()
          ]);
  }
}