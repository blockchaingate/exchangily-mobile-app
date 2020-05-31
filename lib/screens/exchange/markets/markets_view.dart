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
import 'package:exchangilymobileapp/screens/exchange/markets/pairs/market_pairs_tab_view.dart';
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
    return ViewModelBuilder<MarketsViewModal>.reactive(
        onModelReady: (model) {
          print('1');
          model.context = context;
        },
        builder: (context, model, _) => Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: !model.dataReady
                  ? Container()
                  : Container(
                      //  margin: EdgeInsets.only(left: 30),

                      height: 70,
                      child: Row(
                        children: [
                          for (var pair in model.btcFabExgUsdtPriceList)
                            Expanded(
                              child: Card(
                                margin: EdgeInsets.all(1),
                                elevation: 3,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(pair.symbol.toString()),
                                      Text(pair.price.toStringAsFixed(2))
                                    ]),
                              ),
                            )
                        ],
                      ),
                    ),

              // padding: EdgeInsets.all(10),
              // color: Colors.black,
              body: model.isError
                  ? Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(model.errorMessage))
                  : model.dataReady
                      ? ShimmerLayout(
                          layoutType: 'walletDashboard',
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 5.0),
                          color: Theme.of(context).accentColor,
                          child: Container(
                            // height: 200,
                            child: MarketPairsTabView(
                                marketPairsTabBar: model.marketPairsTabBar),
                          ),
                        ),
              bottomNavigationBar: BottomNavBar(count: 1),
            ),
        viewModelBuilder: () => MarketsViewModal());
  }
}
