import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:flutter/material.dart';

import 'market_pairs_detail_view.dart';

class MarketPairsTabView extends StatelessWidget {
  final List<List<Price>> marketPairsTabBarView;
  final bool isBusy;
  MarketPairsTabView({Key key, this.marketPairsTabBarView, this.isBusy})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> tabNames = ['USDT', 'DUSD', 'BTC', 'ETH', 'EXG'];

    return DefaultTabController(
      length: tabNames.length,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false, // removes the back button
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 13),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                      unselectedLabelColor: Colors.redAccent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.redAccent, Colors.orangeAccent]),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.redAccent),
                      tabs: [
                        for (var tab in tabNames)
                          Tab(
                              child: Align(
                            alignment: Alignment.center,
                            child: Text(tab,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ))
                      ]),
                  // Ticker bar below
                  SizedBox(
                    height: 20,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Positioned.fill(
                          bottom: -11,
                          child: Container(
                            margin: EdgeInsets.only(top: 2.0, bottom: 2),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              elevation: 1,
                              child: HeaderRow(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        body: isBusy
            ? Container(
                color: Theme.of(context).accentColor,
                child: TabBarView(
                    children: tabNames.map((tab) {
                  return Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: ShimmerLayout(
                      layoutType: 'marketPairs',
                    ),
                  );
                }).toList()),
              )
            : Container(
                color: Theme.of(context).accentColor,
                child: TabBarView(
                    children: marketPairsTabBarView.map((pairList) {
                  return Container(
                    child: MarketPairPriceDetailView(pairList: pairList),
                  );
                }).toList()),
              ),
      ),
    );
  }
}

class HeaderRow extends StatelessWidget {
  const HeaderRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Ticker',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            )),
        Expanded(
          flex: 2,
          child: Text(
            'Price',
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'High',
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Low',
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Change',
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ],
    );
  }
}
