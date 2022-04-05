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
import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart';
import '../environments/environment.dart';

import 'package:convert/convert.dart';
import "package:hex/hex.dart";
import 'package:crypto/crypto.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

import 'custom_http_util.dart';

class BtcUtils {
  var client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  final log = getLogger('BtcUtils');
  final String btcBaseUrl = environment["endpoints"]["btc"];

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
    var url = btcBaseUrl + getUtxosApiRoute + address;
    log.w(url);
    var json;
    try {
      var response = await client.get(url);
      json = jsonDecode(response.body);
    } catch (e) {}
    return json;
  }

  //  Post Tx
  Future postFabTx(String txHex) async {
    var url = fabBaseUrl + postRawTxApiRoute;
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

  Future getBtcTransactionStatus(String txid) async {
    Response response;
    var url = btcBaseUrl + 'gettransactionjson/' + txid;
    try {
      response = await client.get(url);
    } catch (e) {}

    return response;
  }

  Future getBtcBalanceByAddress(String address) async {
    var url = btcBaseUrl + 'getbalance/' + address;
    var btcBalance = 0.0;
    try {
      var response = await client.get(url);
      btcBalance = double.parse(response.body) / 1e8;
    } catch (e) {}
    return {'balance': btcBalance, 'lockbalance': 0.0};
  }

  getBtcNode(root, {String tickerName, index = 0}) {
    var coinType = environment["CoinType"][tickerName].toString();
    var node =
        root.derivePath("m/44'/" + coinType + "'/0'/0/" + index.toString());
    return node;
  }

  String getBtcAddressForNode(node, {String tickerName}) {
    return P2PKH(
            data: PaymentData(pubkey: node.publicKey),
            //  new P2PKHData(pubkey: node.publicKey),
            network: environment["chains"]["BTC"]["network"])
        .data
        .address;
  }
}
