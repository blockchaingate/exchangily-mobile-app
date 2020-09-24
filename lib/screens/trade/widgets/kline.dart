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

import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../packages/bloc/klineBloc.dart';
import '../../../packages/klinePage.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../../packages/model/klineModel.dart';
import 'package:http/http.dart' as http;
import '../../../services/trade_service.dart';

class KlinePage extends StatefulWidget {
  KlinePage({Key key, this.pair}) : super(key: key);

  final String pair;

  @override
  KlinePageState createState() => KlinePageState();
}

class KlinePageState extends State<KlinePage> {
  @override
  Widget build(BuildContext context) {
    var pair = widget.pair.replaceAll("/", "");

    KlinePageBloc bloc = KlinePageBloc(pair);
    return Container(child: KlinePageWidget(bloc));
  }

  updateTrades(trades) {}
}

Future<String> getKlineData(String pair, String period) async {
  if (pair == null) {
    return '[]';
  }

  if (period == null) {
    period = '1m';
  } else {
    period = period.replaceAll("day", "d").replaceAll("min", "m");
  }
  if (period == '60m') {
    period = '1h';
  }
  //var url =
  //    'https://api.huobi.vn/market/history/kline?period=$period&size=449&symbol=btcusdt';

  var url =
      environment["endpoints"]['kanban'] + 'klinedata/' + pair + '/' + period;

  String result;
  var response = await http.get(url);
  if (response.statusCode == HttpStatus.ok) {
    result = response.body;
  } else {}
  return result;
}

class KlinePageBloc extends KlineBloc with TradeService {
  String pair;
  KlinePageBloc(String pa) {
    this.pair = pa;
    this.initData();
  }
  @override
  void periodSwitch(String period) {
    this._getData(this.pair, period);
    super.periodSwitch(period);
  }

  @override
  void initData() {
    _getData(this.pair, '1min');
    super.initData();
  }

  getDataFromStream() {
    String pair = 'FABUSDT';
    var tickerChannel = getTickerChannel(pair, '1m');
    tickerChannel.stream.listen((tickers) {
      //List<Market> list = List<Market>();

      var json = jsonDecode(tickers);
      var open = double.parse(json['open']) / 1e18;
      var high = double.parse(json['high']) / 1e18;
      var low = double.parse(json['low']) / 1e18;
      var close = double.parse(json['close']) / 1e18;
      var volume = double.parse(json['volume'].toString()) / 1e18;

      var id = json['time'];
      Market market = Market(open, high, low, close, volume, id);
      //list.add(market);
      this.addToDataList(market);
    });
  }

  _getData(String pair, String period) async {
    this.showLoadingSinkAdd(true);
    var result = await getKlineData(pair, '$period');
    //future.then((result) {
    final parseJson = json.decode(result);

    var i = 0;
    for (i = 0; i < parseJson.length; i++) {
      parseJson[i]['open'] =
          BigInt.parse(parseJson[i]['open']) / BigInt.from(1e18);
      parseJson[i]['close'] =
          BigInt.parse(parseJson[i]['close']) / new BigInt.from(1e18);
      parseJson[i]['high'] =
          BigInt.parse(parseJson[i]['high']) / new BigInt.from(1e18);
      parseJson[i]['low'] =
          BigInt.parse(parseJson[i]['low']) / new BigInt.from(1e18);
      parseJson[i]['volume'] = BigInt.parse(parseJson[i]['volume'].toString()) /
          new BigInt.from(1e18);
    }
    var parseJsonData = parseJson;
    //  MarketData marketData = MarketData.fromJson(parseJsonData);

    // List<Market> list = List<Market>();
    // i = 0;
    // for (var item in marketData.data) {
    //   i++;
    //   // print('i=' + i.toString());
    //   /*
    //     if (i > 78) {
    //       break;
    //     }
    //     if(i > 75) {
    //       print('i=' + i.toString());
    //       print(item.open);
    //       print(item.high);
    //       print(item.low);
    //       print(item.close);
    //       print(item.vol);
    //       print(item.id);
    //     }

    //      */
    //   Market market =
    //       Market(item.open, item.high, item.low, item.close, item.vol, item.id);
    //   list.add(market);
    // }
    this.showLoadingSinkAdd(false);
    //  this.updateDataList(list);
    this.getDataFromStream();
    //});
  }
}
