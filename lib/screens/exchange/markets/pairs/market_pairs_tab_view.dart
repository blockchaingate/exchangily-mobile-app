import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/screens/trade/main.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
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
        body: Container(
          color: Theme.of(context).accentColor,
          // padding: EdgeInsets.only(top: 5),
          child: TabBarView(
              children: marketPairsTabBar.map((pairList) {
            return Container(
              // If i add row here than the error was that i should laid widget once only or get key null
              // so i extracted the widget and passed the List<Price> object which worked
              child: PriceDetailRow(pairList: pairList),
            );
          }).toList()),
        ),
      ),
    );
  }
}

class PriceDetailRow extends StatelessWidget {
  final List<Price> pairList;
  PriceDetailRow({Key key, this.pairList}) : super(key: key);
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
                String pair =
                    pairList[index].symbol.replaceAll('/', '').toString();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Trade(pair)),
                // );
                navigationService.navigateTo('/exchangeTrade', arguments: pair);
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
                                    .headline6
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
