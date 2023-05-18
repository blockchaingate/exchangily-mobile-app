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

import 'package:exchangilymobileapp/screens/exchange/markets/markets_viewmodel.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/market_pairs_tab_view.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MarketsView extends StatelessWidget {
  const MarketsView({Key? key, this.hideSlider = true}) : super(key: key);
  final bool? hideSlider;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketsViewModel>.reactive(
        onModelReady: (model) {
          model.context = context;
        },
        initialiseSpecialViewModelsOnce: true,
        builder: (context, model, _) => WillPopScope(
              onWillPop: () async {
                model.onBackButtonPressed();
                return Future(() => false);
              },
              child: Scaffold(
                body: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  //   color: Theme.of(context).tra,
                  child: Column(
                    children: [
                      // Add more widgets here as the market view expands

                      /// Market pairs tab
                      /// this is a dumb widget so no need to provide viewmodel
                      Flexible(
                        child: MarketPairsTabView(
                          marketPairsTabBarView: model.marketPairsTabBar,
                          priceList: model.btcFabExgUsdtPriceList,
                          isBusy: !model.dataReady,
                          hideSlider: hideSlider,
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomNavBar(count: 1),
              ),
            ),
        viewModelBuilder: () => MarketsViewModel());
  }
}
