import '../packages/bip32/bip32_base.dart' as bip32;
import 'package:bitcoin_flutter/src/models/networks.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bitcoin_flutter/src/bitcoin_flutter_base.dart';
import '../utils/string_util.dart';

signedMessage(String originalMessage, seed, coinName, tokenType) async {
  var r = '';
  var s = '';
  var v = '';

  final root = bip32.BIP32.fromSeed(
      seed,
      bip32.NetworkType(wif: testnet.wif, bip32: new bip32.Bip32Type(public: testnet.bip32.public, private: testnet.bip32.private))
  );

  var signedMess;
  if (coinName == 'ETH' || tokenType == 'ETH') {

    final ethCoinChild = root.derivePath("m/44'/60'/0'/0/0");
    var privateKey = ethCoinChild.privateKey;
    //var credentials = EthPrivateKey.fromHex(privateKey);
    var credentials = EthPrivateKey(privateKey);
    signedMess = await credentials.signPersonalMessage(stringToUint8List(originalMessage));

  } else
  if (coinName == 'FAB' || coinName == 'BTC' || tokenType == 'FAB') {
    var hdWallet = new HDWallet.fromSeed(seed);

    var coinType = 1150;
    if(coinName == 'BTC') {
      coinType = 1;
    }
    var btcWallet = hdWallet.derivePath("m/44'/" + coinType.toString() + "'/0'/0/0");
    signedMess = btcWallet.sign(originalMessage);
  }

  if (signedMess != null) {
    String ss = HEX.encode(signedMess);
    r = ss.substring(0,64);
    s = ss.substring(64,128);
    v = ss.substring(128);
  }

  return {
    'r': r,
    's': s,
    'v': v
  };
}
