import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart' as bitcoin_flutter;

final String? ltcBaseUrl = environment["endpoints"]["ltc"];

final client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
// Main net config
bitcoin_flutter.NetworkType liteCoinMainnetNetwork =
    bitcoin_flutter.NetworkType(
        messagePrefix: '\x19Litecoin Signed Message:\n',
        bip32:
            bitcoin_flutter.Bip32Type(public: 0x019da462, private: 0x019d9cfe),
        pubKeyHash: 0x30,
        scriptHash: 0x32,
        wif: 0xb0);

// test net config
final liteCoinTestnetNetwork = bitcoin_flutter.NetworkType(
    messagePrefix: '\x19Litecoin Signed Message:\n',
    bip32: bitcoin_flutter.Bip32Type(public: 0x0436f6e1, private: 0x0436ef7d),
    pubKeyHash: 0x6f,
    scriptHash: 0x3a,
    wif: 0xef);

// Generate LTC address
generateLtcAddress(root, {index = 0}) async {
  var coinType = environment["CoinType"]["LTC"].toString();
  var node = root.derivePath("m/44'/$coinType'/0'/0/$index");

  String? address = bitcoin_flutter
      .P2PKH(
          data: bitcoin_flutter.PaymentData(pubkey: node.publicKey),
          network: environment["chains"]["LTC"]["network"])
      .data
      .address;
  debugPrint('ticker: LTC --  address1: $address');
  return address;
}

// Generate getLtcAddressForNode
String? getLtcAddressForNode(node, {String? tickerName}) {
  return bitcoin_flutter
      .P2PKH(
          data: bitcoin_flutter.PaymentData(pubkey: node.publicKey),
          network: environment["chains"]["LTC"]["network"])
      .data
      .address;
}

// getLtcTransactionStatus
Future getLtcTransactionStatus(String txid) async {
  Response? response;
  var url = '${ltcBaseUrl!}gettransactionjson/$txid';
  try {
    response = await client.get(Uri.parse(url));
  } catch (e) {
    debugPrint(e.toString());
  }

  return response;
}

// getLtcBalanceByAddress
Future getLtcBalanceByAddress(String address) async {
  var url = '${ltcBaseUrl!}getbalance/$address';
  debugPrint('ltc_util- getLtcBalanceByAddress url $url');
  var btcBalance = 0.0;
  try {
    var response = await client.get(Uri.parse(url));
    debugPrint(response.toString());
    btcBalance = double.parse(response.body) / 1e8;
  } catch (e) {
    debugPrint(e.toString());
  }
  return {'balance': btcBalance, 'lockbalance': 0.0};
}
