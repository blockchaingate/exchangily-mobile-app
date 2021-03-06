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
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/utils/exaddr.dart';
import 'package:exchangilymobileapp/utils/fab_util.dart';
import './string_util.dart';
import 'package:web3dart/web3dart.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/src/utils/rlp.dart' as rlp;
import 'dart:typed_data';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
// {"success":true,"data":{"transactionID":"3ba8d681cddea5376c9b6ab2963ff243160fa086ec0681a67a3206ad80284d76"}}

getWithdrawFuncABI(coinType, amountInLink, addressInWallet,
    {String coinName = '', String chain = '', bool isSpecialDeposit = false}) {
  var abiHex = Constants.WithdrawSignatureAbi;
  if (isSpecialDeposit) {
    var hexaDecimalCoinType = fix8LengthCoinType(coinType.toRadixString(16));
    abiHex += specialFixLength(hexaDecimalCoinType, 64, chain);
  } else
    abiHex += fixLength(coinType.toRadixString(16), 64);

  var amountHex = amountInLink.toRadixString(16);
  abiHex += fixLength(trimHexPrefix(amountHex), 64);

  abiHex += fixLength(trimHexPrefix(addressInWallet), 64);
  return abiHex;
}

getSendCoinFuncABI(coinType, kbPaymentAddress, amount) {
  var abiHex = Constants.SendSignatureAbi;
  var fabAddress = toLegacyAddress(kbPaymentAddress);

  var exAddress = fabToExgAddress(fabAddress);
  abiHex += fixLength(trimHexPrefix(exAddress), 64);
  abiHex += fixLength(coinType.toRadixString(16), 64);
  var amountHex = amount.toRadixString(16);
  abiHex += fixLength(trimHexPrefix(amountHex), 64);
  return abiHex;
}

//0x10c43d65000000000000000000000000dcd0f23125f74ef621dfa3310625f8af0dcd971b0000000000000000000000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000a688906bd8b00000

getDepositFuncABI(int coinType, String txHash, BigInt amountInLink,
    String addressInKanban, signedMessage,
    {String coinName = '', String chain = '', bool isSpecialDeposit = false}) {
  var abiHex = Constants.DepositSignatureAbi;
  abiHex += trimHexPrefix(signedMessage["v"]);
  if (isSpecialDeposit) {
    var hexaDecimalCoinType = fix8LengthCoinType(coinType.toRadixString(16));
    abiHex += specialFixLength(hexaDecimalCoinType, 62, chain);
  } else
    abiHex += fixLength(coinType.toRadixString(16), 62);
  abiHex += trimHexPrefix(txHash);
  var amountHex = amountInLink.toRadixString(16);

  abiHex += fixLength(amountHex, 64);
  abiHex += fixLength(trimHexPrefix(addressInKanban), 64);
  abiHex += trimHexPrefix(signedMessage["r"]);
  abiHex += trimHexPrefix(signedMessage["s"]);
  return abiHex;
}

specialFixLength(String hexaDecimalCoinType, int length, String chain) {
  var retStr = '';
  int hexaDecimalCoinTypeLength = hexaDecimalCoinType.length;
  print('hexaDecimalCoinType $hexaDecimalCoinTypeLength');
  int len2 = length - hexaDecimalCoinTypeLength;
  int finalLength = len2 - 4; // subtract chain hexa length
  if (finalLength > 0) {
    for (int i = 0; i < finalLength; i++) {
      retStr += '0';
    }
    if (chain == 'ETH') {
      retStr += Constants.EthChainPrefix;
    } else if (chain == 'TRX') {
      retStr += Constants.TronChainPrefix;
    } else if (chain == 'FAB') {
      retStr += Constants.FabChainPrefix;
    }

    retStr += hexaDecimalCoinType;
    return retStr;
  } else if (finalLength < 0) {
    return hexaDecimalCoinType.substring(0, length - 1);
  } else {
    return hexaDecimalCoinType;
  }
}

String fix8LengthCoinType(String coinType) {
  print('fix8LengthCoinType $coinType');
  String result = '';
  const int reqLength = 8;
  int coinTypeLength = coinType.length;
  int diff = 0;
  if (coinTypeLength < reqLength) {
    diff = reqLength - coinTypeLength;
    for (int i = 0; i < diff; i++) {
      result += '0';
    }
    result += coinType;
  }
  print('fix8LengthCoinType result $result');
  return result;
}

