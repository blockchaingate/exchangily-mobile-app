import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/market_trades/market_trade_model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class MarketTradesView extends StatelessWidget {
  final List<MarketTrades>? marketTrades;
  final PairDecimalConfig? decimalConfig;
  const MarketTradesView({Key? key, this.marketTrades, this.decimalConfig})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).canvasColor,
              child: SizedBox(
                height: 20,
                child: Row(
                  children: <Widget>[
                    UIHelper.horizontalSpaceSmall,
                    UIHelper.horizontalSpaceSmall,
                    Expanded(
                        flex: 1,
                        child: Text(FlutterI18n.translate(context, "price"),
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.titleSmall)),
                    UIHelper.horizontalSpaceMedium,
                    Expanded(
                        flex: 2,
                        child: Text(FlutterI18n.translate(context, "quantity"),
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.titleSmall)),
                    UIHelper.horizontalSpaceSmall,
                    Expanded(
                        flex: 2,
                        child: Text(FlutterI18n.translate(context, "time"),
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.titleSmall)),
                    UIHelper.horizontalSpaceMedium,
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: marketTrades!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: marketTrades![index].bidOrAsk!
                          ? buyOrders
                          : sellOrders,
                      padding: const EdgeInsets.all(4.0),
                      margin: const EdgeInsets.only(bottom: 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          UIHelper.horizontalSpaceSmall,
                          // UIHelper.horizontalSpaceSmall,
                          Expanded(
                              flex: 1,
                              child: Text(
                                  NumberUtil()
                                      .truncateDoubleWithoutRouding(
                                          marketTrades![index].price!,
                                          precision: decimalConfig!.qtyDecimal!)
                                      .toString(),
                                  textAlign: TextAlign.right,
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          UIHelper.horizontalSpaceSmall,
                          Expanded(
                              flex: 2,
                              child: Text(
                                  NumberUtil()
                                      .truncateDoubleWithoutRouding(
                                          marketTrades![index].quantity!,
                                          precision: decimalConfig!.qtyDecimal!)
                                      .toString(),
                                  textAlign: TextAlign.right,
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          UIHelper.horizontalSpaceSmall,
                          Expanded(
                              flex: 2,
                              child: Text(
                                  NumberUtil()
                                      .timeFormatted(marketTrades![index].time)
                                      .toString(),
                                  textAlign: TextAlign.right,
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          //  UIHelper.horizontalSpaceSmall,
                        ],
                      ),
                    );
                  }),
            )),
          ],
        ));
  }
}
