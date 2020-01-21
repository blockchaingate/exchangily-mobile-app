import 'package:exchangilymobileapp/models/trade-model.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import "widgets//price.dart";
import "widgets/market.dart";
import "../place_order/main.dart";
import 'package:web_socket_channel/io.dart';
import '../../services/trade_service.dart';
// import "widgets/kline.dart";
import '../../utils/decoder.dart';
import '../../models/price.dart';
import '../../models/orders.dart';
import 'widgets/trading_view.dart';
import '../../utils/string_util.dart';
enum SingingCharacter { lafayette, jefferson }

class Trade extends StatefulWidget {
  String pair;

  Trade(this.pair);

  @override
  _TradeState createState() => _TradeState();
}

class _TradeState extends State<Trade> with TradeService {
  IOWebSocketChannel allTradesChannel;
  IOWebSocketChannel allOrdersChannel;
  IOWebSocketChannel allPriceChannel;
  bool tradeChannelCompleted = false;
  bool priceChannelCompleted = false;
  bool orderChannelCompleted = false;
  final GlobalKey<TradePriceState> _tradePriceState =
      new GlobalKey<TradePriceState>();
  final GlobalKey<TrademarketState> _tradeMarketState =
      new GlobalKey<TrademarketState>();

  void _updateTrades(tradesString) {
    // _klinePageState.currentState.updateTrades(trades);
    print('tradesString================');
    print(tradesString);
    List<TradeModel> trades = Decoder.fromTradesJsonArray(tradesString);
    if ((this._tradeMarketState != null) &&
        (this._tradeMarketState.currentState != null)) {
      this._tradeMarketState.currentState.updateTrades(trades);
    }
  }

  void _updateOrders(ordersString) {
    Orders orders = Decoder.fromOrdersJsonArray(ordersString);
    if ((this._tradeMarketState != null) &&
        (this._tradeMarketState.currentState != null)) {
      this._tradeMarketState.currentState.updateOrders(orders);
    }
  }

  @override
  void initState() {
    super.initState();
    var pair = widget.pair.replaceAll(RegExp('/'), '');
    allTradesChannel = getTradeListChannel(pair);
    allTradesChannel.stream.listen((trades) {
      //print('trades=');
      //print(trades);
      _updateTrades(trades);
      print('tradeChannelCompleted');
      setState(() =>
      {
        this.tradeChannelCompleted = true
      });
    });

    allOrdersChannel = getOrderListChannel(pair);
    allOrdersChannel.stream.listen((orders) {
      _updateOrders(orders);
      print('orderChannelCompleted');

      setState(() =>
      {
        this.orderChannelCompleted = true
      });
    });

    allPriceChannel = getAllPriceChannel();
    allPriceChannel.stream.listen((prices) async {
      print('prices3333=');
      print(prices);
      if (this._tradePriceState == null ||
          this._tradePriceState.currentState == null) {
        print('exit');
        return;
      }
      List<Price> list = Decoder.fromJsonArray(prices);
      var item;
      for (var i = 0; i < list.length; i++) {
        item = list[i];
        if (item.symbol == pair) {
          break;
        }
      }
      if (item != null) {
        item.changeValue = bigNum2Double(item.close - item.open);
        item.open = bigNum2Double(item.open);
        item.close = bigNum2Double(item.close);
        item.volume = bigNum2Double(item.volume);
        item.price = bigNum2Double(item.price);
        item.high = bigNum2Double(item.high);

        item.low = bigNum2Double(item.low);

        item.change = 0.0;
        if (item.open > 0) {
          item.change = (item.changeValue / item.open * 100 * 10).round() / 10;
        }

        var usdPrice = 0.2;
        if (pair.endsWith("USDT")) {
          usdPrice = await getCoinMarketPrice('tether');
        } else if (pair.endsWith("BTC")) {
          usdPrice = await getCoinMarketPrice('btc');
        } else if (pair.endsWith("ETH")) {
          usdPrice = await getCoinMarketPrice('eth');
        } else if (pair.endsWith("EXG")) {
          usdPrice = await getCoinMarketPrice('exchangily');
        }

        this._tradePriceState.currentState.showPrice(item, usdPrice);

        setState(() =>
        {
          this.priceChannelCompleted = true
        });
      }
      print('priceChannelCompleted');

    });
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
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          middle: Text(
            widget.pair,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body:
        Stack(
            children: <Widget>[

        ListView(
          children: <Widget>[


                TradePrice(key: _tradePriceState),
                //KlinePage(pair: widget.pair),
                LoadHTMLFileToWEbView(widget.pair),
                Trademarket(key: _tradeMarketState),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                        child: FlatButton(
                          color: Color(0xFF0da88b),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceOrder(pair: widget.pair, bidOrAsk: true)),
                            );
                          },
                          child: Text("Buy",
                              style: TextStyle(fontSize: 16, color: Colors.white)),
                        )),
                    Flexible(
                        child: FlatButton(
                          color: Color(0xFFe2103c),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceOrder(pair: widget.pair, bidOrAsk: false)),
                            );
                          },
                          child: Text("Sell",
                              style: TextStyle(fontSize: 16, color: Colors.white)),
                        ))
                  ],
                )

          ],
        ),
              Visibility(
                  visible: !(tradeChannelCompleted&&priceChannelCompleted&&orderChannelCompleted),
                  child:
    Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    color: Color(0xFF2c2c4c),
                  child:
                  Center(
                      child: CircularProgressIndicator()
                  )
    )
              )
         ]     )

        ,


        bottomNavigationBar: AppBottomNav());
  }
}
