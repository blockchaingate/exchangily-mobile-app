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

import 'dart:convert';

import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/trade/order-model.dart';
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

  Stream getAllCoinPriceStream() {
    Stream stream;
    try {
      stream = getAllPriceChannel().stream;
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
    }
    return stream;
  }

/*----------------------------------------------------------------------
                    Get Multiple Stream 
----------------------------------------------------------------------*/

  // Map<String, StreamData<dynamic>> getMultipleStreams(String tickerName) {
  //   try {
  //     Map<String, StreamData<dynamic>> streamData;
  //     final allPricesChannel = getAllCoinPriceByWebSocket();

  //     // Order List
  //     final orderListChannel = getOrderListChannel(tickerName);

  //     // Trade List
  //     final tradeListChannel = getTradeListChannel(tickerName);

  //     // Build a map of streams
  //     streamData = {
  //       'allPrices': StreamData<dynamic>(allPricesChannel),
  //       'orderBookList': StreamData<dynamic>(orderListChannel.stream),
  //       'marketTradesList': StreamData<dynamic>(tradeListChannel.stream)
  //     };

  //     return streamData;
  //   } catch (err) {
  //     throw Exception(
  //         '$err'); // Error thrown here will go to onError in them view model
  //   }
  // }

/*----------------------------------------------------------------------
                    Market Trade Orders 
----------------------------------------------------------------------*/

  Stream getMarketTradesStreamByTickerName(String tickerName) {
    Stream stream;
    try {
      stream = getTradeListChannel(tickerName).stream;
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
    }
    return stream;
  }

/*----------------------------------------------------------------------
                      Orders
----------------------------------------------------------------------*/

  Stream getOrdersStreamByTickerName(String tickerName) {
    Stream stream;
    try {
      stream = getOrderListChannel(tickerName).stream;
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
    }
    return stream;
  }

  /// All Pair Price

  IOWebSocketChannel getAllPriceChannel() {
    String url = basePath + 'allPrices';
    //  log.i(url);
    IOWebSocketChannel channel = IOWebSocketChannel.connect(url);

    return channel;
  }

  IOWebSocketChannel getOrderListChannel(String pair) {
    try {
      var wsString = environment['websocket'] + 'orders' + '@' + pair;
      // if not put the IOWebSoketChannel.connect to variable channel and
      // directly returns it then in the multiple stream it doesn't work
      IOWebSocketChannel channel = IOWebSocketChannel.connect(wsString);
      return channel;
    } catch (err) {
      throw Exception(
          '$err'); // Error thrown here will go to onError in them view model
    }
  }

  IOWebSocketChannel getTradeListChannel(String pair) {
    try {
      var wsString = environment['websocket'] + 'trades' + '@' + pair;
      IOWebSocketChannel channel = IOWebSocketChannel.connect(wsString);
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

// Get my orders
  Future<List<OrderModel>> getOrders(String exgAddress) async {
    var data = await _api.getOrders(exgAddress);
    log.w('raw data $data');
    List<dynamic> jsonDynamicList = jsonDecode(data) as List;
    log.w('OrderBook jsonDynamicList length ${jsonDynamicList.length}');
    OrderList orderList = OrderList.fromJson(jsonDynamicList);
    log.w('OrderBook order list length ${orderList.orders.length}');
    return orderList.orders;
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
        pair.symbol = seperateBasePair(pair.symbol);
        usdtPairsList.add(pair);
      } else if (pair.symbol.endsWith("DUSD")) {
        pair.symbol = seperateBasePair(pair.symbol);
        dusdPairsList.add(pair);
      } else if (pair.symbol.endsWith("BTC")) {
        pair.symbol = seperateBasePair(pair.symbol);
        btcPairsList.add(pair);
      } else if (pair.symbol.endsWith("ETH")) {
        pair.symbol = seperateBasePair(pair.symbol);
        ethPairsList.add(pair);
      } else if (pair.symbol.endsWith("EXG")) {
        pair.symbol = seperateBasePair(pair.symbol);
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

  // Seperate base pair
  String seperateBasePair(String tickerName) {
    String updateTickerName = '';

    if (tickerName.endsWith("USDT")) {
      updateTickerName = tickerName.replaceAll('USDT', '/USDT');
    } else if (tickerName.endsWith("DUSD")) {
      updateTickerName = tickerName.replaceAll('DUSD', '/DUSD');
    } else if (tickerName.endsWith("BTC")) {
      updateTickerName = tickerName.replaceAll('BTC', '/BTC');
    } else if (tickerName.endsWith("ETH")) {
      updateTickerName = tickerName.replaceAll('ETH', '/ETH');
    } else if (tickerName.endsWith("EXG")) {
      updateTickerName = tickerName.replaceAll('EXG', '/EXG');
    }
    return updateTickerName;
  }

  // Check pair ends with
  bool pairNameEndsWith(String pair, String basePair) {
    return pair.endsWith(basePair);
  }
}
