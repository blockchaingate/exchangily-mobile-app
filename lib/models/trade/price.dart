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

class Price {
  String _symbol;
  double _price;
  double _high;
  double _low;
  double _open;
  double _close;
  double _volume;
  double _change;
  double _changeValue;

  Price(
      {String symbol,
      double price,
      double high,
      double low,
      double open,
      double close,
      double volume,
      double change,
      double changeValue}) {
    this._symbol = symbol;
    this._price = price ?? 0.0;
    this._high = high ?? 0.0;
    this._low = low ?? 0.0;
    this._open = open ?? 0.0;
    this._close = close ?? 0.0;
    this._volume = volume ?? 0.0;
    this._change =
        //change ?? 0.0;
        (close - open) / open * 100 ?? 0.0;
    this._changeValue = changeValue ?? 0.0;
  }

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
        symbol: json['symbol'].toString(),
        price: bigNum2Double(json['price']),
        high: bigNum2Double(json['24h_high']),
        low: bigNum2Double(json['24h_low']),
        open: bigNum2Double(json['24h_open']),
        close: bigNum2Double(json['24h_close']),
        volume: bigNum2Double(json['24h_volume']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbol'] = this._symbol;
    data['price'] = this._price;
    data['24h_high'] = this._high;
    data['24h_low'] = this._low;
    data['24h_open'] = this._open;
    data['24h_close'] = this._close;
    data['24h_volume'] = this._volume;
    return data;
  }

  String get symbol => _symbol;
  set symbol(String symbol) {
    this._symbol = symbol;
  }

  double get price => _price;
  set price(double price) {
    this._price = price;
  }

  double get high => _high;
  set high(double high) {
    this._high = high;
  }

  double get low => _low;
  set low(double low) {
    this._low = low;
  }

  double get open => _open;
  set open(double open) {
    this._open = open;
  }

  double get close => _close;
  set close(double close) {
    this._close = close;
  }

  double get volume => _volume;
  set volume(double volume) {
    this._volume = volume;
  }

  double get changeValue => _changeValue;
  set changeValue(double changeValue) {
    this._changeValue = changeValue;
  }

  double get change => _change;
  set change(double change) {
    this._change = change;
  }
}

class PriceList {
  final List<Price> prices;
  PriceList({this.prices});
  factory PriceList.fromJson(List<dynamic> parsedJson) {
    List<Price> prices = new List<Price>();
    parsedJson.forEach((i) {
      // print('0000 ${i}');
      Price price = Price.fromJson(i);
      //  print('1111 ${price.toJson()}');
      prices.add(price);
    });

    return new PriceList(prices: prices);
  }
}
