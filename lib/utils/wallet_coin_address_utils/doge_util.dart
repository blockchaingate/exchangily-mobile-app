import 'package:bitcoin_flutter/bitcoin_flutter.dart' as BitcoinFlutter;
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:flutter/widgets.dart';

final dogeCoinTestnetNetwork = BitcoinFlutter.NetworkType(
    messagePrefix: 'Dogecoin Signed Message:\n',
    bip32: BitcoinFlutter.Bip32Type(
        public: 0x043587cf // xpubkey
        ,
        private: 0x04358394 //xprivkey
        ),
    pubKeyHash: 0x71,
    scriptHash: 0xc4,
    wif: 0xf1 //private key
    );

final dogeCoinMainnetNetwork = BitcoinFlutter.NetworkType(
    messagePrefix: 'Dogecoin Signed Message:\n',
    bip32: BitcoinFlutter.Bip32Type(public: 0x02facafd, private: 0x02fac398),
    pubKeyHash: 0x1e,
    scriptHash: 0x16,
    wif: 0x9e);

generateDogeAddress(root, {index = 0}) async {
  var coinType = environment["CoinType"]["DOGE"].toString();
  var node =
      root.derivePath("m/44'/$coinType'/0'/0/$index");

  String address = BitcoinFlutter.P2PKH(
          data: BitcoinFlutter.PaymentData(pubkey: node.publicKey),
          network: environment["chains"]["DOGE"]["network"])
      .data
      .address;
  debugPrint('ticker: Doge --  address: $address');
  return address;
}

String getDogeAddressForNode(node, {String tickerName}) {
  return BitcoinFlutter.P2PKH(
          data: BitcoinFlutter.PaymentData(pubkey: node.publicKey),
          network: environment["chains"]["DOGE"]["network"])
      .data
      .address;
}
