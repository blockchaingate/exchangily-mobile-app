/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'dart:convert';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_balance.dart';

import '../utils/string_util.dart' as stringUtils;
import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;
import '../environments/environment.dart';
import 'package:exchangilymobileapp/models/trade/order-model.dart';

/// The service responsible for networking requests
class ApiService {
  final log = getLogger('ApiService');
  final client = new http.Client();

  final kanbanBaseUrl = environment['endpoints']['kanban'];
  static const usdCoinPriceUrl =
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,fabcoin,tether&vs_currencies=usd';
  static const getBalance = 'kanban/getBalance/';
  static const assetsBalance = 'exchangily/getBalances/';
  static const orders = 'ordersbyaddress/';
  final String walletBalances = 'walletBalances';
  final btcBaseUrl = environment["endpoints"]["btc"];
  final fabBaseUrl = environment["endpoints"]["fab"];
  final ethBaseUrl = environment["endpoints"]["eth"];
  final String coinCurrencyUsdPriceUrl = Constants.COIN_CURRENCY_USD_PRICE_URL;

/*----------------------------------------------------------------------
                Transaction status
----------------------------------------------------------------------*/

  Future getTransactionStatus(String transactionId) async {
    var url =
        environment['endpoints']['kanban'] + 'checkstatus/' + transactionId;
    log.e(url);
    try {
      var response = await client.get(url);
      var json = jsonDecode(response.body);
      log.w(' getDepositTransactionStatus $json');
      return json;
    } catch (err) {
      log.e('In getDepositTransactionStatus catch $err');
    }
  }

/*-------------------------------------------------------------------------------------
                                  Get all wallet balance
-------------------------------------------------------------------------------------*/

  Future<List<WalletBalance>> getWalletBalance(body) async {
    String url = kanbanBaseUrl + walletBalances;
    log.i(url);
    WalletBalanceList balanceList;
    try {
      var response = await client.post(url, body: body);
      bool success = jsonDecode(response.body)['success'];
      if (success == true) {
        print(success);
        var jsonList = jsonDecode(response.body)['data'];
        log.w(' getWalletBalance $jsonList');
        balanceList = WalletBalanceList.fromJson(jsonList);
      } else {
        log.e('get wallet balances returning null');
        return null;
      }
      return balanceList.balanceList;
    } catch (err) {
      log.e('In getWalletBalance catch $err');
      return null;
    }
  }

  /*-------------------------------------------------------------------------------------
                                        Get coin currency Usd Prices
      -------------------------------------------------------------------------------------*/

  Future getCoinCurrencyUsdPrice() async {
    log.w('url $coinCurrencyUsdPriceUrl');
    try {
      var response = await client.get(coinCurrencyUsdPriceUrl);
      var json = jsonDecode(response.body);
      log.w('getCoinCurrencyUsdPrice $json');
      return json;
    } catch (err) {
      log.e('In getCoinCurrencyUsdPrice catch $err');
    }
  }

  // Get Coin Usd Price ( OLD way to get the market price)

  // Future getCoinsUsdValue() async {
  //   final res = await http.get(usdCoinPriceUrl);
  //   if (res.statusCode == 200 || res.statusCode == 201) {
  //     return jsonDecode(res.body);
  //   }
  //   return log.e('getCoinsUsdValue Failed to load the data from the API');
  // }

  // Get Gas Balance
  Future getGasBalance(String exgAddress) async {
    try {
      final res = await http
          .get(environment['endpoints']['kanban'] + getBalance + exgAddress);
      log.w(jsonDecode(res.body));
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log.e('getGasBalance Failed to load the data from the API $e');
    }
    return {};
  }

  // Get Assets balance
  Future getAssetsBalance(String exgAddress) async {
    String url =
        environment['endpoints']['kanban'] + assetsBalance + exgAddress;
    log.w('get assets balance url $url');
    try {
      final res = await client.get(url);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log.e('getAssetsBalance Failed to load the data from the API, $e');
    }
  }

  // Get Orders by address
  Future getOrdersTest(String exgAddress) async {
    String url = environment['endpoints']['kanban'] + orders + exgAddress;
    log.w('get my orders url $url');
    try {
      throw Exception('Catch Exception');
    } catch (err) {
      log.e('getOrders Failed to load the data from the API， $err');
      throw Exception('Catch Exception $err');
    }
  }

