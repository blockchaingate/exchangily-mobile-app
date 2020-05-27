import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class MarketPairsTabView extends StatelessWidget {
  final List<List<Price>> marketPairsTabBar;
  MarketPairsTabView({Key key, this.marketPairsTabBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> tabNames = ['USDT', 'DUSD', 'BTC', 'ETH', 'EXG'];

    return DefaultTabController(
      length: marketPairsTabBar.length,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(tabs: [
          for (var tab in tabNames)
            Text(tab, style: Theme.of(context).textTheme.headline4)
          //  tabNames.map((tickerName) {
          //   return Tab(
          //     child: Text(tickerName,
          //         style: Theme.of(context).textTheme.headline4),
          //   );
          // }).toList()
        ])),
        body: Container(
          child: TabBarView(
              children: marketPairsTabBar.map((pairList) {
            return Container(
              // If i add row here than the error was that i should laid widget once only or get key null
              // so i extracted the widget and passed the List<Price> object which worked
              child: PriceRow(pairList: pairList),
            );
          }).toList()),
        ),
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final List<Price> pairList;
  PriceRow({Key key, this.pairList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pairList.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UIHelper.horizontalSpaceSmall,
              Expanded(
                child: Text(
                  pairList[index].symbol.toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              UIHelper.horizontalSpaceSmall,
              Expanded(
                child: Text(
                  pairList[index].price.toString(),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              UIHelper.horizontalSpaceSmall,
              Expanded(
                child: Text(
                  pairList[index].high.toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              UIHelper.horizontalSpaceSmall,
              Expanded(
                child: Text(
                  pairList[index].low.toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              )
            ]);
      },
    );
  }
}
