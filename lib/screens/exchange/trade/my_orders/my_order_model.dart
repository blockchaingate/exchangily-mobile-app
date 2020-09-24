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

class Order {
  String _orderHash;
  int _orderType;
  bool _bidOrAsk;
  double _price;
  double _orderQuantity;
  double _originalOrderQuantity;
  double _filledQuantity;
  int _time;
  bool _isActive;
  String _pairName;
  double _totalOrderQuantity;
  double _filledPercentage;
  bool _isCancelled;
  Order(
      {String orderHash,
      int orderType,
      bool bidOrAsk,
      double price,
      double orderQuantity,
      double originalOrderQuantity,
      double filledQuantity,
      int time,
      bool isActive,
      String pairName,
      double totalOrderQuantity,
      double filledPercentage,
      bool isCancelled}) {
    this._orderHash = orderHash;

    this._orderType = orderType;
    this._bidOrAsk = bidOrAsk;
    this._price = price ?? 0.0;
    this._orderQuantity = orderQuantity ??
        0.0; // how much is left, if i order 10 and filled 3 then oq is 7
    this._originalOrderQuantity = originalOrderQuantity ?? 0.0;
    this._filledQuantity = filledQuantity ??
        0.0; // how many filled so if order of 10 with 3 filled then 3 is the value
    this._time = time;
    this._isActive = isActive;
    this._pairName = pairName;
    this._totalOrderQuantity = orderQuantity + filledQuantity;
    this._filledPercentage = (filledQuantity * 100) / _totalOrderQuantity;
    this._isCancelled = isCancelled;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        orderHash: json['orderHash'],
        orderType: json['orderType'],
        bidOrAsk: json['bidOrAsk'],
        price: bigNum2Double(json['price']),
        orderQuantity: bigNum2Double(json['orderQuantity']),
        originalOrderQuantity: bigNum2Double(json['originalOrderQuantity']),
        filledQuantity: bigNum2Double(json['filledQuantity']),
        time: json['time'],
        isActive: json['isActive'],
        pairName: json['pairName'],
        isCancelled: json['isCancelled']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderHash'] = this._orderHash;
    data['orderType'] = this._orderType;
    data['bidOrAsk'] = this._bidOrAsk;
    data['price'] = this._price;
    data['orderQuantity'] = this._orderQuantity;
    data['originalOrderQuantity'] = this._originalOrderQuantity;
    data['filledQuantity'] = this._filledQuantity;
    data['time'] = this._time;
    data['isActive'] = this._isActive;
    data['pairName'] = this._pairName;
    data['isCancelled'] = this._isCancelled;
    return data;
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

  int get orderType => _orderType;
  set orderType(int orderType) {
    this._orderType = orderType;
  }

  bool get isActive => _isActive;
  set isActive(bool isActive) {
    this._isActive = isActive;
  }

  bool get bidOrAsk => _bidOrAsk;
  set bidOrAsk(bool bidOrAsk) {
    this._bidOrAsk = bidOrAsk;
  }

  String get pairName => _pairName;
  set pairName(String pairName) {
    this._pairName = pairName;
  }

  double get totalOrderQuantity => _totalOrderQuantity;
  set totalOrderQuantity(double totalOrderQuantity) {
    this._totalOrderQuantity = totalOrderQuantity;
  }

  double get filledPercentage => _filledPercentage;
  set filledPercentage(double filledPercentage) {
    this._filledPercentage = filledPercentage;
  }

  bool get isCancelled => isCancelled;
  set isCancelled(bool isCancelled) {
    this.isCancelled = isCancelled;
  }
}

class OrderList {
  final List<Order> orders;
  OrderList({this.orders});

  factory OrderList.fromJson(List<dynamic> parsedJson) {
    List<Order> orders = new List<Order>();
    parsedJson.forEach((i) {
      // print('raw orders ${i}');
      Order order = Order.fromJson(i);
      //  print('ready for ui orders ${order.toJson()}');
      orders.add(order);
    });
    return new OrderList(orders: orders);
  }
}
