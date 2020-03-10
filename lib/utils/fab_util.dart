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

import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;
import '../environments/environment.dart';
import './string_util.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:web3dart/web3dart.dart';
import "package:hex/hex.dart";
import 'package:crypto/crypto.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:exchangilymobileapp/environments/environment_type.dart';

final String fabBaseUrl = environment["endpoints"]["fab"];
final log = getLogger('fab_util');

Future getFabTransactionStatus(String txid) async {
  var url = fabBaseUrl + 'gettransactionjson/' + txid;
  var client = new http.Client();
  var response = await client.get(url);
  print(url);
  log.w(response.body);
  return response.body;
}

getFabNode(root, {index = 0}) {
  var node = root.derivePath("m/44'/" +
      environment["CoinType"]["FAB"].toString() +
      "'/0'/0/" +
      index.toString());
  return node;
}

Future getFabLockBalanceByAddress(String address) async {
  double balance = 0.0;
  var fabSmartContractAddress =
      environment['addresses']['smartContract']['FABLOCK'];
  var getLockedInfoABI = '43eb7b44';
  var data = {
    'address': trimHexPrefix(fabSmartContractAddress),
    'data': trimHexPrefix(getLockedInfoABI),
    'sender': address
  };
  var url = fabBaseUrl + 'callcontract';
  try {
    var response = await http.post(url, body: data);
    var json = jsonDecode(response.body);
    if (json != null &&
        json['executionResult'] != null &&
        json['executionResult']['output'] != null) {
      var balanceHex = json['executionResult']['output'];

      print('balanceHex===' + balanceHex);
      final abiCode = """
      [
      {
        "constant": false,
  "name": "withdraw",
  "payable": false,
  "stateMutability": "nonpayable",
  "type": "function",
  "inputs": [],
  "outputs": []
  },
  {
  "constant": true,
  "name": "lockPeriod",
  "payable": false,
  "stateMutability": "view",
  "type": "function",
  "inputs": [],
  "outputs": [
  {
  "name": "",
  "type": "uint256"
  }
  ]
  },
  {
  "constant": true,
  "name": "getLockerInfo",
  "payable": false,
  "stateMutability": "view",
  "type": "function",
  "inputs": [],
  "outputs": [
  {
  "name": "",
  "type": "uint256[]"
  },
  {
  "name": "",
  "type": "uint256[]"
  }
  ]
  },
  {
  "constant": true,
  "name": "startBlock",
  "payable": false,
  "stateMutability": "view",
  "type": "function",
  "inputs": [],
  "outputs": [
  {
  "name": "",
  "type": "uint256"
  }
  ]
  },
  {
  "constant": false,
  "name": "lockFab",
  "payable": true,
  "stateMutability": "payable",
  "type": "function",
  "inputs": [],
  "outputs": []
  },
  {
  "constant": true,
  "name": "isOwner",
  "payable": false,
  "stateMutability": "view",
  "type": "function",
  "inputs": [],
  "outputs": [
  {
  "name": "",
  "type": "bool"
  }
  ]
  },
  {
  "constant": false,
  "name": "updateLockPeriod",
  "payable": false,
  "stateMutability": "nonpayable",
  "type": "function",
  "inputs": [
  {
  "name": "newLockPeriod",
  "type": "uint256"
  }
  ],
  "outputs": []
  },
  {
  "constant": true,
  "name": "_owner",
  "payable": false,
  "stateMutability": "view",
  "type": "function",
  "inputs": [],
  "outputs": [
  {
  "name": "",
  "type": "address"
  }
  ]
  },
  {
  "constant": false,
  "name": "",
  "payable": false,
  "stateMutability": "nonpayable",
  "type": "constructor",
  "inputs": [],
  "outputs": null
  }
  ]""";

      final EthereumAddress contractAddr =
          EthereumAddress.fromHex(fabSmartContractAddress);
      final contract = DeployedContract(
          ContractAbi.fromJson(abiCode, 'FabLock'), contractAddr);
      final getLockerInfo = contract.function('getLockerInfo');
      var res = getLockerInfo.decodeReturnValues(balanceHex);

      if (res != null && res.length == 2) {
        var values = res[1];
        values.forEach((element) => {balance = balance + element.toDouble()});
        balance = balance / 1e8;
      }
    }
  } catch (e) {}
  return balance;
}

