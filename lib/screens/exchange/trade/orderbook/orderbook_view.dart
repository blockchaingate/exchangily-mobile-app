import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';

import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderBookView extends StatelessWidget {
  final bool isVerticalOrderbook;
  final Orderbook orderbook;
  final PairDecimalConfig decimalConfig;
  OrderBookView(
      {Key key, this.isVerticalOrderbook, this.orderbook, this.decimalConfig});

  @override
  Widget build(BuildContext context) {
    final tradeService = locator<TradeService>();
    return isVerticalOrderbook
        ?

/*----------------------------------------------------------------------
                      Vertical Orderbook
----------------------------------------------------------------------*/

        Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Heading Price
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Text(FlutterI18n.translate(context, "price"),
                          style: Theme.of(context).textTheme.headline6)),
                  // Heading Quantity
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Text(FlutterI18n.translate(context, "quantity"),
                          style: Theme.of(context).textTheme.headline6))
                ],
              ),
              buildVerticalOrderbookColumn(
                  orderbook.sellOrders, false, decimalConfig, tradeService),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      orderbook.buyOrders != [] && orderbook.sellOrders != []
                          ? Text('${orderbook.price.toString()}',
                              style: Theme.of(context).textTheme.headline4)
                          : Center(
                              child: Text('No Orders',
                                  style: Theme.of(context).textTheme.bodyText2),
                            )
                    ],
                  )),
              buildVerticalOrderbookColumn(
                  orderbook.buyOrders, true, decimalConfig, tradeService)
            ],
          )
        : Container(
            color: secondaryColor.withAlpha(250),
            padding: EdgeInsets.all(5.0),
            child: ListView(
              //   mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Heading Buy Sell Orders Row
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(FlutterI18n.translate(context, "buyOrders"),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      Container(
                        child: Text(
                            FlutterI18n.translate(context, "sellOrders"),
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
                            Text(FlutterI18n.translate(context, "quantity"),
                                style: TextStyle(fontSize: 9, color: grey)),
                            Text(FlutterI18n.translate(context, "price"),
                                style: TextStyle(fontSize: 9, color: grey)),
                            Text(FlutterI18n.translate(context, "quantity"),
                                style: TextStyle(fontSize: 9, color: grey)),
                          ],
                        ),
                      ),
                    )
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
                        itemCount: orderbook.buyOrders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return OrderDetailsView(
                            decimalConfig: decimalConfig,
                            orders: orderbook.buyOrders,
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
                        itemCount: orderbook.sellOrders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return OrderDetailsView(
                            decimalConfig: decimalConfig,
                            orders: orderbook.sellOrders,
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
          );
  }

  /*----------------------------------------------------------------------
                      Order Detail
----------------------------------------------------------------------*/

  Column buildVerticalOrderbookColumn(List<OrderType> orderArray,
      final bool bidOrAsk, deciamlConfig, TradeService tradeService) {
    // List<OrderType> sellOrders = [];
    print('OrderArray $bidOrAsk length before ${orderArray.length}');
    if (orderArray.length > 7) orderArray = orderArray.sublist(0, 7);
    if (!bidOrAsk) orderArray = orderArray.reversed.toList();

    print('OrderArray $bidOrAsk length after ${orderArray.length}');
    return Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        for (var order in orderArray)
          InkWell(
            onTap: () {
              print(
                  'trying filling values ${order.price} --  ${order.quantity}');
              tradeService.setPriceQuantityValues(order.price, order.quantity);
              // model.fillTextFields(order.price, order.quantity);
              // model.setBusy(true);
              // model.quantityTextController.text =
              //     order.quantity.toStringAsFixed(model.quantityDecimal);
              // model.quantity = order.quantity;
              // model.priceTextController.text =
              //     order.price.toStringAsFixed(model.priceDecimal);
              // model.price = order.price;
              // model.transactionAmount = model.quantity * model.price;
              // model.updateTransFee();
              // model.setBusy(false);
            },
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        order.price.toStringAsFixed(decimalConfig.priceDecimal),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(bidOrAsk ? 0xFF0da88b : 0xFFe2103c),
                            fontSize: 13.0)),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        color: Color(bidOrAsk ? 0xFF264559 : 0xFF502649),
                        child: Text(
                            order.quantity
                                .toStringAsFixed(decimalConfig.qtyDecimal),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 13.0)))
                  ],
                )),
          )
      ],
    );
  }
}

class OrderDetailsView extends StatelessWidget {
  final int index;
  final bool isBuy;
  final PairDecimalConfig decimalConfig;
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
        // margin: EdgeInsets.only(bottom: 2.0),
        padding: EdgeInsets.all(3.0),
        color: isBuy ? buyOrders : sellOrders,
        child: isBuy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  orderRow(
                      NumberUtil()
                          .truncateDoubleWithoutRouding(
                            orders[index].quantity,
                            precision: decimalConfig.qtyDecimal,
                          )
                          .toString(),
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
                      NumberUtil()
                          .truncateDoubleWithoutRouding(
                            orders[index].quantity,
                            precision: decimalConfig.qtyDecimal,
                          )
                          .toString(),
                      TextAlign.end,
                      grey),
                ],
              ));
  }

  Widget orderRow(String textValue, TextAlign textAlign, Color colorValue) {
    return Expanded(
        child: Text(textValue,
            textAlign: textAlign,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12, color: colorValue)));
  }
}
