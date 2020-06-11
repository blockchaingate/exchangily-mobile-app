import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/market_pairs_tab_view.dart';

import 'package:exchangilymobileapp/screens/exchange/trade/pair_price_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trade_viewmodel.dart';
import 'package:exchangilymobileapp/screens/trade/place_order/buy_sell.dart';
import 'package:exchangilymobileapp/screens/trade/widgets/trading_view.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

import 'market_trades/market_trades_view.dart';
import 'my_orders/my_orders_view.dart';
import 'orderbook/orders_view.dart';

class TradeView extends StatelessWidget {
  final Price pairPriceByRoute;
  TradeView({Key key, this.pairPriceByRoute}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TradeViewModel>.reactive(
      // passing tickername in the constructor of the viewmodal so that we can pass it to the streamMap
      // which is required override
      viewModelBuilder: () =>
          TradeViewModel(pairPriceByRoute: pairPriceByRoute),
      onModelReady: (model) {
        print('in init trade view');
        model.context = context;
        // if (model.dataReady(model.allPriceStreamKey)) {
        //   print('before cancelling stream');
        //   model.cancelSingleStreamByKey(model.allPriceStreamKey);
        // }
        // model.resumeAllStreams();
      },
      builder: (context, model, _) => Scaffold(
        key: _scaffoldKey,
        drawer: model.dataReady('allPrices')
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: Stack(overflow: Overflow.visible, children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      child: MarketPairsTabView(
                        marketPairsTabBarView: model.marketPairsTabBar,
                        isBusy: false,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(90),
                                bottomLeft: Radius.circular(1))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: white,
                              size: 30,
                            ),
                            onPressed: () {
                              //model.resumeAllStreams();
                              model.navigationService.goBack();
                            },
                          ),
                        ),
                      )),
                  // Icon(Icons.access_alarm)
                ]))
            : Container(
                child: Center(
                  child: Text(AppLocalizations.of(context).serverError),
                ),
              ),
        appBar: AppBar(
            backgroundColor: primaryColor.withOpacity(0.25),
            leading: IconButton(
              icon: Icon(Icons.compare_arrows),
              onPressed: () {
                // model.pauseAllStreams();
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            title: Text(
              model.updateTickerName(pairPriceByRoute.symbol),
              style: Theme.of(context).textTheme.headline4,
            ),
            centerTitle: true,
            automaticallyImplyLeading: false),
        body: Container(
          child:
              //  model.hasError('allPrices') ||
              //         model.hasError('orderBookList') ||
              //         model.hasError('marketTradesList')
              //     ? Center(
              //         child: Text('Data Stream Failed'),
              //       )
              //     :
              ListView(
            children: [
              /// Check if price current price object is not null
              !model.dataReady(model.allPriceStreamKey)
                  ? Container(
                      child: Shimmer.fromColors(
                          child: PairPriceView(
                            pairPrice: model.pairPriceByRoute,
                            isBusy: true,
                          ),
                          baseColor: white,
                          highlightColor: primaryColor))
                  : Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: PairPriceView(
                        pairPrice: model.currentPairPrice,
                        isBusy: false,
                      ),
                    ),

              // Below container contains trading view chart in the trade tab
              Container(
                //margin: EdgeInsets.symmetric(horizontal: 9.0),
                child: LoadHTMLFileToWEbView(
                    model.updateTickerName(pairPriceByRoute.symbol)),
              ),

              /// Market orders
              // !model.dataReady('marketTradeList') &&
              // !model.dataReady('orderBookList')
              //     ? Container(
              //         margin:
              //             EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
              //         height: 150,
              //         child: ShimmerLayout(
              //           layoutType: 'orderbook',
              //         ),
              //       )
              //     :

              // Tabs for orderbook, market trades and my orders
              DefaultTabController(
                length: 3,
                //ordersViewTabBody.length,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                        indicatorWeight: 3.0,
                        onTap: (int tabIndex) {
                          model.switchStreams(tabIndex);
                        },
                        indicatorColor: primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          for (var tab in model.tabNames)
                            Tab(
                                child: Align(
                              alignment: Alignment.center,
                              child: Text(tab,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ))
                        ]),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: TabBarView(children: [
                        !model.dataReady(model.orderBookStreamKey)
                            // order book container
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 20),
                                height: 150,
                                child: ShimmerLayout(
                                  layoutType: 'orderbook',
                                ),
                              )
                            : OrdersView(orderBook: model.orderBook),
                        !model.dataReady(model.marketTradesStreamKey)
                            // market trades container
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 20),
                                height: 150,
                                child: ShimmerLayout(
                                  layoutType: 'marketTrades',
                                ),
                              )
                            : MarketTradesView(
                                marketTrades: model.marketTradesList),
                        // my trades view
                        MyOrdersView()
                      ]

                          //      ordersViewTabBody.map((tabBody) {
                          //   int index = ordersViewTabBody.indexOf(tabBody);
                          //   print('Index $index');
                          //   return Container(
                          //     child: SelectedTabWidget(tabBody: tabBody, index: index),
                          //   );
                          // }).toList()
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // Floatin Button buy/sell
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Container(
            width: 160,
            //margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Buy Button
                Flexible(
                    child: Container(
                  margin: EdgeInsets.only(right: 2.0),
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    color: buyPrice,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuySell(
                                pair: model.currentPairPrice.symbol,
                                bidOrAsk: true)),
                      );
                    },
                    child: Text(AppLocalizations.of(context).buy,
                        style: TextStyle(fontSize: 13, color: white)),
                  ),
                )),
                // Sell button
                Flexible(
                    child: RaisedButton(
                  padding: EdgeInsets.all(0),
                  color: sellPrice,
                  shape: StadiumBorder(
                      side: BorderSide(color: sellPrice, width: 1)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuySell(
                              pair: model.currentPairPrice.symbol,
                              bidOrAsk: false)),
                    );
                  },
                  child: Text(AppLocalizations.of(context).sell,
                      style: TextStyle(fontSize: 13, color: Colors.white)),
                ))
              ],
            )),
        bottomNavigationBar: BottomNavBar(count: 1),
      ),
    );
  }
}
