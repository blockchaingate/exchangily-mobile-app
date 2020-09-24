import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';

import 'package:exchangilymobileapp/screens/exchange/trade/market_trades/market_trades_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_orders_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orders_book_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trade_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

// TODO: Change stream accordiongly when user select tab

class OrdersTabView extends
// StatelessWidget {
    ViewModelBuilderWidget<TradeViewModel> {
  // final List<dynamic> ordersViewTabBody;
  // OrdersTabView({
  //   Key key,
  //   // this.ordersViewTabBody
  // }) : super(key: key);

  @override
  // Widget build(BuildContext context) {
  Widget builder(BuildContext context, TradeViewModel model, Widget child) {
    double screenHeight = MediaQuery.of(context).size.height;
    // List<dynamic> ordersViewTabBody = model.ordersViewTabBody;
    // print(' ordersViewTabBody.length ${ordersViewTabBody.length}');
    return !model.dataReady('orderBookList')
        ? Center(
            child: Text(AppLocalizations.of(context).loading + '...'),
          )
        : DefaultTabController(
            length: 3,
            //ordersViewTabBody.length,
            child: Column(
              children: [
                TabBar(
                    onTap: (int i) {
                      print('Tab $i');
                      //              model.switchStreams(i);
                    },
                    indicatorColor: primaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      // for (var tab in model.tabNames)
                      //   Tab(
                      //       child: Align(
                      //     alignment: Alignment.center,
                      //     child: Text(tab,
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //         )),
                      //   ))
                    ]),
                Container(
                  height: screenHeight * 0.70,
                  color: Theme.of(context).accentColor,
                  child: TabBarView(children: [
                    Expanded(child: OrderBookView(orderBook: model.orderbook)),
                    Expanded(
                        child: MarketTradesView(
                            marketTrades: model.marketTradesList)),
                    Expanded(child: MyOrdersView())
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
          );
  }

  @override
  TradeViewModel viewModelBuilder(BuildContext context) => TradeViewModel();
}

class SelectedTabWidget extends StatelessWidget {
  final tabBody;
  final int index;
  const SelectedTabWidget({Key key, this.tabBody, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (index == 0)
        Expanded(child: OrderBookView(orderBook: tabBody))
      else if (index == 1)
        Expanded(child: MarketTradesView(marketTrades: tabBody))
      else if (index == 2)
        Expanded(child: Text(AppLocalizations.of(context).myOrders))
      // MyOrderDetails(orderList: tabBody)
    ]);
  }
}

// Order Book Details
