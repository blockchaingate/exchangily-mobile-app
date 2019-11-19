import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/kline_data_model.dart';
import '../../../packages/bloc/klineBloc.dart';
import '../../../packages/klinePage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../../packages/model/klineModel.dart';
import 'package:http/http.dart' as http;

class KlinePage extends StatefulWidget {
  KlinePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<KlinePage> {
  @override
  Widget build(BuildContext context) {
    KlinePageBloc bloc = KlinePageBloc();
    return Container(
        child: KlinePageWidget(bloc)
    );
  }
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('json/btcusdt.json');
}

Future<String> getIPAddress(String period) async {
  if (period == null) {
    period = '1day';
  }
  var url =
      'https://api.huobi.vn/market/history/kline?period=$period&size=449&symbol=btcusdt';
  // var url = 'http://18.223.17.4:3002/klinedata/ethusdt/1m';
  print("url=" + url);
  String result;
  var response = await http.get(url);
  if (response.statusCode == HttpStatus.ok) {
    result = response.body;
    print(result.toString());
  } else {
    print('Failed loading trade data.');
  }
  return result;
}

class KlinePageBloc extends KlineBloc {
  @override
  void periodSwitch(String period) {
    _getData(period);
    super.periodSwitch(period);
  }

  @override
  void initData() {
    _getData('1day');
    super.initData();
  }

  _getData(String period) {
    this.showLoadingSinkAdd(true);
    Future<String> future = getIPAddress('$period');
    future.then((result) {
      final parseJson = json.decode(result);
      MarketData marketData = MarketData.fromJson(parseJson);
      List<Market> list = List<Market>();
      for (var item in marketData.data) {
        Market market =
        Market(item.open, item.high, item.low, item.close, item.vol,item.id);
        list.add(market);
      }
      this.showLoadingSinkAdd(false);
      this.updateDataList(list);
    });
  }
}
