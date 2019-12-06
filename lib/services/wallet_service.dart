import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bitcoin_flutter/src/models/networks.dart';
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:bitcoin_flutter/src/transaction_builder.dart';
import 'package:bitcoin_flutter/src/ecpair.dart';
import 'package:bitcoin_flutter/src/utils/script.dart' as script;
import 'package:hex/hex.dart';
import "package:pointycastle/pointycastle.dart";
import "package:pointycastle/digests/sha256.dart";
import 'package:flutter/foundation.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:logger/logger.dart';
import 'dart:developer' as developer;
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; //You can also import the browser version
import 'package:web3dart/web3dart.dart';
import "package:pointycastle/pointycastle.dart";
import 'package:http/http.dart' as http;
import '../shared/globals.dart' as globals;

import 'models.dart';

class WalletService {
  static final randomMnemonic =
      'culture sound obey clean pretty medal churn behind chief cactus alley ready';
  static final seed = bip39.mnemonicToSeed(randomMnemonic);
  static final root = bip32.BIP32.fromSeed(seed);
  static final bitCoinChild = root.derivePath("m/44'/1'/0'/0/0");
  static final ethCoinChild = root.derivePath("m/44'/60'/0'/0/0");
  static final fabCoinChild = root.derivePath("m/44'/1150'/0'/0/0");
  final fabPublicKey = fabCoinChild.publicKey;
  final privateKey = HEX.encode(ethCoinChild.privateKey);
  final client = new http.Client();

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

  String randonMnemonic = bip39.generateMnemonic();
  String ticker;
  List<WalletInfo> _walletInfo;

  static String btcApiUrl = "https://btctest.fabcoinapi.com/";
  static String fabApiUrl = "https://fabtest.fabcoinapi.com/";
  static String ethApiUrl = "https://ethtest.fabcoinapi.com/";

  List<CoinType> _childrens = [
    CoinType('btc', bitCoinChild, btcApiUrl),
    CoinType('fab', fabCoinChild, fabApiUrl)
  ];

  // Get All Balances

