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
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MarketsView extends StatelessWidget {
  const MarketsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketsViewModal>.reactive(
        builder: (context, model, _) => Container(
            padding: EdgeInsets.all(10),
            color: Colors.black,
            child: model.isError
                ? Container(
                    alignment: Alignment.center,
                    color: Colors.red,
                    child: Text(model.errorMessage))
                : Container(
                    color: Colors.purple,
                    child: Center(
                      child: !model.dataReady
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.purple.withAlpha(75),
                            )
                          : ListView.builder(
                              itemCount: model.coinPriceDetails.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        child: Text(
                                          model.coinPriceDetails[index].symbol
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        child: Text(
                                          model.coinPriceDetails[index].price
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        child: Text(
                                          model.coinPriceDetails[index].high
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        child: Text(
                                          model.coinPriceDetails[index].low
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                    ]);
                              },
                            ),
                    ),
                  )),
        viewModelBuilder: () => MarketsViewModal());
  }
}
