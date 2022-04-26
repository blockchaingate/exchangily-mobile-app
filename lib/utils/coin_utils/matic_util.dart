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

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:keccak/keccak.dart';
import 'package:hex/hex.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';

class MaticUtils {
  final log = getLogger('MaticUtils');

  var client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  String result;
  Future<double> gasFee() async {
    var body = {
      "jsonrpc": "2.0",
      "method": "eth_gasPrice",
      "params": [],
      "id": 73
    };
    log.i('gasFee url $maticmBaseUrl');
    try {
      var response = await client.post(maticmBaseUrl,
          headers: {"responseType": "text"}, body: jsonEncode(body));
      var json = jsonDecode(response.body);
      log.w('json $json');
      result = json["result"];
      int gasInWei = int.parse(result);
      log.w('gasInWei $gasInWei');
      var fee = NumberUtil.weiToGwei(gasInWei);
      log.i('feeInGwei $fee');
      return fee;
    } catch (err) {
      log.e('gasFee: CATCH $err');
      throw Exception(err);
    }
  }

  Future postTx(String txHex) async {
    var body = {
      "jsonrpc": "2.0",
      "method": "eth_sendRawTransaction",
      "params": [txHex],
      "id": 1
    };
    var errMsg = '';
    String txHash;
    try {
      var response = await client.post(maticmBaseUrl,
          headers: {"responseType": "text"}, body: jsonEncode(body));
      var json = jsonDecode(response.body);
      log.w('json $json');
      txHash = json["result"];

      if (txHash.contains('txerError')) {
        errMsg = txHash;
        txHash = '';
      }
    } catch (e) {
      debugPrint('ETHUtils - postMaticmFunc: Catch $e');
      errMsg = 'connection error';
    }
    return {'txHash': txHash, 'errMsg': errMsg};
  }

// Request
//curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionCount","params":["0x407d73d8a49eeb85d32cf465507dd71d507100c1","latest"],"id":1}'

// Result
// {
//   "id":1,
//   "jsonrpc": "2.0",
//   "result": "0x1" // 1
// }

  Future getNonce(String address) async {
    var body = {
      "jsonrpc": "2.0",
      "method": "eth_getTransactionCount",
      "params": ["0x02c55515e62a0b25d2447c6d70369186b8f10359", "latest"],
      "id": 1
    };
    int nonce = 0;
    try {
      var response = await client.post(maticmBaseUrl, body: jsonEncode(body));
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

  getTransactionHash(Uint8List signTransaction) {
    var p = keccak(signTransaction);
    var hash = "0x" + HEX.encode(p);
    return hash;
  }

  Future getEthTransactionStatus(String txid) async {
    var url = ethBaseUrl + 'getconfirmationcount/' + txid;

    var response = await client.get(url);
    debugPrint(response.body);
    return response.body;
  }

  getEthNode(root, {index = 0}) {
    var node = root.derivePath("m/44'/" +
        environment["CoinType"]["ETH"].toString() +
        "'/0'/0/" +
        index.toString());
    return node;
  }

  getEthAddressForNode(node) async {
    var privateKey = node.privateKey;

    Credentials credentials = EthPrivateKey.fromHex(HEX.encode(privateKey));

    final address = await credentials.extractAddress();

    var ethAddress = address.hex;
    return ethAddress;
  }

  Future getEthBalanceByAddress(String address) async {
    var url = ethBaseUrl + 'getbalance/' + address;
    var ethBalance = 0.0;
    try {
      var response = await client.get(url);
      Map<String, dynamic> balance = jsonDecode(response.body);
      ethBalance = bigNum2Double(balance['balance']);
    } catch (e) {}
    return {'balance': ethBalance, 'lockbalance': 0.0};
  }

  Future getEthTokenBalanceByAddress(String address, String coinName) async {
    TokenInfoDatabaseService tokenListDatabaseService =
        locator<TokenInfoDatabaseService>();
    var smartContractAddress =
        environment["addresses"]["smartContract"][coinName];
    if (smartContractAddress == null) {
      debugPrint('$coinName contract is null so fetching from token database');
      await tokenListDatabaseService
          .getContractAddressByTickerName(coinName)
          .then((String value) {
        //  if(!value.startsWith('0x'))
        smartContractAddress = value;
      });
    }
    var url =
        ethBaseUrl + 'callcontract/' + smartContractAddress + '/' + address;
    debugPrint('eth_util - getEthTokenBalanceByAddress - $url ');

    var tokenBalanceIe18 = 0.0;
    var balanceIe8 = 0.0;
    var balance1e6 = 0.0;
    try {
      var response = await client.get(url);
      var balance = jsonDecode(response.body);
      balanceIe8 = double.parse(balance['balance']) / 1e8;
      balance1e6 = double.parse(balance['balance']) / 1e6;
      tokenBalanceIe18 = double.parse(balance['balance']) / 1e18;
    } catch (e) {}
    return {
      'balance1e6': balance1e6,
      'balanceIe8': balanceIe8,
      'lockbalance': 0.0,
      'tokenBalanceIe18': tokenBalanceIe18
    };
  }
}
