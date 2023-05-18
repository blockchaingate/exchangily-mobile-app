import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import "package:flutter/material.dart";
import "overview-block.dart";
import '../../../shared/globals.dart' as globals;

class MarketOverview extends StatefulWidget {
  final List<Price>? data;
  const MarketOverview({Key? key, this.data}) : super(key: key);
  @override
  MarketOverviewState createState() => MarketOverviewState();
}

class MarketOverviewState extends State<MarketOverview> {
  double? btcUsdtPrice;
  double? btcUsdtChange;
  double? exgUsdtPrice;
  double? exgUsdtChange;
  double? fabUsdtPrice;
  double? fabUsdtChange;
  @override
  void initState() {
    super.initState();
    updatePrices(widget.data);
  }

  void updatePrices(List<Price>? prices) {
    double? btcUsdtP = 0.0;
    double? btcUsdtC = 0.0;
    double? exgUsdtP = 0.0;
    double? exgUsdtC = 0.0;
    double? fabUsdtP = 0.0;
    double? fabUsdtC = 0.0;
    if (prices != null) {
      for (var i = 0; i < prices.length; i++) {
        var item = prices[i];
        if (item.symbol == "BTCUSDT") {
          btcUsdtP = item.price;
          btcUsdtC = item.change;
        } else if (item.symbol == "EXGUSDT") {
          exgUsdtP = item.price;
          exgUsdtC = item.change;
        } else if (item.symbol == "FABUSDT") {
          fabUsdtP = item.price;
          fabUsdtC = item.change;
        }
      }
    }

    setState(() => {
          btcUsdtPrice = btcUsdtP,
          btcUsdtChange = btcUsdtC,
          exgUsdtPrice = exgUsdtP,
          exgUsdtChange = exgUsdtC,
          fabUsdtPrice = fabUsdtP,
          fabUsdtChange = fabUsdtC
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: globals.walletCardColor,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MarketOverviewBlock("BTC/USDT", btcUsdtPrice, btcUsdtChange),
            UIHelper.verticalSpaceMedium,
            MarketOverviewBlock("EXG/USDT", exgUsdtPrice, exgUsdtChange),
            UIHelper.verticalSpaceMedium,
            MarketOverviewBlock("FAB/USDT", fabUsdtPrice, fabUsdtChange),
          ],
        ),
      ),
    );
  }
}
