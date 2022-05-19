import 'dart:convert';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart' as StringUtil;
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart';
import 'package:web3dart/crypto.dart' as CryptoWeb3;
import 'package:crypto/crypto.dart' as CryptoHash;
// import 'trx_generate_address_util.dart' as TrxUtil;
import 'package:fixnum/fixnum.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:exchangilymobileapp/protos_gen/any.pb.dart';
import 'package:exchangilymobileapp/protos_gen/protos/tron.pb.dart' as Tron;

import '../custom_http_util.dart';

Future generateTrxTransactionContract(
    {@required Uint8List privateKey,
    @required String fromAddr,
    @required String toAddr,
    @required Decimal amount,
    @required bool isTrxUsdt,
    @required String tickerName,
    @required bool isBroadcast}) async {
  int decimal = 0;

  String contractAddress = '';
  final tokenListDatabaseService = locator<TokenInfoDatabaseService>();
  final apiService = locator<ApiService>();
  List<int> fromAddress = bs58check.decode(fromAddr);

  // debugPrint('base58 fromAddress to Hex ${StringUtil.uint8ListToHex(fromAddress)}');
  List<int> toAddress = bs58check.decode(toAddr);
  // debugPrint(
  //    'base58 address toAddress to hex ${StringUtil.uint8ListToHex(toAddress)}');
  // 4103b01c144f4e41c22b411c2997fbcdfae4fc9c2e
  var amount1e6 = amount * Decimal.parse(1e6.toString());
  var amountToBigInt = NumberUtil.decimalToBigInt(amount1e6);
  Int64 bigIntAmountToInt64 = Int64.parseInt(amountToBigInt.toString());

  // debugPrint('original amount - $amount and int64 res $bigIntAmountToInt64');

  GeneratedMessage trans;

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
          //   debugPrint('token from token database ${token.toJson()}');
        } else {
          await apiService.getTokenListUpdates().then((tokenList) {
            for (var token in tokenList) {
              if (token.tickerName == 'USDTX') {
                contractAddress = token.contract;
                decimal = token.decimal;
                //  debugPrint('token from api ${token.toJson()}');
              }
            }
          });
        }
      });
    }
    //  debugPrint('contract address $contractAddress');
  }
  if (isTrxUsdt) {
    var transferAbi = Constants.DepositTronUsdtSignatureAbi;
    var decodedHexToAddress = StringUtil.uint8ListToHex(toAddress);
// 4103b01c144f4e41c22b411c2997fbcdfae4fc9c2e
    if (decodedHexToAddress.startsWith('41') ||
        decodedHexToAddress.startsWith('0x')) {
      decodedHexToAddress = decodedHexToAddress.substring(2);
      //03b01c144f4e41c22b411c2997fbcdfae4fc9c2e
    }
    // if address length is > 20 bytes then trim checksum(last 8 bytes)
    if (decodedHexToAddress.length > 40) {
      //  debugPrint(
      //      ' decodedHexToAddress.length ${decodedHexToAddress.length} is more than 40');
      int difference = decodedHexToAddress.length - 40;
      decodedHexToAddress = decodedHexToAddress.substring(
          0, decodedHexToAddress.length - difference);
    }
    var dataToAddress = StringUtil.fixLength(decodedHexToAddress, 64);
    // 00000000000000000000000003b01c144f4e41c22b411c2997fbcdfae4fc9c2e
    //  debugPrint('dataToAddress ${dataToAddress.length} -- $dataToAddress');

// AMOUNT
    var hexDataAmount = NumberUtil().intToHex(amountToBigInt);
    var dataAmount = StringUtil.fixLength(hexDataAmount.toString(), 64);
// 00000000000000000000000000000000000000000000000000000000002dc6c0
    //   debugPrint('dataAmount ${dataAmount.length} -- $dataAmount');
    //   debugPrint('bigint amount $amountToBigInt -- hex amount $dataAmount');
    var data = transferAbi + dataToAddress + dataAmount;
    //   debugPrint('data $data');

// Trigger Smart Contract
    trans = Tron.TriggerSmartContract(
      data: StringUtil.hexToBytes(data),
      ownerAddress: fromAddress,
      //  hex address for contract address in config for trx-usdt
      contractAddress: StringUtil.hexToUint8List(contractAddress),
    );
  } else {
    //  debugPrint('in else $fromAddress -- $toAddress -- $bigIntAmountToInt64 ');
    trans = Tron.TransferContract(
        ownerAddress: fromAddress,
        toAddress: toAddress,
        amount: bigIntAmountToInt64);
  }
  // debugPrint('trans $trans');
