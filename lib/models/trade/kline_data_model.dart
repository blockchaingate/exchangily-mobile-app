/*
 * @Description:
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 14:55:49
 * @LastEditTime: 2019-04-18 12:41:55
 */

// kline_package:lib/
// import 'package:json_annotation/json_annotation.dart';

//@JsonSerializable()
class MarketModel {
  MarketModel(this.open, this.high, this.low, this.close, this.vol, this.id);
  double open;
  double high;
  double low;
  double close;
  double vol;
  int id;

  //不同的类使用不同的mixin即可
  factory MarketModel.fromJson(json) =>
      _marketModelFromJson(json);
  Map<String, dynamic> toJson() => _marketModelToJson(this);
}

//@JsonSerializable()
class MarketData {
  MarketData(this.data);
  //@JsonKey(name: 'data')
  List<MarketModel> data;
  factory MarketData.fromJson(json) =>
      _marketDataFromJson(json);
  Map<String, dynamic> toJson() => _marketDataToJson(this);
}

MarketModel _marketModelFromJson(json) {
  return MarketModel(
      json['open'],
      json['high'],
      json['low'],
      json['close'],
      json['volume'],
      (json['time'] as num)?.toInt());
}

Map<String, dynamic> _marketModelToJson(MarketModel model) => <String, dynamic>{
  'open': model.open,
  'high': model.high,
  'low': model.low,
  'close': model.close,
  'amount': model.vol,
  'id': model.id
};

MarketData _marketDataFromJson(json) {
  return MarketData((json as List)
      ?.map((e) =>
  e == null ? null : MarketModel.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _marketDataToJson(MarketData instance) =>
    <String, dynamic>{'data': instance.data};