  // Get Orders by address
  Future<List<OrderModel>> getOrders(String exgAddress) async {
    try {
      String url = environment['endpoints']['kanban'] + orders + exgAddress;
      log.w('get my orders url $url');
      var res = await client.get(url);
      var jsonList = jsonDecode(res.body) as List;
      OrderList orderList = OrderList.fromJson(jsonList);
      return orderList.orders;
    } catch (err) {
      log.e('getOrders Failed to load the data from the API， $err');
      throw Exception('Catch Exception $err');
    }
  }

  // Get Orders by tickername
  Future getMyOrdersByTickerName(String exgAddress, String tickerName) async {
    String url = environment['endpoints']['kanban'] +
        'getordersbytickername/' +
        exgAddress +
        '/' +
        tickerName;
    log.i('getMyOrdersByTickerName url $url');
    try {
      final res = await http.get(url);
      print('after res $res');
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log.e('getOrders Failed to load the data from the API， $e');
      throw Exception;
    }
  }

  // Get FabUtxos
  Future getFabUtxos(String address) async {
    var url = fabBaseUrl + 'getutxos/' + address;
    log.w(url);
    var json;
    try {
      var response = await client.get(url);
      json = jsonDecode(response.body);
    } catch (e) {
      log.e(e);
    }
    return json;
  }

  // Get BtcUtxos
  Future getBtcUtxos(String address) async {
    var url = btcBaseUrl + 'getutxos/' + address;
    log.w(url);
    var json;
    try {
      var response = await client.get(url);
      json = jsonDecode(response.body);
    } catch (e) {}
    return json;
  }

  // Post Btc Transaction
  Future postBtcTx(String txHex) async {
    var url = btcBaseUrl + 'postrawtransaction';
    var json;
    var txHash = '';
    var errMsg = '';
    try {
      var data = {'rawtx': txHex};
      var response = await client.post(url, body: data);

      json = jsonDecode(response.body);
    } catch (e) {}

    log.w('json= $json');
    if (json != null) {
      if (json['txid'] != null) {
        txHash = '0x' + json['txid'];
      } else if (json['Error'] != null) {
        errMsg = json['Error'];
      }
    } else {
      errMsg = 'invalid json format.';
    }
    return {'txHash': txHash, 'errMsg': errMsg};
  }

  // Get Fab Transaction
  Future getFabTransactionJson(String txid) async {
    txid = stringUtils.trimHexPrefix(txid);
    var url = fabBaseUrl + 'gettransactionjson/' + txid;
    var json;
    try {
      var response = await client.get(url);
      json = jsonDecode(response.body);
    } catch (e) {}
    return json;
  }

  // Eth Post
  Future postEthTx(String txHex) async {
    var url = ethBaseUrl + 'sendsignedtransaction';
    var data = {'signedtx': txHex};
    var errMsg = '';
    var txHash;
    try {
      var response =
          await client.post(url, headers: {"responseType": "text"}, body: data);
      txHash = response.body;

      if (txHash.indexOf('txerError') >= 0) {
        errMsg = txHash;
        txHash = '';
      }
    } catch (e) {
      errMsg = 'connection error';
    }
    return {'txHash': txHash, 'errMsg': errMsg};
  }

  // Fab Post Tx
  Future postFabTx(String txHex) async {
    var url = fabBaseUrl + 'postrawtransaction';
    var txHash = '';
    var errMsg = '';
    if (txHex != '') {
      var data = {'rawtx': txHex};
      try {
        var response = await client.post(url, body: data);

        var json = jsonDecode(response.body);
        if (json != null) {
          if ((json['txid'] != null) && (json['txid'] != '')) {
            txHash = json['txid'];
          } else if (json['Error'] != '') {
            errMsg = json['Error'];
          }
        }
      } catch (e) {
        errMsg = 'connection error';
      }
    }

    return {'txHash': txHash, 'errMsg': errMsg};
  }

  // Eth Nonce
  Future getEthNonce(String address) async {
    var url = ethBaseUrl + 'getnonce/' + address + '/latest';
    var nonce = 0;
    try {
      var response = await client.get(url);
      nonce = int.parse(response.body);
    } catch (e) {}
    return nonce;
  }

  // Get Decimal configuration for the coins
  Future<List<PairDecimalConfig>> getPairDecimalConfig() async {
    var url = Constants.PAIR_DECIMAL_CONFIG_URL;
    log.e(url);
    try {
      var response = await client.get(url);
      var jsonList = jsonDecode(response.body) as List;
      log.w(' getPairDecimalConfig $jsonList');
      PairDecimalConfigList pairList = PairDecimalConfigList.fromJson(jsonList);
      return pairList.pairList;
    } catch (err) {
      log.e('In getPairDecimalConfig catch $err');
      return null;
    }
  }
}
