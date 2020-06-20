import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/widgets/carousel.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:flutter/material.dart';

import 'market_pairs_detail_view.dart';

class MarketPairsTabView extends StatelessWidget {
  final List<List<Price>> marketPairsTabBarView;
  final List priceList;
  final bool isBusy;
  MarketPairsTabView(
      {Key key, this.marketPairsTabBarView, this.priceList, this.isBusy})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> tabNames = ['USDT', 'DUSD', 'BTC', 'ETH', 'EXG'];
    final List<Map> images = [
      {
        "imgUrl": "assets/images/slider/campaign.jpg",
        "route": '/campaignInstructions'
      },
      // {"imgUrl": "https://images.unsplash.com/photo-1561451213-d5c9f0951fdf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"},
      // {"imgUrl": "https://images.unsplash.com/photo-1516245834210-c4c142787335?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"},
    ];

    return DefaultTabController(
        length: tabNames.length,
        child: SafeArea(
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Carousel(imageData: images),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Offstage(
                      offstage: isBusy,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        height: 40,
                        child: Row(
                          children: [
                            for (var pair in priceList)
                              Expanded(
                                child: Card(
                                  color: Color(0xff851fff),
                                  margin: EdgeInsets.all(2),
                                  elevation: 3,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(pair.symbol.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Text(pair.price.toStringAsFixed(2),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ))
                                      ]),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                          indicatorPadding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          unselectedLabelColor: Color(0xffaaaaaa),
                          unselectedLabelStyle: TextStyle(fontSize: 14),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.redAccent,
                                Colors.yellowAccent
                              ]),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
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
                    ),
                    pinned: true,
                  ),
                ];
              },
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
          ),
        ));
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + 20;
  @override
  double get maxExtent => _tabBar.preferredSize.height + 20;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        new Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _tabBar,
          color: Color(0xff202138),
        ),
        new SizedBox(
          height: 20,
          child: Container(
            child: Container(
              padding: EdgeInsets.only(top: 2.0, bottom: 2),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                elevation: 1,
                child: HeaderRow(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
