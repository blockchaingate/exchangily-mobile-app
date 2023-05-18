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

class MarketTrades {
  double? _price;
  double? _quantity;
  int? _time;
  bool? _bidOrAsk;

  MarketTrades({double? price, double? quantity, int? time, bool? bidOrAsk}) {
    _price = price;
    _quantity = quantity;
    _time = time;
    _bidOrAsk = bidOrAsk;
  }

  factory MarketTrades.fromJson(Map<String, dynamic> json) {
    return MarketTrades(
      price: json['p'].toDouble(),
      quantity: json['q'].toDouble(),
      time: json['t'],
      bidOrAsk: json['b'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['p'] = _price;
    json['q'] = _quantity;
    json['t'] = _time;
    json['b'] = _bidOrAsk;
    return json;
  }

  double? get price => _price;
  set price(double? price) {
    _price = price;
  }

  double? get quantity => _quantity;
  set quantity(double? quantity) {
    _quantity = quantity;
  }

  int? get time => _time;
  set time(int? time) {
    _time = time;
  }

  bool? get bidOrAsk => _bidOrAsk;
  set bidOrAsk(bool? bidOrAsk) {
    _bidOrAsk = bidOrAsk;
  }
}

class MarketTradeList {
  final List<MarketTrades>? trades;
  MarketTradeList({this.trades});
  factory MarketTradeList.fromJson(List<dynamic> parsedJson) {
    List<MarketTrades> trades = <MarketTrades>[];
    for (var i in parsedJson) {
      MarketTrades trade = MarketTrades.fromJson(i);

      trades.add(trade);
    }
    return MarketTradeList(trades: trades);
  }
}
