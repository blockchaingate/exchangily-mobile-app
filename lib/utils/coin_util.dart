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

import 'dart:convert';
import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip_32;
import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:exchangilymobileapp/utils/ltc_util.dart';
import 'package:exchangilymobileapp/utils/tron_util/trx_generate_address_util.dart'
    as tron_address_util;
import 'package:flutter/widgets.dart';
import 'package:hex/hex.dart';
import "package:pointycastle/digests/sha256.dart";
import "package:pointycastle/ecc/curves/secp256k1.dart";
import 'package:pointycastle/macs/hmac.dart';
import "package:pointycastle/pointycastle.dart";
import "package:pointycastle/signers/ecdsa_signer.dart";
import 'package:web3dart/crypto.dart' as crypto_web3;

import './btc_util.dart';
import './eth_util.dart';
import '../environments/environment.dart';
import '../utils/string_util.dart';
import 'varuint.dart';
import 'wallet_coin_address_utils/doge_util.dart';

final ECDomainParameters _params = ECCurve_secp256k1();
final BigInt _halfCurveOrder = _params.n >> 1;

class CoinUtils {
  final log = getLogger('coin_util');
  final fabUtils = FabUtils();
  final btcUtils = BtcUtils();
  final ethUtils = EthUtils();
/*----------------------------------------------------------------------
                Sign deposit TRX tx
--------------r--------------------------------------------------------*/
  signTrxMessage(
    String originalMessage,
    Uint8List privateKey,
  ) {
    // const a = "0x15TRON Signed Message:\n";
    // var aToAscii = ascii.encode(a);
    // debugPrint('aToAscii $aToAscii');
    //debugPrint('part1HexPrefix $part1PrefixBytes');
    //Uint8List prefixBytes = CryptoWeb3.hexToBytes(messagePrefix);
// Uint8List bytePrefixIntToUintList = CryptoWeb3.(
//   bytePrefixToInt);

    // const intBytePrefix = 0x15;
    // Uint8List part1PrefixBytes = utf8.encode(intBytePrefix.toString());
    // debugPrint('intBytePrefixToHex ${uint8ListToHex(part1PrefixBytes)}');

    const messagePrefix = '\u0015TRON Signed Message:\n';
    final prefixBytes = ascii.encode(messagePrefix);
    debugPrint(
        'part2PrefixBytes ascii bytes to hex-- ${crypto_web3.bytesToHex(prefixBytes)}');

    //final prefixBytes = part1PrefixBytes + part2PrefixBytes;
    debugPrint(
        'final prefixBytes bytes ascii bytes to hex-- ${crypto_web3.bytesToHex(prefixBytes)}');

    debugPrint(
        'hash $originalMessage --  hash length ${originalMessage.length}');

    Uint8List originalMessageWithPrefix = Uint8List.fromList(prefixBytes +
        //CryptoWeb3.hexToBytes(originalMessage));
        ascii.encode(originalMessage));
    debugPrint(
        'originalMessageWithPrefix ${crypto_web3.bytesToHex(originalMessageWithPrefix)}');

    var hashedOriginalMessageWithPrefix =
        crypto_web3.keccak256(originalMessageWithPrefix);

    debugPrint(
        'hashedOriginalMessageWithPrefix ${crypto_web3.bytesToHex(hashedOriginalMessageWithPrefix)}');

    var signature = sign(hashedOriginalMessageWithPrefix, privateKey);

    debugPrint('signature v ${signature.v}');

    final chainIdV = signature.v + 27;

    debugPrint('chainIdV $chainIdV');

    signature = crypto_web3.MsgSignature(signature.r, signature.s, chainIdV);

    final r = _padTo32(crypto_web3.intToBytes(signature.r));
    final s = _padTo32(crypto_web3.intToBytes(signature.s));
    var v = crypto_web3.intToBytes(BigInt.from(signature.v));

    var rsv = r + s + v;
    debugPrint('rsv  $rsv');
    return rsv;
  }

/*----------------------------------------------------------------------
                Sign TRX transaction for send
--------------r--------------------------------------------------------*/
  List<Uint8List> signTrxTx(
    Uint8List hash,
    Uint8List privateKey,
  ) {
    debugPrint('sign trx');

    var signature = sign(hash, privateKey);

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L26
    // be aware that signature.v already is recovery + 27

    debugPrint('signature v ${signature.v}');

    final chainIdV = signature.v;

    debugPrint('chainIdV $chainIdV');
    //final chainIdV = signature.v;
    signature = crypto_web3.MsgSignature(signature.r, signature.s, chainIdV);

    //debugPrint('chainIdVchainIdVchainIdV==' + chainIdV.toString());
    //debugPrint('signature.v====');
    //debugPrint(signature.v);
    final r = _padTo32(crypto_web3.intToBytes(signature.r));
    final s = _padTo32(crypto_web3.intToBytes(signature.s));
    var v = crypto_web3.intToBytes(BigInt.from(signature.v));

    if (signature.v == 0) {
      v = Uint8List.fromList([0].toList());
    }
    List<Uint8List> rsvList = [];
    var res = r + s + v;
    rsvList.add(Uint8List.fromList(res));
    debugPrint('rsv list $rsvList');
    return rsvList;
  }

