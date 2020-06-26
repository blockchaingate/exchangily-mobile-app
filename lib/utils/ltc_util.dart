// Generate LTC address
import 'package:bitcoin_flutter/bitcoin_flutter.dart' as BitcoinFlutter;
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:http/http.dart' as http;

final String ltcBaseUrl = environment["endpoints"]["ltc"];

String tickerName = 'LTC';
BitcoinFlutter.NetworkType liteCoinNetworkType = new BitcoinFlutter.NetworkType(
    messagePrefix: '\x19Litecoin Signed Message:\n',
    bip32:
        new BitcoinFlutter.Bip32Type(public: 0x019da462, private: 0x019d9cfe),
    pubKeyHash: 0x30,
    scriptHash: 0x32,
    wif: 0xb0);

generateLtcAddress(root, {index = 0}) async {
  var coinType = environment["CoinType"]["$tickerName"].toString();
  var node =
      root.derivePath("m/44'/" + coinType + "'/0'/0/" + index.toString());

  String address = new BitcoinFlutter.P2PKH(
          data: new BitcoinFlutter.PaymentData(pubkey: node.publicKey),
          network: isProduction ? liteCoinNetworkType : BitcoinFlutter.testnet)
      .data
      .address;
  print('ticker: $tickerName --  address1: $address');
  return address;
}

String getLtcAddressForNode(node, {String tickerName}) {
  return BitcoinFlutter.P2PKH(
          data: new BitcoinFlutter.PaymentData(pubkey: node.publicKey),
          network: isProduction ? liteCoinNetworkType : BitcoinFlutter.testnet)
      .data
      .address;
}

Future getLtcTransactionStatus(String txid) async {
  var response;
  var url = ltcBaseUrl + 'gettransactionjson/' + txid;
  var client = new http.Client();
  try {
    response = await client.get(url);
  } catch (e) {}

  return response;
}

Future getLtcBalanceByAddress(String address) async {
  var url = ltcBaseUrl + 'getbalance/' + address;
  var btcBalance = 0.0;
  try {
    var response = await http.get(url);
    btcBalance = double.parse(response.body) / 1e8;
  } catch (e) {}
  return {'balance': btcBalance, 'lockbalance': 0.0};
}
