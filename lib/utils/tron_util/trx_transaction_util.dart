import 'dart:convert';
import 'dart:typed_data';

import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart' as StringUtil;
import 'package:flutter/material.dart';
import 'package:web3dart/crypto.dart' as CryptoWeb3;
import 'package:crypto/crypto.dart' as CryptoHash;
import 'trx_generate_address_util.dart' as TrxUtil;
import 'package:fixnum/fixnum.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:exchangilymobileapp/protos_gen/any.pb.dart';
import 'package:exchangilymobileapp/protos_gen/protos/tron.pb.dart' as Tron;
import 'package:exchangilymobileapp/utils/coin_util.dart' as CoinUtil;
import 'package:http/http.dart' as http;

Future broadcastTronTransaction(transactionHex) async {
  final client = new http.Client();
  Map<String, dynamic> body = {"transaction": transactionHex};
  print(
      'broadcasrTronTransaction $BroadcasrTronTransactionUrl -- body ${jsonEncode(body)}');
  try {
    var response =
        await client.post(BroadcasrTronTransactionUrl, body: jsonEncode(body));
    var json = jsonDecode(response.body);
    if (json != null) {
      print('broadcastTronTransaction $json}');
      return json;
    }
  } catch (err) {
    print('broadcastTronTransaction CATCH $err');
    throw Exception(err);
  }
}

generateTrxTransactionContract(String fromAddr, String toAddr, double amount,
    {bool isTrxUsdt = false, tickerName = 'TRX'}) async {
  int decimal = 0;

  String contractAddress = '';
  final tokenListDatabaseService = locator<TokenListDatabaseService>();
  final apiService = locator<ApiService>();
  List<int> fromAddress = bs58check.decode(fromAddr);
  //utf8.encode(fromAddr);
  print(fromAddress);
  List<int> toAddress = bs58check.decode(toAddr);
  print(
      'base58 address toAddress to hex ${StringUtil.uint8ListToHex(toAddress)}');
  // 4103b01c144f4e41c22b411c2997fbcdfae4fc9c2e

  var amountToBigInt = BigInt.from(amount * 1e6);
  Int64 bigIntAmountToInt64 = Int64.parseInt(amountToBigInt.toString());

  print('original amount - $amount and int64 res $bigIntAmountToInt64');

  var trans;

//   TriggerSmartContract{
//    OwnerAddress: fromaddr,
//    ContractAddress:  contractAddrBytes[:21],
//    Data:       data,
// }

  if (isTrxUsdt) {
    // get trx-usdt contract address
    contractAddress = environment["addresses"]["smartContract"][tickerName];
    if (contractAddress == null) {
      await tokenListDatabaseService
          .getByTickerName(tickerName)
          .then((token) async {
        if (token != null) {
          contractAddress = token.contract;
          decimal = token.decimal;
          print('token from token database ${token.toJson()}');
        } else {
          await apiService.getTokenListUpdates().then((tokenList) {
            tokenList.forEach((token) {
              if (token.tickerName == 'USDTX') {
                contractAddress = token.contract;
                decimal = token.decimal;
                print('token from api ${token.toJson()}');
              }
            });
          });
        }
      });
    }
    print('contract address $contractAddress');
  }
  if (isTrxUsdt) {
    var transferAbi = 'a9059cbb';
    var decodedHexToAddress = StringUtil.uint8ListToHex(toAddress);
// 4103b01c144f4e41c22b411c2997fbcdfae4fc9c2e
    if (decodedHexToAddress.startsWith('41') ||
        decodedHexToAddress.startsWith('0x')) {
      decodedHexToAddress = decodedHexToAddress.substring(2);
      //03b01c144f4e41c22b411c2997fbcdfae4fc9c2e
    }
    // if address length is > 20 bytes then trim checksum(last 8 bytes)
    if (decodedHexToAddress.length > 40) {
      print(
          ' decodedHexToAddress.length ${decodedHexToAddress.length} is more than 40');
      int difference = decodedHexToAddress.length - 40;
      decodedHexToAddress = decodedHexToAddress.substring(
          0, decodedHexToAddress.length - difference);
    }
    var dataToAddress = StringUtil.fixLength(decodedHexToAddress, 64);
    // 00000000000000000000000003b01c144f4e41c22b411c2997fbcdfae4fc9c2e
    print('dataToAddress ${dataToAddress.length} -- $dataToAddress');

// AMOUNT
    var hexDataAmount = NumberUtil().intToHex(amountToBigInt);
    var dataAmount = StringUtil.fixLength(
       hexDataAmount.toString(), 64);
// 00000000000000000000000000000000000000000000000000000000002dc6c0
    print('dataAmount ${dataAmount.length} -- $dataAmount');
    print('bigint amount $amountToBigInt -- hex amount $dataAmount');
    var data = transferAbi + dataToAddress + dataAmount;
    print('data $data');

// Trigger Smart Contract
    trans = Tron.TriggerSmartContract(
      data: StringUtil.hexToBytes(data),
      ownerAddress: fromAddress,
      //  hex address for contract address in config for trx-usdt
      contractAddress: StringUtil.hexToUint8List(contractAddress),
    );
  } else
    Tron.TransferContract(
        ownerAddress: fromAddress,
        toAddress: toAddress,
        amount: bigIntAmountToInt64);
  print('trans $trans');
//buf, _ := proto.Marshal(&trans)
  var transToUint8List = trans.writeToBuffer();
  //print('transToUint8List $transToUint8List');
  var buf = Tron.TransferContract.fromBuffer(transToUint8List);

  //print('buf $buf');

  var parameter = Any.pack(
    buf,
    // typeUrlPrefix: "type.googleapis.com/protocol",
  );
  var transferContractType = isTrxUsdt
      ? Tron.Transaction_Contract_ContractType.TriggerSmartContract
      : Tron.Transaction_Contract_ContractType.TransferContract;

  parameter.typeUrl =
      "type.googleapis.com/protocol." + transferContractType.toString();

  print('PARAMETER $parameter');

  Tron.Transaction_Contract contract = new Tron.Transaction_Contract();
  contract.parameter = parameter;

  contract.type = transferContractType;
  print('contract -- $contract');

  var contractBuffer = contract.writeToBuffer();
  var contractBufferToHex = StringUtil.uint8ListToHex(contractBuffer);
  debugPrint('contractBufferToHex $contractBufferToHex');
  // gen raw tx
  generateTrxRawTransaction(contract, isTrxUsdt: true);
}