  Uint8List hash256(Uint8List buffer) {
    Uint8List tmp = SHA256Digest().process(buffer);
    return SHA256Digest().process(tmp);
  }

  encodeSignature(signature, recovery, compressed, segwitType) {
    if (segwitType != null) {
      recovery += 8;
      if (segwitType == 'p2wpkh') recovery += 4;
    } else {
      if (compressed) recovery += 4;
    }
    recovery += 27;
    return recovery.toRadixString(16);
  }

/*
Future signedBitcoinMessage(String originalMessage, String wif) async {
  debugPrint('originalMessage=');
  debugPrint(originalMessage);
  var hdWallet = Wallet.fromWIF(wif);
  var compressed = false;
  var sigwitType;
  var signedMess = await hdWallet.sign(originalMessage);
  var recovery = 0;
  var r = encodeSignature(signedMess, recovery, compressed, sigwitType);
  debugPrint('r=');
  debugPrint(r);
  debugPrint('signedMess=');
  debugPrint(signedMess);
  return signedMess;
}
*/

  crypto_web3.MsgSignature sign(Uint8List messageHash, Uint8List privateKey) {
    final digest = SHA256Digest();
    final signer = ECDSASigner(null, HMac(digest, 64));
    final key = ECPrivateKey(crypto_web3.bytesToInt(privateKey), _params);

    signer.init(true, PrivateKeyParameter(key));
    var sig = signer.generateSignature(messageHash) as ECSignature;

    debugPrint('sig =============');
    debugPrint(sig.r.toString());
    debugPrint(sig.s.toString());
    /*
	This is necessary because if a message can be signed by (r, s), it can also
	be signed by (r, -s (mod N)) which N being the order of the elliptic function
	used. In order to ensure transactions can't be tampered with (even though it
	would be harmless), Ethereum only accepts the signature with the lower value
	of s to make the signature for the message unique.
	More details at
	https://github.com/web3j/web3j/blob/master/crypto/src/main/java/org/web3j/crypto/ECDSASignature.java#L27
	 */
    if (sig.s.compareTo(_halfCurveOrder) > 0) {
      final canonicalisedS = _params.n - sig.s;
      sig = ECSignature(sig.r, canonicalisedS);
    }

    final publicKey =
        crypto_web3.bytesToInt(crypto_web3.privateKeyBytesToPublic(privateKey));
    debugPrint("publicKey: $publicKey");

    //Implementation for calculating v naively taken from there, I don't understand
    //any of this.
    //https://github.com/web3j/web3j/blob/master/crypto/src/main/java/org/web3j/crypto/Sign.java
    var recId = -1;
    for (var i = 0; i < 4; i++) {
      final k = _recoverFromSignature(i, sig, messageHash, _params);
      if (k == publicKey) {
        recId = i;
        break;
      }
    }

    debugPrint('recId====$recId');
    if (recId == -1) {
      throw Exception(
          'Could not construct a recoverable key. This should never happen');
    }

    return crypto_web3.MsgSignature(sig.r, sig.s, recId);
  }

