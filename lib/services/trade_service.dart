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

import 'package:bs58check/bs58check.dart';
import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/decimal_config.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/stoppable_service.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import "package:hex/hex.dart";

import 'package:http/http.dart' as http;

class TradeService extends StoppableService with ReactiveServiceMixin {
  TradeService() {
    listenToReactiveValues([_price, _quantity, _interval, _isTradingChartModelBusy]);
  }

  final log = getLogger('TradeService');
  ApiService _api = locator<ApiService>();
  ConfigService configService = locator<ConfigService>();
  final client = new http.Client();
  //static String basePath = environment['websocket'];

  /// To check if orderbook has loaded in orderbook viewmodel
  /// and then use this in buysellview to display price and quantity values
  /// in the textfields
  RxValue<bool> _isOrderbookLoaded = RxValue<bool>(initial: false);
  bool get isOrderbookLoaded => _isOrderbookLoaded.value;

  RxValue<double> _price = RxValue<double>(initial: 0.0);
  double get price => _price.value;

  RxValue<double> _quantity = RxValue<double>(initial: 0.0);
  double get quantity => _quantity.value;

  RxValue<String> _interval = RxValue<String>(initial: '30m');
  String get interval => _interval.value;

  RxValue<bool> _isTradingChartModelBusy = RxValue<bool>(initial: false);
  bool get isTradingChartModelBusy => _isTradingChartModelBusy.value;

  

  Stream tickerStream;
  Stream allPriceStream;
  StreamSubscription _streamSubscription;
  StreamController streamController;

  @override
  void start() {
    super.start();
    log.w('starting service');
    // start subscription again
  }

  @override
  void stop() async {
    super.stop();
    log.w('stopping service');
    //     _streamSubscription = allPriceStream.listen((event) { });
    //     _streamSubscription.cancel();
    //  // await getAllPriceChannel().sink.close();
    //     log.w('all price closed');
    //   // cancel stream subscription
  }

/*----------------------------------------------------------------------
                    set orderbook loaded status
----------------------------------------------------------------------*/
  void setTradingChartInterval(String v, bool isBusy) {
    _isTradingChartModelBusy.value = isBusy;
    _interval.value = v;
    log.w('setTradingChartInterval $interval -- isBusy $isTradingChartModelBusy');
  }

/*----------------------------------------------------------------------
                    Get tx status
        - kanban/explorer/getTransactionStatus/orderHash
		        - {txhash:'',status:0x1 or 0x0}
		        - error will be any string
----------------------------------------------------------------------*/
  Future getTxStatus(String txHash) async {
    String url =
        configService.getKanbanBaseUrl() + txStatusStatusRoute + '/$txHash';
    log.e('getTxStatus url $url');

    var response = await client.get(url);
    var json = jsonDecode(response.body);
    if (json != null) {
      // json['message'] != null

      log.w('getTxStatus json $json}');
    }
    return json;
  }

/*----------------------------------------------------------------------
                    set orderbook loaded status
----------------------------------------------------------------------*/
  void setOrderbookLoadedStatus(bool v) {
    _isOrderbookLoaded.value = v;
    log.w('setOrderbookLoadedStatus $isOrderbookLoaded');
  }

/*----------------------------------------------------------------------
                    Set price and quantity
----------------------------------------------------------------------*/
  void setPriceQuantityValues(double p, double q) {
    _price.value = p;
    _quantity.value = q;
    log.w('$price, $quantity');
  }

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

  Future<DecimalConfig> getSinglePairDecimalConfig(String pairName) async {
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

  closeIOWebSocketConnections(String pair) {
    getTickerDataChannel(pair, '24').sink.close();
    getAllPriceChannel().sink.close();
    getOrderListChannel(pair).sink.close();
    getTradeListChannel(pair).sink.close();
  }

/*----------------------------------------------------------------------
                    Get single pair WS data
----------------------------------------------------------------------*/
// Values based on that time interval

  Stream getTickerDataStream(String pair, {String interval = '24h'}) {
    try {
      tickerStream = getTickerDataChannel(pair, interval).stream;
      return tickerStream.asBroadcastStream().distinct();
    } catch (err) {
      log.e(
          'getTickerDataStream CATCH $err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
    }
  }

  IOWebSocketChannel getTickerDataChannel(String pair, String interval) {
    var wsStringUrl =
        configService.getKanbanBaseWSUrl() + 'ticker@' + pair + '@' + interval;
    log.e('getTickerDataUrl $wsStringUrl');
    final channel = IOWebSocketChannel.connect(wsStringUrl);
    return channel;
  }

/*----------------------------------------------------------------------
          Get Coin Price Details Using allPrices Web Sockets
----------------------------------------------------------------------*/

// Stream getAllCoinPriceStream() async* {

// try{
//        allPriceStream = getAllPriceChannel().stream;
//        yield allPriceStream;
// }
//    catch (err) {
//       log.e('$err'); // Error thrown here will go to onError in them view model
//       throw Exception(err);
//     }
//   }
  Stream getAllCoinPriceStream() {
    Stream stream;
    try {
      allPriceStream = getAllPriceChannel().stream;
      return allPriceStream.asBroadcastStream().distinct();
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
    }
  }

  IOWebSocketChannel getAllPriceChannel() {
    var wsStringUrl = configService.getKanbanBaseWSUrl() + 'allPrices';
    log.e('getAllPriceChannelUrl $wsStringUrl');

    IOWebSocketChannel channel = IOWebSocketChannel.connect(wsStringUrl);
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
      var wsString = configService.getKanbanBaseWSUrl() + 'trades' + '@' + pair;
    //  log.i('getTradeListUrl $wsString');
      IOWebSocketChannel channel = IOWebSocketChannel.connect(wsString);
      return channel;
    } catch (err) {
      throw Exception(
          '$err'); // Error thrown here will go to onError in them view model
    }
  }

/*----------------------------------------------------------------------
                      Orderbook
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
      var wsString = configService.getKanbanBaseWSUrl() + 'orders' + '@' + pair;
      log.i('getOrderListUrl $wsString');
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
  Future<List<OrderModel>> getMyOrdersByTickerName(
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
