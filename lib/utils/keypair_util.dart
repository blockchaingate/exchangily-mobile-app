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

import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import "package:pointycastle/pointycastle.dart";
import '../environments/environment.dart';

getExgKeyPair(seed) {
  final root = bip32.BIP32.fromSeed(
      seed,
      bip32.NetworkType(
          wif: environment["chains"]["BTC"]["network"].wif,
          bip32: bip32.Bip32Type(
              public: environment["chains"]["BTC"]["network"].bip32.public,
              private: environment["chains"]["BTC"]["network"].bip32.private)));

  final fabCoinChild = root.derivePath(
      "m/44'/" + environment["CoinType"]["FAB"].toString() + "'/0'/0/0");
  final fabPublicKey = fabCoinChild.publicKey;

  final fabPrivateKey = fabCoinChild.privateKey;
  Digest sha256 = Digest("SHA-256");
  var pass1 = sha256.process(fabPublicKey);
  Digest ripemd160 = Digest("RIPEMD-160");
  var pass2 = ripemd160.process(pass1);
  var exgAddr = '0x' + HEX.encode(pass2);
  return {"address": exgAddr, "privateKey": fabPrivateKey};
}
