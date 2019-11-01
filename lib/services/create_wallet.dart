import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:web3dart/credentials.dart';

class CreateWalletService {
  String exgAddress = '';
  String fabAddress = '';
  String btcAddress = '';
  String ethAddress = '';
  String usdtAddress = '';

  double exgBalance = 0;
  double fabBalance = 0;
  double btcBalance = 0;
  double ethBalance = 0;
  double usdtBalance = 0;
  var seed;

  String randonMnemonic = bip39.generateMnemonic();

  // Get Address

  String getAddress(node, [network]) {
    return P2PKH(data: new P2PKHData(pubkey: node.publicKey), network: network)
        .data
        .address;
  }

  // Get ETH Address
  getEthAddress(privateKey) async {
    Credentials credentials = EthPrivateKey.fromHex(privateKey);

    final address = await credentials.extractAddress();

    return address.hex;
  }

  // Fix

  fixLength(String str, int length) {}

  // Trim

  trimHexPrefix(String str) {}

  // Eth

  getEthNonce(String address) {}

  // Btc

  getBtcUtxos(String address) {}

  // Fab

  getFabUtxos(String txHex) {}

  // Post Btc

  postBtcTx(String txHex) {}

  // Post Eth

  postEthTx(String txHex) {}

  // Post Fab

  postFabTx(String txHex) {}

  // Fab Transaction Json

  getFabTransactionJson(String txid) {}

  // Fab Transaction Locked

  isFabTransactionLocked() {}

  // Number -> Buffer

  number2Buffer(num) {}

  // Hex -> buffer

  hex2Buffer(hexString) {}

  // Convert Liu -> Fab Coin

  convertLiuToFabcoin(amount) {}

  // Get Fab Transaction Hex

  getFabTransactionHex() {}

  // Send transaction

  sendTransaction() {}
}
