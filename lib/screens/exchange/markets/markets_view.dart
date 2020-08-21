/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/markets_viewmodel.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/market_pairs_tab_view.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class MarketsView extends StatelessWidget {
  const MarketsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketsViewModel>.reactive(
        onModelReady: (model) {
          model.context = context;
          print('in markets view');
        },
        builder: (context, model, _) => WillPopScope(
              onWillPop: () async {
                model.onBackButtonPressed();
                return new Future(() => false);
              },
              child: Scaffold(
                body: Container(
                  margin: EdgeInsets.only(top: 5.0),
                  //   color: Theme.of(context).tra,
                  child: Column(
                    children: [
                      // Add more widgets here as the market view expands

                      /// Market pairs tab
                      /// this is a dumb widget so need to provide viewmodel
                      Flexible(
                        child: MarketPairsTabView(
                          marketPairsTabBarView: model.marketPairsTabBar,
                          priceList: model.btcFabExgUsdtPriceList,
                          isBusy: !model.dataReady,
                        ),
                      ),
                    ],
                  ),
                ),
                // floatingActionButtonLocation:
                //     FloatingActionButtonLocation.centerFloat,
                // floatingActionButton: !model.dataReady
                //     ? Container()
                //     : Container(
                //         height: 70,
                //         child: Row(
                //           children: [
                //             for (var pair in model.btcFabExgUsdtPriceList)
                //               Expanded(
                //                 child: Card(
                //                   margin: EdgeInsets.all(1),
                //                   elevation: 3,
                //                   child: Column(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.center,
                //                       children: [
                //                         Text(pair.symbol.toString()),
                //                         Text(pair.price.toStringAsFixed(2))
                //                       ]),
                //                 ),
                //               )
                //           ],
                //         ),
                //       ),
                bottomNavigationBar: BottomNavBar(count: 1),
              ),
            ),
        viewModelBuilder: () => MarketsViewModel());
  }
}
