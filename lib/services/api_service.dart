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
import 'package:exchangilymobileapp/constants/api_endpoints.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/models/wallet/token.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_balance.dart';
import 'package:exchangilymobileapp/screens/exchange/exchange_balance_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:exchangilymobileapp/utils/kanban.util.dart';

import '../utils/string_util.dart' as stringUtils;
import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;
import '../environments/environment.dart';

/// The service responsible for networking requests
class ApiService {
  final log = getLogger('ApiService');
  final client = new http.Client();

  final kanbanBaseUrl = environment['endpoints']['kanban'];
  final blockchaingateUrl = environment['endpoints']['blockchaingate'];

  // Please keep this for future test
  // final kanbanBaseUrl = environment['endpoints']['LocalKanban'];
  // final blockchaingateUrl = environment['endpoints']['blockchaingateLocal'];

  static const getBalance = 'kanban/getBalance/';
  static const assetsBalance = 'exchangily/getBalances/';
  static const orders = 'ordersbyaddress/';
  final String walletBalances = 'walletBalances';
  final btcBaseUrl = environment["endpoints"]["btc"];
  final ltcBaseUrl = environment["endpoints"]["ltc"];
  final bchBaseUrl = environment["endpoints"]["bch"];
  final dogeBaseUrl = environment["endpoints"]["doge"];
  final fabBaseUrl = environment["endpoints"]["fab"];
  final ethBaseUrl = environment["endpoints"]["eth"];
  final eventsUrl = environment["eventInfo"];

/*----------------------------------------------------------------------
                    Get single coin exchange balance
----------------------------------------------------------------------*/
  Future<ExchangeBalanceModel> getSingleCoinExchangeBalance(
      String tickerName) async {
    String exgAddress = await getExchangilyAddress();
    String url =
        getSingleCoinExchangeBalanceUrl + exgAddress + '/' + tickerName;
    log.i('getSingleCoinExchangeBalance url $url');
    ExchangeBalanceModel exchangeBalance = new ExchangeBalanceModel();
    try {
      var response = await client.get(url);
      var json = jsonDecode(response.body);
      log.w('json data  $json');
      if (json != null) {
        json['message'] != null
            ? exchangeBalance = null
            : exchangeBalance = ExchangeBalanceModel.fromJson(json);
      }
      log.e('exchangeBalance ${exchangeBalance.toJson()}');
      return exchangeBalance;
    } catch (err) {
      log.e('getSingleCoinExchangeBalance CATCH $err');
      throw Exception(err);
    }
  }
/*----------------------------------------------------------------------
                    Get Token List
----------------------------------------------------------------------*/

  Future<List<Token>> getTokenList() async {
    String url = getTokenListUrl;
    log.i('getTokenList url $url');
    try {
      var response = await client.get(url);
      var json = jsonDecode(response.body);
      var data = json['data'];
      var parsedTokenList = data['tokenList'] as List;
      log.w('getTokenList  $parsedTokenList');
      TokenList tokenList = TokenList.fromJson(parsedTokenList);
      return tokenList.tokens;
    } catch (err) {
      log.e('getTokenList CATCH $err');
      throw Exception(err);
    }
  }

/*----------------------------------------------------------------------
                    Get app version
----------------------------------------------------------------------*/

  Future getApiAppVersion() async {
    String url = getAppVersionUrl;
    log.i('getApiAppVersion url $url');
    try {
      var response = await client.get(getAppVersionUrl);

      log.w('getApiAppVersion  ${response.body}');
      return response.body;
    } catch (err) {
      log.e('getApiAppVersion $err');
      throw Exception(err);
    }
  }

/*----------------------------------------------------------------------
                    Post free fab
----------------------------------------------------------------------*/

  Future postFreeFab(data) async {
    try {
      var response = await client.post(postFreeFabUrl, body: data);
      var json = jsonDecode(response.body);
      log.w(json);
      return json;
    } catch (err) {
      log.e('postFreeFab $err');
      throw Exception(err);
    }
  }

/*----------------------------------------------------------------------
                    Get free fab
----------------------------------------------------------------------*/

