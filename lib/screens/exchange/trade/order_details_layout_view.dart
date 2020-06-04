import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/trade/order-model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class OrderDetailsLayoutView extends StatelessWidget {
  final List orderBook;
  OrderDetailsLayoutView({Key key, this.orderBook}) : super(key: key);
  // final NavigationService navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    List<OrderModel> buyOrders = orderBook[0];
    List<OrderModel> sellOrders = orderBook[1];
    return Container(
        padding: EdgeInsets.only(top: 5.0),
        child: Column(
          children: <Widget>[
            // Heading Buy Sell Orders Row
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Container(
                child: Text(AppLocalizations.of(context).buyOrders,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2),
              ),
              Container(
                child: Text(AppLocalizations.of(context).sellOrders,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2),
              ),
            ]),
            UIHelper.horizontalSpaceSmall,
            // Buy/Sell Row
            Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceAround,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Buy Orders Column
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: walletCardColor,
                      width: MediaQuery.of(context).size.width * 0.45,
                      padding: EdgeInsets.all(5.0),
                      // Quantity/Price headers row
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context).quantity,
                                style: TextStyle(fontSize: 12, color: grey)),
                            Text(AppLocalizations.of(context).price,
                                style: TextStyle(fontSize: 12, color: grey))
                          ]),
                    ),

                    // Buy Orders List View
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: buyOrders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return OrderDetailsView(
                              buyOrders: buyOrders, index: index);
                        },
                      ),
                    )
                  ],
                ),
                // Column Sell Orders
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        color: walletCardColor,
                        width: MediaQuery.of(context).size.width * 0.45,
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context).price,
                                  style: TextStyle(fontSize: 12, color: grey)),
                              Text(AppLocalizations.of(context).quantity,
                                  style: TextStyle(fontSize: 12, color: grey)),
                            ]),
                      ),

                      // Sell Orders For Loop

                      // Container(
                      //   height: 400,
                      //   child: ListView.builder(
                      //     itemCount: sellOrders.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return Container(
                      //         // decoration: const BoxDecoration(
                      //         //   border: Border(
                      //         //     top: BorderSide(
                      //         //         width: 0.5, color: Color(0xFF4c5684)),
                      //         //     bottom: BorderSide(
                      //         //         width: 0.15, color: Color(0xFF4c5684)),
                      //         //   ),
                      //         //   //  color: Color(0xFF472a4a),
                      //         // ),
                      //         width: MediaQuery.of(context).size.width * 0.45,
                      //         margin: EdgeInsets.only(bottom: 5.0),
                      //         color: Color(0xFF472a4a).withAlpha(75),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //           children: <Widget>[
                      //             Container(
                      //                 width: 100,
                      //                 child: Text(
                      //                     sellOrders[index].price.toStringAsFixed(3),
                      //                     textAlign: TextAlign.start,
                      //                     style: TextStyle(
                      //                         fontSize: 12, color: sellPrice))),
                      //             Container(
                      //                 width: 50,
                      //                 padding: EdgeInsets.symmetric(vertical: 7.0),
                      //                 child: Text(
                      //                     sellOrders[index].orderQuantity.toString(),
                      //                     textAlign: TextAlign.end,
                      //                     style: TextStyle(
                      //                         fontSize: 12, color: Color(0xFF5e617f))))
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ]),
              ],
            )
          ],
        ));
  }
}

class OrderDetailsView extends StatelessWidget {
  final int index;
  const OrderDetailsView(
      {Key key, @required this.buyOrders, @required this.index})
      : super(key: key);

  final List<OrderModel> buyOrders;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.45,
        margin: EdgeInsets.only(bottom: 5.0),
        color: Color(0xFF264559).withAlpha(75),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Quantity Container
            Flexible(
                fit: FlexFit.loose,
                //  width: 50,
                child: Text(buyOrders[index].orderQuantity.toStringAsFixed(2),
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, color: Color(0xFF5e617f)))),
            // Price Container
            Flexible(
                fit: FlexFit.loose,
                //width: 100,
                // padding: EdgeInsets.symmetric(vertical: 7.0),
                child: Text(buyOrders[index].price.toStringAsFixed(3),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 12, color: green))),
          ],
        ));
  }
}
