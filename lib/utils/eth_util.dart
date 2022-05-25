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

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:keccak/keccak.dart';
import 'package:hex/hex.dart';
import 'dart:typed_data';
import '../environments/environment.dart';
import 'dart:async';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';

import 'custom_http_util.dart';

class EthUtils {
  var client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();

  // Eth Post
  Future postEthTx(String txHex) async {
    var url = '${ethBaseUrl}sendsignedtransaction';
    var data = {'signedtx': txHex};
    var errMsg = '';
    String txHash;
    try {
      var response =
          await client.post(url, headers: {"responseType": "text"}, body: data);
      txHash = response.body;

      if (txHash.contains('txerError')) {
        errMsg = txHash;
        txHash = '';
      }
    } catch (e) {
      errMsg = 'connection error';
    }
    return {'txHash': txHash, 'errMsg': errMsg};
  }

  // Eth Nonce
  Future getEthNonce(String address) async {
    var url = '$ethBaseUrl$getNonceApiRoute$address/latest';
    var nonce = 0;
    try {
      var response = await client.get(url);
      nonce = int.parse(response.body);
    } catch (e) {}
    return nonce;
  }

  getTransactionHash(Uint8List signTransaction) {
    var p = keccak(signTransaction);
    var hash = "0x${HEX.encode(p)}";
    return hash;
  }

  Future getEthTransactionStatus(String txid) async {
    var url = '${ethBaseUrl}getconfirmationcount/$txid';

    var response = await client.get(url);
    debugPrint(response.body);
    return response.body;
  }

  getEthNode(root, {index = 0}) {
    var node =
        root.derivePath("m/44'/${environment["CoinType"]["ETH"]}'/0'/0/$index");
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
    var url = '${ethBaseUrl}getbalance/$address';
    var ethBalance = 0.0;
    try {
      var response = await client.get(url);
      Map<String, dynamic> balance = jsonDecode(response.body);
      ethBalance = bigNum2Double(balance['balance']);
    } catch (e) {}
    return {'balance': ethBalance, 'lockbalance': 0.0};
  }

  Future<BigInt> getEthTokenBalanceByAddress(
      String address, String coinName) async {
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
    var url = '${'${ethBaseUrl}callcontract/' + smartContractAddress}/$address';
    debugPrint('eth_util - getEthTokenBalanceByAddress - $url ');

    var balance;
    try {
      var response = await client.get(url);
      balance = jsonDecode(response.body);
      debugPrint('getEthBalanceByAddress $balance');
      // balanceIe8 = double.parse(balance['balance']) / 1e8;
      // balance1e6 = double.parse(balance['balance']) / 1e6;
      // tokenBalanceIe18 = double.parse(balance['balance']) / 1e18;
    } catch (e) {
      debugPrint('getEthTokenBalanceByAddress CATCH $e');
    }
    return BigInt.parse(balance['balance'].toString());
    // return {
    //   'balance1e6': balance1e6,
    //   'balanceIe8': balanceIe8,
    //   'lockbalance': 0.0,
    //   'tokenBalanceIe18': tokenBalanceIe18
    // };
  }
}
