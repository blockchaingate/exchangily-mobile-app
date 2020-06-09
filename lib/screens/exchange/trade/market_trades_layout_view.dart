import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/trade/trade-model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trade_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MarketTradesLayoutView extends StatelessWidget {
  final List<TradeModel> marketTrades;
  const MarketTradesLayoutView({Key key, this.marketTrades}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
              color: secondaryColor,
              child: SizedBox(
                height: 20,
                child: Row(
                  children: <Widget>[
                    UIHelper.horizontalSpaceMedium,
                    Expanded(
                        flex: 3,
                        child: Text(AppLocalizations.of(context).price,
                            style: Theme.of(context).textTheme.subtitle2)),
                    Expanded(
                        flex: 3,
                        child: Text(AppLocalizations.of(context).quantity,
                            style: Theme.of(context).textTheme.subtitle2)),
                    Expanded(
                        flex: 2,
                        child: Text(AppLocalizations.of(context).date,
                            style: Theme.of(context).textTheme.subtitle2))
                  ],
                ),
              ),
            ),
            Expanded(child: MarketTradeDetailView(marketTrades: marketTrades)),
          ],
        ));
  }
}

class MarketTradeDetailView extends StatelessWidget {
  const MarketTradeDetailView({
    Key key,
    @required this.marketTrades,
  }) : super(key: key);

  final List<TradeModel> marketTrades;

  @override
  Widget build(BuildContext context) {
    timeFormatted(timeStamp) {
      var time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
      return time.hour.toString() +
          ':' +
          time.minute.toString() +
          ':' +
          time.second.toString();
    }

    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: marketTrades.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  UIHelper.horizontalSpaceSmall,
                  Expanded(
                      flex: 3,
                      child: Text(marketTrades[index].price.toStringAsFixed(5),
                          style: Theme.of(context).textTheme.headline6)),
                  Expanded(
                      flex: 3,
                      child: Text(marketTrades[index].amount.toString(),
                          style: Theme.of(context).textTheme.headline6)),
                  Expanded(
                      flex: 2,
                      child: Text(
                          timeFormatted(marketTrades[index].time).toString(),
                          style: Theme.of(context).textTheme.headline6)),
                ],
              ),
            );
          }),
    );
  }
}