  Future getFreeFab(String address) async {
    String url = getFreeFabUrl + address + '/10.4.5.3';
    log.i('getFreeFab url $url');
    try {
      var response = await client.get(getFreeFabUrl + address + '/10.4.5.3');
      var json = jsonDecode(response.body);
      log.w('getFreeFab json $json');
      return json;
    } catch (err) {
      log.e('getFreeFab $err');
      throw Exception(err);
    }
  }

  Future getEthGasPrice() async {
    var url = 'https://ethprod.fabcoinapi.com/getgasprice';
    var ethGasPrice = 0;
    try {
      var response = await client.get(url);
      var json = jsonDecode(response.body);
      log.w(' getDepositTransactionStatus111 $json');
      print((BigInt.parse(json['gasprice']) / BigInt.parse('1000000000'))
          .toDouble());
      ethGasPrice =
          (BigInt.parse(json['gasprice']) / BigInt.parse('1000000000'))
              .toDouble()
              .round();
    } catch (err) {
      log.e('In getDepositTransactionStatus catch $err');
    }

    if (ethGasPrice < environment['chains']['ETH']['gasPrice']) {
      ethGasPrice = environment['chains']['ETH']['gasPrice'];
    }

    if (ethGasPrice > environment['chains']['ETH']['gasPriceMax']) {
      ethGasPrice = environment['chains']['ETH']['gasPriceMax'];
    }
    print('ethGasPrice=====');
    print(ethGasPrice);
    return ethGasPrice;
  }
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
    log.i('getWalletBalance URL $url');
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

/*----------------------------------------------------------------------
                Get Current Market Price For The Coin By Name
----------------------------------------------------------------------*/

  Future<double> getCoinMarketPriceByTickerName(String tickerName) async {
    double currentTickerUsdValue = 0;
    if (tickerName == 'DUSD') {
      return currentTickerUsdValue = 1.0;
    }
    await getCoinCurrencyUsdPrice().then((res) {
      if (res != null) {
        currentTickerUsdValue = res['data'][tickerName]['USD'].toDouble();
      }
    });
    return currentTickerUsdValue;
  }

/*-------------------------------------------------------------------------------------
                      Get coin currency Usd Prices
-------------------------------------------------------------------------------------*/

