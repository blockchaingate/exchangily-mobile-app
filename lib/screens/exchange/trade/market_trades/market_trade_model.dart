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

import 'package:exchangilymobileapp/utils/string_util.dart';

class MarketTrades {
  double _price;
  double _quantity;
  int _time;
  bool _bidOrAsk;

  MarketTrades({double price, double quantity, int time, bool bidOrAsk}) {
    this._price = price;
    this._quantity = quantity;
    this._time = time;
    this._bidOrAsk = bidOrAsk;
  }

  factory MarketTrades.fromJson(Map<String, dynamic> json) {
    return MarketTrades(
      price: bigNum2Double(json['p'].toString()),
      quantity: bigNum2Double(json['q'].toString()),
      time: json['t'],
      bidOrAsk: json['b'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['p'] = this._price;
    json['q'] = this._quantity;
    json['t'] = this._time;
    json['b'] = this._bidOrAsk;
    return json;
  }

  double get price => _price;
  set price(double price) {
    this._price = price;
  }

  double get quantity => _quantity;
  set quantity(double quantity) {
    this._quantity = quantity;
  }

  int get time => _time;
  set time(int time) {
    this._time = time;
  }

  bool get bidOrAsk => _bidOrAsk;
  set bidOrAsk(bool bidOrAsk) {
    this._bidOrAsk = bidOrAsk;
  }
}

class MarketTradeList {
  final List<MarketTrades> trades;
  MarketTradeList({this.trades});
  factory MarketTradeList.fromJson(List<dynamic> parsedJson) {
    List<MarketTrades> trades = new List<MarketTrades>();
    parsedJson.forEach((i) {
      MarketTrades trade = MarketTrades.fromJson(i);

      trades.add(trade);
    });
    return new MarketTradeList(trades: trades);
  }
}