//buf, _ := proto.Marshal(&trans)
  var transToUint8List = trans.writeToBuffer();
  //debugPrint('transToUint8List $transToUint8List');
  var buf = Tron.TransferContract.fromBuffer(transToUint8List);

  //debugPrint('buf $buf');

  var parameter = Any.pack(
    buf,
    // typeUrlPrefix: "type.googleapis.com/protocol",
  );
  var transferContractType = isTrxUsdt
      ? Tron.Transaction_Contract_ContractType.TriggerSmartContract
      : Tron.Transaction_Contract_ContractType.TransferContract;

  parameter.typeUrl =
      Constants.DepositTronTypeProtocol + transferContractType.toString();

  //debugPrint('PARAMETER $parameter');

  Tron.Transaction_Contract contract = Tron.Transaction_Contract();
  contract.parameter = parameter;

  contract.type = transferContractType;
  // debugPrint('contract -- $contract');

  var contractBuffer = contract.writeToBuffer();
  var contractBufferToHex = StringUtil.uint8ListToHex(contractBuffer);
  // debugPrint('contractBufferToHex $contractBufferToHex');
  // gen raw tx
  var res = _generateTrxRawTransaction(
      contract: contract,
      privateKey: privateKey,
      isTrxUsdt: isTrxUsdt,
      isBroadcast: isBroadcast);
  return res;
}

// sendTrxTx(rawTx, ret, signature) {
//   var transaction =
//       Tron.Transaction(rawData: rawTx, ret: [], signature: signature);
//   var txBuffer = transaction.writeToBuffer();
//   var txBufferHex = StringUtil.uint8ListToHex(txBuffer);

//   debugPrint('txBufferHex ${txBufferHex}');
// }

/*----------------------------------------------------------------------
                  Raw Transaction
----------------------------------------------------------------------*/
_generateTrxRawTransaction(
    {@required Tron.Transaction_Contract contract,
    @required Uint8List privateKey,
    @required bool isTrxUsdt,
    @required bool isBroadcast}) async {
  ApiService apiService = locator<ApiService>();
// txRaw.SetRefBlockHash(blkhash)
// txRaw.SetRefBlockBytes(blk.BlockHeader.Raw.Number)
// txRaw.SetExpiration(blk.BlockHeader.Raw.Timestamp + 1 * 60 * 60 * 1000 + int64(i) ) // 1 hours
// txRaw.SetTimestamp(time.Now().UnixNano() / 1000000)

  var refBlockHash;
  List<int> refBlockBytes;
  Int64 expiration;
  Int64 timestamp;

// block_header: {
// raw_data: {
// number: 28284944,
// txTrieRoot: "92dc4143f5aa2fbb3dcfb121fd1649231deb6d9e7a462b5cf110949971b7038d",
// witness_address: "4114f2c09d3de3fe82a71960da65d4935a30b24e1f",
// parentHash: "0000000001af980f8f5be0a6faffaeac4aab182e0041b681a570fd22dfe08e66",
// version: 20,
// timestamp: 1615246092000
// },

  await apiService.getTronLatestBlock().then((res) {
    var blockHash =
        //'0000000001b2a1380ab6f5081d4388499fa9dbb0d4c7d7b70478fbd6c661cfdd';
        res['blockID'];
    var timestampOfLatestBlock = //1615843515000;
        res['block_header']['raw_data']['timestamp'];
    var blockNumber = //28483896;
        res['block_header']['raw_data']['number'];
    // debugPrint(
    //     'BLOCK HASH $blockHash -- Time stamp of latest block $timestampOfLatestBlock -- block number $blockNumber');
    refBlockHash = calculateTrxRwTxRefBlockHash(blockHash);
    refBlockBytes = calculateTrxRawTxRefBlockBytes(blockNumber);
    timestamp = calculateTrxRwTxInt64Timestamp();
    expiration = calculateTrxRwTxExpiration(timestampOfLatestBlock);
  });
  List<Tron.Transaction_Contract> contractList = [];
  contractList.add(contract);
  Tron.Transaction_raw rawTx;
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

  //debugPrint('txRaw ${rawTx.writeToJson()}');
  Uint8List txRawBuffer = rawTx.writeToBuffer();
  //debugPrint('txRawBuffer $txRawBuffer');
  // String rawTxBufferToHex = StringUtil.uint8ListToHex(txRawBuffer);
//  debugPrint('txRawBufferToHex $rawTxBufferToHex');
  var hashedRawTxBuffer = CryptoHash.sha256.convert(txRawBuffer);
  // debugPrint('hashedRawTxBuffer $hashedRawTxBuffer');

  // CryptoWeb3.MsgSignature
  var signature = //CryptoWeb3.sign(hashedRawTxBuffer.bytes, privateKey);
      CoinUtils().signTrxTx(hashedRawTxBuffer.bytes, privateKey);
  //signTrxTx(keyPair, digest1.bytes);
  // var rsvInList = constructTrxSigntureList(signature);
  // fill transaction object
  //  sendTrxTx(rawTx, [], signature);
  //debugPrint('signature $signature');
  var transaction =
      Tron.Transaction(rawData: rawTx, ret: [], signature: signature);
  var txBuffer = transaction.writeToBuffer();
  var rawTxBufferHex = StringUtil.uint8ListToHex(txBuffer);

  // debugPrint('txBufferHex $rawTxBufferHex');

  var broadcastTronTransactionRes;
  if (isBroadcast) {
    broadcastTronTransactionRes =
        await broadcastTronTransaction(rawTxBufferHex);
  }

  return {
    "broadcastTronTransactionRes": broadcastTronTransactionRes,
    "rawTxBufferHexAfterSign": rawTxBufferHex,
    "hashedRawTxBufferBeforeSign": hashedRawTxBuffer
  };
}

