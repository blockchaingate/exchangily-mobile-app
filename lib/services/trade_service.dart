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
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';

import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/stoppable_service.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'package:flutter/widgets.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'package:exchangilymobileapp/models/wallet/token_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import "package:hex/hex.dart";
import 'package:exchangilymobileapp/services/local_storage_service.dart';

class TradeService extends StoppableService with ReactiveServiceMixin {
  TradeService() {
    listenToReactiveValues([
      _price,
      _quantity,
      _interval,
      _isTradingChartModelBusy,
      _isRefreshBalance
    ]);
  }

  final log = getLogger('TradeService');
  final ApiService? _api = locator<ApiService>();
  ConfigService? configService = locator<ConfigService>();

  LocalStorageService? storageService = locator<LocalStorageService>();
  var client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  //static String basePath = environment['websocket'];

  /// To check if orderbook has loaded in orderbook viewmodel
  /// and then use this in buysellview to display price and quantity values
  /// in the textfields
  final RxValue<bool> _isOrderbookLoaded = RxValue<bool>(false);
  bool get isOrderbookLoaded => _isOrderbookLoaded.value;

  final RxValue<double?> _price = RxValue<double?>(0.0);
  double? get price => _price.value;

  final RxValue<double?> _quantity = RxValue<double?>(0.0);
  double? get quantity => _quantity.value;

  final RxValue<String?> _interval = RxValue<String?>('24h');
  String? get interval => _interval.value;

  final RxValue<bool> _isTradingChartModelBusy = RxValue<bool>(false);
  bool get isTradingChartModelBusy => _isTradingChartModelBusy.value;

  late Stream tickerStream;
  Stream? allPriceStream;

  final RxValue<bool> _isRefreshBalance = RxValue<bool>(false);
  bool get isRefreshBalance => _isRefreshBalance.value;

  String? setTickerNameByType(type) {
    String? res = '';
    //return
    //  await tokenListDatabaseService.getTickerNameByCoinType(type).then((token) {
    for (var element in storageService!.tokenList) {
      var json = jsonDecode(element);
      TokenModel token = TokenModel.fromJson(json);
      if (token.coinType == type) {
        debugPrint(token.tickerName);
        res = token.tickerName;
      }
    }

    return res;
  }

/*----------------------------------------------------------------------
                    set balance refresh
----------------------------------------------------------------------*/
  void setBalanceRefresh(bool v) {
    _isRefreshBalance.value = v;
    log.w('setBalanceRefresh $isRefreshBalance');
  }

/*----------------------------------------------------------------------
                    set Trading Chart Interval
----------------------------------------------------------------------*/
  void setTradingChartInterval(String? v, bool isBusy) {
    _isTradingChartModelBusy.value = isBusy;
    _interval.value = v;
    log.w(
        'setTradingChartInterval $interval -- isBusy $isTradingChartModelBusy');
  }

/*----------------------------------------------------------------------
                    Get tx status
        - kanban/explorer/getTransactionStatus/orderHash
		        - {txhash:'',status:0x1 or 0x0}
		        - error will be any string
----------------------------------------------------------------------*/
  Future getTxStatus(String? txHash) async {
    String url =
        configService!.getKanbanBaseUrl()! + txStatusStatusRoute + '/$txHash';
    log.e('getTxStatus url $url');
    var res;
    try {
      var response = await client.get(Uri.parse(url));
      if (response.body != null) {
        res = jsonDecode(response.body);
        // json['message'] != null

        log.w('getTxStatus json $res}');
      }
    } catch (err) {
      log.e('getTxStatus func: Catch err $err');
    }
    return res;
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
  void setPriceQuantityValues(double? p, double? q) {
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
    //  int length = hexString.length;
    String trimmedString = '0x' + hexString.substring(2, 42);
    return trimmedString;
  }

/*----------------------------------------------------------------------
                    Close IOWebSocket Connections
----------------------------------------------------------------------*/

  closeIOWebSocketConnections(String pair) {
    tickerDataChannel(pair).sink.close();
    getAllPriceChannel().sink.close();
    orderbookChannel(pair).sink.close();
    marketTradesChannel(pair).sink.close();
  }

/*----------------------------------------------------------------------
                    Get single pair WS data
----------------------------------------------------------------------*/
// Values based on that time interval

  Stream getTickerDataStream(String pair, {String interval = '24h'}) {
    try {
      tickerStream = tickerDataChannel(pair, interval: interval)
          .stream
          .asBroadcastStream();
      return tickerStream.distinct();
    } catch (err) {
      log.e(
          'getTickerDataStream CATCH $err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
    }
  }

  IOWebSocketChannel tickerDataChannel(String pair, {String interval = '24'}) {
    var wsStringUrl = configService!.getKanbanBaseWSUrl()! +
        tickerWSRoute +
        pair +
        '@' +
        interval;
    log.i('getTickerDataUrl $wsStringUrl');
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
      stream = getAllPriceChannel().stream;
      return stream.asBroadcastStream().distinct();
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
    }
  }

  IOWebSocketChannel getAllPriceChannel() {
    var wsStringUrl = configService!.getKanbanBaseWSUrl()! + allPricesWSRoute;
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
      stream = marketTradesChannel(tickerName).stream;
      return stream.asBroadcastStream().distinct();
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
    }
  }