  BigInt? _recoverFromSignature(
      int recId, ECSignature sig, Uint8List msg, ECDomainParameters params) {
    final n = params.n;
    final i = BigInt.from(recId ~/ 2);
    final x = sig.r + (i * n);

    //Parameter q of curve
    final prime = BigInt.parse(
        'fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f',
        radix: 16);
    if (x.compareTo(prime) >= 0) return null;

    final R = _decompressKey(x, (recId & 1) == 1, params.curve)!;
    if (!(R * n)!.isInfinity) return null;

    final e = crypto_web3.bytesToInt(msg);

    final eInv = (BigInt.zero - e) % n;
    final rInv = sig.r.modInverse(n);
    final srInv = (rInv * sig.s) % n;
    final eInvrInv = (rInv * eInv) % n;

    final q = ((params.G * eInvrInv)! + (R * srInv))!;

    final bytes = q.getEncoded(false);
    return crypto_web3.bytesToInt(bytes.sublist(1));
  }

  Uint8List uint8ListFromList(List<int> data) {
    if (data is Uint8List) return data;

    return Uint8List.fromList(data);
  }

  ECPoint? _decompressKey(BigInt xBN, bool yBit, ECCurve c) {
    List<int> x9IntegerToBytes(BigInt s, int qLength) {
      //https://github.com/bcgit/bc-java/blob/master/core/src/main/java/org/bouncycastle/asn1/x9/X9IntegerConverter.java#L45
      final bytes = crypto_web3.intToBytes(s);

      if (qLength < bytes.length) {
        return bytes.sublist(0, bytes.length - qLength);
      } else if (qLength > bytes.length) {
        final tmp = List<int>.filled(qLength, 0);

        final offset = qLength - bytes.length;
        for (var i = 0; i < bytes.length; i++) {
          tmp[i + offset] = bytes[i];
        }

        return tmp;
      }

      return bytes;
    }

    final compEnc = x9IntegerToBytes(xBN, 1 + ((c.fieldSize + 7) ~/ 8));
    compEnc[0] = yBit ? 0x03 : 0x02;
    return c.decodePoint(compEnc);
  }

  Uint8List _padTo32(Uint8List data) {
    assert(data.length <= 32);
    if (data.length == 32) return data;

    // todo there must be a faster way to do this?
    return Uint8List(32)..setRange(32 - data.length, 32, data);
  }

  Future<Uint8List> signBtcMessageWith(originalMessage, Uint8List privateKey,
      {int? chainId, var network}) async {
    debugPrint('signBtcMessageWith begin');
    // Uint8List messageHash = magicHash(originalMessage, network);
    Uint8List messageHash = Uint8List(2332);

    debugPrint('network=');
    debugPrint(network.toString());
    debugPrint('messageHash=');
    debugPrint(messageHash.toString());
    var signature = sign(messageHash, privateKey);

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L26
    // be aware that signature.v already is recovery + 27

    /*
  final chainIdV =
      chainId != null ? (signature.v - 27 + (chainId * 2 + 35)) : signature.v;
  */

    //debugPrint('signature.vsignature.vsignature.v=' + signature.v.toString());
    final chainIdV = signature.v;
    signature = crypto_web3.MsgSignature(signature.r, signature.s, chainIdV);

    //debugPrint('chainIdVchainIdVchainIdV==' + chainIdV.toString());
    //debugPrint('signature.v====');
    //debugPrint(signature.v);
    final r = _padTo32(crypto_web3.intToBytes(signature.r));
    final s = _padTo32(crypto_web3.intToBytes(signature.s));
    var v = crypto_web3.intToBytes(BigInt.from(signature.v));

    if (signature.v == 0) {
      v = Uint8List.fromList([0].toList());
    }
    //debugPrint('vvvv=');
    //debugPrint(v);
    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L63
    return uint8ListFromList(r + s + v);
  }

