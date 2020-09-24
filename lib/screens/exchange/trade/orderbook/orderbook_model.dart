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

/*---------------------------------------
                Json Structure
---------------------------------------*/

var jsonStructure = [
  {
    "payWithExg": false,
    "orderHash":
        "0xb63c75356a21caaf4c416b00455b4cbce5444fb83481911158393c80aec30dfc",
    "address": "0xdcd0f23125f74ef621dfa3310625f8af0dcd971b",
    "pairLeft": 3,
    "pairRight": 1,
    "orderType": 1,
    "bidOrAsk": true,
    "price": "139000000000000000000",
    "orderQuantity": "98351302944053745",
    "filledQuantity": "1648697055946255",
    "time": 1588987183,
    "isActive": true,
    "txHash": {
      "createOrder":
          "0xae0870d115ab40b8ccf6b9780d60ab7edddc8ba60473f7ed92cd16c0364d882a"
    },
    "blockNumber": {
      "createOrder": 1974689,
      "fulfillOrder": [1974689, 1974689, 1974689, 1974689, 1974689]
    },
    "price_n": {"numberDecimal": "139000000000000000000"},
    "orderQuantity_n": {"numberDecimal": "100000000000000000"},
    "filledQuantity_n": {"numberDecimal": "1648697055946255"}
  }
];

// Ordertype to map an array of buy/sell from orderbook data

class OrderType {
  double price;
  double quantity;

  OrderType({this.price, this.quantity});

  factory OrderType.fromJson(Map<String, dynamic> json) {
    return OrderType(price: json['p'], quantity: json['q']);
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
    this._buyOrders = buyOrders;
    this._sellOrders = sellOrders;
    this._price = price ?? 0.0;
    this._quantity = orderQuantity ?? 0.0;
  }

  factory Orderbook.fromJson(Map<String, dynamic> json) {
    List buyOrdersFromJson = json['b'] as List;
    List<OrderType> buyOrderTypeList =
        buyOrdersFromJson.map((order) => OrderType.fromJson(order));

    List sellOrdersFromJson = json['s'] as List;
    List<OrderType> sellOrderTypeList =
        sellOrdersFromJson.map((order) => OrderType.fromJson(order));

    return Orderbook(
      buyOrders: buyOrderTypeList,
      sellOrders: sellOrderTypeList,
      price: bigNum2Double(json['p']),
      orderQuantity: bigNum2Double(json['orderQuantity']),
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

  double get orderQuantity => _quantity;
  set orderQuantity(double orderQuantity) {
    this._quantity = orderQuantity;
  }
}

// class OrderbookList {
//   final List<Orderbook> orderBookList;
//   OrderbookList({this.orderBookList});

//   factory OrderbookList.fromJson(List<dynamic> parsedJson) {
//     List<Orderbook> orderBookList = new List<Orderbook>();
//     parsedJson.forEach((i) {
//       // print('raw orders ${i}');
//       Orderbook order = Orderbook.fromJson(i);
//       //  print('ready for ui orders ${order.toJson()}');
//       orderBookList.add(order);
//     });
//     return new OrderbookList(orderBookList: orderBookList);
//   }
// }
