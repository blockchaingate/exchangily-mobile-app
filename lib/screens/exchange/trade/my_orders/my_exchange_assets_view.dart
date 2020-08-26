import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';

class MyExchangeAssetsView extends StatelessWidget {
  final List myExchangeAssets;
  const MyExchangeAssetsView({Key key, this.myExchangeAssets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: myExchangeAssets == null
          ? ShimmerLayout(
              layoutType: 'marketTrades',
            )
          : Column(
              children: [
                Container(
                  color: walletCardColor,
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                  child: Row(children: <Widget>[
                    UIHelper.horizontalSpaceSmall,
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(AppLocalizations.of(context).symbol,
                            style: Theme.of(context).textTheme.subtitle2),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(AppLocalizations.of(context).coin,
                            style: Theme.of(context).textTheme.subtitle2),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(AppLocalizations.of(context).amount,
                          style: Theme.of(context).textTheme.subtitle2),
                    ),
                    Expanded(
                        flex: 2,
                        child: Text(AppLocalizations.of(context).lockedAmount,
                            style: Theme.of(context).textTheme.subtitle2)),
                  ]),
                ),
                Container(
                  decoration: BoxDecoration(
                      //  border: Border.all(color: primaryColor, width: 0.35)
                      ),
                  height: UIHelper.getScreenFullHeight(context) / 1.75,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        String tickerName =
                            model.data[index]["coin"].toString();
                        return Container(
                          // color: grey.withAlpha(25),

                          child: Row(
                            children: [
                              UIHelper.horizontalSpaceSmall,
                              // Card logo container
                              Expanded(
                                flex: 1,
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(right: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Image.asset(
                                        'assets/images/wallet-page/${tickerName.toLowerCase()}.png'),
                                    width: 35,
                                    height: 35),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(model.data[index]["coin"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      model.data[index]["amount"].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      model.data[index]["lockedAmount"]
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6))
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
    );
  }
}
