import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class MyExchangeAssetsView extends StatelessWidget {
  final List myExchangeAssets;
  const MyExchangeAssetsView({Key key, this.myExchangeAssets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            color: walletCardColor,
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            child: Row(children: <Widget>[
              UIHelper.horizontalSpaceSmall,
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
          Flexible(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ListView.builder(
                  itemCount: myExchangeAssets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      // color: grey.withAlpha(25),
                      padding: const EdgeInsets.all(5.0),
                      margin: EdgeInsets.only(bottom: 2.0),
                      child: Row(
                        children: [
                          UIHelper.horizontalSpaceSmall,
                          Expanded(
                              flex: 2,
                              child: Text(myExchangeAssets[index]["coin"],
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  myExchangeAssets[index]["amount"].toString(),
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  myExchangeAssets[index]["lockedAmount"]
                                      .toString(),
                                  style: Theme.of(context).textTheme.headline6))
                        ],
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
