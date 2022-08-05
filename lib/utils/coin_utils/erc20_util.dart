import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'package:flutter/widgets.dart';

class Erc20Util {
  final log = getLogger('ERC20Util');

  var client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();

  Future postTx(String baseUrl, String txHex) async {
    var body = {
      "jsonrpc": "2.0",
      "method": "eth_sendRawTransaction",
      "params": [txHex],
      "id": 1
    };
    var errMsg = '';
    log.i('url $baseUrl -- body $body');
    String txHash;
    try {
      var response = await client.post(baseUrl,
          headers: {"responseType": "text"}, body: jsonEncode(body));
      var json = jsonDecode(response.body);
      log.w('json $json');
      txHash = json["result"];

      if (json != null && json['error'] != null) {
        String errorString = json['error'].toString();
        errMsg = errorString.substring(1, errorString.length - 1);
        txHash = '';
      }
    } catch (e) {
      log.e('erc20tils - $baseUrl Func: Catch $e');
      errMsg = e.toString();
    }
    return {'txHash': txHash, 'errMsg': errMsg};
  }

  Future getNonce({String baseUrl, String smartContractAddress}) async {
    var body = {
      "jsonrpc": "2.0",
      "method": "eth_getTransactionCount",
      "params": [smartContractAddress, "latest"],
      //    "params": ["0x02c55515e62a0b25d2447c6d70369186b8f10359", "latest"],
      "id": 1
    };
    debugPrint('url $baseUrl -- body $body');
    int nonce = 0;
    try {
      var response = await client.post(baseUrl, body: jsonEncode(body));
      log.w('getnonce func- response: ${response.body}');
      var json = jsonDecode(response.body);
      log.w('json $json');
      nonce = int.parse(json['result']);
    } catch (e) {
      log.e('getNonce func- Catch $e');
    }
    log.w('res nonce $nonce');
    return nonce;
  }

  Future getGasPrice(String baseUrl) async {
    var body = {
      "jsonrpc": "2.0",
      "method": "eth_gasPrice",
      "params": [],
      "id": 1
    };
    debugPrint('url $baseUrl -- body $body');
    var gasPrice = 0;
    try {
      var response = await client.post(baseUrl, body: jsonEncode(body));
      var json = jsonDecode(response.body);
      log.w('json $json');
      gasPrice = (BigInt.parse(json['result']) / BigInt.parse('1000000000'))
          .toDouble()
          .round();
    } catch (e) {
      log.e('getGasPrice func- Catch $e');
    }
    log.w('res getGasPrice $gasPrice');
    return gasPrice;
  }

  Future getTokenBalanceByAddress(String baseUrl, String smartContractAddress,
      String officialAddress) async {
    var callTransaction = {
      'to': smartContractAddress,
      'data': '0x70a08231000000000000000000000000' + officialAddress
    };
    var body = {
      "jsonrpc": "2.0",
      "method": "eth_call",
      "params": [callTransaction, "latest"],
      "id": 1
    };
    debugPrint('url $baseUrl -- body $body');
    int nonce = 0;
    try {
      var response = await client.post(baseUrl, body: jsonEncode(body));
      log.w('getTokenBalanceByAddress func- response: ${response.body}');
      var json = jsonDecode(response.body);
      log.w('json $json');
      nonce = int.parse(json['result']);
    } catch (e) {
      log.e('getTokenBalanceByAddress func- Catch $e');
    }
    log.w('res getTokenBalanceByAddress $nonce');

    var url = baseUrl +
        'callcontract/' +
        smartContractAddress +
        '/' +
        smartContractAddress;
    log.i('getEthTokenBalanceByAddress - $url ');

    var tokenBalanceIe18 = 0.0;
    var balanceIe8 = 0.0;
    var balance1e6 = 0.0;
    try {
      var response = await client.get(url);
      var balance = jsonDecode(response.body);
      balanceIe8 = double.parse(balance['balance']) / 1e8;
      balance1e6 = double.parse(balance['balance']) / 1e6;
      tokenBalanceIe18 = double.parse(balance['balance']) / 1e18;
    } catch (e) {
      debugPrint('getEthNonce CATCH $e');
    }
    return {
      'balance1e6': balance1e6,
      'balanceIe8': balanceIe8,
      'lockbalance': 0.0,
      'tokenBalanceIe18': tokenBalanceIe18
    };
  }
  // Future<double> gasFee() async {
  //    String result;
  //   var body = {
  //     "jsonrpc": "2.0",
  //     "method": "eth_gasPrice",
  //     "params": [],
  //     "id": 73
  //   };
  //   log.i('gasFee url $maticmBaseUrl');
  //   try {
  //     var response = await client.post(maticmBaseUrl,
  //         headers: {"responseType": "text"}, body: jsonEncode(body));
  //     var json = jsonDecode(response.body);
  //     log.w('json $json');
  //     result = json["result"];
  //     int gasInWei = int.parse(result);
  //     log.w('gasInWei $gasInWei');
  //     var fee = NumberUtil.weiToGwei(gasInWei);
  //     log.i('feeInGwei $fee');
  //     return fee;
  //   } catch (err) {
  //     log.e('gasFee: CATCH $err');
  //     throw Exception(err);
  //   }
  // }
}
