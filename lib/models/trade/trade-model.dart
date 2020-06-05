/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com, barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/utils/string_util.dart';

class TradeModel {
  String _orderHash1;
  String _orderHash2;
  double _price;
  double _amount;
  int _blockNumber;
  int _time;
  bool _bidOrAsk;

  TradeModel(
      {String orderHash1,
      String orderHash2,
      double price,
      double amount,
      int blockNumber,
      int time,
      bool bidOrAsk}) {
    this._orderHash1 = orderHash1;
    this._orderHash2 = orderHash2;
    this._price = price;
    this._amount = amount;
    this._blockNumber = blockNumber;
    this._time = time;
    this._bidOrAsk = bidOrAsk;
  }

  factory TradeModel.fromJson(Map<String, dynamic> json) {
    return TradeModel(
      orderHash1: json['orderHash1'],
      orderHash2: json['orderHash2'],
      price: bigNum2Double(json['price'].toString()),
      amount: bigNum2Double(json['amount'].toString()),
      blockNumber: json['blockNumber'],
      time: json['time'],
      bidOrAsk: json['bidOrAsk'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['orderHash1'] = this._orderHash1;
    json['orderHash2'] = this._orderHash2;
    json['price'] = this._price;
    json['amount'] = this._amount;
    json['blockNumber'] = this._blockNumber;
    json['time'] = this._time;
    json['bidOrAsk'] = this._bidOrAsk;
    return json;
  }

  String get orderHash1 => orderHash1;
  set orderHash1(String orderHash1) {
    this.orderHash1 = orderHash1;
  }

  String get orderHash2 => orderHash2;
  set orderHash2(String orderHash2) {
    this.orderHash2 = orderHash2;
  }

  double get price => _price;
  set price(double price) {
    this._price = price;
  }

  double get amount => _amount;
  set amount(double amount) {
    this._amount = amount;
  }

  int get time => _time;
  set time(int time) {
    this._time = time;
  }

  int get blockNumber => _blockNumber;
  set blockNumber(int blockNumber) {
    this._blockNumber = blockNumber;
  }

  bool get bidOrAsk => bidOrAsk;
  set bidOrAsk(bool bidOrAsk) {
    this._bidOrAsk = bidOrAsk;
  }
}

class TradeList {
  final List<TradeModel> trades;
  TradeList({this.trades});
  factory TradeList.fromJson(List<dynamic> parsedJson) {
    // print(parsedJson);
    List<TradeModel> trades = new List<TradeModel>();
    parsedJson.forEach((i) {
      TradeModel trade = TradeModel.fromJson(i);

      trades.add(trade);
    });
    return new TradeList(trades: trades);
  }
}
