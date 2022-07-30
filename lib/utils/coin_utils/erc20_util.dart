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
    String txHash;
    try {
      var response = await client.post(bnbBaseUrl,
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
      log.e('erc20tils - postbnb Func: Catch $e');
      errMsg = e.toString();
    }
    return {'txHash': txHash, 'errMsg': errMsg};
  }

  Future getNonce({String baseUrl, String smartContractAddress}) async {
    var body = {
      "jsonrpc": "2.0",
      "method": "eth_getTransactionCount",
      "params": [smartContractAddress, "latest"],
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
}