  Future<List<WalletInfo>> getAllBalances() async {
    try {
      _childrens.map((f) => {getAddress(f, testnet)});

      await getBtcBalance();
      await getFabBalance();
      //await getExgBalance();

      return _walletInfo;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Get Btc balance

  getBtcBalance() async {
    btcAddress = getAddress(bitCoinChild, testnet);
    var url = btcApiUrl + 'getbalance/' + btcAddress;
    print(url);
    var response = await client.get(url);
    btcBalance = double.parse(response.body) / 1e8;
    _walletInfo = [
      WalletInfo('btc', btcAddress, btcBalance, 12345.214, globals.primaryColor,
          'bitcoin')
    ];
  }

// Get Fab Balance

  getFabBalance() async {
    fabAddress = getAddress(fabCoinChild, testnet);
    var url = fabApiUrl + 'getbalance/' + fabAddress;
    print(url);
    var response = await client.get(url);
    fabBalance = double.parse(response.body) / 1e8;
    _walletInfo.add(WalletInfo('fab', fabAddress, fabBalance, 214212.112,
        globals.fabLogoColor, 'fast access blockchain'));
  }

  // Get Exg Balance

  getExgBalance() async {
    var exgSmartContractAddress = '0x867480ba8e577402fa44f43c33875ce74bdc5df6';
    var body = {
      'address': this.trimHexPrefix(exgSmartContractAddress),
      'data': '70a08231' + this.fixLength(this.trimHexPrefix(exgAddress), 64)
    };
    var response = await client.post('$fabApiUrl + callcontract', body: body);
    var json = jsonDecode(response.body);
    var unlockBalance = json['executionResult']['output'];
    var unlockInt = int.parse("0x$unlockBalance");
    exgBalance = unlockInt / 1e18;
    _walletInfo.add(WalletInfo('exg', exgSmartContractAddress, exgBalance,
        34212.782, globals.exgLogoColor, 'exchangily'));
  }

  Future<int> addGas() async {
    return 0;
  }

  String getAddress(node, [network]) {
    return P2PKH(data: new P2PKHData(pubkey: node.publicKey), network: network)
        .data
        .address;
  }

  convertLiuToFabcoin(amount) {
    return (amount * 1e-8);
  }

  fixLength(String str, int length) {
    var retStr = '';
    int len = str.length;
    int len2 = length - len;
    if (len2 > 0) {
      for (int i = 0; i < len2; i++) {
        retStr += '0';
      }
    }
    retStr += str;
    return retStr;
  }

  trimHexPrefix(String str) {
    if (str.startsWith('0x')) {
      str = str.substring(2);
    }
    return str;
  }

  number2Buffer(num) {
    var buffer = new List<int>();
    var neg = (num < 0);
    num = num.abs();
    while (num > 0) {
      print('num=');
      print(num);
      print(buffer.length);
      print(num & 0xff);
      buffer.add(num & 0xff);
      print('buffer=');
      print(buffer);
      num = num >> 8;
    }

    var top = buffer[buffer.length - 1];
    if (top & 0x80 != 0) {
      buffer.add(neg ? 0x80 : 0x00);
    } else if (neg) {
      buffer.add(top | 0x80);
    }
    return buffer;
  }

  hex2Buffer(hexString) {
    var buffer = new List<int>();
    for (var i = 0; i < hexString.length; i += 2) {
      var val = (int.parse(hexString[i], radix: 16) << 4) |
          int.parse(hexString[i + 1], radix: 16);
      buffer.add(val);
    }
    return buffer;
  }

  getFabUtxos(String address) async {
    var url = fabApiUrl + 'getutxos/' + address;
    print(url);
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }

  getBtcUtxos(String address) async {
    var url = btcApiUrl + 'getutxos/' + address;
    print(url);
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }

  postBtcTx(String txHex) async {
    var url = btcApiUrl + 'sendrawtransaction/' + txHex;
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    var txHash = '';
    var errMsg = '';
    print('json=');
    print(json);
    if (json != null) {
      if (json['txid'] != null) {
        txHash = '0x' + json['txid'];
      } else if (json['Error'] != null) {
        errMsg = json['Error'];
      }
    }
    return {'txHash': txHash, 'errMsg': errMsg};
  }

  getFabTransactionJson(String txid) async {
    txid = trimHexPrefix(txid);
    var url = fabApiUrl + 'gettransactionjson/' + txid;
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }

  isFabTransactionLocked(String txid, int idx) async {
    if (idx != 0) {
      return false;
    }
    var response = await getFabTransactionJson(txid);

    if ((response['vin'] != null) && (response['vin'].length > 0)) {
      var vin = response['vin'][0];
      if (vin['coinbase'] != null) {
        if (response['onfirmations'] <= 800) {
          return true;
        }
      }
    }
    return false;
  }

  postEthTx(String txHex) async {
    var url = ethApiUrl + 'sendsignedtransaction';
    var data = {'signedtx': txHex};

    var client = new http.Client();
    var response =
        await client.post(url, headers: {"responseType": "text"}, body: data);

    var txHash = response.body;
    var errMsg = '';
    if (txHash.indexOf('txerError') >= 0) {
      errMsg = txHash;
      txHash = '';
    }
    return {'txHash': txHash, 'errMsg': errMsg};
  }

  postFabTx(String txHex) async {
    var url = fabApiUrl + 'sendrawtransaction/' + txHex;
    var txHash = '';
    var errMsg = '';
    var client = new http.Client();
    if (txHex != '') {
      var response = await client.get(url);
      var json = jsonDecode(response.body);
      if (json != null) {
        if ((json['txid'] != null) && (json['txid'] != '')) {
          txHash = json['txid'];
        } else if (json['Error'] != '') {
          errMsg = json['Error'];
        }
      }
    }

    return {'txHash': txHash, 'errMsg': errMsg};
  }

  getEthNonce(String address) async {
    var url = ethApiUrl + 'getnonce/' + address + '/latest';
    var client = new http.Client();
    var response = await client.get(url);
    return int.parse(response.body);
  }

  getFabTransactionHex(seed, addressIndexList, toAddress, double amount,
      double extraTransactionFee, int satoshisPerBytes) async {
    final txb = new TransactionBuilder(network: testnet);
    final root = bip32.BIP32.fromSeed(seed);
    var totalInput = 0;
    var changeAddress = '';
    var finished = false;
    var receivePrivateKeyArr = [];

    var totalAmount = amount + extraTransactionFee;
    var amountNum = totalAmount * 1e8;

    var bytesPerInput = 148;
    var feePerInput = bytesPerInput * satoshisPerBytes;

    for (var i = 0; i < addressIndexList.length; i++) {
      var index = addressIndexList[i];
      var fabCoinChild =
          root.derivePath("m/44'/1150'/0'/0/" + index.toString());
      final fromAddress = getAddress(fabCoinChild, testnet);
      if (i == 0) {
        changeAddress = fromAddress;
      }
      final privateKey = fabCoinChild.privateKey;
      var utxos = await this.getFabUtxos(fromAddress);
      if ((utxos != null) && (utxos.length > 0)) {
        for (var j = 0; j < utxos.length; i++) {
          var utxo = utxos[i];
          var idx = utxo['idx'];
          var txid = utxo['txid'];
          var value = utxo['value'];
          var isLocked = await isFabTransactionLocked(txid, idx);
          if (isLocked) {
            continue;
          }
          txb.addInput(txid, idx);
          receivePrivateKeyArr.add(privateKey);
          totalInput += value;

          amountNum -= value;
          amountNum += feePerInput;
          if (amountNum <= 0) {
            finished = true;
            break;
          }
        }
      }

      if (!finished) {
        print('not enough fab coin to make the transaction.');
        return {
          'txHex': '',
          'errMsg': 'not enough fab coin to make the transaction.'
        };
      }

      var transFee = (receivePrivateKeyArr.length) * feePerInput + 2 * 34 + 10;

      var output1 =
          (totalInput - amount * 1e8 - extraTransactionFee * 1e8 - transFee)
              .round();
      var output2 = (amount * 1e8).round();

      if (output1 < 0 || output2 < 0) {
        print('output1 or output2 should be greater than 0.');
        return {
          'txHex': '',
          'errMsg': 'output1 or output2 should be greater than 0.'
        };
      }

      txb.addOutput(changeAddress, output1);
      txb.addOutput(toAddress, output2);

      for (var i = 0; i < receivePrivateKeyArr.length; i++) {
        var privateKey = receivePrivateKeyArr[i];
        print('there we go');
        var alice = ECPair.fromPrivateKey(privateKey,
            compressed: true, network: testnet);
        print('alice.network=');
        print(alice.network);
        txb.sign(i, alice);
      }

      var txHex = txb.build().toHex();
      return {'txHex': txHex, 'errMsg': ''};
    }
  }

  // Send Transaction

  sendTransaction(String coin, List addressIndexList, String toAddress,
      double amount, options, bool doSubmit) async {
    var totalInput = 0;
    var finished = false;
    var gasPrice = 10.2;
    var gasLimit = 21000;
    var satoshisPerBytes = 14;
    var txHex = '';
    var txHash = '';
    var errMsg = '';

    var receivePrivateKeyArr = [];

    var tokenType = options['tokenType'] ?? '';
    var contractAddress = options['contractAddress'] ?? '';
    var changeAddress = '';
    if (coin == 'BTC') {
      var bytesPerInput = 148;
      var amountNum = amount * 1e8;
      amountNum += (2 * 34 + 10);
      final txb = new TransactionBuilder(network: testnet);
      // txb.setVersion(1);

      print('addressIndexList=');
      print(addressIndexList);
      print(addressIndexList.length);
      for (var i = 0; i < addressIndexList.length; i++) {
        var index = addressIndexList[i];
        var bitCoinChild = root.derivePath("m/44'/1'/0'/0/" + index.toString());
        final fromAddress = getAddress(bitCoinChild, testnet);
        if (i == 0) {
          changeAddress = fromAddress;
        }
        final privateKey = bitCoinChild.privateKey;
        var utxos = await this.getBtcUtxos(fromAddress);
        print('utxos=');
        print(utxos);
        if ((utxos == null) || (utxos.length == 0)) {
          continue;
        }
        for (var j = 0; j < utxos.length; j++) {
          var tx = utxos[j];
          if (tx['idx'] < 0) {
            continue;
          }
          txb.addInput(tx['txid'], tx['idx']);
          print('amountNum=' + amountNum.toString());
          amountNum -= tx['value'];
          print('amountNum1=' + amountNum.toString());
          amountNum += bytesPerInput * satoshisPerBytes;
          print('amountNum2=' + amountNum.toString());
          totalInput += tx['value'];
          receivePrivateKeyArr.add(privateKey);
          if (amountNum <= 0) {
            finished = true;
            break;
          }
        }

        fixLength(String str, int length) {
          var retStr = '';
          int len = str.length;
          int len2 = length - len;
          if (len2 > 0) {
            for (int i = 0; i < len2; i++) {
              retStr += '0';
            }
          }
          retStr += str;
          return retStr;
        }

        trimHexPrefix(String str) {
          if (str.startsWith('0x')) {
            str = str.substring(2);
          }
          return str;
        }
      }

      print('finished=' + finished.toString());
      if (!finished) {
        txHex = '';
        txHash = '';
        errMsg = 'not enough fund.';
        return {'txHex': txHex, 'txHash': txHash, 'errMsg': errMsg};
      }

      var transFee =
          (receivePrivateKeyArr.length) * bytesPerInput * satoshisPerBytes +
              2 * 34 +
              10;
      var output1 = (totalInput - amount * 1e8 - transFee).round();
      var output2 = (amount * 1e8).round();
      print('111');
      txb.addOutput(changeAddress, output1);
      print('222');
      txb.addOutput(toAddress, output2);
      print('333');
      for (var i = 0; i < receivePrivateKeyArr.length; i++) {
        var privateKey = receivePrivateKeyArr[i];
        print('there we go');
        var alice = ECPair.fromPrivateKey(privateKey,
            compressed: true, network: testnet);
        print('alice.network=');
        print(alice.network);
        txb.sign(i, alice);
      }

      txHex = txb.build().toHex();
      if (doSubmit) {
        var res = await postBtcTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      } else {
        print('not right');
      }
    }

    // ETH Transaction

    else if (coin == 'ETH') {
      // Credentials fromHex = EthPrivateKey.fromHex("c87509a[...]dc0d3");
      final ropstenChainId = 3;
      final ethCoinChild = root.derivePath("m/44'/60'/0'/0/0");
      final privateKey = HEX.encode(ethCoinChild.privateKey);
      var amountNum = (amount * 1e18).round();
      Credentials credentials = EthPrivateKey.fromHex(privateKey);

      final address = await credentials.extractAddress();
      final addressHex = address.hex;
      final nonce = await getEthNonce(addressHex);

      var apiUrl =
          "https://ropsten.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef"; //Replace with your API

      var httpClient = new Client();
      var ethClient = new Web3Client(apiUrl, httpClient);

      print('amountNum=');
      print(amountNum);
      final signed = await ethClient.signTransaction(
          credentials,
          Transaction(
            nonce: nonce,
            to: EthereumAddress.fromHex(toAddress),
            gasPrice:
                EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice.round()),
            maxGas: gasLimit,
            value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amountNum),
          ),
          chainId: ropstenChainId,
          fetchChainIdFromNetworkId: false);
      print('signed=');
      txHex = '0x' + HEX.encode(signed);

      if (doSubmit) {
        var res = await postEthTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      } else {}
    } else if (coin == 'FAB') {
      var res1 = await getFabTransactionHex(
          seed, addressIndexList, toAddress, amount, 0, satoshisPerBytes);
      txHex = res1['txHex'];
      errMsg = res1['errMsg'];
      if ((errMsg == '') && (txHex != '')) {
        if (doSubmit) {
          var res = await postFabTx(txHex);
          print('res therrrr');
          print(res);
          txHash = res['txHash'];
          errMsg = res['errMsg'];
        } else {}
      }
    } else if (tokenType == 'FAB') {
      var transferAbi = 'a9059cbb';
      var amountSent = (amount * 1e18).round();
      var fxnCallHex = transferAbi +
          this.fixLength(this.trimHexPrefix(toAddress), 64) +
          this.fixLength(this.trimHexPrefix(amountSent.toRadixString(16)), 64);
      contractAddress = this.trimHexPrefix(contractAddress);
      var gasLimit = 800000;
      var gasPrice = 40;
      var totalAmount = gasLimit * gasPrice / 1e8;
      // let cFee = 3000 / 1e8 // fee for the transaction

      var totalFee = totalAmount;
      var chunks = new List<dynamic>();
      chunks.add(84);
      chunks.add(Uint8List.fromList(this.number2Buffer(gasLimit)));
      chunks.add(Uint8List.fromList(this.number2Buffer(gasPrice)));
      chunks.add(Uint8List.fromList(this.hex2Buffer(fxnCallHex)));
      chunks.add(Uint8List.fromList(this.hex2Buffer(contractAddress)));
      chunks.add(194);

      print('chunks=');
      print(chunks);
      var contract = script.compile(chunks);
      print('contract=');
      print(contract);
      var contractSize = contract.toString().length;

      totalFee += this.convertLiuToFabcoin(contractSize * 10);

      var res1 = await getFabTransactionHex(
          seed, addressIndexList, contract, 0, totalFee, satoshisPerBytes);
      txHex = res1['txHex'];
      errMsg = res1['errMsg'];
      if (txHex != null && txHex != '') {
        if (doSubmit) {
          var res = await this.postFabTx(txHex);
          txHash = res['txHash'];
          errMsg = res['errMsg'];
        } else {}
      }
    } else if (tokenType == 'ETH') {
      final ropstenChainId = 3;
      final ethCoinChild = root.derivePath("m/44'/60'/0'/0/0");
      final privateKey = HEX.encode(ethCoinChild.privateKey);
      Credentials credentials = EthPrivateKey.fromHex(privateKey);

      final address = await credentials.extractAddress();
      final addressHex = address.hex;
      final nonce = await getEthNonce(addressHex);
      gasLimit = 100000;
      var amountSent = (amount * 1e6).round();
      var transferAbi = 'a9059cbb';
      var fxnCallHex = transferAbi +
          this.fixLength(this.trimHexPrefix(toAddress), 64) +
          this.fixLength(this.trimHexPrefix(amountSent.toRadixString(16)), 64);
      var apiUrl =
          "https://ropsten.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef"; //Replace with your API

      var httpClient = new Client();
      var ethClient = new Web3Client(apiUrl, httpClient);

      final signed = await ethClient.signTransaction(
          credentials,
          Transaction(
              nonce: nonce,
              to: EthereumAddress.fromHex(contractAddress),
              gasPrice: EtherAmount.fromUnitAndValue(
                  EtherUnit.gwei, gasPrice.round()),
              maxGas: gasLimit,
              value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 0),
              data: Uint8List.fromList(this.hex2Buffer(fxnCallHex))),
          chainId: ropstenChainId,
          fetchChainIdFromNetworkId: false);
      print('signed=');
      txHex = '0x' + HEX.encode(signed);

      if (doSubmit) {
        var res = await postEthTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      } else {}
    }

    return {'txHex': txHex, 'txHash': txHash, 'errMsg': errMsg};
  }
}
