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

import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/market_pairs_tab_view.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/shared/carousel/carousel_view.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

class MarketsView extends StatelessWidget {
  final NavigationService navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigationService.navigateUsingpopAndPushedNamed(DashboardViewRoute);
        return new Future(() => false);
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: 5.0),
            //   color: Theme.of(context).tra,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add more widgets here as the market view expands
                CarouselView(),

                /// Market pairs tab
                /// this is a dumb widget so need to provide viewmodel
                Flexible(
                  child: MarketPairsTabView(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(count: 1),
        ),
      ),
    );
  }
}