/*
 0x12a3da170000000000000000000000000000000000000000000000000000000000000001
 00000000000000000000000000000000000000000000000000000000000000010000000000
 00000000000000000000000000000000000000000000000000000200000000000000000000
 00000000000000000000000000000000000000000003000000000000000000000000000000
 000000000000000000002386f26fc100000000000000000000000000000000000000000000
 00000000002386f26fc1000000000000000000000000000000000000000000000000000000
 00006296a75020000000000000000000000000000000000000000000000000000000000000
 000006e328d04a77db9be48be26004e8eb87ccb4432839a10bdff4112a2bffdb3821
   */
getCreateOrderFuncABI(
    bool payWithEXG,
    bool bidOrAsk,
    // int orderType,
    int baseCoin,
    int targetCoin,
    String qty,
    String price,
    //int timeBeforeExpiration,
    String orderHash) {
  var abiHex = '0x19b54ba9';
  var payWithEXGString = payWithEXG ? '1' : '0';
  abiHex += fixLength(payWithEXGString, 64);
  var bidOrAskString = bidOrAsk ? '1' : '0';
  abiHex += fixLength(bidOrAskString, 64);
  // abiHex += fixLength(orderType.toString(), 64);
  abiHex += fixLength(baseCoin.toString(), 64);
  abiHex += fixLength(targetCoin.toString(), 64);
  var qtyHex = BigInt.parse(qty).toRadixString(16);
  abiHex += fixLength(qtyHex, 64);
  var priceHex = BigInt.parse(price).toRadixString(16);
  abiHex += fixLength(priceHex, 64);
  // abiHex += fixLength(timeBeforeExpiration.toString(), 64);
  abiHex += fixLength(orderHash, 64);

  return abiHex;
}

List<dynamic> _encodeToRlp(Transaction transaction, MsgSignature signature) {
  final list = [
    transaction.nonce,
    transaction.gasPrice.getInWei,
    transaction.maxGas,
  ];

  if (transaction.to != null) {
    list.add(transaction.to.addressBytes);
  } else {
    list.add('');
  }

  list..add(transaction.value.getInWei);
  list.add('');
  list..add(transaction.data);

  if (signature != null) {
    list..add(signature.v)..add(signature.r)..add(signature.s);
  }

  return list;
}

Uint8List uint8ListFromList(List<int> data) {
  if (data is Uint8List) return data;

  return Uint8List.fromList(data);
}

Future signAbiHexWithPrivateKey(String abiHex, String privateKey,
    String coinPoolAddress, int nonce, int gasPrice, int gasLimit) async {
  var chainId = environment["chains"]["KANBAN"]["chainId"];
  //var apiUrl = "https://ropsten.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef"; //Replace with your API

  //var httpClient = new http.Client();

  abiHex = trimHexPrefix(abiHex);
  //var ethClient = new Web3Client(apiUrl, httpClient);
  var credentials = new EthPrivateKey.fromHex(privateKey);

  var transaction = Transaction(
      to: EthereumAddress.fromHex(coinPoolAddress),
      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.wei, gasPrice),
      maxGas: gasLimit,
      nonce: nonce,
      value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 0),
      data: HEX.decode(abiHex));
  final innerSignature =
      chainId == null ? null : MsgSignature(BigInt.zero, BigInt.zero, chainId);

  var transactionList = _encodeToRlp(transaction, innerSignature);
  final encoded = uint8ListFromList(rlp.encode(transactionList));

  final signature =
      await credentials.signToSignature(encoded, chainId: chainId);

  var encodeList =
      uint8ListFromList(rlp.encode(_encodeToRlp(transaction, signature)));
  var finalString = '0x' + HEX.encode(encodeList);
  // print('finalString===' + finalString);
  return finalString;
  /*
  var signed = await ethClient.signTransaction(
    credentials,
    Transaction(
      to: EthereumAddress.fromHex(coinPoolAddress),
      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 4),
      maxGas: 20000000,
      nonce: nonce,
      data: HEX.decode(abiHex)
    ),
  );
  return HEX.encode(signed);

   */
}
