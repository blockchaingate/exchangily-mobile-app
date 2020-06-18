import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/trade/order-model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class OrderBookView extends StatelessWidget {
  final List orderBook;
  OrderBookView({Key key, this.orderBook}) : super(key: key);
  // final NavigationService navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            // Heading Buy Sell Orders Row
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Container(
                child: Text(AppLocalizations.of(context).buyOrders,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6),
              ),
              Container(
                child: Text(AppLocalizations.of(context).sellOrders,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6),
              ),
            ]),

            // Buy/Sell Row

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Buy/Sell Orders Column
                for (var orders in orderBook)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        color: walletCardColor,
                        width: MediaQuery.of(context).size.width * 0.48,
                        padding: EdgeInsets.all(5.0),
                        // Quantity/Price headers row
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context).quantity,
                                  style: TextStyle(fontSize: 9, color: grey)),
                              Text(AppLocalizations.of(context).price,
                                  style: TextStyle(fontSize: 9, color: grey))
                            ]),
                      ),

                      // Buy/Sell Orders List View
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.48,
                        height: MediaQuery.of(context).size.height * 0.46,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: orders.length,
                          itemBuilder: (BuildContext context, int index) {
                            int orderTypeByIndex = orderBook.indexOf(orders);
                            return OrderDetailsView(
                              orders: orders,
                              index: index,
                              isBuy: orderTypeByIndex == 0 ? true : false,
                            );
                          },
                        ),
                      )
                    ],
                  ),
              ],
            )
          ],
        ));
  }
}

class OrderDetailsView extends StatelessWidget {
  final int index;
  final bool isBuy;
  final List<OrderModel> orders;
  const OrderDetailsView(
      {Key key,
      @required this.orders,
      @required this.index,
      @required this.isBuy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 2.0),
        padding: EdgeInsets.all(3.0),
        color: isBuy ? buyOrders : sellOrders,
        child: Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Quantity Container
            Expanded(
                child: isBuy
                    ? Text('${orders[index].orderQuantity.toStringAsFixed(3)}',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12, color: grey))
                    : Text('${orders[index].price.toStringAsFixed(3)}',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12, color: sellPrice))),
            // Price Container
            Expanded(
                child: isBuy
                    ? Text('${orders[index].price.toStringAsFixed(3)}',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 12, color: buyPrice))
                    : Text('${orders[index].orderQuantity.toStringAsFixed(3)}',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 12, color: grey))),
          ],
        ));
  }
}