  Future<Uint8List> signDogeMessageWith(originalMessage, Uint8List privateKey,
      {int? chainId, var network}) async {
    debugPrint('signDogeMessageWith');
    Uint8List messageHash = magicHashDoge(originalMessage);
    //messageHash.insert(1, 25);
    debugPrint('network=');
    debugPrint(network);
    debugPrint('messageHash=');
    debugPrint(messageHash.toString());
    var signature = sign(messageHash, privateKey);

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L26
    // be aware that signature.v already is recovery + 27

    /*
  final chainIdV =
      chainId != null ? (signature.v - 27 + (chainId * 2 + 35)) : signature.v;
  */

    //debugPrint('signature.vsignature.vsignature.v=' + signature.v.toString());
    final chainIdV = signature.v;
    signature = crypto_web3.MsgSignature(signature.r, signature.s, chainIdV);

    //debugPrint('chainIdVchainIdVchainIdV==' + chainIdV.toString());
    //debugPrint('signature.v====');
    //debugPrint(signature.v);
    final r = _padTo32(crypto_web3.intToBytes(signature.r));
    final s = _padTo32(crypto_web3.intToBytes(signature.s));
    var v = crypto_web3.intToBytes(BigInt.from(signature.v));

    if (signature.v == 0) {
      v = Uint8List.fromList([0].toList());
    }
    //debugPrint('vvvv=');
    //debugPrint(v);
    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L63
    return uint8ListFromList(r + s + v);
  }

  Future<Uint8List> signPersonalMessageWith(
      String messagePrefix, Uint8List privateKey, Uint8List payload,
      {int? chainId}) async {
    final prefix = messagePrefix + payload.length.toString();
    final prefixBytes = ascii.encode(prefix);

    // will be a Uint8List, see the documentation of Uint8List.+
    final concat = uint8ListFromList(prefixBytes + payload);

    //final signature = await credential.signToSignature(concat, chainId: chainId);

    var signature = sign(crypto_web3.keccak256(concat), privateKey);

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L26
    // be aware that signature.v already is recovery + 27
    debugPrint('signature.v=======${signature.v}');
    debugPrint('chainId=$chainId');

    /*
  final chainIdV =
      chainId != null ? (signature.v + (chainId * 2 + 35)) : signature.v;

   */
    final chainIdV = signature.v + 27;
    debugPrint('chainIdV=$chainIdV');
    signature = crypto_web3.MsgSignature(signature.r, signature.s, chainIdV);

    final r = _padTo32(crypto_web3.intToBytes(signature.r));
    final s = _padTo32(crypto_web3.intToBytes(signature.s));
    final v = crypto_web3.intToBytes(BigInt.from(signature.v));

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L63
    return uint8ListFromList(r + s + v);
    //return credential.sign(concat, chainId: chainId);
  }

  Uint8List magicHash(String message, [NetworkType? network]) {
    network = network ?? bitcoin;
    List<int> messagePrefix = utf8.encode(network.messagePrefix);
    debugPrint('messagePrefix===');
    debugPrint(messagePrefix.toString());
    int messageVISize = encodingLength(message.length);
    debugPrint('messageVISize===');
    debugPrint(messageVISize.toString());
    int length = messagePrefix.length + messageVISize + message.length;
    Uint8List buffer = Uint8List(length);
    buffer.setRange(0, messagePrefix.length, messagePrefix);
    encode(message.length, buffer, messagePrefix.length);
    buffer.setRange(
        messagePrefix.length + messageVISize, length, utf8.encode(message));

    return hash256(buffer);
  }

  Uint8List magicHashDoge(String message, [NetworkType? network]) {
    network = network ?? bitcoin;
    List<int> messagePrefix = utf8.encode(network.messagePrefix);

    int messageVISize = encodingLength(message.length);

    int length = messagePrefix.length + messageVISize + message.length + 1;
    Uint8List buffer = Uint8List(length);
    buffer.setRange(0, 1, [25]);

    buffer.setRange(1, messagePrefix.length + 1, messagePrefix);

    encode(message.length, buffer, messagePrefix.length + 1);
    buffer.setRange(
        messagePrefix.length + messageVISize + 1, length, utf8.encode(message));

    return hash256(buffer);
  }

