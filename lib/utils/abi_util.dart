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
import './string_util.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/src/utils/rlp.dart' as rlp;
import 'dart:typed_data';

// {"success":true,"data":{"transactionID":"3ba8d681cddea5376c9b6ab2963ff243160fa086ec0681a67a3206ad80284d76"}}

getWithdrawFuncABI(coinType, amountInLink, addressInWallet) {
  var abiHex = "3295d51e";
  abiHex += fixLength(coinType.toString(), 64);

  var amountHex = amountInLink.toRadixString(16);
  abiHex += fixLength(trimHexPrefix(amountHex), 64);

  abiHex += fixLength(trimHexPrefix(addressInWallet), 64);
  return abiHex;
}

getDepositFuncABI(int coinType, String txHash, BigInt amountInLink,
    String addressInKanban, signedMessage) {
  var abiHex = "379eb862";
  abiHex += trimHexPrefix(signedMessage["v"]);
  abiHex += fixLength(coinType.toString(), 62);
  abiHex += trimHexPrefix(txHash);
  var amountHex = amountInLink.toRadixString(16);

  abiHex += fixLength(amountHex, 64);
  abiHex += fixLength(trimHexPrefix(addressInKanban), 64);
  abiHex += trimHexPrefix(signedMessage["r"]);
  abiHex += trimHexPrefix(signedMessage["s"]);
  return abiHex;
}

getCreateOrderFuncABI(
    bool bidOrAsk,
    int orderType,
    int baseCoin,
    int targetCoin,
    BigInt qty,
    BigInt price,
    int timeBeforeExpiration,
    bool payWithEXG,
    String orderHash) {
  /*
 0x12a3da170000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000002386f26fc10000000000000000000000000000000000000000000000000000002386f26fc100000000000000000000000000000000000000000000000000000000006296a75020000000000000000000000000000000000000000000000000000000000000000006e328d04a77db9be48be26004e8eb87ccb4432839a10bdff4112a2bffdb3821
   */
  var abiHex = '12a3da17';
  var bidOrAskString = bidOrAsk ? '1' : '0';
  abiHex += fixLength(bidOrAskString, 64);
  abiHex += fixLength(orderType.toString(), 64);
  abiHex += fixLength(baseCoin.toString(), 64);
  abiHex += fixLength(targetCoin.toString(), 64);
  var qtyHex = qty.toRadixString(16);
  abiHex += fixLength(qtyHex, 64);
  var priceHex = price.toRadixString(16);
  abiHex += fixLength(priceHex, 64);
  abiHex += fixLength(timeBeforeExpiration.toString(), 64);
  var payWithEXGString = payWithEXG ? '1' : '0';
  abiHex += fixLength(payWithEXGString, 64);
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

Future signAbiHexWithPrivateKey(String abiHex, String privateKey, String coinPoolAddress, int nonce) async{

  var chainId = environment["chains"]["KANBAN"]["chainId"];
  //var apiUrl = "https://ropsten.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef"; //Replace with your API

  //var httpClient = new http.Client();

  abiHex = trimHexPrefix(abiHex);
  //var ethClient = new Web3Client(apiUrl, httpClient);
  var credentials = new EthPrivateKey.fromHex(privateKey);

  var transaction = Transaction(
      to: EthereumAddress.fromHex(coinPoolAddress),
      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 6),
      maxGas: 20000000,
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