Future getFabBalanceByAddress(String address) async {
  var url = fabBaseUrl + 'getbalance/' + address;
  var fabBalance = 0.0;
  try {
    var response = await http.get(url);
    fabBalance = double.parse(response.body) / 1e8;
  } catch (e) {
    log.e(e);
  }
  var lockbalance = await getFabLockBalanceByAddress(address);
  return {'balance': fabBalance, 'lockbalance': lockbalance};
}

exgToFabAddress(String address) {
  var prefix = '6f';
  if (isProduction) {
    prefix = '00';
  }
  address = prefix + trimHexPrefix(address);
  /*
  var bytes = hex.decode(address);

  print('bytes=');
  var digest1 = sha256.convert(bytes).toString();
  print('digest1==' + digest1);
  var bytes1 = hex.decode(digest1);
  var digest2 = sha256.convert(bytes1).toString();
  print('digest2=' + digest2);
  var checksum = digest2.substring(0,8);
  print('checksum=' + checksum);
  // address = address + checksum;
  print('address before encode=' + address);

   */
  address = bs58check.encode(HEX.decode(address));
  // print('address after encode=' + address);

  /*
  var decoded = bs58check.decode('mvLuZXGYMxpRM65kgzbfoKqs3FPcisM6ri');
  print(decoded);
  print(HEX.encode(decoded));
  print(bs58check.encode(decoded));
  */
  return address;
}

btcToBase58Address(address) {
  var bytes = bs58check.decode(address);
  var digest1 = sha256.convert(bytes).toString();
  var bytes1 = hex.decode(digest1);
  var digest2 = sha256.convert(bytes1).toString();
  var checksum = digest2.substring(0, 8);

  address = HEX.encode(bytes);
  address = address + checksum;
  // print('address for exg=' + address);
  return address;
}

Future getFabTokenBalanceForABI(
    String balanceInfoABI, String smartContractAddress, String address) async {
  var body = {
    'address': trimHexPrefix(smartContractAddress),
    'data': balanceInfoABI + fixLength(trimHexPrefix(address), 64)
  };
  var tokenBalance = 0.0;
  var url = fabBaseUrl + 'callcontract';
  try {
    var response = await http.post(url, body: body);

    var json = jsonDecode(response.body);
    var unlockBalance = json['executionResult']['output'];

    print('unlockBalance===' + unlockBalance.toString());
    if (unlockBalance == null || unlockBalance == '') {
      return 0.0;
    }
    // var unlockInt = int.parse(unlockBalance, radix: 16);
    var unlockInt = BigInt.parse(unlockBalance, radix: 16);
    print('unlockInt===' + unlockInt.toString());
    tokenBalance = bigNum2Double(unlockInt);
    print('tokenBalance===' + tokenBalance.toString());
  } catch (e) {}
  return tokenBalance;
}

Future getSmartContractABI(String smartContractAddress) async {
  var url = fabBaseUrl + 'getabiforcontract/' + smartContractAddress;
  var response = await http.get(url);
  Map<String, dynamic> resJson = jsonDecode(response.body);
  return resJson;
}

Future getFabTokenBalanceByAddress(String address, String coinName) async {
  var smartContractAddress =
      environment["addresses"]["smartContract"][coinName];
  String balanceInfoABI = '70a08231';
  var tokenBalance = await getFabTokenBalanceForABI(
      balanceInfoABI, smartContractAddress, address);
  balanceInfoABI = '6ff95d25';
  var tokenLockedBalance = await getFabTokenBalanceForABI(
      balanceInfoABI, smartContractAddress, address);
  print('address=' + address.toString());
  print('tokenLockedBalance=' + tokenLockedBalance.toString());
  return {'balance': tokenBalance, 'lockbalance': tokenLockedBalance};
}