  signedMessage(
    String originalMessage,
    seed,
    coinName,
    tokenType,
  ) async {
    var r = '';
    var s = '';
    var v = '';

    var signedMess;
    if (coinName == 'TRX' || tokenType == 'TRX') {
      var privateKey = tron_address_util.generateTrxPrivKeyBySeed(seed);
      //var bytes = CryptoWeb3.hexToBytes(originalMessage);

      signedMess = signTrxMessage(originalMessage, privateKey);
      //signTrxMessage(bytes, privateKey);

      String ss = HEX.encode(signedMess);

      r = ss.substring(0, 64);
      s = ss.substring(64, 128);
      v = ss.substring(128);
      debugPrint('r: $r --  s: $s -- v: $v');

      return {'r': r, 's': s, 'v': v};
    }

    // other coins signed message
    else if (coinName == 'ETH' || tokenType == 'ETH') {
      final root = bip_32.BIP32.fromSeed(seed);
      var coinType = environment["CoinType"]["ETH"];
      final ethCoinChild = root.derivePath("m/44'/$coinType'/0'/0/0");
      var privateKey = ethCoinChild.privateKey;
      //var credentials = EthPrivateKey.fromHex(privateKey);
      //var credentials = EthPrivateKey(privateKey);

      var chainId = environment["chains"]["ETH"]["chainId"];
      // chainId = 0;
      debugPrint('chainId==$chainId');

      // var signedMessOrig = await credentials
      //    .signPersonalMessage(stringToUint8List(originalMessage), chainId: chainId);

      signedMess = await signPersonalMessageWith(Constants.EthMessagePrefix,
          privateKey!, stringToUint8List(originalMessage),
          chainId: chainId);
      String ss = HEX.encode(signedMess);
      //String ss2 = HEX.encode(signedMessOrig);

      //debugPrint('ss='+ss);
      //debugPrint('ss2='+ss2);
      r = ss.substring(0, 64);
      s = ss.substring(64, 128);
      v = ss.substring(128);
      debugPrint('v=$v');
    } else if (coinName == 'BNB' ||
        tokenType == 'BNB' ||
        coinName == 'MATICM' ||
        tokenType == 'MATICM' ||
        tokenType == 'POLYGON') {
      final root = bip_32.BIP32.fromSeed(seed);
      var coinType = environment["CoinType"]["ETH"];
      final ethCoinChild = root.derivePath("m/44'/$coinType'/0'/0/0");
      var privateKey = ethCoinChild.privateKey;
      //var credentials = EthPrivateKey.fromHex(privateKey);
      //var credentials = EthPrivateKey(privateKey);
      var chainId;
      if (coinName == 'BNB' || tokenType == 'BNB') {
        chainId = environment["chains"]["BNB"]["chainId"];
      } else if (coinName == 'MATICM' || tokenType == 'MATICM') {
        chainId = environment["chains"]["MATICM"]["chainId"];
      }

      // chainId = 0;
      debugPrint('chainId==$chainId');

      // var signedMessOrig = await credentials
      //    .signPersonalMessage(stringToUint8List(originalMessage), chainId: chainId);

      signedMess = await signPersonalMessageWith(Constants.EthMessagePrefix,
          privateKey!, stringToUint8List(originalMessage),
          chainId: chainId);
      String ss = HEX.encode(signedMess);
      //String ss2 = HEX.encode(signedMessOrig);

      //debugPrint('ss='+ss);
      //debugPrint('ss2='+ss2);
      r = ss.substring(0, 64);
      s = ss.substring(64, 128);
      v = ss.substring(128);
      debugPrint('v=$v');
    } else if (coinName == 'FAB' ||
        coinName == 'BTC' ||
        coinName == 'LTC' ||
        coinName == 'BCH' ||
        coinName == 'DOGE' ||
        tokenType == 'FAB') {
      //var hdWallet = new HDWallet.fromSeed(seed, network: testnet);

      var network = environment["chains"]['BTC']["network"];
      if (coinName == 'LTC') {
        network = environment["chains"]['LTC']["network"];
      } else if (coinName == 'DOGE') {
        network = environment["chains"]['DOGE']["network"];
      }
      final root2 = bip_32.BIP32.fromSeed(
          seed,
          bip_32.NetworkType(
              wif: network.wif,
              bip32: bip_32.Bip32Type(
                  public: network.bip32.public,
                  private: network.bip32.private)));

      var coinType = environment["CoinType"]["FAB"];
      if (coinName == 'BTC') {
        coinType = environment["CoinType"]["BTC"];
      }
      if (coinName == 'LTC') {
        coinType = environment["CoinType"]["LTC"];
      }
      if (coinName == 'DOGE') {
        coinType = environment["CoinType"]["DOGE"];
      }
      if (coinName == 'BCH') {
        coinType = environment["CoinType"]["BCH"];
      }
      var bitCoinChild = root2.derivePath("m/44'/$coinType'/0'/0/0");
      //var btcWallet =
      //    hdWallet.derivePath("m/44'/" + coinType.toString() + "'/0'/0/0");
      var privateKey = bitCoinChild.privateKey;
      // var credentials = EthPrivateKey(privateKey);

      if (coinName == 'DOGE') {
        signedMess = await signDogeMessageWith(originalMessage, privateKey!,
            network: network);
      } else {
        signedMess = await signBtcMessageWith(originalMessage, privateKey!,
            network: network);
      }

      String ss = HEX.encode(signedMess);

      r = ss.substring(0, 64);
      s = ss.substring(64, 128);
      v = ss.substring(128);

      /*
    Uint8List messageHash =
        magicHash(originalMessage, environment["chains"]["BTC"]["network"]);

    signedMess = await ecc.sign(messageHash, privateKey);
    */
      var recovery = int.parse(v);
      var compressed = true;
      var sigwitType;
      v = encodeSignature(signedMess, recovery, compressed, sigwitType);

      /*
    String sss = HEX.encode(signedMess);
    var r1 = sss.substring(0, 64);
    var s1 = sss.substring(64, 128);

    if (r == r1) {
      debugPrint('signiture is right');
    } else {
      debugPrint('signiture is wrong');
    }
    */
      //amount=0.01
      //r1=d2c3555da5b1deb7147e63cbc6d431f4ac15433b16bdd95ab6da214a442c8f12
      //s1=0d6564a5e6ae55ed429330189affc31a3f50a1bcf30c2dbd8d814886d2c7d71e
    }

    if (signedMess != null) {}

    return {'r': r, 's': s, 'v': v};
  }

