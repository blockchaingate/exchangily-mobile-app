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
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MarketsView extends StatelessWidget {
  const MarketsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketsViewModal>.reactive(
        builder: (context, model, _) => Scaffold(
              // padding: EdgeInsets.all(10),
              // color: Colors.black,
              body: model.isError
                  ? Container(
                      alignment: Alignment.center,
                      color: Colors.red,
                      child: Text(model.errorMessage))
                  : !model.dataReady
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.purple.withAlpha(75),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 5.0),
                          color: Theme.of(context).accentColor,
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          'Ticker',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                      )),
                                  Expanded(
                                    flex: 1,
                                    child: Text('Volume',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                        textAlign: TextAlign.end),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text('High',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                        textAlign: TextAlign.end),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text('Low',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                        textAlign: TextAlign.end),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text('Change',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                        textAlign: TextAlign.end),
                                  ),
                                ],
                              ),
                              Container(
                                height: 200,
                                child: MarketPairsTabView(
                                    marketPairsTabBar: model.marketPairsTabBar),
                              )
                            ],
                          ),
                        ),
              bottomNavigationBar: BottomNavBar(count: 1),
            ),
        viewModelBuilder: () => MarketsViewModal());
  }
}
