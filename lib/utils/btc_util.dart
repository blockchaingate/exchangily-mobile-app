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

import 'dart:convert';
import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:flutter/material.dart';
import "package:hex/hex.dart";
import 'package:http/http.dart';

import '../environments/environment.dart';
import 'custom_http_util.dart';

class BtcUtils {
  var client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  final log = getLogger('BtcUtils');
  final String? btcBaseUrl = environment["endpoints"]["btc"];

  btcToBase58Address(address) {
    var bytes = bs58check.decode(address);
    var digest1 = sha256.convert(bytes).toString();
    var bytes1 = hex.decode(digest1);
    var digest2 = sha256.convert(bytes1).toString();
    var checksum = digest2.substring(0, 8);

    address = HEX.encode(bytes);
    address = address + checksum;
    // debugPrint('address for exg=' + address);
    return address;
  }

  // Get BtcUtxos
  Future getBtcUtxos(String address) async {
    var url = btcBaseUrl! + getUtxosApiRoute + address;
    log.w(url);
    var json;
    try {
      var response = await client.get(Uri.parse(url));
      json = jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
    return json;
  }

  //  Post Tx
  Future postFabTx(String txHex) async {
    var url = fabBaseUrl! + postRawTxApiRoute;
    String? txHash = '';
    String? errMsg = '';
    if (txHex != '') {
      var data = {'rawtx': txHex};
      try {
        var response = await client.post(Uri.parse(url), body: data);

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

  Future getBtcTransactionStatus(String txid) async {
    Response? response;
    var url = '${btcBaseUrl!}gettransactionjson/$txid';
    try {
      response = await client.get(Uri.parse(url));
    } catch (e) {
      debugPrint(e.toString());
    }

    return response;
  }

  Future getBtcBalanceByAddress(String address) async {
    var url = '${btcBaseUrl!}getbalance/$address';
    var btcBalance = 0.0;
    try {
      var response = await client.get(Uri.parse(url));
      btcBalance = double.parse(response.body) / 1e8;
    } catch (e) {
      debugPrint(e.toString());
    }
    return {'balance': btcBalance, 'lockbalance': 0.0};
  }

  getBtcNode(root, {String? tickerName, index = 0}) {
    var coinType = environment["CoinType"][tickerName].toString();
    var node = root.derivePath("m/44'/$coinType'/0'/0/$index");
    return node;
  }

  String? getBtcAddressForNode(node, {String? tickerName}) {
    return P2PKH(
            data: PaymentData(pubkey: node.publicKey),
            //  new P2PKHData(pubkey: node.publicKey),
            network: environment["chains"]["BTC"]["network"])
        .data
        .address;
  }
}
