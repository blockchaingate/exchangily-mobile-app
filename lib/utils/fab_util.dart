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
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/utils/btc_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

import '../environments/environment.dart';
import './string_util.dart';
import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import "package:hex/hex.dart";
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:bip32/bip32.dart' as bip32;
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'custom_http_util.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart' as bitcoin_flutter;

final String fabBaseUrl = environment["endpoints"]["fab"];

class FabUtils {
  var client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  final log = getLogger('fab_util');
  final btcUtils = BtcUtils();
  final apiService = locator<ApiService>();

  getFabTransactionHexV2(
      seed,
      addressIndexList,
      toAddress,
      Decimal amount,
      Decimal extraTransactionFee,
      int satoshisPerBytes,
      addressList,
      getTransFeeOnly) async {
    final txb = bitcoin_flutter.TransactionBuilder(
        network: environment["chains"]["BTC"]["network"]);
    final root = bip32.BIP32.fromSeed(seed);
    var totalInput = 0;
    var amountInTx = BigInt.from(0);
    var allTxids = [];
    var changeAddress = '';
    var finished = false;
    var receivePrivateKeyArr = [];

    var totalAmount = amount + extraTransactionFee;

    int calc1 = ((2 * 34 + 10) * satoshisPerBytes).toInt();
    var amountInt =
        NumberUtil.decimalToBigInt(totalAmount, decimalPrecision: 8).toInt();
    var amountNum = amountInt + calc1;
    //  var amountNum = BigInt.parse(NumberUtil.toBigInt(totalAmount, 8)).toInt();
    //   amountNum += (2 * 34 + 10) * satoshisPerBytes;

    var transFeeDouble = 0.0;
    int bytesPerInput = environment["chains"]["FAB"]["bytesPerInput"];
    var feePerInput = bytesPerInput * satoshisPerBytes;

    for (var i = 0; i < addressIndexList.length; i++) {
      var index = addressIndexList[i];
      var fabCoinChild = root
          .derivePath("m/44'/${environment["CoinType"]["FAB"]}'/0'/0/$index");
      var fromAddress = btcUtils.getBtcAddressForNode(fabCoinChild);
      if (addressList != null && addressList.length > 0) {
        fromAddress = addressList[i];
      }
      if (i == 0) {
        changeAddress = fromAddress;
      }
      final privateKey = fabCoinChild.privateKey;
      var utxos = await apiService.getFabUtxos(fromAddress);
      if ((utxos != null) && (utxos.length > 0)) {
        for (var j = 0; j < utxos.length; j++) {
          var utxo = utxos[j];
          var idx = utxo['idx'];
          var txid = utxo['txid'];
          var value = utxo['value'];
          /*
          var isLocked = await isFabTransactionLocked(txid, idx);
          if (isLocked) {
            continue;
          }
           */

          var txidItem = {'txid': txid, 'idx': idx};
          var txids = [];
          var existed = false;
          for (var iii = 0; iii < txids.length; iii++) {
            var ttt = txids[iii];
            if ((ttt['txid'] == txidItem['txid']) &&
                (ttt['idx'] == txidItem['idx'])) {
              existed = true;
              break;
            }
          }

          if (existed) {
            continue;
          }

          allTxids.add(txidItem);

          txb.addInput(txid, idx);
          receivePrivateKeyArr.add(privateKey);
          totalInput += value;

          amountNum -= value;
          amountNum += feePerInput;
          if (amountNum <= 0) {
            finished = true;
            break;
          }
        }
      }

      if (!finished) {
        return {
          'txHex': '',
          'errMsg': 'not enough fab coin to make the transaction.',
          'transFee': transFeeDouble,
          'amountInTx': amountInTx
        };
      }
      var calc2 = (receivePrivateKeyArr.length) * feePerInput +
          (2 * 34 + 10) * satoshisPerBytes;
      Decimal transFee = Decimal.fromInt(calc2);
      int amountBigIntToInt =
          NumberUtil.decimalToBigInt(totalAmount, decimalPrecision: 8).toInt();

      var output1 =
          (totalInput - amountBigIntToInt - transFee.toDouble()).round();

// transFeeDouble = ((Decimal.parse(extraTransactionFee.toString()) +
//               Decimal.parse(transFee.toString()) / Decimal.parse('1e8')))
//           .toDouble();
      transFeeDouble =
          (extraTransactionFee + (transFee / Decimal.parse('1e8')).toDecimal())
              .toDouble();
      if (getTransFeeOnly) {
        return {'txHex': '', 'errMsg': '', 'transFee': transFeeDouble};
      }
      var output2 =
          NumberUtil.decimalToBigInt(totalAmount, decimalPrecision: 8).toInt();
      amountInTx = BigInt.from(output2);
      if (output1 < 0 || output2 < 0) {
        return {
          'txHex': '',
          'errMsg': 'output1 or output2 should be greater than 0.',
          'transFee': transFeeDouble,
          'amountInTx': amountInTx
        };
      }

      txb.addOutput(changeAddress, output1);

      txb.addOutput(toAddress, output2);

      for (var i = 0; i < receivePrivateKeyArr.length; i++) {
        var privateKey = receivePrivateKeyArr[i];
        var alice = bitcoin_flutter.ECPair.fromPrivateKey(privateKey,
            compressed: true, network: environment["chains"]["BTC"]["network"]);

        txb.sign(vin: i, keyPair: alice);
      }

      var txHex = txb.build().toHex();

      return {
        'txHex': txHex,
        'errMsg': '',
        'transFee': transFeeDouble,
        'amountInTx': amountInTx,
        'txids': allTxids
      };
    }
  }

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

