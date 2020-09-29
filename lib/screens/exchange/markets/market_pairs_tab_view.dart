import 'package:exchangilymobileapp/screen_state/market/MarketPairsTabViewState.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/widgets/carousel.dart';
import 'package:exchangilymobileapp/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;
import 'market_pairs_detail_view.dart';

class MarketPairsTabView extends StatelessWidget {
  final List<List<Price>> marketPairsTabBarView;
  final List priceList;
  final bool isBusy;
  final bool hideSlider;
  MarketPairsTabView(
      {Key key,
      this.marketPairsTabBarView,
      this.priceList,
      this.isBusy,
      this.hideSlider = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> tabNames = [
      // 'FAV.',
      'USDT', 'DUSD', 'BTC', 'ETH', 'EXG'
    ];

    return BaseScreen<MarketPairsTabViewState>(
        onModelReady: (model) {
          model.context = context;
          model.init();
        },
        builder: (context, model, child) => DefaultTabController(
            length: tabNames.length,
            child: SafeArea(
              child: Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      model.busy
                          ? SliverToBoxAdapter(child: LoadingGif())
                          : SliverToBoxAdapter(
                              child: Offstage(
                                offstage: hideSlider,
                                child: Column(
                                  children: [
                                    Carousel(
                                        imageData: model.images,
                                        lang: model.lang),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                      SliverToBoxAdapter(
                        child: Offstage(
                          offstage: isBusy,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
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
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                  gradient: LinearGradient(
                                      colors: [
                                        globals.primaryColor,
                                        globals.walletCardColor,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
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
                          child: Center(
                            child:
                                //      ShimmerLayout(
                                //   layoutType: 'marketPairs',
                                // )
                                model.sharedService.loadingIndicator(),
                            // margin: EdgeInsets.only(top: 10.0),
                            // child: ShimmerLayout(
                            //   layoutType: 'marketPairs',
                            // ),
                          ))
                      : Container(
                          color: Theme.of(context).accentColor,
                          child: TabBarView(
                              children: marketPairsTabBarView.map((pairList) {
                            return Container(
                              child:
                                  MarketPairPriceDetailView(pairList: pairList),
                            );
                          }).toList()),
                        ),
                ),
              ),
            )));
  }
}

class HeaderRow extends StatelessWidget {
  const HeaderRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // Container();

        Row(
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

  // @override
  // double get minExtent => _tabBar.preferredSize.height + 20;
  // @override
  // double get maxExtent => _tabBar.preferredSize.height + 20;

  @override
  double get minExtent => _tabBar.preferredSize.height - 10;
  @override
  double get maxExtent => _tabBar.preferredSize.height - 10;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        new Container(
          height: _tabBar.preferredSize.height - 10,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: PreferredSize(
              child: _tabBar,
              preferredSize: Size(MediaQuery.of(context).size.width,
                  _tabBar.preferredSize.height - 10)),
          color: Color(0xff202138),
        ),
        // new SizedBox(
        //   height: 20,
        //   child: Container(
        //     child: Container(
        //       padding: EdgeInsets.only(top: 2.0, bottom: 2),
        //       decoration: BoxDecoration(
        //           color: Theme.of(context).cardColor,
        //           borderRadius: BorderRadius.only(
        //               topLeft: Radius.circular(15),
        //               topRight: Radius.circular(15))),
        //       child: Card(
        //         margin: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(35),
        //         ),
        //         elevation: 1,
        //         child: HeaderRow(),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
