/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/trade-model.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/screens/trade/place_order/buy_sell.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import "widgets//price.dart";
import "widgets/market.dart";
import 'package:web_socket_channel/io.dart';
import '../../services/trade_service.dart';
// import "widgets/kline.dart";
import '../../utils/decoder.dart';
import '../../models/price.dart';
import '../../models/orders.dart';
import 'widgets/trading_view.dart';
import '../../utils/string_util.dart';
import '../../shared/globals.dart' as globals;

enum SingingCharacter { lafayette, jefferson }

class Trade extends StatefulWidget {
  final pair;

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
      var pair;

  List<PairDecimalConfig> pairDecimalConfigList = [];
  ApiService apiService = locator<ApiService>();
  void _updateTrades(tradesString) {
    // _klinePageState.currentState.updateTrades(trades);

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

  getDecimalPairConfig() async {
    await apiService.getPairDecimalConfig().then((res) {
      pairDecimalConfigList = res;
    });
    print(pairDecimalConfigList.length);
  }

  @override
  void initState() {
    super.initState();
    getDecimalPairConfig();
     pair = widget.pair.replaceAll(RegExp('/'), '');
    allTradesChannel = getTradeListChannel(pair);
    allTradesChannel.stream.listen((trades) {
      // print('Trade Channel $trades');
      _updateTrades(trades);
      if (this.mounted) {
        setState(() => {this.tradeChannelCompleted = true});
      }
    });

    allOrdersChannel = getOrderListChannel(pair);
    allOrdersChannel.stream.listen((orders) {
      // print('Order Channel $orders');
      _updateOrders(orders);
      if (this.mounted) {
        setState(() => {this.orderChannelCompleted = true});
      }
    });

    allPriceChannel = getAllPriceChannel();
    allPriceChannel.stream.listen((prices) async {
      //   print('Price Channel $prices');
      if (this._tradePriceState == null ||
          this._tradePriceState.currentState == null) {
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
       
        item.price = item.price;
        item.high = bigNum2Double(item.high);
     
        item.low = bigNum2Double(item.low);

        item.change = 0.0;
        if (item.open > 0) {
          item.change = (item.changeValue / item.open * 100 * 10).round() / 10;
        }

        var usdPrice = 0.2;
        if (pair.endsWith("USDT")) {
          usdPrice = await getCoinMarketPrice('tether');
          print('1111 $usdPrice');
          usdPrice = NumberUtil().truncateDouble(usdPrice, 2);
          print('2222 $usdPrice');
        } else if (pair.endsWith("BTC")) {
          usdPrice = await getCoinMarketPrice('btc');
        } else if (pair.endsWith("ETH")) {
          usdPrice = await getCoinMarketPrice('eth');
        } else if (pair.endsWith("EXG")) {
          usdPrice = await getCoinMarketPrice('exchangily');
        }

        if (this._tradePriceState != null &&
            this._tradePriceState.currentState != null) {
          this._tradePriceState.currentState.showPrice(item, usdPrice);
        }

        if (this.mounted) {
          setState(() => {this.priceChannelCompleted = true});
        }
      }
    });
  }

  closeChannels() {
    allTradesChannel.sink.close();
    allOrdersChannel.sink.close();
    allPriceChannel.sink.close();
    print('Close Channels');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          padding: EdgeInsetsDirectional.only(top: 5, bottom: 5),
          leading: CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                closeChannels();
                Navigator.pop(context);
              }
            },
          ),
          middle: Text(
            widget.pair,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: globals.walletCardColor,
        ),
        //backgroundColor: Color(0xFF1F2233),
        body: Stack(children: <Widget>[
          ListView(
            children: <Widget>[
              TradePrice(key: _tradePriceState),
              // Below container contains trading view chart in the trade tab
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 9.0),
                  child: LoadHTMLFileToWEbView(widget.pair)),
              // Below class contains the order book and market trades
              Trademarket(key: _tradeMarketState),
              SizedBox(height: 60)
            ],
          ),
          // Buy Sell Buttons
          Visibility(
              visible: (tradeChannelCompleted &&
                  priceChannelCompleted &&
                  orderChannelCompleted),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    width: 250,
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // Buy Button
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: FlatButton(
                            color: globals.buyPrice,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BuySell(
                                        pair: widget.pair, bidOrAsk: true)),
                              );
                            },
                            child: Text(AppLocalizations.of(context).buy,
                                style: TextStyle(
                                    fontSize: 13, color: globals.white)),
                          ),
                        )),
                        // Sell button
                        Flexible(
                            child: RaisedButton(
                          color: globals.sellPrice.withAlpha(175),
                          shape: StadiumBorder(
                              side: BorderSide(
                                  color: globals.sellPrice, width: 2)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BuySell(
                                      pair: widget.pair, bidOrAsk: false)),
                            );
                          },
                          child: Text(AppLocalizations.of(context).sell,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                        ))
                      ],
                    )),
              )),
          Visibility(
              visible: !(tradeChannelCompleted &&
                  priceChannelCompleted &&
                  orderChannelCompleted),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Color(0xFF2c2c4c),
                  child: Center(child: CircularProgressIndicator())))
        ]),
        // bottomNavigationBar: BottomNavBar(count: 2)
        );
  }

  @override
  void dispose() {
    super.dispose();
    closeChannels();
  }
}
