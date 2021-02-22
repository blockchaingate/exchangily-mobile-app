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

import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:http/http.dart' as http;
import '../environments/environment.dart';

final String btcBaseUrl = environment["endpoints"]["btc"];

Future getBtcTransactionStatus(String txid) async {
  var response;
  var url = btcBaseUrl + 'gettransactionjson/' + txid;
  var client = new http.Client();
  try {
    response = await client.get(url);
  } catch (e) {}

  return response;
}

Future getBtcBalanceByAddress(String address) async {
  var url = btcBaseUrl + 'getbalance/' + address;
  var btcBalance = 0.0;
  try {
    var response = await http.get(url);
    btcBalance = double.parse(response.body) / 1e8;
  } catch (e) {}
  return {'balance': btcBalance, 'lockbalance': 0.0};
}

getBtcNode(root, {String tickerName, index = 0}) {
  var coinType = environment["CoinType"]["$tickerName"].toString();
  var node =
      root.derivePath("m/44'/" + coinType + "'/0'/0/" + index.toString());
  return node;
}

String getBtcAddressForNode(node, {String tickerName}) {
  return P2PKH(
          data: new PaymentData(pubkey: node.publicKey),
          //  new P2PKHData(pubkey: node.publicKey),
          network: environment["chains"]["BTC"]["network"])
      .data
      .address;
}
