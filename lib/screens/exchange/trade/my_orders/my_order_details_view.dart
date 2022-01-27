import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';

import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'my_orders_viewmodel.dart';

class MyOrderDetailsView extends ViewModelWidget<MyOrdersViewModel> {
  final List<OrderModel> orders;
  const MyOrderDetailsView({this.orders});

  @override
  Widget build(BuildContext context, MyOrdersViewModel model) {
    return model.isBusy
        ? ShimmerLayout(layoutType: 'marketTrades')
        : ListView.builder(
            itemCount: orders.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var order = orders[index];
              return Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text('$index',
                          style: Theme.of(context).textTheme.headline6)),
                  Expanded(
                      flex: 1,
                      child: Text(
                          order.bidOrAsk
                              ? FlutterI18n.translate(context, "buy")
                              : FlutterI18n.translate(context, "sell"),
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Color(
                                    (order.bidOrAsk) ? 0xFF0da88b : 0xFFe2103c),
                              ))),
                  Expanded(
                      flex: 2,
                      child: Text(order.pairName.toString(),
                          style: Theme.of(context).textTheme.headline6)),
                  Expanded(
                      flex: 2,
                      child: Text(order.price.toString(),
                          style: Theme.of(context).textTheme.headline6)),
                  Expanded(
                      flex: 2,
                      child: Text(
                          '${model.filledAmount.toString()} (${model.filledPercentage.toStringAsFixed(2)}%)',
                          style: Theme.of(context).textTheme.headline6)),
                  Expanded(
                      flex: 1,
                      child: order.isActive
                          ? model.isBusy
                              ? CircularProgressIndicator()
                              : IconButton(
                                  color: red,
                                  icon: Icon(
                                    Icons.close,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    model.checkPass(context, order.orderHash);
                                  })
                          : IconButton(
                              disabledColor:
                                  Theme.of(context).disabledColor.withAlpha(50),
                              icon: Icon(
                                Icons.close,
                                size: 16,
                              ),
                              onPressed: () {
                                print('closed orders');
                              }))
                ],
              );
            });
  }
}
