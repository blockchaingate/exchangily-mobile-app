import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/kline_data_model.dart';
import '../../../packages/bloc/klineBloc.dart';
import '../../../packages/klinePage.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../../packages/model/klineModel.dart';
import 'package:http/http.dart' as http;

class KlinePage extends StatefulWidget {
  KlinePage({Key key, this.pair}) : super(key: key);

  final String pair;

  @override
  _KlinePageState createState() => _KlinePageState();
}

class _KlinePageState extends State<KlinePage> {
  @override
  Widget build(BuildContext context) {
    KlinePageBloc bloc = KlinePageBloc();
    return Container(
        child: KlinePageWidget(bloc)
    );
  }
}

Future<String> getKlineData(String period) async {
  if (period == null) {
    period = '1m';
  } else {
    period = period.replaceAll("day", "d").replaceAll("min", "m");
  }
  if(period == '60m') {
    period = '1h';
  }
  //var url =
  //    'https://api.huobi.vn/market/history/kline?period=$period&size=449&symbol=btcusdt';
  print('pair=');
  var url = environment["endpoints"]['kanban'] + 'klinedata/FABUSDT/' + period;
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
    _getData('1min');
    super.initData();
  }

  _getData(String period) async {
    this.showLoadingSinkAdd(true);
    var result = await getKlineData('$period');
    //future.then((result) {
      final parseJson = json.decode(result);
      print('parseJson=');
      print(parseJson);
      var i = 0;
      for(i = 0; i < parseJson.length; i++) {

        parseJson[i]['open'] = BigInt.parse(parseJson[i]['open']) / BigInt.from(1e18);
        parseJson[i]['close'] = BigInt.parse(parseJson[i]['close']) / new BigInt.from(1e18);
        parseJson[i]['high'] = BigInt.parse(parseJson[i]['high']) / new BigInt.from(1e18);
        parseJson[i]['low'] = BigInt.parse(parseJson[i]['low']) / new BigInt.from(1e18);
        parseJson[i]['volume'] = BigInt.parse(parseJson[i]['volume'].toString()) / new BigInt.from(1e18);


      }
      var parseJsonData = parseJson;
      MarketData marketData = MarketData.fromJson(parseJsonData);
      print('marketData=');
      print(marketData);
      List<Market> list = List<Market>();
      i = 0;
      for (var item in marketData.data) {
        i ++;
        // print('i=' + i.toString());
        /*
        if (i > 78) {
          break;
        }
        if(i > 75) {
          print('i=' + i.toString());
          print(item.open);
          print(item.high);
          print(item.low);
          print(item.close);
          print(item.vol);
          print(item.id);
        }

         */
        Market market =
        Market(item.open, item.high, item.low, item.close, item.vol,item.id);
        list.add(market);
      }
      this.showLoadingSinkAdd(false);
      this.updateDataList(list);
    //});
  }
}
