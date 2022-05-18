/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

// Ordertype to map an array of buy/sell from orderbook data

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

class OrderType {
  Decimal price;
  Decimal quantity;

  OrderType({this.price, this.quantity}) {
    price = price ?? Constants.decimalZero;
    quantity = quantity ?? Constants.decimalZero;
  }

  factory OrderType.fromJson(Map<String, dynamic> json) {
    var res = OrderType(
        price: NumberUtil.parseStringToDecimal(json['p'].toString()),
        quantity: NumberUtil.parseStringToDecimal(json['q'].toString()));
    return res;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p'] = price;
    data['q'] = quantity;
    return data;
  }
}

// Map orderbook

class Orderbook extends OrderType {
  List<OrderType> buyOrders;
  List<OrderType> sellOrders;

  Orderbook({this.buyOrders, this.sellOrders, price, quantity})
      : super(
            price: price ?? Constants.decimalZero,
            quantity: quantity ?? Constants.decimalZero) {
    buyOrders = buyOrders ?? [];
    sellOrders = sellOrders ?? [];
  }

  factory Orderbook.fromJson(Map<String, dynamic> json) {
    List buyOrdersFromJson = json['b'] as List;
    List<OrderType> buyOrders =
        buyOrdersFromJson.map((order) => OrderType.fromJson(order)).toList();

    List sellOrdersFromJson = json['s'] as List;
    List<OrderType> sellOrders =
        sellOrdersFromJson.map((order) => OrderType.fromJson(order)).toList();

    return Orderbook(
      price: NumberUtil.parseStringToDecimal(json['p'].toString()),
      quantity: NumberUtil.parseStringToDecimal(json['q'].toString()),
      buyOrders: buyOrders,
      sellOrders: sellOrders,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['b'] = buyOrders;
    data['s'] = sellOrders;
    data['p'] = price;
    data['q'] = quantity;
    return data;
  }
}