  getOfficalAddress(String? coinName, {String? tokenType = ''}) {
    if (tokenType == 'FAB') {
      String? fabTokensOfficialAddress =
          environment['addresses']['exchangilyOfficial'][0]['address'];
      debugPrint(
          'fabTokensOfficialAddress $fabTokensOfficialAddress for $coinName');
      return fabTokensOfficialAddress;
    }
    if (tokenType == 'TRX' || tokenType == 'TRON') {
      String? trxTokensOfficialAddress =
          environment['addresses']['exchangilyOfficial'][9]['address'];
      debugPrint(
          'TRXTokensOfficialAddress $trxTokensOfficialAddress for $coinName');
      return trxTokensOfficialAddress;
    } else if (coinName == 'ETH' || tokenType == 'ETH') {
      var ethTokenOfficialAddress =
          environment['addresses']['exchangilyOfficial'][3]['address'];

      debugPrint(
          'ethTokenOfficialAddress $ethTokenOfficialAddress for $coinName');
      return ethTokenOfficialAddress;
    } else if (coinName == 'BNB' || tokenType == 'BNB') {
      var bnbTokenOfficialAddress =
          environment['addresses']['exchangilyOfficial'][10]['address'];

      debugPrint(
          'BNBTokenOfficialAddress $bnbTokenOfficialAddress for $coinName');
      return bnbTokenOfficialAddress;
    } else if (coinName == 'MATICM' ||
        tokenType == 'MATICM' ||
        tokenType == 'POLYGON') {
      var maticmTokenOfficialAddress =
          environment['addresses']['exchangilyOfficial'][11]['address'];

      debugPrint(
          'maticmTokenOfficialAddress $maticmTokenOfficialAddress for $coinName');
      return maticmTokenOfficialAddress;
    } else {
      var address = environment['addresses']['exchangilyOfficial']
          .where((addr) => addr['name'] == coinName)
          .toList();
      String? majorsOfficialAddress =
          (address as List).isNotEmpty ? address[0]['address'] : '';
      debugPrint(
          'majors official address $majorsOfficialAddress for $coinName');
      return majorsOfficialAddress;
    }
  }

/*
usage:
getAddressForCoin(root, 'BTC');
getAddressForCoin(root, 'ETH');
getAddressForCoin(root, 'FAB');
getAddressForCoin(root, 'USDT', tokenType: 'ETH');
getAddressForCoin(root, 'EXG', tokenType: 'FAB');
 */
  Future getAddressForCoin(root, String tickerName,
      {tokenType = '', index = 0}) async {
    if (tickerName == 'BTC') {
      var node =
          btcUtils.getBtcNode(root, tickerName: tickerName, index: index);
      return btcUtils.getBtcAddressForNode(node, tickerName: tickerName);
    } else if (tickerName == 'LTC') {
      return generateLtcAddress(root);
    } else if (tickerName == 'DOGE') {
      return generateDogeAddress(root);
    } else if ((tickerName == 'ETH') || (tokenType == 'ETH')) {
      var node = ethUtils.getEthNode(root, index: index);
      return await ethUtils.getEthAddressForNode(node);
    } else if (tickerName == 'FAB') {
      var node = fabUtils.getFabNode(root, index: index);
      return btcUtils.getBtcAddressForNode(node, tickerName: tickerName);
    } else if (tokenType == 'FAB') {
      var node = fabUtils.getFabNode(root, index: index);
      var fabPublicKey = node.publicKey;
      Digest sha256 = Digest("SHA-256");
      var pass1 = sha256.process(fabPublicKey);
      Digest ripemd160 = Digest("RIPEMD-160");
      var pass2 = ripemd160.process(pass1);
      var fabTokenAddr = '0x${HEX.encode(pass2)}';
      return fabTokenAddr;
    }
    return '';
  }

// Future Coin Balances With Addresses
  Future getCoinBalanceByAddress(String coinName, String? address,
      {tokenType = ''}) async {
    try {
      if (coinName == 'BTC') {
        return await btcUtils.getBtcBalanceByAddress(address!);
      } else if (coinName == 'LTC') {
        return await getLtcBalanceByAddress(address!);
      } else if (coinName == 'ETH') {
        return await ethUtils.getEthBalanceByAddress(address!);
      } else if (coinName == 'FAB') {
        return await fabUtils.getFabBalanceByAddress(address!);
      } else if (tokenType == 'ETH') {
        return await ethUtils.getEthTokenBalanceByAddress(address!, coinName);
      } else if (tokenType == 'FAB') {
        return await fabUtils.getFabTokenBalanceByAddress(address, coinName);
      }
    } catch (e) {
      log.e('getCoinBalanceByAddress $e');
    }

    return {'balance': -1.0, 'lockbalance': -1.0};
  }

  Future getBalanceForCoin(root, coinName, {tokenType = '', index = 0}) async {
    var address = await getAddressForCoin(root, coinName,
        tokenType: tokenType, index: index);
    try {
      if (coinName == 'BTC') {
        return await btcUtils.getBtcBalanceByAddress(address);
      } else if (coinName == 'ETH') {
        return await ethUtils.getEthBalanceByAddress(address);
      } else if (coinName == 'FAB') {
        return await fabUtils.getFabBalanceByAddress(address);
      } else if (tokenType == 'ETH') {
        return await ethUtils.getEthTokenBalanceByAddress(address, coinName);
      } else if (tokenType == 'FAB') {
        return await fabUtils.getFabTokenBalanceByAddress(address, coinName);
      }
    } catch (e) {
      log.e('getCoinBalanceByAddress $e');
    }

    return {'balance': -1.0, 'lockbalance': -1.0};
  }
}