  Future getCoinCurrencyUsdPrice() async {
    log.w('url $coinCurrencyUsdValueUrl');
    try {
      var response = await client.get(coinCurrencyUsdValueUrl);
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
  //Future<Order>
  Future getMyOrders(String exgAddress) async {
    try {
      String url = getOrdersPagedURL + exgAddress;
      log.w('get my orders url $url');
      var res = await client.get(url);
      log.e('res ${res.body}');
      var jsonList = jsonDecode(res.body) as List;
      log.i('jsonList $jsonList');
      OrderList orderList = OrderList.fromJson(jsonList);
      print('after order list ${orderList.orders.length}');
      //  throw Exception('Catch Exception');
      //return jsonList;
      return orderList.orders;
    } catch (err) {
      log.e('getOrders Failed to load the data from the API， $err');
      throw Exception('Catch Exception $err');
    }
  }

  // Get Orders by tickername
  Future getMyOrdersPagedByFabHexAddressAndTickerName(
      String exgAddress, String tickerName) async {
    String url = getOrdersPagedByTickerNameURL + exgAddress + '/' + tickerName;
    // String url = environment['endpoints']['kanban'] +
    //     'getordersbytickername/' +
    //     exgAddress +
    //     '/' +
    //     tickerName;
    log.i('getMyOrdersByTickerName url $url');
    try {
      final res = await client.get(url);
      print('after res ${res.body}');
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log.e('getMyOrdersByTickerName Failed to load the data from the API， $e');
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

  // Get LtcUtxos
  Future getLtcUtxos(String address) async {
    var url = ltcBaseUrl + 'getutxos/' + address;
    log.w(url);

    try {
      var response = await client.get(url);
      var json = jsonDecode(response.body);
      return json;
    } catch (e) {
      log.e('getLtcUtxos $e');
      throw Exception('e');
    }
  }

  Future getBchUtxos(String address) async {
    var url = bchBaseUrl + 'getutxos/' + address;
    log.w(url);

    try {
      var response = await client.get(url);
      var json = jsonDecode(response.body);
      return json;
    } catch (e) {
      log.e('getBchUtxos $e');
      throw Exception('e');
    }
  }

  // Get DogeUtxos
  Future getDogeUtxos(String address) async {
    var url = dogeBaseUrl + 'getutxos/' + address;
    log.w(url);

    try {
      var response = await client.get(url);
      var json = jsonDecode(response.body);
      return json;
    } catch (e) {
      log.e('getDogeUtxos $e');
      throw Exception('e');
    }
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

  // Post Ltc Transaction
  Future postLtcTx(String txHex) async {
    var url = ltcBaseUrl + 'postrawtransaction';
    var json;
    var txHash = '';
    var errMsg = '';
    try {
      var data = {'rawtx': txHex};
      var response = await client.post(url, body: data);

      json = jsonDecode(response.body);
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
    } catch (e) {
      log.e('postLtcTx $e');
    }
  }

  // Post Bch Transaction
  Future postBchTx(String txHex) async {
    var url = bchBaseUrl + 'postrawtransaction';
    var json;
    var txHash = '';
    var errMsg = '';
    try {
      var data = {'rawtx': txHex};
      var response = await client.post(url, body: data);

      json = jsonDecode(response.body);
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
    } catch (e) {
      log.e('postBchTx $e');
    }
  }

  // Post Ltc Transaction
  Future postDogeTx(String txHex) async {
    var url = dogeBaseUrl + 'postrawtransaction';
    var json;
    var txHash = '';
    var errMsg = '';
    try {
      var data = {'rawtx': txHex};
      var response = await client.post(url, body: data);

      json = jsonDecode(response.body);
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
    } catch (e) {
      log.e('postDogeTx $e');
    }
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

  Future getSliderImages() async {
    try {
      final res = await http.get(kanbanBaseUrl + "kanban/getadvconfig");
      log.w(jsonDecode(res.body));
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      log.e('getSliderImages Failed to load the data from the API $e');
      return "error";
    }
    return "error";
  }

  Future getAnnouncement(lang) async {
    final langcode = lang == "en" ? "en" : "cn";
    final url = blockchaingateUrl + "announcements/" + langcode;

    print("Calling api: getAnnouncement " + lang);
    print("url: " + url);
    try {
      final res = await http.get(url);
      log.w(jsonDecode(res.body));
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body)['body'];
      }
    } catch (e) {
      log.e('getAnnouncement Failed to load the data from the API $e');
      return "error";
    }
    return "error";
  }

  Future getEvents() async {
    print("Calling api: getEvents");
    print("Url: " + kanbanBaseUrl + "kanban/getCampaigns");
    try {
      final res = await http.get(
          // "http://192.168.0.12:4000/kanban/getCampaigns"
          kanbanBaseUrl + "kanban/getCampaigns");
      log.w(jsonDecode(res.body));
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("success");
        return jsonDecode(res.body);
      } else {
        print("error: " + res.body);
        return "error";
      }
    } catch (e) {
      log.e('getEvents failed to load the data from the API $e');
      return "error";
    }
  }

  //get a single event detailed information
  Future postEventSingle(id) async {
    print("Calling api: getEventSingle");
    try {
      final res = await http.post(
        // "http://192.168.0.12:4000/kanban/getCampaignSingle",
        kanbanBaseUrl + "kanban/getCampaignSingle",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': id,
        }),
      );
      log.w(jsonDecode(res.body));
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("success");
        return jsonDecode(res.body);
      } else {
        print("error");
        return ["error"];
      }
    } catch (e) {
      log.e('getEventSingle failed to load the data from the API $e');
    }
    return {};
  }
}
