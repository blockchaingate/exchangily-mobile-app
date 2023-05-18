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

class OrderType {
  double? _price;
  double? _quantity;

  OrderType({double? price, double? quantity}) {
    _price = price ?? 0.0;
    _quantity = quantity ?? 0.0;
  }

  factory OrderType.fromJson(Map<String, dynamic> json) {
    return OrderType(
        price: json['p'].toDouble(), quantity: json['q'].toDouble());
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p'] = _price;
    data['q'] = _quantity;
    return data;
  }

  double? get price => _price;
  set price(double? price) {
    _price = price;
  }

  double? get quantity => _quantity;
  set quantity(double? quantity) {
    _quantity = quantity;
  }
}

// Map orderbook

class Orderbook {
  List<OrderType>? _buyOrders;
  List<OrderType>? _sellOrders;
  double? _price;
  double? _quantity;

  Orderbook({
    List<OrderType>? buyOrders,
    List<OrderType>? sellOrders,
    double? price,
    double? orderQuantity,
  }) {
    _buyOrders = buyOrders ?? [];
    _sellOrders = sellOrders ?? [];
    _price = price ?? 0.0;
    _quantity = orderQuantity ?? 0.0;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['b'] = _buyOrders;
    data['s'] = _sellOrders;
    data['p'] = _price;
    data['q'] = _quantity;
    return data;
  }

  List<OrderType>? get buyOrders => _buyOrders;
  set buyOrders(List<OrderType>? buyOrders) {
    _buyOrders = buyOrders;
  }

  List<OrderType>? get sellOrders => _sellOrders;
  set sellOrders(List<OrderType>? sellOrders) {
    _sellOrders = sellOrders;
  }

  double? get price => _price;
  set price(double? price) {
    _price = price;
  }

  double? get quantity => _quantity;
  set quantity(double? quantity) {
    _quantity = quantity;
  }
}
