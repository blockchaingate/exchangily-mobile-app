import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:keccak/keccak.dart';
import 'package:hex/hex.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../environments/environment.dart';
import 'dart:async';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';

final String ethBaseUrl = environment["endpoints"]["eth"];
getTransactionHash(Uint8List signTransaction) {
  var p = keccak(signTransaction);
  var hash = "0x" + HEX.encode(p);
  return hash;
}

Future getEthTransactionStatus(String txid) async {
  var url = ethBaseUrl + 'gettransactionstatus/' + txid;
  var client = new http.Client();
  var response = await client.get(url);
  return response;
}

getEthNode(root, {index = 0}) {
  var node = root.derivePath("m/44'/" +
      environment["CoinType"]["ETH"].toString() +
      "'/0'/0/" +
      index.toString());
  return node;
}

getEthAddressForNode(node) async {
  var privateKey = node.privateKey;

  Credentials credentials = EthPrivateKey.fromHex(HEX.encode(privateKey));

  final address = await credentials.extractAddress();

  var ethAddress = address.hex;
  return ethAddress;
}

Future getEthBalanceByAddress(String address) async {
  var url = ethBaseUrl + 'getbalance/' + address;
  var ethBalance = 0.0;
  try {
    var response = await http.get(url);
    Map<String, dynamic> balance = jsonDecode(response.body);
    ethBalance = bigNum2Double(balance['balance']);
  } catch (e) {}
  return {'balance': ethBalance, 'lockbalance': 0.0};
}

Future getEthTokenBalanceByAddress(String address, String coinName) async {
  var smartContractAddress =
      environment["addresses"]["smartContract"][coinName];
  var url = ethBaseUrl + 'callcontract/' + smartContractAddress + '/' + address;
  var tokenBalance = 0.0;
  try {
    var response = await http.get(url);
    var balance = jsonDecode(response.body);

    tokenBalance = double.parse(balance['balance']) / 1e6;
  } catch (e) {}
  return {'balance': tokenBalance, 'lockbalance': 0.0};
}
