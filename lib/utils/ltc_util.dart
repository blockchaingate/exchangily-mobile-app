import 'package:bitcoin_flutter/bitcoin_flutter.dart' as BitcoinFlutter;
import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:http/http.dart' as http;

final String ltcBaseUrl = environment["endpoints"]["ltc"];

// Main net config
BitcoinFlutter.NetworkType liteCoinMainnetNetwork =
    new BitcoinFlutter.NetworkType(
        messagePrefix: '\x19Litecoin Signed Message:\n',
        bip32: new BitcoinFlutter.Bip32Type(
            public: 0x019da462, private: 0x019d9cfe),
        pubKeyHash: 0x30,
        scriptHash: 0x32,
        wif: 0xb0);

// test net config
final liteCoinTestnetNetwork = new BitcoinFlutter.NetworkType(
    messagePrefix: '\x19Litecoin Signed Message:\n',
    bip32:
        new BitcoinFlutter.Bip32Type(public: 0x0436f6e1, private: 0x0436ef7d),
    pubKeyHash: 0x6f,
    scriptHash: 0x3a,
    wif: 0xef);

// Generate LTC address
generateLtcAddress(root, {index = 0}) async {
  var coinType = environment["CoinType"]["LTC"].toString();
  var node =
      root.derivePath("m/44'/" + coinType + "'/0'/0/" + index.toString());

  String address = new BitcoinFlutter.P2PKH(
          data: new BitcoinFlutter.PaymentData(pubkey: node.publicKey),
          network: environment["chains"]["LTC"]["network"])
      .data
      .address;
  print('ticker: LTC --  address1: $address');
  return address;
}

// Generate getLtcAddressForNode
String getLtcAddressForNode(node, {String tickerName}) {
  return BitcoinFlutter.P2PKH(
          data: new BitcoinFlutter.PaymentData(pubkey: node.publicKey),
          network: environment["chains"]["LTC"]["network"])
      .data
      .address;
}

// getLtcTransactionStatus
Future getLtcTransactionStatus(String txid) async {
  var response;
  var url = ltcBaseUrl + 'gettransactionjson/' + txid;
  var client = new http.Client();
  try {
    response = await client.get(url);
  } catch (e) {}

  return response;
}

// getLtcBalanceByAddress
Future getLtcBalanceByAddress(String address) async {
  var url = ltcBaseUrl + 'getbalance/' + address;
  var btcBalance = 0.0;
  try {
    var response = await http.get(url);
    btcBalance = double.parse(response.body) / 1e8;
  } catch (e) {}
  return {'balance': btcBalance, 'lockbalance': 0.0};
}
