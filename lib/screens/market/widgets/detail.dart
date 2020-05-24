import 'package:exchangilymobileapp/models/trade/price.dart';
import "package:flutter/material.dart";
import "detail-pair.dart";
import '../../../shared/globals.dart' as globals;

class MarketDetail extends StatefulWidget {
  final List<Price> data;
  MarketDetail({Key key, this.data}) : super(key: key);

  @override
  MarketDetailState createState() => MarketDetailState();
}

class MarketDetailState extends State<MarketDetail>
    with SingleTickerProviderStateMixin {
  var usdtWidgets = List<Widget>();
  var dusdWidgets = List<Widget>();
  var btcWidgets = List<Widget>();
  var ethWidgets = List<Widget>();
  var exgWidgets = List<Widget>();

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
    this.updatePrices(widget.data);
  }

  void updatePrices(List<Price> prices) {
    usdtWidgets = [];
    dusdWidgets = [];
    btcWidgets = [];
    ethWidgets = [];
    exgWidgets = [];

    for (var price in prices) {
      print('price ${price.price}');
      if (price.symbol.endsWith("USDT")) {
        setState(() {
          price.high = double.parse(price.high.toStringAsFixed(2));
          print('hight ${price.high}');
        });
        usdtWidgets.add(DetailPair(price.symbol.replaceAll('USDT', '/USDT'),
            price.volume, price.price, price.change, price.low, price.high));
      } else if (price.symbol.endsWith("DUSD")) {
        dusdWidgets.add(DetailPair(price.symbol.replaceAll('DUSD', '/DUSD'),
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
          this.dusdWidgets = dusdWidgets,
          this.btcWidgets = btcWidgets,
          this.ethWidgets = ethWidgets,
          this.exgWidgets = exgWidgets
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 7.0),
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
              Text("DUSD"),
              Text("BTC"),
              Text("ETH"),
              Text("EXG")
            ],
            controller: _tabController,
            indicatorColor: Colors.white,
          ),
          Container(
              margin: EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.all(5.0),
              color: globals.walletCardColor.withAlpha(75),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          'Ticker',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: Text('Volume',
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('High',
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Low',
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Change',
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.end),
                  ),
                ],
              )),
          Container(
            height: 550,
            child: TabBarView(
              children: [
                Container(child: Column(children: usdtWidgets)),
                Container(child: Column(children: dusdWidgets)),
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
