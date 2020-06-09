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

/// PENDING - Change the name to Order from OrderModel once new architecture fully working
class OrderModel {
  bool _payWithExg;
  String _orderHash;
  String _address;
  int _pairLeft;
  int _pairRight;
  int _orderType;
  bool _bidOrAsk;
  double _price;
  double _orderQuantity;
  double _filledQuantity;
  int _time;
  bool _isActive;
  OrderModel(
      {bool payWithExg,
      String orderHash,
      String address,
      int pairLeft,
      int pairRight,
      int orderType,
      bool bidOrAsk,
      double price,
      double orderQuantity,
      double filledQuantity,
      int time,
      bool isActive}) {
    this._payWithExg = payWithExg;
    this._orderHash = orderHash;
    this._address = address;
    this._pairLeft = pairLeft;
    this._pairRight = pairRight;
    this._orderType = orderType;
    this._bidOrAsk = bidOrAsk;
    this._price = price ?? 0.0;
    this._orderQuantity = orderQuantity ?? 0.0;
    this._filledQuantity = filledQuantity ?? 0.0;
    this._time = time;
    this._isActive = isActive;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        payWithExg: json['payWithExg'],
        orderHash: json['orderHash'],
        address: json['address'],
        pairLeft: json['pairLeft'],
        pairRight: json['pairRight'],
        orderType: json['orderType'],
        bidOrAsk: json['bidOrAsk'],
        price: bigNum2Double(json['price']),
        orderQuantity: bigNum2Double(json['orderQuantity']),
        filledQuantity: bigNum2Double(json['filledQuantity']),
        time: json['time'],
        isActive: json['isActive']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payWithExg'] = this._payWithExg;
    data['orderHash'] = this._orderHash;
    data['address'] = this._address;
    data['pairLeft'] = this._pairLeft;
    data['pairRight'] = this._pairRight;
    data['orderType'] = this._orderType;
    data['bidOrAsk'] = this._bidOrAsk;
    data['price'] = this._price;
    data['orderQuantity'] = this._orderQuantity;
    data['filledQuantity'] = this._filledQuantity;
    data['time'] = this._time;
    data['isActive'] = this._isActive;
    return data;
  }

  String get address => _address;
  set address(String address) {
    this._address = address;
  }

  String get orderHash => _orderHash;
  set orderHash(String orderHash) {
    this._orderHash = orderHash;
  }

  double get price => _price;
  set price(double price) {
    this._price = price;
  }

  double get filledQuantity => _filledQuantity;
  set filledQuantity(double filledQuantity) {
    this._filledQuantity = filledQuantity;
  }

  double get orderQuantity => _orderQuantity;
  set orderQuantity(double orderQuantity) {
    this._orderQuantity = orderQuantity;
  }

  int get time => _time;
  set time(int time) {
    this._time = time;
  }

  int get pairRight => _pairRight;
  set pairRight(int pairRight) {
    this._pairRight = pairRight;
  }

  int get pairLeft => _pairLeft;
  set pairLeft(int pairLeft) {
    this._pairLeft = pairLeft;
  }

  int get orderType => _orderType;
  set orderType(int orderType) {
    this._orderType = orderType;
  }

  bool get isActive => _isActive;
  set isActive(bool isActive) {
    this._isActive = isActive;
  }

  bool get payWithExg => _payWithExg;
  set payWithExg(bool payWithExg) {
    this.payWithExg = payWithExg;
  }

  bool get bidOrAsk => _bidOrAsk;
  set bidOrAsk(bool bidOrAsk) {
    this._bidOrAsk = bidOrAsk;
  }
}

class OrderList {
  final List<OrderModel> orders;
  OrderList({this.orders});

  factory OrderList.fromJson(List<dynamic> parsedJson) {
    List<OrderModel> orders = new List<OrderModel>();
    parsedJson.forEach((i) {
      // print('raw orders ${i}');
      OrderModel order = OrderModel.fromJson(i);
      //  print('ready for ui orders ${order.toJson()}');
      orders.add(order);
    });
    return new OrderList(orders: orders);
  }
}