sendTrxTx(rawTx, ret, signature) {
  var transaction =
      Tron.Transaction(rawData: rawTx, ret: [], signature: signature);
  var txBuffer = transaction.writeToBuffer();
  var txBufferHex = StringUtil.uint8ListToHex(txBuffer);

  print('txBufferHex ${txBufferHex}');
}

/*----------------------------------------------------------------------
                  Raw Transaction
----------------------------------------------------------------------*/
generateTrxRawTransaction(Tron.Transaction_Contract contract,
    {bool isTrxUsdt = false}) async {
  ApiService _apiService = locator<ApiService>();
// txRaw.SetRefBlockHash(blkhash)
// txRaw.SetRefBlockBytes(blk.BlockHeader.Raw.Number)
// txRaw.SetExpiration(blk.BlockHeader.Raw.Timestamp + 1 * 60 * 60 * 1000 + int64(i) ) // 1 hours
// txRaw.SetTimestamp(time.Now().UnixNano() / 1000000)

  var refBlockHash;
  var refBlockBytes;
  var expiration;
  var timestamp;

// block_header: {
// raw_data: {
// number: 28284944,
// txTrieRoot: "92dc4143f5aa2fbb3dcfb121fd1649231deb6d9e7a462b5cf110949971b7038d",
// witness_address: "4114f2c09d3de3fe82a71960da65d4935a30b24e1f",
// parentHash: "0000000001af980f8f5be0a6faffaeac4aab182e0041b681a570fd22dfe08e66",
// version: 20,
// timestamp: 1615246092000
// },

  await _apiService.getTronLatestBlock().then((res) {
    var blockHash =
        //'0000000001b2a1380ab6f5081d4388499fa9dbb0d4c7d7b70478fbd6c661cfdd';
        res['blockID'];
    var timestampOfLatestBlock = //1615843515000;
        res['block_header']['raw_data']['timestamp'];
    var blockNumber = //28483896;
        res['block_header']['raw_data']['number'];
    print(
        'BLOCK HASH $blockHash -- Time stamp of latest block $timestampOfLatestBlock -- block number $blockNumber');
    refBlockHash = calculateTrxRwTxRefBlockHash(blockHash);
    refBlockBytes = calculateTrxRawTxRefBlockBytes(blockNumber);
    timestamp = calculateTrxRwTxInt64Timestamp();
    expiration = calculateTrxRwTxExpiration(timestampOfLatestBlock);
  });
  List<Tron.Transaction_Contract> contractList = [];
  contractList.add(contract);
  var rawTx;
  // if trx usdt then add fee limit of 15 trx
  int feeLimit = 15000000;
  isTrxUsdt
      ? rawTx = Tron.Transaction_raw(
          feeLimit: Int64.parseInt(feeLimit.toString()),
          contract: contractList,
          refBlockHash: refBlockHash,
          refBlockBytes: refBlockBytes,
          expiration: expiration,
          timestamp: timestamp)
      : rawTx = Tron.Transaction_raw(
          contract: contractList,
          refBlockHash: refBlockHash,
          refBlockBytes: refBlockBytes,
          expiration: expiration,
          timestamp: timestamp);

  debugPrint('txRaw ${rawTx.writeToJson()}');
  var txRawBuffer = rawTx.writeToBuffer();
  debugPrint('txRawBuffer $txRawBuffer');
  var txRawBufferToHex = StringUtil.uint8ListToHex(txRawBuffer);
  debugPrint('txRawBufferToHex $txRawBufferToHex');
  var hashedRawTxBuffer = CryptoHash.sha256.convert(txRawBuffer);
  print('hashedRawTxBuffer $hashedRawTxBuffer');
  String mnemonic =
      "expire grid drift mosquito cupboard gloom depart veteran volcano indoor olympic century";
  var privateKey = TrxUtil.generateTrxPrivKey(mnemonic);
  // address gen by the priv key TWxNjGUkn2Dc6Avh9zZy8thMt5mBqVWjnP
  print('priv key hex ${StringUtil.uint8ListToHex(privateKey)}');
  // var keyPair = ECPair.fromPrivateKey(privateKey);
  // print('keypair ${uint8ListToHex(keyPair.privateKey)}');

  // CryptoWeb3.MsgSignature
  var signature = //CryptoWeb3.sign(hashedRawTxBuffer.bytes, privateKey);
      CoinUtil.signTrxTx(hashedRawTxBuffer.bytes, privateKey);
  //signTrxTx(keyPair, digest1.bytes);
  // var rsvInList = constructTrxSigntureList(signature);
  // fill transaction object
  //  sendTrxTx(rawTx, [], signature);

  var transaction =
      Tron.Transaction(rawData: rawTx, ret: [], signature: signature
          //rsvInList
          );
  var txBuffer = transaction.writeToBuffer();
  var txBufferHex = StringUtil.uint8ListToHex(txBuffer);

  print('txBufferHex ${txBufferHex}');
  broadcastTronTransaction(txBufferHex);
}

