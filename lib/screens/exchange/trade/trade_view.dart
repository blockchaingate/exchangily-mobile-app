import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/market_pairs_tab_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orders_tab_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trade_viewmodel.dart';
import 'package:exchangilymobileapp/screens/trade/place_order/buy_sell.dart';
import 'package:exchangilymobileapp/screens/trade/widgets/trading_view.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class TradeView extends StatelessWidget {
  final String tickerName;
  TradeView({Key key, this.tickerName}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TradeViewModel>.reactive(
      // passing tickername in the constructor of the viewmodal so that we can pass it to the streamMap
      // which is required override
      viewModelBuilder: () => TradeViewModel(tickerName: tickerName),
      onModelReady: (model) {
        model.context = context;
      },
      builder: (context, model, _) => Scaffold(
        //   endDrawer: Text('End'),
        //backgroundColor: primaryColor.withOpacity(0.3),
        key: _scaffoldKey,

        drawer: model.dataReady('allPrices')
            ? Container(
                color: green,
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Stack(children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        color: yellow,
                        child: Positioned(
                            top: -50,
                            right: 5,
                            //   bottom: -50,
                            //  alignment: Alignment.bottomCenter,
                            child: IconButton(
                              icon: Icon(Icons.cancel, color: red),
                              onPressed: () {
                                model.navigationService.goBack();
                              },
                            )),
                      ),
                      Icon(Icons.access_alarm)
                    ]),
                    Expanded(
                      child: MarketPairsTabView(
                          marketPairsTabBar: model.marketPairsTabBar),
                    ),
                  ],
                ))
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
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            title: Text(
              tickerName,
              style: Theme.of(context).textTheme.headline4,
            ),
            centerTitle: true,
            automaticallyImplyLeading: false),
        body: Container(
          child: ListView(
            children: [
              /// Check if price current price object is not null
              model.currentPairPrice == null
                  ? Container(
                      child: LinearProgressIndicator(
                      backgroundColor: red,
                      value: null,
                    ))
                  :

                  /// Price, price change, low, high, vol Container

                  Container(
                      //  margin: EdgeInsets.all(5.0),
                      //  padding: EdgeInsets.all(5.0),
                      child: Column(
                        children: <Widget>[
                          // Price Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 10, 30.0, 10),
                                  child: Text(
                                      model.currentPairPrice.price
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 40, color: priceColor))),
                              Column(
                                children: [
                                  Text(
                                      "\$" +
                                          model.currentPairPrice.price
                                              .toStringAsFixed(2),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                  Row(
                                    children: [
                                      Text(
                                          (model.currentPairPrice.close -
                                                  model.currentPairPrice.open)
                                              .toStringAsFixed(2),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  color: Color(model
                                                              .currentPairPrice
                                                              .close >
                                                          model.currentPairPrice
                                                              .open
                                                      ? 0XFF0da88b
                                                      : 0XFFe2103c))),
                                      UIHelper.horizontalSpaceSmall,
                                      Text(
                                          model.currentPairPrice.change
                                                  .toStringAsFixed(2) +
                                              "%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  color: Color(model
                                                              .currentPairPrice
                                                              .change >=
                                                          0
                                                      ? 0XFF0da88b
                                                      : 0XFFe2103c))),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          // Change Price Value Row
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            color: walletCardColor,
                            child: Column(children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(AppLocalizations.of(context).volume,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2),
                                  Text(
                                      AppLocalizations.of(context)
                                          .low
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2),
                                  Text(
                                      AppLocalizations.of(context)
                                          .high
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2),
                                ],
                              ),
                              // Low Volume High Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(model.currentPairPrice?.low.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Text(
                                      model.currentPairPrice?.volume.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Text(model.currentPairPrice?.high.toString(),
                                      style:
                                          Theme.of(context).textTheme.headline6)
                                ],
                              ),
                            ]),
                          )
                        ],
                      ),
                    ), // price container ends
              // Below container contains trading view chart in the trade tab
              // Container(
              //   //margin: EdgeInsets.symmetric(horizontal: 9.0),
              //   child: LoadHTMLFileToWEbView(model.currentPairPrice.symbol),
              // ),
              // Buy Sell Buttons

              /// Market orders
              !model.dataReady('marketTradeList') &&
                      !model.dataReady('orderBookList')
                  ? Center(
                      child: CircularProgressIndicator(
                      backgroundColor: red,
                    ))
                  : Container(
                      child:
                          // Center(child: Text('Tabs')),

                          OrdersTabView(
                              ordersViewTabBody: model.ordersViewTabBody))
            ],
          ),
        ),
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
                  margin: EdgeInsets.only(right: 4.0),
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
                  color: sellPrice.withAlpha(175),
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
