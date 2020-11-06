import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/shared/decimal_config.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_viewmodel.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trade_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class OrderBookView extends StatelessWidget {
  final String tickerName;
  OrderBookView({Key key, this.tickerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderbookViewModel>.reactive(
      // passing tickername in the constructor of the viewmodal so that we can pass it to the streamMap
      // which is required override
      viewModelBuilder: () => OrderbookViewModel(tickerName: tickerName),
      onModelReady: (model) {
        // model.context = context;
        model.init();
      },
      builder: (context, model, _) => !model.dataReady
          ? ShimmerLayout(
              layoutType: 'orderbook',
            )
          : Container(
              padding: EdgeInsets.all(5.0),
              child: ListView(
          //   mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Heading Buy Sell Orders Row
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                  UIHelper.verticalSpaceSmall,
                  // quanity/price text Row

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(AppLocalizations.of(context).quantity,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 9, color: grey)),
                              Text(AppLocalizations.of(context).price,
                                  style: TextStyle(fontSize: 9, color: grey))
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(AppLocalizations.of(context).price,
                                  style: TextStyle(fontSize: 9, color: grey)),
                              Text(AppLocalizations.of(context).quantity,
                                  style: TextStyle(fontSize: 9, color: grey)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Buy/Sell Orders List View
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Buy orders
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: model.orderbook.buyOrders.length,
                          itemBuilder: (BuildContext context, int index) {
                            return OrderDetailsView(
                              decimalConfig: model.decimalConfig,
                              orders: model.orderbook.buyOrders,
                              index: index,
                              isBuy: true,
                            );
                          },
                        ),
                      ),

                      // Sell Orders
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.orderbook.sellOrders.length,
                          itemBuilder: (BuildContext context, int index) {
                            return OrderDetailsView(
                              decimalConfig: model.decimalConfig,
                              orders: model.orderbook.sellOrders,
                              index: index,
                              isBuy: false,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

class OrderDetailsView extends StatelessWidget {
  final int index;
  final bool isBuy;
  final DecimalConfig decimalConfig;
  final List<OrderType> orders;
  const OrderDetailsView(
      {Key key,
      this.decimalConfig,
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
        child: isBuy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  orderRow(
                      orders[index]
                          .quantity
                          .toStringAsFixed(decimalConfig.quantityDecimal),
                      TextAlign.start,
                      grey),
                  orderRow(
                      orders[index]
                          .price
                          .toStringAsFixed(decimalConfig.priceDecimal),
                      TextAlign.end,
                      buyPrice),
                ],
              )
            : Row(
                children: <Widget>[
                  orderRow(
                      orders[index]
                          .price
                          .toStringAsFixed(decimalConfig.priceDecimal),
                      TextAlign.start,
                      sellPrice),
                  orderRow(
                      orders[index]
                          .quantity
                          .toStringAsFixed(decimalConfig.quantityDecimal),
                      TextAlign.end,
                      grey),
                ],
              ));
  }

  Widget orderRow(String textValue, TextAlign textAlign, Color colorValue) {
    return Expanded(
        child: Text(textValue,
            textAlign: textAlign,
            style: TextStyle(fontSize: 12, color: colorValue)));
  }
}
