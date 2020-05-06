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
import 'package:exchangilymobileapp/models/wallet.dart';

import '../utils/string_util.dart' as stringUtils;
import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;
import '../environments/environment.dart';

/// The service responsible for networking requests
class ApiService {
  final log = getLogger('API');
  final client = new http.Client();

  static const usdCoinPriceUrl =
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,fabcoin,tether&vs_currencies=usd';
  static const getBalance = 'kanban/getBalance/';
  static const assetsBalance = 'exchangily/getBalances/';
  static const orders = 'ordersbyaddress/';

  final btcBaseUrl = environment["endpoints"]["btc"];
  final fabBaseUrl = environment["endpoints"]["fab"];
  final ethBaseUrl = environment["endpoints"]["eth"];
  final String coinCurrencyUsdPriceUrl = Constants.COIN_CURRENCY_USD_PRICE_URL;

/*-------------------------------------------------------------------------------------
                                  Get coin currency Usd Prices
-------------------------------------------------------------------------------------*/

  Future getCoinCurrencyUsdPrice() async {
    try {
      var response = await client.get(coinCurrencyUsdPriceUrl);
      var json = jsonDecode(response.body);
      log.w(' getCoinCurrencyUsdPrice $json');
      return json;
    } catch (err) {
      log.e('In getCoinCurrencyUsdPrice catch $err');
    }
  }

// Get Coin Usd Price
  Future getCoinsUsdValue() async {
    final res = await http.get(usdCoinPriceUrl);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    return log.e('getCoinsUsdValue Failed to load the data from the API');
  }

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
    try {
      final res = await http
          .get(environment['endpoints']['kanban'] + assetsBalance + exgAddress);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log.e('getAssetsBalance Failed to load the data from the API, $e');
    }
    return {};
  }

// Get Orders
  Future getOrders(String exgAddress) async {
    try {
      final res = await http
          .get(environment['endpoints']['kanban'] + orders + exgAddress);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log.e('getOrders Failed to load the data from the API， $e');
    }
    return {};
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
    try {
      var response = await client.get(url);
      var jsonList = jsonDecode(response.body) as List;
      log.w(' getCoinCurrencyUsdPrice $jsonList');
      PairDecimalConfigList pairList = PairDecimalConfigList.fromJson(jsonList);
      return pairList.pairList;
    } catch (err) {
      log.e('In getCoinCurrencyUsdPrice catch $err');
      return null;
    }
  }
}
