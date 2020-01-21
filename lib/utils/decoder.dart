import 'dart:convert';
import 'package:exchangilymobileapp/models/order-model.dart';
import 'package:exchangilymobileapp/models/trade-model.dart';

import '../models/price.dart';
import '../models/orders.dart';
import '../utils/string_util.dart';
class Decoder {
  //Given a Map (property names are keys, property values are the values), decode as a Student
  static Price fromJsonMap(Map<String, dynamic> json) {
    String symbol = json['symbol'];
    double price = double.parse(json['price'].toString());
    double high = double.parse(json['24h_high'].toString());
    double low = double.parse(json['24h_low'].toString());
    double open = double.parse(json['24h_open'].toString());
    double close = double.parse(json['24h_close'].toString());
    double volume = double.parse(json['24h_volume'].toString());

    double change = (close - open) / open * 100;
    double changeValue = 0.0;
    Price s = new Price(symbol, price, high, low, open, close, volume, change, changeValue);
    return s;
  }

  static TradeModel fromTradeJsonMap(Map<String, dynamic> json) {
    String orderHash1 = json['orderHash1'];
    String orderHash2 = json['orderHash2'];
    double price = bigNum2Double(json['price'].toString());
    double amount = bigNum2Double(json['amount'].toString());
    int blockNumber = json['blockNumber'];
    int time = json['time'];
    bool bidOrAsk = json['bidOrAsk'];
    TradeModel s = new TradeModel(orderHash1, orderHash2, price, amount, blockNumber, time, bidOrAsk);
    return s;
  }

  static OrderModel fromOrderJsonMap(Map<String, dynamic> json) {
    bool payWithExg = json['payWithExg'];
    String orderHash = json['orderHash'];
    String address = json['address'];
    int pairLeft = json['pairLeft'];
    int pairRight = json['pairRight'];
    int orderType = json['orderType'];
    bool bidOrAsk = json['bidOrAsk'];
    double price = bigNum2Double(json['price']);
    double orderQuantity = bigNum2Double(json['orderQuantity']);
    double filledQuantity = bigNum2Double(json['filledQuantity']);
    int time = json['time'];
    bool isActive = json['isActive'];
    OrderModel s = new OrderModel(payWithExg, orderHash, address, pairLeft, pairRight, orderType, bidOrAsk, price, orderQuantity, filledQuantity, time, isActive);
    return s;
  }

  static List<TradeModel> fromTradesJsonArray(String jsonString) {
    // Map<String, dynamic> decodedMap = jsonDecode(jsonString);
    List<dynamic> dynamicList = jsonDecode(jsonString);
    List<TradeModel> trades = new List<TradeModel>();
    dynamicList.forEach((f) {
      TradeModel s = fromTradeJsonMap(f);
      trades.add(s);
    });

    return trades;
  }

  //Given a JSON string representing an array of Students, decode as a List of Student
  static List<Price> fromJsonArray(String jsonString) {
    // Map<String, dynamic> decodedMap = jsonDecode(jsonString);
    List<dynamic> dynamicList = jsonDecode(jsonString);
    List<Price> students = new List<Price>();
    dynamicList.forEach((f) {
      Price s = fromJsonMap(f);
      students.add(s);
    });

    return students;
  }

  static Orders fromOrdersJsonArray (String jsonString) {
    var dynamicList = jsonDecode(jsonString);
    List<OrderModel> buy = new List<OrderModel>();
    List<OrderModel> sell = new List<OrderModel>();

    dynamicList['buy'].forEach((f) {
      OrderModel s = fromOrderJsonMap(f);
      buy.add(s);
    });

    for(var i = dynamicList['sell'].length - 1; i >= 0; i-- ) {
      var f = dynamicList['sell'][i];
      OrderModel s = fromOrderJsonMap(f);
      sell.add(s);
    }

    Orders orders = new Orders();
    orders.buy = buy;
    orders.sell = sell;
    return orders;
  }
}