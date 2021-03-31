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
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:keccak/keccak.dart';
import 'package:hex/hex.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../environments/environment.dart';
import 'dart:async';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';

getTransactionHash(Uint8List signTransaction) {
  var p = keccak(signTransaction);
  var hash = "0x" + HEX.encode(p);
  return hash;
}

Future getEthTransactionStatus(String txid) async {
  var url = ethBaseUrl + 'getconfirmationcount/' + txid;
  var client = new http.Client();
  var response = await client.get(url);
  print(response.body);
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
    var response = await http.get(url);
    Map<String, dynamic> balance = jsonDecode(response.body);
    ethBalance = bigNum2Double(balance['balance']);
  } catch (e) {}
  return {'balance': ethBalance, 'lockbalance': 0.0};
}

Future getEthTokenBalanceByAddress(String address, String coinName) async {
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  var smartContractAddress =
      environment["addresses"]["smartContract"][coinName];
  if (smartContractAddress == null) {
    print('$coinName contract is null so fetching from token database');
    await tokenListDatabaseService
        .getContractAddressByTickerName(coinName)
        .then((String value) {
      //  if(!value.startsWith('0x'))
      smartContractAddress = value;
    });
  }
  var url = ethBaseUrl + 'callcontract/' + smartContractAddress + '/' + address;
  print('eth_util - getEthTokenBalanceByAddress - $url ');

  var tokenBalanceIe18 = 0.0;
  var balanceIe8 = 0.0;
  var balance1e6 = 0.0;
  try {
    var response = await http.get(url);
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
