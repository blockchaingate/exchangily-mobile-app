import 'package:exchangilymobileapp/screen_state/market/marketPairsTabViewState.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/widgets/carousel.dart';
import 'package:exchangilymobileapp/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;
import 'market_pairs_detail_view.dart';

class MarketPairsTabView extends StatelessWidget {
  final List<List<Price>>? marketPairsTabBarView;
  final List? priceList;
  final bool? isBusy;
  final bool? hideSlider;
  const MarketPairsTabView(
      {Key? key,
      this.marketPairsTabBarView,
      this.priceList,
      this.isBusy,
      this.hideSlider = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> tabNames = [
      // 'FAV.',
      'DUSD', 'USDT', 'BTC', 'ETH', 'EXG', 'USDC', 'OTHERS'
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
                          ? const SliverToBoxAdapter(child: LoadingGif())
                          : SliverToBoxAdapter(
                              child: Offstage(
                                offstage: hideSlider!,
                                child: Column(
                                  children: [
                                    Carousel(
                                        imageData: model.images,
                                        lang: model.lang),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                      SliverToBoxAdapter(
                        child: Offstage(
                          offstage: isBusy!,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                            height: 40,
                            child: Row(
                              children: [
                                for (var pair in priceList!)
                                  Expanded(
                                    child: Card(
                                      color: const Color(0xff851fff),
                                      margin: const EdgeInsets.all(2),
                                      elevation: 3,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(pair.symbol.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                NumberUtil()
                                                    .truncateDoubleWithoutRouding(
                                                        pair.price,
                                                        precision: 3)
                                                    .toString(),
                                                style: const TextStyle(
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
                              isScrollable: true,
                              unselectedLabelColor: const Color(0xffaaaaaa),
                              unselectedLabelStyle:
                                  const TextStyle(fontSize: 10),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        globals.walletCardColor,
                                        globals.walletCardColor,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(3)),
                                  color: Colors.redAccent),
                              tabs: [
                                for (var tab in tabNames)
                                  Tab(
                                      child: Align(
                                    alignment: Alignment.center,
                                    child: Text(tab,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ))
                              ]),
                        ),
                        pinned: true,
                      ),
                    ];
                  },
                  body: isBusy!
                      ? Center(
                          child: model.sharedService!.loadingIndicator(),
                        )
                      : TabBarView(
                          children: marketPairsTabBarView!.map((pairList) {
                          return MarketPairPriceDetailView(pairList: pairList);
                        }).toList()),
                ),
              ),
            )));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height - 10;
  @override
  double get maxExtent => _tabBar.preferredSize.height - 10;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        Container(
          height: _tabBar.preferredSize.height - 10,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: const Color(0xff202138),
          child: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width,
                  _tabBar.preferredSize.height - 10),
              child: _tabBar),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