  IOWebSocketChannel marketTradesChannel(String pair) {
    try {
      var wsString = configService!.getKanbanBaseWSUrl()! + tradesWSRoute + pair;
      log.i('marketTradesChannel URL $wsString');
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
      stream = orderbookChannel(tickerName).stream;

      return stream.asBroadcastStream().distinct();
    } catch (err) {
      log.e('$err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
    }
  }

  IOWebSocketChannel orderbookChannel(String pair) {
    try {
      var wsString = configService!.getKanbanBaseWSUrl()! + ordersWSRoute + pair;
      log.i('ordersChannel Url $wsString');
      // if not put the IOWebSoketChannel.connect to variable channel and
      // directly returns it then in the multiple stream it doesn't work
      IOWebSocketChannel channel = IOWebSocketChannel.connect(wsString);
      return channel;
    } catch (err) {
      throw Exception(
          '$err'); // Error thrown here will go to onError in them view model
    }
  }

  Future<double?> getCoinMarketPrice(String name) async {
    double? currentUsdValue;
    var data = await _api!.getCoinCurrencyUsdPrice();

    currentUsdValue = data['data'][name.toUpperCase()]['USD'];
    debugPrint('Current market price $currentUsdValue');
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
  Future<List<OrderModel>?> getMyOrdersByTickerName(
      String exgAddress, String tickerName) async {
    OrderList orderList;
    try {
      var data = await _api!.getMyOrdersPagedByFabHexAddressAndTickerName(
          exgAddress, tickerName);
      debugPrint(data.toString());
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
    List<List<Price?>> marketPairsGroupList = [];
    List<Price?> usdtPairsList = [];
    List<Price?> dusdPairsList = [];
    List<Price?> btcPairsList = [];
    List<Price?> ethPairsList = [];
    List<Price?> exgPairsList = [];
    List<Price?> usdcPairsList = [];
    List<Price?> bnbPairsList = [];
    List<Price?> btcFabExgUsdtPriceList = [];
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
      } else if (pair.symbol.endsWith("USDC")) {
        pair.symbol = seperateBasePair(pair.symbol);
        usdcPairsList.add(pair);
      } else if (pair.symbol.endsWith("BNB")) {
        pair.symbol = seperateBasePair(pair.symbol);
        bnbPairsList.add(pair);
      }
    }
    marketPairsGroupList.add(dusdPairsList);
    marketPairsGroupList.add(usdtPairsList);
    marketPairsGroupList.add(btcPairsList);
    marketPairsGroupList.add(ethPairsList);
    marketPairsGroupList.add(exgPairsList);
    marketPairsGroupList.add(usdcPairsList);
    marketPairsGroupList.add(bnbPairsList);
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
    } else if (tickerName.endsWith("USDC")) {
      updateTickerName = tickerName.replaceAll('USDC', '/USDC');
    } else if (tickerName.endsWith("BNB")) {
      updateTickerName = tickerName.replaceAll('BNB', '/BNB');
    }
    return updateTickerName;
  }

  // Check pair ends with
  bool pairNameEndsWith(String pair, String basePair) {
    return pair.endsWith(basePair);
  }
}
