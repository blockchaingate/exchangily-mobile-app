import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:flutter/material.dart';

class MarketPairsTabView extends StatelessWidget {
  final List<List<Price>> marketPairsTabBarView;
  final bool isBusy;
  MarketPairsTabView({Key key, this.marketPairsTabBarView, this.isBusy})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> tabNames = ['USDT', 'DUSD', 'BTC', 'ETH', 'EXG'];

    return DefaultTabController(
      length: tabNames.length,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false, // removes the back button
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 13),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                      unselectedLabelColor: Colors.redAccent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.redAccent, Colors.orangeAccent]),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.redAccent),
                      tabs: [
                        for (var tab in tabNames)
                          Tab(
                              child: Align(
                            alignment: Alignment.center,
                            child: Text(tab,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ))
                      ]),
                  // Ticker bar below
                  SizedBox(
                    height: 20,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Positioned.fill(
                          bottom: -11,
                          child: Container(
                            margin: EdgeInsets.only(top: 2.0, bottom: 2),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25))),
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              elevation: 1,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          'Ticker',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Price',
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'High',
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Low',
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Change',
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        body: isBusy
            ? Container(
                color: Theme.of(context).accentColor,
                child: TabBarView(
                    children: tabNames.map((tab) {
                  return Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: ShimmerLayout(
                      layoutType: 'marketPairs',
                    ),
                  );
                }).toList()),
              )
            : Container(
                color: Theme.of(context).accentColor,
                child: TabBarView(
                    children: marketPairsTabBarView.map((pairList) {
                  return Container(
                    child: MarketPairPriceDetailView(pairList: pairList),
                  );
                }).toList()),
              ),
      ),
    );
  }
}

class MarketPairPriceDetailView extends StatelessWidget {
  final List<Price> pairList;
  MarketPairPriceDetailView({Key key, this.pairList}) : super(key: key);
  final NavigationService navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pairList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          // decoration: BoxDecoration(
          //     border: Border(
          //         bottom: BorderSide(
          //             color: Theme.of(context).primaryColor, width: 0.51))),
          //  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
          child: Card(
            margin: EdgeInsets.only(top: 1.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: InkWell(
              onTap: () {
                pairList[index].symbol =
                    pairList[index].symbol.replaceAll('/', '').toString();
                //navigationService.navigateTo

                /// If i use pushReplacementNamed here
                /// then reading from closed socket error is gone
                /// but now all the streams are running all the time
                /// as pushNamed doesn't remove the widget from the tree
                /// so widget don't get dispose
                Navigator.popAndPushNamed(context, '/exchangeTrade',
                    arguments: pairList[index]);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UIHelper.horizontalSpaceSmall,
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                pairList[index].symbol.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            ),
                            Text(
                              'Vol: ${pairList[index].volume.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(pairList[index].price.toString(),
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.start),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          pairList[index].high.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          pairList[index].low.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          pairList[index].change >= 0
                              ? "+" +
                                  pairList[index].change.toStringAsFixed(2) +
                                  '%'
                              : pairList[index].change.toStringAsFixed(2) + '%',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Color(pairList[index].change >= 0
                                    ? 0XFF0da88b
                                    : 0XFFe2103c),
                              ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
