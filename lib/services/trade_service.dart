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

import 'package:bs58check/bs58check.dart';
import 'package:exchangilymobileapp/constants/api_endpoints.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/decimal_config.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import "package:hex/hex.dart";

class TradeService {
  final log = getLogger('TradeService');
  ApiService _api = locator<ApiService>();
  static String basePath = environment['websocket'];

/*----------------------------------------------------------------------
                    Convert fab to hex
----------------------------------------------------------------------*/

  String convertFabAddressToHex(String fabAddress) {
    var decoded = base58.decode(fabAddress);
    String hexString = HEX.encode(decoded);
    return hexString;
  }

// store the trimmed hex value as kanban address won't change so
// no need to convert everytime
  String trimHexString(String hexString) {
    int length = hexString.length;
    String trimmedString = '0x' + hexString.substring(2, 42);
    return trimmedString;
  }

/*----------------------------------------------------------------------
                    getPairDecimalConfig
----------------------------------------------------------------------*/

  Future<DecimalConfig> getDecimalPairConfig(String pairName) async {
    List<PairDecimalConfig> pairDecimalConfigList = [];
    DecimalConfig singlePairDecimalConfig = new DecimalConfig();
    await _api.getPairDecimalConfig().then((res) {
      pairDecimalConfigList = res;
      for (PairDecimalConfig pair in pairDecimalConfigList) {
        if (pair.name == pairName) {
          singlePairDecimalConfig = DecimalConfig(
              priceDecimal: pair.priceDecimal,
              quantityDecimal: pair.qtyDecimal);
        }
      }
    });
    return singlePairDecimalConfig;
  }

/*----------------------------------------------------------------------
                    Close IOWebSocket Connections
----------------------------------------------------------------------*/

  closeIOWebSocketConnections(String pair) async {
    await getAllPriceChannel().sink.close();
    await getOrderListChannel(pair).sink.close();
    await getTradeListChannel(pair).sink.close();
  }

/*----------------------------------------------------------------------
                    Get single pair WS data
----------------------------------------------------------------------*/
// Values based on that time interval

  Stream getTickerDataStream(String pair, {String interval = '24h'}) {
    Stream stream;
    try {
      stream = getTickerDataChannel(pair, interval).stream;
      return stream.asBroadcastStream().distinct();
    } catch (err) {
      log.e(
          'getTickerDataStream CATCH $err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
    }
  }

  IOWebSocketChannel getTickerDataChannel(String pair, String interval) {
    var wsStringUrl = tickerWSUrl + pair + '@' + interval;
    log.i('getTickerDataUrl $wsStringUrl');
    final channel = IOWebSocketChannel.connect(wsStringUrl);
    return channel;
  }

/*----------------------------------------------------------------------
          Get Coin Price Details Using allPrices Web Sockets
----------------------------------------------------------------------*/

  Stream getAllCoinPriceStream() {
    Stream stream;
    try {
      stream = getAllPriceChannel().stream;
      return stream.asBroadcastStream().distinct();
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
    }
  }

  IOWebSocketChannel getAllPriceChannel() {
    log.i('allPricesWSUrl $allPricesWSUrl');
    IOWebSocketChannel channel = IOWebSocketChannel.connect(allPricesWSUrl);
    return channel;
  }

/*----------------------------------------------------------------------
                    Market Trade Orders 
----------------------------------------------------------------------*/

  Stream getMarketTradesStreamByTickerName(String tickerName) {
    Stream stream;
    try {
      // var wsString = environment['websocket'] + 'trades' + '@' + tickerName;
      //  log.w(wsString);
      // IOWebSocketChannel channel = IOWebSocketChannel.connect(wsString);
      stream = getTradeListChannel(tickerName).stream;
      return stream.asBroadcastStream().distinct();
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
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

/*----------------------------------------------------------------------
                      Orders
----------------------------------------------------------------------*/

  Stream getOrderBookStreamByTickerName(String tickerName) {
    Stream stream;
    try {
      // var wsString = environment['websocket'] + 'orders' + '@' + tickerName;
      // log.w(wsString);
      // log.w('getOrderBookStreamByTickerName $wsString');
      // if not put the IOWebSoketChannel.connect to variable channel and
      // directly returns it then in the multiple stream it doesn't work
      //  IOWebSocketChannel channel = IOWebSocketChannel.connect(wsString);

      stream = getOrderListChannel(tickerName).stream;

      return stream.asBroadcastStream().distinct();
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
    }
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

  Future<double> getCoinMarketPrice(String name) async {
    double currentUsdValue;
    var data = await _api.getCoinCurrencyUsdPrice();

    currentUsdValue = data['data'][name.toUpperCase()]['USD'];
    print('Current market price $currentUsdValue');
    return currentUsdValue;
  }

// // Get all my orders
//   Future<List<Order>> getMyOrders(String exgAddress) async {
//     OrderList orderList;
//     try {
//       var data = await _api.getOrders(exgAddress);
//       orderList = OrderList.fromJson(data);
//       // throw Exception('Catch Exception');
//       return orderList.orders;
//     } catch (err) {
//       log.e('getMyOrders Catch $err');
//       throw Exception('Catch Exception $err');
//     }
//   }

  // Get my orders by tickername
  Future<List<Order>> getMyOrdersByTickerName(
      String exgAddress, String tickerName) async {
    OrderList orderList;
    try {
      var data = await _api.getMyOrdersPagedByFabHexAddressAndTickerName(
          exgAddress, tickerName);
      print(data);
      if (data != null) {
        orderList = OrderList.fromJson(data);
        return orderList.orders;
      } else {
        return null;
      }
    } catch (err) {
      log.e('getMyOrdersByTickerName Catch $err');
      throw Exception;
    }
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