  // Fab Post Tx
  Future postFabTx(String txHex) async {
    var url = fabBaseUrl + postRawTxApiRoute;
    final sharedService = locator<SharedService>();
    var txHash = '';
    var errMsg = '';
    if (txHex != '') {
      var versionInfo = await sharedService.getLocalAppVersion();
      log.i('getAppVersion $versionInfo');
      String versionName = versionInfo['name'];
      String buildNumber = versionInfo['buildNumber'];
      String fullVersion = versionName + buildNumber;
      log.i('getAppVersion name $versionName');
      var data = {'app': 'exchangily', 'version': fullVersion, 'rawtx': txHex};
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

  Future getFabTransactionStatus(String txid) async {
    var url = fabBaseUrl + fabTransactionJsonApiRoute + txid;

    var response = await client.get(url);
    debugPrint(url);
    log.w(response.body);
    return response.body;
  }

  getFabNode(root, {index = 0}) {
    var node =
        root.derivePath("m/44'/${environment["CoinType"]["FAB"]}'/0'/0/$index");
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
    var url = '${fabBaseUrl}callcontract';
    try {
      var response = await client.post(url, body: data);
      var json = jsonDecode(response.body);
      if (json != null &&
          json['executionResult'] != null &&
          json['executionResult']['output'] != null) {
        var balanceHex = json['executionResult']['output'];

        //  debugPrint('balanceHex===' + balanceHex);
        const abiCode = """
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
    var url = '${fabBaseUrl}getbalance/$address';
    var fabBalance = 0.0;
    try {
      var response = await client.get(url);
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

  debugPrint('bytes=');
  var digest1 = sha256.convert(bytes).toString();
  debugPrint('digest1==' + digest1);
  var bytes1 = hex.decode(digest1);
  var digest2 = sha256.convert(bytes1).toString();
  debugPrint('digest2=' + digest2);
  var checksum = digest2.substring(0,8);
  debugPrint('checksum=' + checksum);
  // address = address + checksum;
  debugPrint('address before encode=' + address);

   */
    address = bs58check.encode(HEX.decode(address));
    log.w('address after encode=$address');

    /*
  var decoded = bs58check.decode('mvLuZXGYMxpRM65kgzbfoKqs3FPcisM6ri');
  debugPrint(decoded);
  debugPrint(HEX.encode(decoded));
  debugPrint(bs58check.encode(decoded));
  */
    return address;
  }

  String fabToExgAddress(String address) {
    var decoded = bs58check.decode(address);
    address = HEX.encode(decoded);
    address = address.substring(2);
    address = '0x$address';
    log.w('in fabToExgAddress $address');
    return address;
  }

/*
  miuFiyLJPcg1i586vhj9JWvHa6bfttDJnd
  var decoded = bs58check.decode('mvLuZXGYMxpRM65kgzbfoKqs3FPcisM6ri');
  debugPrint(decoded);
  debugPrint(HEX.encode(decoded));
  debugPrint(bs58check.encode(decoded));
  */

  Future getFabTokenBalanceForABI(
      String balanceInfoABI, String smartContractAddress, String address,
      [int decimal]) async {
    var body = {
      'address': trimHexPrefix(smartContractAddress),
      'data': balanceInfoABI + fixLength(trimHexPrefix(address), 64)
    };
    var tokenBalance = 0.0;
    var url = '${fabBaseUrl}callcontract';
    log.i(
        'Fab_util -- address $address getFabTokenBalanceForABI balance by address url -- $url -- body $body');
    try {
      var response = await client.post(url, body: body);
      var json = jsonDecode(response.body);
      log.w('getFabTokenBalanceForABIForCustomTokens json $json');
      var unlockBalance = json['executionResult']['output'];

      if (unlockBalance == null || unlockBalance == '') {
        return 0.0;
      }
      // var unlockInt = int.parse(unlockBalance, radix: 16a);
      var unlockInt = BigInt.parse(unlockBalance, radix: 16);

      if ((decimal != null) && (decimal > 0)) {
        tokenBalance =
            ((unlockInt) / BigInt.parse(pow(10, decimal).toString()));
      } else {
        tokenBalance = bigNum2Double(unlockInt);
        // debugPrint('tokenBalance for EXG==');
        // debugPrint(tokenBalance);
      }

      //debugPrint('tokenBalance===' + tokenBalance.toString());
    } catch (err) {
      log.e('getFabTokenBalanceForABI func - CATCH $err');
    }
    return tokenBalance;
  }

  Future getSmartContractABI(String smartContractAddress) async {
    var url = '${fabBaseUrl}getabiforcontract/$smartContractAddress';
    var response = await client.get(url);
    Map<String, dynamic> resJson = jsonDecode(response.body);
    return resJson;
  }

  Future getFabTokenBalanceByAddress(String address, String coinName) async {
    TokenInfoDatabaseService tokenListDatabaseService =
        locator<TokenInfoDatabaseService>();
    var smartContractAddress =
        environment["addresses"]["smartContract"][coinName];
    if (smartContractAddress == null) {
      debugPrint('$coinName contract is null so fetching from token database');
      await tokenListDatabaseService
          .getContractAddressByTickerName(coinName)
          .then((value) {
        if (!value.startsWith('0x')) {
          smartContractAddress = '0x$value';
        } else {
          smartContractAddress = value;
        }
      });
      debugPrint('official smart contract address $smartContractAddress');
    }
    var tokenBalance = 0.0;
    var tokenLockedBalance = 0.0;
    if (coinName == 'EXG' || coinName == 'CNB') {
      String balanceInfoABI = '70a08231';
      tokenBalance = await getFabTokenBalanceForABI(
          balanceInfoABI, smartContractAddress, address);
      balanceInfoABI = '6ff95d25';
      tokenLockedBalance = await getFabTokenBalanceForABI(
          balanceInfoABI, smartContractAddress, address);
    } else {
      String balanceInfoABI = '70a08231';
      tokenBalance = await getFabTokenBalanceForABI(
          balanceInfoABI, smartContractAddress, address, 6);
    }

    // debugPrint('address=' + address.toString());
    // debugPrint('tokenLockedBalance=' + tokenLockedBalance.toString());
    return {'balance': tokenBalance, 'lockbalance': tokenLockedBalance};
  }
}
