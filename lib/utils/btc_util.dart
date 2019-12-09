import 'package:http/http.dart' as http;
import '../environments/environment.dart';
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:bitcoin_flutter/src/models/networks.dart';

final String btcBaseUrl = environment["endpoints"]["btc"];

Future getBtcTransactionStatus(String txid) async {
  var url = btcBaseUrl  + 'gettransactionjson/' + txid;
  var client = new http.Client();
  var response = await client.get(url);
  return response;
}

Future getBtcBalanceByAddress(String address) async{
  var url =  btcBaseUrl + 'getbalance/' + address;
  var response = await http.get(url);
  var btcBalance = double.parse(response.body) / 1e8;
  return btcBalance;
}

getBtcNode(root, {int index = 0}) {
  var node = root.derivePath("m/44'/" + environment["CoinType"]["BTC"].toString() + "'/0'/0/" + index.toString());
  return node;
}

String getBtcAddressForNode(node) {

  var network = testnet;
  if(isProduction) {
    network = bitcoin;
  }
  return P2PKH(data: new P2PKHData(pubkey: node.publicKey), network: network)
      .data
      .address;
}