/*----------------------------------------------------------------------
                Broadcast Transaction
----------------------------------------------------------------------*/

Future broadcastTronTransaction(transactionHex) async {
  var httpClient = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  Map<String, dynamic> body = {"transaction": transactionHex};
  // debugPrint(
  //    'broadcasrTronTransaction $BroadcasrTronTransactionUrl -- body ${jsonEncode(body)}');
  try {
    var response = await httpClient.post(broadcasrTronTransactionUrl,
        body: jsonEncode(body));
    var json = jsonDecode(response.body);
    if (json != null) {
      debugPrint('broadcastTronTransaction $json}');
      return json;
    }
  } catch (err) {
    debugPrint('broadcastTronTransaction CATCH $err');
    throw Exception(err);
  }
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
  // debugPrint('bytesBuilder ${bytesBuilder.toBytes()}');

  // Uint8List.fromList(vIntList);
  List<Uint8List> rsvList = [];
  rsvList.add(bytesBuilder.toBytes());
  // debugPrint('rsvList $rsvList');
  return rsvList.toList();
}

// timestamp
Int64 calculateTrxRwTxInt64Timestamp() {
  var res = Int64.parseInt(DateTime.now().millisecondsSinceEpoch.toString());
  // debugPrint('calculateTrxRwTxInt64Timestamp res $res');
  return res;
}

// expiration
Int64 calculateTrxRwTxExpiration(int timestamp) {
  var v = timestamp + 1 * 60 * 60 * 1000; // + Int64(i)
  var res = Int64.parseInt(v.toString());
  // debugPrint('calculateTrxRwTxExpiration res $res');
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
  // debugPrint('source $source');
  var hexBlockNumber = source.toRadixString(16);
//  debugPrint('hexBlockNumber $hexBlockNumber');
  var length = hexBlockNumber.length;
  var last4BytesHexBlockNumber = hexBlockNumber.substring(length - 4);
//  debugPrint('last4Bytes $last4BytesHexBlockNumber');

//  debugPrint(Endian.host == Endian.little);
  res = StringUtil.hexToUint8List(last4BytesHexBlockNumber);

  debugPrint('res $res');
  return res;
}

// blockHash is hash[8:16] of latest block.
// take first 8 or last 8 bytes from 16 bytes
calculateTrxRwTxRefBlockHash(blockHash) {
  var x = StringUtil.hexToUint8List(blockHash);
  // debugPrint('x $x');
  var last8Bytes = x.sublist(8, 16);
  // debugPrint('last8Bytes $last8Bytes');
  var refBlockHashInHex = StringUtil.uint8ListToHex(last8Bytes);
//  debugPrint('refBlockHashInHex $refBlockHashInHex');
  return last8Bytes;
}
