/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';

class OrderModel {
  String? _orderHash;
  int? _orderType;
  bool? _bidOrAsk;
  double? _price;
  double? _orderQuantity;
  double? _originalOrderQuantity;
  double? _filledQuantity;
  int? _time;
  bool? _isActive;
  String? _pairName;
  double? _totalOrderQuantity;
  double? _filledPercentage;
  bool? _isCancelled;
  OrderModel(
      {String? orderHash,
      int? orderType,
      bool? bidOrAsk,
      double? price,
      required double orderQuantity,
      double? originalOrderQuantity,
      required double filledQuantity,
      int? time,
      bool? isActive,
      String? pairName,
      double? totalOrderQuantity,
      double? filledPercentage,
      bool? isCancelled}) {
    _orderHash = orderHash;

    _orderType = orderType;
    _bidOrAsk = bidOrAsk;
    _price = price ?? 0.0;
    _orderQuantity =
        orderQuantity; // how much is left, if i order 10 and filled 3 then oq is 7
    _originalOrderQuantity = originalOrderQuantity ?? 0.0;
    _filledQuantity =
        filledQuantity; // how many filled so if order of 10 with 3 filled then 3 is the value
    _time = time;
    _isActive = isActive;
    _pairName = pairName;
    _totalOrderQuantity = orderQuantity + filledQuantity;
    _filledPercentage = (filledQuantity * 100) / _totalOrderQuantity!;
    _isCancelled = isCancelled;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        orderHash: json['orderHash'],
        orderType: json['orderType'],
        bidOrAsk: json['bidOrAsk'],
        price:
            NumberUtil.rawStringToDecimal(json['price'].toString()).toDouble(),
        orderQuantity:
            NumberUtil.rawStringToDecimal(json['orderQuantity'].toString())
                .toDouble(),
        originalOrderQuantity: NumberUtil.rawStringToDecimal(
                json['originalOrderQuantity'].toString())
            .toDouble(),
        filledQuantity:
            NumberUtil.rawStringToDecimal(json['filledQuantity'].toString())
                .toDouble(),
        time: json['time'],
        isActive: json['isActive'],
        pairName: json['pairName'],
        isCancelled: json['isCancelled']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderHash'] = _orderHash;
    data['orderType'] = _orderType;
    data['bidOrAsk'] = _bidOrAsk;
    data['price'] = _price;
    data['orderQuantity'] = _orderQuantity;
    data['originalOrderQuantity'] = _originalOrderQuantity;
    data['filledQuantity'] = _filledQuantity;
    data['time'] = _time;
    data['isActive'] = _isActive;
    data['pairName'] = _pairName;
    data['isCancelled'] = _isCancelled;
    return data;
  }

  String? get orderHash => _orderHash;
  set orderHash(String? orderHash) {
    _orderHash = orderHash;
  }

  double? get price => _price;
  set price(double? price) {
    _price = price;
  }

  double? get filledQuantity => _filledQuantity;
  set filledQuantity(double? filledQuantity) {
    _filledQuantity = filledQuantity;
  }

  double? get orderQuantity => _orderQuantity;
  set orderQuantity(double? orderQuantity) {
    _orderQuantity = orderQuantity;
  }

  int? get time => _time;
  set time(int? time) {
    _time = time;
  }

  int? get orderType => _orderType;
  set orderType(int? orderType) {
    _orderType = orderType;
  }

  bool? get isActive => _isActive;
  set isActive(bool? isActive) {
    _isActive = isActive;
  }

  bool? get bidOrAsk => _bidOrAsk;
  set bidOrAsk(bool? bidOrAsk) {
    _bidOrAsk = bidOrAsk;
  }

  String? get pairName => _pairName;
  set pairName(String? pairName) {
    _pairName = pairName;
  }

  double? get totalOrderQuantity => _totalOrderQuantity;
  set totalOrderQuantity(double? totalOrderQuantity) {
    _totalOrderQuantity = totalOrderQuantity;
  }

  double? get filledPercentage => _filledPercentage;
  set filledPercentage(double? filledPercentage) {
    _filledPercentage = filledPercentage;
  }

  bool? get isCancelled => _isCancelled;
  set isCancelled(bool? isCancelled) {
    _isCancelled = isCancelled;
  }
}

class OrderList {
  final List<OrderModel>? orders;
  OrderList({this.orders});

  factory OrderList.fromJson(List<dynamic> parsedJson) {
    List<OrderModel> orders = <OrderModel>[];
    for (var i in parsedJson) {
      // debugPrint('raw orders ${i}');
      OrderModel order = OrderModel.fromJson(i);
      //  debugPrint('ready for ui orders ${order.toJson()}');
      orders.add(order);
    }
    return OrderList(orders: orders);
  }
}
