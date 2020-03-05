import "package:flutter/material.dart";
import "detail-pair.dart";
import '../../../models/price.dart';

class MarketDetail extends StatefulWidget {
  final List<Price> data;
  MarketDetail({Key key, this.data}) : super(key: key);

  @override
  MarketDetailState createState() => MarketDetailState();
}

class MarketDetailState extends State<MarketDetail>
    with SingleTickerProviderStateMixin {
  var usdtWidgets = List<Widget>();
  var btcWidgets = List<Widget>();
  var ethWidgets = List<Widget>();
  var exgWidgets = List<Widget>();

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
    this.updatePrices(widget.data);
  }

  void updatePrices(List<Price> prices) {
    usdtWidgets = [];
    btcWidgets = [];
    ethWidgets = [];
    exgWidgets = [];

    for (var price in prices) {
      if (price.symbol.endsWith("USDT")) {
        usdtWidgets.add(DetailPair(price.symbol.replaceAll('USDT', '/USDT'),
            price.volume, price.price, price.change, price.low, price.high));
      } else if (price.symbol.endsWith("BTC")) {
        btcWidgets.add(DetailPair(price.symbol.replaceAll('BTC', '/BTC'),
            price.volume, price.price, price.change, price.low, price.high));
      } else if (price.symbol.endsWith("ETH")) {
        ethWidgets.add(DetailPair(price.symbol.replaceAll('ETH', '/ETH'),
            price.volume, price.price, price.change, price.low, price.high));
      } else if (price.symbol.endsWith("EXG")) {
        exgWidgets.add(DetailPair(price.symbol.replaceAll('EXG', '/EXG'),
            price.volume, price.price, price.change, price.low, price.high));
      }
    }
    setState(() => {
          this.usdtWidgets = usdtWidgets,
          this.btcWidgets = btcWidgets,
          this.ethWidgets = ethWidgets,
          this.exgWidgets = exgWidgets
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0XFF871fff)),
            tabs: [
              Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                  child: Text("USDT")),
              Text("BTC"),
              Text("ETH"),
              Text("EXG")
            ],
            controller: _tabController,
            indicatorColor: Colors.white,
          ),
          Container(
            height: 550,
            child: TabBarView(
              children: [
                Container(child: Column(children: usdtWidgets)),
                Container(child: Column(children: btcWidgets)),
                Container(child: Column(children: ethWidgets)),
                Container(child: Column(children: exgWidgets)),
              ],
              controller: _tabController,
            ),
          )
        ],
      ),
    );
  }
}
