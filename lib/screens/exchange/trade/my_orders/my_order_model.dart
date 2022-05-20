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

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

class OrderModel {
  String orderHash;
  int orderType;
  bool bidOrAsk;
  Decimal price;
  Decimal orderQuantity;
  Decimal originalOrderQuantity;
  Decimal filledQuantity;
  int time;
  bool isActive;
  String pairName;

  bool isCancelled;

  OrderModel(
      {this.orderHash = '',
      this.orderType,
      this.bidOrAsk,
      this.price,
      this.orderQuantity,
      this.filledQuantity,
      this.originalOrderQuantity,
      this.time,
      this.isActive,
      this.pairName,
      this.isCancelled});
  // : price = Constants.decimalZero,
  //   orderQuantity = Constants.decimalZero,
  //   filledQuantity = Constants.decimalZero {
  // _orderHash = orderHash;

  // _orderType = orderType;
  // _bidOrAsk = bidOrAsk;
  // _price = price ?? 0.0;
  // _orderQuantity = orderQuantity ??
  //     0.0; // how much is left, if i order 10 and filled 3 then oq is 7
  // _originalOrderQuantity = originalOrderQuantity ?? 0.0;
  // _filledQuantity = filledQuantity ??
  //     0.0; // how many filled so if order of 10 with 3 filled then 3 is the value
  // _time = time;
  // _isActive = isActive;
  // _pairName = pairName;
  // _totalOrderQuantity = orderQuantity + filledQuantity;
  // _filledPercentage = (filledQuantity * 100) / _totalOrderQuantity;
  // _isCancelled = isCancelled;
  //}
  Decimal totalOrderQuantity() {
    return orderQuantity + filledQuantity;
  }

  Decimal filledPercentage() {
    var toq = totalOrderQuantity();
    var res = filledQuantity * Decimal.fromInt(100) / toq;
    return res.toDecimal(scaleOnInfinitePrecision: 6);
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        orderHash: json['orderHash'],
        orderType: json['orderType'],
        bidOrAsk: json['bidOrAsk'],
        pairName: json['pairName'],
        price: NumberUtil.rawStringToDecimal(json['price']),
        orderQuantity: NumberUtil.rawStringToDecimal(json['orderQuantity']),
        originalOrderQuantity:
            NumberUtil.rawStringToDecimal(json['originalOrderQuantity']),
        filledQuantity: NumberUtil.rawStringToDecimal(json['filledQuantity']),
        time: json['time'],
        isActive: json['isActive'],
        isCancelled: json['isCancelled']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderHash'] = orderHash;
    data['orderType'] = orderType;
    data['bidOrAsk'] = bidOrAsk;
    data['price'] = price;
    data['orderQuantity'] = orderQuantity;
    data['originalOrderQuantity'] = originalOrderQuantity;
    data['filledQuantity'] = filledQuantity;
    data['time'] = time;
    data['isActive'] = isActive;
    data['pairName'] = pairName;
    data['isCancelled'] = isCancelled;
    return data;
  }
}

class OrderList {
  final List<OrderModel> orders;
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
