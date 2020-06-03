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

import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/utils/decoder.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import '../utils/string_util.dart' as stringUtils;

class TradeService {
  final log = getLogger('TradeService');
  ApiService _api = locator<ApiService>();
  static String basePath = environment['websocket'];
/*----------------------------------------------------------------------
          Get Coin Price Details Using allPrices Web Sockets
----------------------------------------------------------------------*/

  Stream<dynamic> getAllCoinPriceByWebSocket() {
    Stream stream;
    try {
      final channel = getAllPriceChannel();
      stream = channel.stream;
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
    }
    return stream;
  }

/*----------------------------------------------------------------------
                    Get Multiple Stream 
----------------------------------------------------------------------*/

  Map<String, StreamData<dynamic>> getMultipleStreams(String tickerName) {
    try {
      Map<String, StreamData<dynamic>> streamData;
      final allPricesChannel = getAllCoinPriceByWebSocket();

      // Order List
      final orderListChannel = getOrderListChannel(tickerName);

      // Trade List
      final tradeListChannel = getTradeListChannel(tickerName);

      // Build a map of streams
      streamData = {
        'allPrices': StreamData<dynamic>(allPricesChannel),
        //   'orderList': StreamData<dynamic>(orderListChannel.stream),
        'marketTradeList': StreamData<dynamic>(tradeListChannel.stream)
      };
      return streamData;
    } catch (err) {
      throw Exception(
          '$err'); // Error thrown here will go to onError in them view model
    }
  }

  getAllPriceChannel() {
    String url = basePath + 'allPrices';
    log.i(url);
    final channel = IOWebSocketChannel.connect(url);

    return channel;
  }

  getOrderListChannel(String pair) {
    try {
      var wsString = environment['websocket'] + 'orders' + '@' + pair;
      // if not put the IOWebSoketChannel.connect to variable channel and
      // directly returns it then in the multiple stream it doesn't work
      final channel = IOWebSocketChannel.connect(wsString);
      return channel;
    } catch (err) {
      throw Exception(
          '$err'); // Error thrown here will go to onError in them view model
    }
  }

  getTradeListChannel(String pair) {
    try {
      var wsString = environment['websocket'] + 'trades' + '@' + pair;
      final channel = IOWebSocketChannel.connect(wsString);
      return channel;
    } catch (err) {
      throw Exception(
          '$err'); // Error thrown here will go to onError in them view model
    }
  }

  getTickerChannel(String pair, String interval) {
    var wsString =
        environment['websocket'] + 'ticker' + '@' + pair + '@' + interval;
    final channel = IOWebSocketChannel.connect(wsString);
    return channel;
  }

  Future<double> getCoinMarketPrice(String name) async {
    double currentUsdValue;
    var data = await _api.getCoinCurrencyUsdPrice();

    currentUsdValue = data['data'][name.toUpperCase()]['USD'];
    print('Current market price $currentUsdValue');
    return currentUsdValue;
  }

  getAssetsBalance(String exgAddress) async {
    return await _api.getAssetsBalance(exgAddress);
  }

  getOrders(String exgAddress) async {
    return await _api.getOrders(exgAddress);
  }

  // Market Pair Group Price List
  marketPairPriceGroups(pairPriceList) {
    List<List<Price>> marketPairsGroupList = [];
    List<Price> usdtPairsList = [];
    List<Price> dusdPairsList = [];
    List<Price> btcPairsList = [];
    List<Price> ethPairsList = [];
    List<Price> exgPairsList = [];
    List<Price> btcFabExgUsdtPriceList = [];
    for (var pair in pairPriceList) {
      if (pair.symbol.endsWith("USDT")) {
        if (pair.symbol == 'BTCUSDT' ||
            pair.symbol == 'FABUSDT' ||
            pair.symbol == 'EXGUSDT') btcFabExgUsdtPriceList.add(pair);
        pair.symbol = pair.symbol.replaceAll('USDT', '/USDT');
        usdtPairsList.add(pair);
      } else if (pair.symbol.endsWith("DUSD")) {
        pair.symbol = pair.symbol.replaceAll('DUSD', '/DUSD');
        dusdPairsList.add(pair);
      } else if (pair.symbol.endsWith("BTC")) {
        pair.symbol = pair.symbol.replaceAll('BTC', '/BTC');
        btcPairsList.add(pair);
      } else if (pair.symbol.endsWith("ETH")) {
        pair.symbol = pair.symbol.replaceAll('ETH', '/ETH');
        ethPairsList.add(pair);
      } else if (pair.symbol.endsWith("EXG")) {
        pair.symbol = pair.symbol.replaceAll('EXG', '/EXG');
        exgPairsList.add(pair);
      }
    }
    marketPairsGroupList.add(usdtPairsList);
    marketPairsGroupList.add(dusdPairsList);
    marketPairsGroupList.add(btcPairsList);
    marketPairsGroupList.add(ethPairsList);
    marketPairsGroupList.add(exgPairsList);
    Map<String, dynamic> res = {
      'marketPairsGroupList': marketPairsGroupList,
      'btcFabExgUsdtPriceList': btcFabExgUsdtPriceList
    };
    return res;
  }
}
