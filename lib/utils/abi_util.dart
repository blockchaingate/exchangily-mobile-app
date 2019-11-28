import './string_util.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

getDepositFuncABI(int coinType, String txHash, BigInt amountInLink, String addressInKanban, signedMessage) {
  var abiHex = "a9059cbb";
  abiHex += trimHexPrefix(signedMessage.v.toString());
  abiHex += fixLength(coinType.toString(), 62);
  abiHex += trimHexPrefix(txHash);
  var amountHex = amountInLink.toRadixString(16);
  abiHex += fixLength(amountHex, 64);
  abiHex += fixLength(trimHexPrefix(addressInKanban), 64);
  abiHex += trimHexPrefix(signedMessage.r.toString());
  abiHex += trimHexPrefix(signedMessage.s.toString());
  return abiHex;
}

Future signAbiHexWithPrivateKey(String abiHex, String privateKey, String coinPoolAddress, int nonce) async{

  var apiUrl = "https://ropsten.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef"; //Replace with your API

  var httpClient = new http.Client();

  abiHex = trimHexPrefix(abiHex);
  var ethClient = new Web3Client(apiUrl, httpClient);
  var credentials = await ethClient.credentialsFromPrivateKey(privateKey);
  var signed = await ethClient.signTransaction(
    credentials,
    Transaction(
      to: EthereumAddress.fromHex(coinPoolAddress),
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 100000,
      nonce: nonce,
      data: stringToUint8List(abiHex)
    ),
  );
  return signed;
}