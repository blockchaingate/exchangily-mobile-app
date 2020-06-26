// Generate LTC address
import 'package:bitcoin_flutter/bitcoin_flutter.dart' as BitcoinFlutter;
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';

generateLtcAddress(root, {index = 0}) async {
  String tickerName = 'LTC';
  BitcoinFlutter.NetworkType liteCoinNetworkType =
      new BitcoinFlutter.NetworkType(
          messagePrefix: '\x19Litecoin Signed Message:\n',
          bip32: new BitcoinFlutter.Bip32Type(
              public: 0x019da462, private: 0x019d9cfe),
          pubKeyHash: 0x30,
          scriptHash: 0x32,
          wif: 0xb0);

  var coinType = environment["CoinType"]["$tickerName"].toString();
  print('coin type $coinType');
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
