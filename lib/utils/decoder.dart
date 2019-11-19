import 'dart:convert';
import '../models/price.dart';

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
    Price s = new Price(symbol, price, high, low, open, close, volume, change);
    return s;
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
}