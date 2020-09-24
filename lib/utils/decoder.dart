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

class Decoder {
  //Given a Map (property names are keys, property values are the values), decode as a Student
  // static Price fromJsonMap(Map<String, dynamic> json) {
  //   String symbol = json['symbol'];
  //   double price = double.parse(json['price'].toString());
  //   double high = double.parse(json['24h_high'].toString());
  //   double low = double.parse(json['24h_low'].toString());
  //   double open = double.parse(json['24h_open'].toString());
  //   double close = double.parse(json['24h_close'].toString());
  //   double volume = double.parse(json['24h_volume'].toString());

  //   double change = (close - open) / open * 100;
  //   double changeValue = 0.0;
  //   Price s = new Price(
  //       symbol: symbol,
  //       price: price,
  //       high: high,
  //       low: low,
  //       open: open,
  //       close: close,
  //       volume: volume,
  //       change: change,
  //       changeValue: changeValue);
  //   return s;
  // }

  // static Trade fromTradeJsonMap(Map<String, dynamic> json) {
  //   String orderHash1 = json['orderHash1'];
  //   String orderHash2 = json['orderHash2'];
  //   double price = bigNum2Double(json['price'].toString());
  //   double amount = bigNum2Double(json['amount'].toString());
  //   int blockNumber = json['blockNumber'];
  //   int time = json['time'];
  //   bool bidOrAsk = json['bidOrAsk'];
  //   Trade s = new Trade(
  //       orderHash1: orderHash1,
  //       orderHash2: orderHash2,
  //       price: price,
  //       amount: amount,
  //       blockNumber: blockNumber,
  //       time: time,
  //       bidOrAsk: bidOrAsk);
  //   return s;
  // }

  // static Order fromOrderJsonMap(Map<String, dynamic> json) {
  //   bool payWithExg = json['payWithExg'];
  //   String orderHash = json['orderHash'];
  //   String address = json['address'];
  //   int pairLeft = json['pairLeft'];
  //   int pairRight = json['pairRight'];
  //   int orderType = json['orderType'];
  //   bool bidOrAsk = json['bidOrAsk'];
  //   double price = bigNum2Double(json['price']);
  //   double orderQuantity = bigNum2Double(json['orderQuantity']);
  //   double filledQuantity = bigNum2Double(json['filledQuantity']);
  //   int time = json['time'];
  //   bool isActive = json['isActive'];
  //   Order s = new Order(
  //       payWithExg: payWithExg,
  //       orderHash: orderHash,
  //       address: address,
  //       pairLeft: pairLeft,
  //       pairRight: pairRight,
  //       orderType: orderType,
  //       bidOrAsk: bidOrAsk,
  //       price: price,
  //       orderQuantity: orderQuantity,
  //       filledQuantity: filledQuantity,
  //       time: time,
  //       isActive: isActive);
  //   return s;
  // }

  // static List<Trade> fromTradesJsonArray(String jsonString) {
  //   // Map<String, dynamic> decodedMap = jsonDecode(jsonString);
  //   List<dynamic> dynamicList = jsonDecode(jsonString);
  //   List<Trade> trades = new List<Trade>();
  //   dynamicList.forEach((f) {
  //     Trade s = fromTradeJsonMap(f);
  //     trades.add(s);
  //   });

  //   return trades;
  // }

  // //Given a JSON string representing an array of Students, decode as a List of Student
  // static List<Price> fromJsonArray(String jsonString) {
  //   // Map<String, dynamic> decodedMap = jsonDecode(jsonString);
  //   List<dynamic> dynamicList = jsonDecode(jsonString);
  //   List<Price> students = new List<Price>();
  //   dynamicList.forEach((f) {
  //     Price s = fromJsonMap(f);
  //     students.add(s);
  //   });

  //   return students;
  // }

  // static Orders fromOrdersJsonArray(String jsonString) {
  //   var dynamicList = jsonDecode(jsonString);
  //   List<Order> buy = new List<Order>();
  //   List<Order> sell = new List<Order>();

  //   dynamicList['buy'].forEach((f) {
  //     Order s = fromOrderJsonMap(f);
  //     buy.add(s);
  //   });

  //   for (var i = dynamicList['sell'].length - 1; i >= 0; i--) {
  //     var f = dynamicList['sell'][i];
  //     Order s = fromOrderJsonMap(f);
  //     sell.add(s);
  //   }

  //   Orders orders = new Orders();
  //   orders.buy = buy;
  //   orders.sell = sell;
  //   return orders;
  // }
}
