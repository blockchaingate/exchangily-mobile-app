import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/models/trade/trade-model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

// TODO: Change stream accordiongly when user select tab

class OrdersTabView extends StatelessWidget {
  final List<dynamic> ordersViewTabBody;
  OrdersTabView({Key key, this.ordersViewTabBody}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> tabNames = ['Order Book', 'Market Trades', 'My Orders'];

    return DefaultTabController(
      length: ordersViewTabBody.length,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 13),
              child: TabBar(
                  //  unselectedLabelColor: Colors.redAccent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // indicator: BoxDecoration(
                  //     gradient: LinearGradient(
                  //         colors: [Colors.redAccent, Colors.orangeAccent]),
                  //     shape: BoxShape.rectangle,
                  //     borderRadius: BorderRadius.circular(25),
                  //     color: Colors.redAccent),
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
            )),
        body: Container(
          color: Theme.of(context).accentColor,
          child: TabBarView(
              children: ordersViewTabBody.map((tabBody) {
            Container(
              child: SelectedTabWidget(tabBody: tabBody),
            );
          }).toList()),
        ),
      ),
    );
  }
}

class SelectedTabWidget extends StatelessWidget {
  final tabBody;
  const SelectedTabWidget({Key key, this.tabBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (1 == 1)
        OrderDetails(orderList: tabBody)
      else if (2 == 2)
        MarketTradeDetails(marketTradeList: tabBody)
    ]);
  }
}

// Order Book Details

class OrderDetails extends StatelessWidget {
  final List<Price> orderList;
  OrderDetails({Key key, this.orderList}) : super(key: key);
  final NavigationService navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orderList.length,
      itemBuilder: (BuildContext context, int index) {
        return Text('In order book');

        // Container(
        //       child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: <Widget>[
        //       // Heading Buy Sell Orders Row
        //       Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        //         Container(
        //           child: Text(AppLocalizations.of(context).buyOrders,
        //               textAlign: TextAlign.center,
        //               style: Theme.of(context).textTheme.bodyText1),
        //         ),
        //         Container(
        //           padding: EdgeInsets.all(5.0),
        //           child: Text(AppLocalizations.of(context).sellOrders,
        //               textAlign: TextAlign.center,
        //               style: Theme.of(context).textTheme.bodyText1),
        //         ),
        //       ]),
        //       UIHelper.horizontalSpaceSmall,
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: <Widget>[
        //           // Column Buy Orders
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: <Widget>[
        //               Container(
        //                 color: walletCardColor,
        //                 width: MediaQuery.of(context).size.width * 0.45,
        //                 padding: EdgeInsets.all(5.0),
        //                 child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Text(AppLocalizations.of(context).quantity,
        //                           style: TextStyle(
        //                               fontSize: 12, color: grey)),
        //                       Text(AppLocalizations.of(context).price,
        //                           style: TextStyle(
        //                               fontSize: 12, color: grey))
        //                     ]),
        //               ),
        //               // Buy Orders For Loop
        //               for (var item in buy)
        //                 Container(
        //                     width: MediaQuery.of(context).size.width * 0.45,
        //                     margin: EdgeInsets.only(bottom: 5.0),
        //                     color: Color(0xFF264559).withAlpha(75),
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                       children: <Widget>[
        //                         // Quantity Container
        //                         Container(
        //                             width: 50,
        //                             child: Text(
        //                                 item.orderQuantity.toStringAsFixed(2),
        //                                 textAlign: TextAlign.start,
        //                                 style: TextStyle(
        //                                     fontSize: 12,
        //                                     color: Color(0xFF5e617f)))),
        //                         // Price Container
        //                         Container(
        //                             width: 100,
        //                             padding:
        //                                 EdgeInsets.symmetric(vertical: 7.0),
        //                             child: Text(item.price.toStringAsFixed(3),
        //                                 textAlign: TextAlign.end,
        //                                 style: TextStyle(
        //                                     fontSize: 12,
        //                                     color: green))),
        //                       ],
        //                     )),
        //               SizedBox(height: 10)
        //             ],
        //           ),
        //           // Column Sell Orders
        //           Column(
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: <Widget>[
        //                 Container(
        //                   color: walletCardColor,
        //                   width: MediaQuery.of(context).size.width * 0.45,
        //                   padding: EdgeInsets.all(5.0),
        //                   child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Text(AppLocalizations.of(context).price,
        //                             style: TextStyle(
        //                                 fontSize: 12, color: grey)),
        //                         Text(AppLocalizations.of(context).quantity,
        //                             style: TextStyle(
        //                                 fontSize: 12, color: grey)),
        //                       ]),
        //                 ),

        //                 // Sell Orders For Loop
        //                 for (var item in sell.reversed)
        //                   Container(
        //                       // decoration: const BoxDecoration(
        //                       //   border: Border(
        //                       //     top: BorderSide(
        //                       //         width: 0.5, color: Color(0xFF4c5684)),
        //                       //     bottom: BorderSide(
        //                       //         width: 0.15, color: Color(0xFF4c5684)),
        //                       //   ),
        //                       //   //  color: Color(0xFF472a4a),
        //                       // ),
        //                       width: MediaQuery.of(context).size.width * 0.45,
        //                       margin: EdgeInsets.only(bottom: 5.0),
        //                       color: Color(0xFF472a4a).withAlpha(75),
        //                       child: Row(
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.spaceEvenly,
        //                         children: <Widget>[
        //                           Container(
        //                               width: 100,
        //                               child: Text(item.price.toStringAsFixed(3),
        //                                   textAlign: TextAlign.start,
        //                                   style: TextStyle(
        //                                       fontSize: 12,
        //                                       color: sellPrice))),
        //                           Container(
        //                               width: 50,
        //                               padding:
        //                                   EdgeInsets.symmetric(vertical: 7.0),
        //                               child: Text(item.orderQuantity.toString(),
        //                                   textAlign: TextAlign.end,
        //                                   style: TextStyle(
        //                                       fontSize: 12,
        //                                       color: Color(0xFF5e617f))))
        //                         ],
        //                       )),
        //                 SizedBox(height: 10)
        //               ]),
        //         ],
        //       )
        //     ],
        //   ));
      },
    );
  }
}

/// Market Trade Details
class MarketTradeDetails extends StatelessWidget {
  final List<TradeModel> marketTradeList;
  const MarketTradeDetails({Key key, this.marketTradeList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PageView.builder(
            itemCount: marketTradeList.length,
            itemBuilder: (BuildContext context, int index) {
              return Text('in market trades');
            }));
  }
}
