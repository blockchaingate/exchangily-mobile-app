import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/models/trade/trade-model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/market_trades_details_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/order_details_layout_view.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

// TODO: Change stream accordiongly when user select tab

class OrdersTabView extends StatelessWidget {
// ViewModelBuilderWidget<TradeViewModal> {
  final List<dynamic> ordersViewTabBody;
  OrdersTabView({Key key, this.ordersViewTabBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Widget builder(BuildContext context, TradeViewModal model, Widget child) {
    List<String> tabNames = ['Order Book', 'Market Trades', 'My Orders'];
    double screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: ordersViewTabBody.length,
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
          Container(
            height: screenHeight * 0.70,
            color: Theme.of(context).accentColor,
            child: TabBarView(
                children: ordersViewTabBody.map((tabBody) {
              int index = ordersViewTabBody.indexOf(tabBody);
              print('Index $index');
              return Container(
                child: SelectedTabWidget(tabBody: tabBody, index: index),
              );
            }).toList()),
          ),
        ],
      ),
    );
  }
  //@override
//TradeViewModal viewModelBuilder(BuildContext context) => TradeViewModal();

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
        // Expanded(child: Text('OrderBook'))
        Expanded(child: OrderDetailsLayoutView(orderBook: tabBody))
      else if (index == 1)
        Expanded(child: MarketOrderDetails(marketTrades: tabBody))
      else if (index == 2)
        Expanded(child: Text('My orders'))
      //OrderDetails(orderList: tabBody)
    ]);
  }
}

// Order Book Details
