import 'package:exchangilymobileapp/screen_state/market/MarketPairsTabViewState.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
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
  const MarketPairsTabView(
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
                                offstage: hideSlider,
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
                          offstage: isBusy,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                            height: 40,
                            child: Row(
                              children: [
                                for (var pair in priceList)
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
                  body: isBusy
                      ? Container(
                          //color: Theme.of(context).colorScheme.secondary,
                          child: Center(
                          child: model.sharedService.loadingIndicator(),
                        ))
                      : Container(
                          //  color: Theme.of(context).colorScheme.secondary,
                          child: TabBarView(
                              children: marketPairsTabBarView.map((pairList) {
                            return MarketPairPriceDetailView(
                                pairList: pairList);
                          }).toList()),
                        ),
                ),
              ),
            )));
  }
}

// class HeaderRow extends StatelessWidget {
//   const HeaderRow({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return
//         // Container();

//         Row(
//       children: <Widget>[
//         Expanded(
//             flex: 3,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10.0),
//               child: Text(
//                 'Ticker',
//                 style: Theme.of(context).textTheme.subtitle2,
//               ),
//             )),
//         Expanded(
//           flex: 2,
//           child: Text(
//             'Price',
//             style: Theme.of(context).textTheme.subtitle2,
//           ),
//         ),
//         Expanded(
//           flex: 2,
//           child: Text(
//             'High',
//             style: Theme.of(context).textTheme.subtitle2,
//           ),
//         ),
//         Expanded(
//           flex: 2,
//           child: Text(
//             'Low',
//             style: Theme.of(context).textTheme.subtitle2,
//           ),
//         ),
//         Expanded(
//           flex: 1,
//           child: Text(
//             'Change',
//             style: Theme.of(context).textTheme.subtitle2,
//           ),
//         ),
//       ],
//     );
//   }
// }

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
        Container(
          height: _tabBar.preferredSize.height - 10,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PreferredSize(
              child: _tabBar,
              preferredSize: Size(MediaQuery.of(context).size.width,
                  _tabBar.preferredSize.height - 10)),
          color: const Color(0xff202138),
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
