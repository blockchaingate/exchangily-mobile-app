import 'package:exchangilymobileapp/models/trade/order-model.dart';
import 'package:flutter/material.dart';

class MyOrdersView extends StatelessWidget {
  final List<OrderModel> myOrders;
  const MyOrdersView({Key key, this.myOrders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: myOrders.isEmpty
            ? Align(alignment: Alignment.topCenter, child: Text('No orders'))
            : Center(child: Text('Orders ${myOrders.length}')));
  }
}
