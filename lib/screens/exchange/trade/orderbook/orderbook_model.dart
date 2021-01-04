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

import 'package:exchangilymobileapp/utils/string_util.dart';

// Ordertype to map an array of buy/sell from orderbook data

class OrderType {
  double _price;
  double _quantity;

  OrderType({double price, double quantity}) {
    this._price = price ?? 0.0;
    this._quantity = quantity ?? 0.0;
  }

  factory OrderType.fromJson(Map<String, dynamic> json) {
    return OrderType(
        price: json['p'].toDouble(), quantity: json['q'].toDouble());
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p'] = this._price;
    data['q'] = this._quantity;
    return data;
  }

  double get price => _price;
  set price(double price) {
    this._price = price;
  }

  double get quantity => _quantity;
  set quantity(double quantity) {
    this._quantity = quantity;
  }
}

// Map orderbook

class Orderbook {
  List<OrderType> _buyOrders;
  List<OrderType> _sellOrders;
  double _price;
  double _quantity;

  Orderbook({
    List<OrderType> buyOrders,
    List<OrderType> sellOrders,
    double price,
    double orderQuantity,
  }) {
    this._buyOrders = buyOrders ?? [];
    this._sellOrders = sellOrders ?? [];
    this._price = price ?? 0.0;
    this._quantity = orderQuantity ?? 0.0;
  }

  factory Orderbook.fromJson(Map<String, dynamic> json) {
    var price = json['p'] ?? 0.0;
    var qty = json['q'] ?? 0.0;
    List buyOrdersFromJson = json['b'] as List;
    List<OrderType> buyOrders =
        buyOrdersFromJson.map((order) => OrderType.fromJson(order)).toList();

    List sellOrdersFromJson = json['s'] as List;
    List<OrderType> sellOrders =
        sellOrdersFromJson.map((order) => OrderType.fromJson(order)).toList();

    return Orderbook(
      buyOrders: buyOrders,
      sellOrders: sellOrders,
      price: price.toDouble(),
      orderQuantity: qty.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['b'] = this._buyOrders;
    data['s'] = this._sellOrders;
    data['p'] = this._price;
    data['q'] = this._quantity;
    return data;
  }

  List<OrderType> get buyOrders => _buyOrders;
  set buyOrders(List<OrderType> buyOrders) {
    this._buyOrders = buyOrders;
  }

  List<OrderType> get sellOrders => _sellOrders;
  set sellOrders(List<OrderType> sellOrders) {
    this._sellOrders = sellOrders;
  }

  double get price => _price;
  set price(double price) {
    this._price = price;
  }

  double get quantity => _quantity;
  set quantity(double quantity) {
    this._quantity = quantity;
  }
}
