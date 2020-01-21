import "package:flutter/material.dart";
import "overview-block.dart";
import '../../../models/price.dart';

class MarketOverview extends StatefulWidget {
  List<Price> data;
  MarketOverview({Key key,this.data})
      : super(key: key);
  @override
  MarketOverviewState createState() => MarketOverviewState();
}

class MarketOverviewState extends State<MarketOverview> {
  double btcUsdtPrice;
  double btcUsdtChange;
  double exgUsdtPrice;
  double exgUsdtChange;
  double fabUsdtPrice;
  double fabUsdtChange;
  @override
  void initState() {
    super.initState();
    this.updatePrices(widget.data);
  }

  void updatePrices(List<Price> prices) {

    var btcUsdtP = 0.0;
    var btcUsdtC = 0.0;
    var exgUsdtP = 0.0;
    var exgUsdtC = 0.0;
    var fabUsdtP = 0.0;
    var fabUsdtC = 0.0;
    if(prices != null) {
      for( var i = 0; i < prices.length; i++ ) {
        var item = prices[i];
        if(item.symbol == "BTCUSDT") {
          btcUsdtP = item.price;
          btcUsdtC = item.change;
        } else
        if(item.symbol == "EXGUSDT") {
          exgUsdtP = item.price;
          exgUsdtC = item.change;
        } else
        if(item.symbol == "FABUSDT") {
          fabUsdtP = item.price;
          fabUsdtC = item.change;
        }
      }
    }

    setState(() => {
      this.btcUsdtPrice = btcUsdtP,
      this.btcUsdtChange = btcUsdtC,
      this.exgUsdtPrice = exgUsdtP,
      this.exgUsdtChange = exgUsdtC,
      this.fabUsdtPrice = fabUsdtP,
      this.fabUsdtChange = fabUsdtC
    });
  }
  @override
  Widget build(BuildContext context) {
    return
      Container(
          color: Color(0xFF1a243f),
          margin: new EdgeInsets.symmetric(horizontal: 30),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MarketOverviewBlock("BTC/USDT", btcUsdtPrice, btcUsdtChange),
              Container(height: 80, child: VerticalDivider(color: Color(0xFF4c5684))),
              MarketOverviewBlock("EXG/USDT", exgUsdtPrice, exgUsdtChange),
              Container(height: 80, child: VerticalDivider(color: Color(0xFF4c5684))),
              MarketOverviewBlock("FAB/USDT", fabUsdtPrice, fabUsdtChange),

            ],
          )
      );
  }
}