/*----------------------------------------------------------------------
                Construct Signture List
----------------------------------------------------------------------*/

List<Uint8List> constructTrxSigntureList(CryptoWeb3.MsgSignature signature) {
  // List<int> vIntList = [];
  // vIntList.add(signature.v);

  var bytesBuilder = BytesBuilder();
  var r = CryptoWeb3.intToBytes(signature.r);
  bytesBuilder.add(r);
  var s = CryptoWeb3.intToBytes(signature.s);
  bytesBuilder.add(s);
  var v = CryptoWeb3.intToBytes(BigInt.from(signature.v - 27));
  if (signature.v == 0) {
    v = Uint8List.fromList([0].toList());
  }
  bytesBuilder.add(v);
  print('bytesBuilder ${bytesBuilder.toBytes()}');

  // Uint8List.fromList(vIntList);
  List<Uint8List> rsvList = [];
  rsvList.add(bytesBuilder.toBytes());
  print('rsvList $rsvList');
  return rsvList.toList();
}

// timestamp
Int64 calculateTrxRwTxInt64Timestamp() {
  var res = Int64.parseInt(DateTime.now().millisecondsSinceEpoch.toString());
  print('calculateTrxRwTxInt64Timestamp res $res');
  return res;
}

// expiration
Int64 calculateTrxRwTxExpiration(int timestamp) {
  var v = timestamp + 1 * 60 * 60 * 1000; // + Int64(i)
  var res = Int64.parseInt(v.toString());
  print('calculateTrxRwTxExpiration res $res');
  return res;
}

// block bytes has 2 bytes
// turn latest block number into little endian uint64
// which has 8 bytes
// take highest 2 bytes and assign to RefBlockBytes
// these were your instruction and i kept on converting it to little endian which in dart i need to use bytedata
List<int> calculateTrxRawTxRefBlockBytes(int source) {
  var res;
  //source = 28333801;
  print('source $source');
  var hexBlockNumber = source.toRadixString(16);
  print('hexBlockNumber $hexBlockNumber');
  var length = hexBlockNumber.length;
  var last4BytesHexBlockNumber = hexBlockNumber.substring(length - 4);
  print('last4Bytes $last4BytesHexBlockNumber');

  print(Endian.host == Endian.little);
  res = StringUtil.hexToUint8List(last4BytesHexBlockNumber);

  print('res $res');
  return res;
}

// blockHash is hash[8:16] of latest block.
// take first 8 or last 8 bytes from 16 bytes
calculateTrxRwTxRefBlockHash(blockHash) {
  var x = StringUtil.hexToUint8List(blockHash);
  print('x $x');
  var last8Bytes = x.sublist(8, 16);
  print('last8Bytes $last8Bytes');
  var refBlockHashInHex = StringUtil.uint8ListToHex(last8Bytes);
  print('refBlockHashInHex $refBlockHashInHex');
  return last8Bytes;
}
