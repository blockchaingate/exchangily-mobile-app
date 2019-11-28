import 'dart:async';
import 'package:bip39/bip39.dart' as bip39;
import '../packages/bip32/bip32_base.dart' as bip32;
import 'package:bitcoin_flutter/src/models/networks.dart';
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:bitcoin_flutter/src/transaction_builder.dart';
import 'package:bitcoin_flutter/src/ecpair.dart';
import 'package:bitcoin_flutter/src/utils/script.dart' as script;
import 'package:hex/hex.dart';
import "package:pointycastle/pointycastle.dart";
import 'dart:convert';
import 'dart:typed_data';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import '../environments/environment.dart';
import '../environments/coins.dart';
import 'package:bitcoin_flutter/src/bitcoin_flutter_base.dart';
import '../utils/abi_util.dart';
import '../utils/string_util.dart';
import '../utils/kanban.util.dart';
import '../utils/keypair_util.dart';

mixin WalletService {

  getOfficalAddress(String coinName) {
    var address = environment['addresses']['exchangilyOfficial'].where((addr) => addr['name'] == coinName).toList();
    if(address != null) {
      return address[0]['address'];
    }
    return null;
  }

  getCoinTypeIdByName(String coinName) {
    var coins = coin_list.where((coin) => coin['name'] == coinName).toList();
    if(coins != null) {
      return coins[0]['id'];
    }
    return 0;
  }

  getOriginalMessage(int coinType, String txHash, BigInt amount, String address) {

    var buf = '';
    buf += fixLength(coinType.toString(), 4);
    buf += fixLength(txHash, 64);
    var hexString = amount.toRadixString(16);
    buf += fixLength(hexString, 64);
    buf += fixLength(address, 64);

    return buf;
  }




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

  Future depositDo(String coinName, String tokenType, double amount) async {
    var randomMnemonic = 'culture sound obey clean pretty medal churn behind chief cactus alley ready';
    var seed = bip39.mnemonicToSeed(randomMnemonic);
    var officalAddress = getOfficalAddress(coinName);
    if(officalAddress == null) {
      return -1;
    }
    var resST = sendTransaction(coinName, seed, [0], officalAddress, amount, {}, false);
    if(resST['errMsg'] != '') {
      return -2;
    }
    if(resST['txHex'] == '' || resST['txHash'] == '') {
      return -3;
    }

    var txHash = resST['txHash'];
    var amountInLink = BigInt.from(amount * 1e18);

    var coinType = getCoinTypeIdByName(coinName);
    if(coinType == 0) {
      return -4;
    }

    var keyPairKanban = getExgKeyPair(seed);
    var addressInKanban = keyPairKanban["address"];
    var originalMessage = getOriginalMessage(coinType, trimHexPrefix(txHash)
        , amountInLink, trimHexPrefix(addressInKanban));

    var signedMessage = await this.signedMessage(originalMessage, seed, coinName, tokenType);

    var coinPoolAddress = await getCoinPoolAddress();

    var abiHex = getDepositFuncABI(coinType, txHash, amountInLink, addressInKanban, signedMessage);
    var nonce = await getNonce(addressInKanban);
    var txKanbanHex = await signAbiHexWithPrivateKey(abiHex, addressInKanban["privateKey"], coinPoolAddress, nonce);

    var res = await submitDeposit(txHash, txKanbanHex);
    return res;
  }



  Future AddGasDo(double amount) async {
    var satoshisPerBytes = 14;
    var randomMnemonic = 'culture sound obey clean pretty medal churn behind chief cactus alley ready';
    var seed = bip39.mnemonicToSeed(randomMnemonic);
    // final root = bip32.BIP32.fromSeed(seed);
    var scarContractAddress = await getScarAddress();
    scarContractAddress = trimHexPrefix(scarContractAddress);
    print('scarContractAddress=');
    print(scarContractAddress);
    var fxnDepositCallHex = '4a58db19';
    var contractInfo  = await getFabSmartContract(scarContractAddress, fxnDepositCallHex);

    print('contractInfo===');
    print(contractInfo['totalFee']);
    print(contractInfo['contract']);
    print('end of contractInfo');
    var res1 = await getFabTransactionHex(seed, [0], contractInfo['contract'], amount, contractInfo['totalFee'], satoshisPerBytes);
    var txHex = res1['txHex'];
    var errMsg = res1['errMsg'];
    var txHash = '';
    if (txHex != null && txHex != '') {

        var res = await this.postFabTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];

    }

    return {'txHex': txHex, 'txHash': txHash, 'errMsg': errMsg};
  }


  String getAddress (node, [network]) {
    return P2PKH(data: new P2PKHData(pubkey: node.publicKey), network: network).data.address;
  }

  convertLiuToFabcoin(amount) {
    return (amount * 1e-8);
  }


  getFabUtxos(String address) async {
    var url = 'https://fabtest.fabcoinapi.com/' + 'getutxos/' + address;
    print(url);
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }

  getBtcUtxos(String address) async {
    var url = 'https://btctest.fabcoinapi.com/' + 'getutxos/' + address;
    print(url);
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }

  postBtcTx(String txHex) async {
    var url = 'https://btctest.fabcoinapi.com/' + 'sendrawtransaction/' + txHex;
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
      }
      else if(json['Error'] != null) {
        errMsg = json['Error'];
      }
    }
    return {'txHash':txHash, 'errMsg': errMsg};
  }

  getFabTransactionJson(String txid) async {
    txid = trimHexPrefix(txid);
    var url = 'https://fabtest.fabcoinapi.com/' + 'gettransactionjson/' + txid;
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }

  isFabTransactionLocked(String txid, int idx) async {
    if(idx != 0) {
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
    var url = 'https://ethtest.fabcoinapi.com/' + 'sendsignedtransaction';
    var data = {
      'signedtx': txHex
    };

    var client = new http.Client();
    var response = await client.post(url,headers: {"responseType": "text"}, body:data);

    var txHash = response.body;
    var errMsg = '';
    if (txHash.indexOf('txerError') >= 0) {
      errMsg = txHash;
      txHash = '';
    }
    return {'txHash':txHash, 'errMsg': errMsg};
  }

  postFabTx(String txHex) async {
    var url = 'https://fabtest.fabcoinapi.com/' + 'sendrawtransaction/' + txHex;
    var txHash = '';
    var errMsg = '';
    var client = new http.Client();
    if (txHex != '') {
      var response = await client.get(url);
      var json = jsonDecode(response.body);
      if (json != null) {
        if ( (json['txid'] != null) && (json['txid'] != '') ) {
          txHash = json['txid'];
        } else
        if (json['Error'] != '') {
          errMsg = json['Error'];
        }
      }
    }

    return {'txHash':txHash, 'errMsg': errMsg};
  }

  getEthNonce(String address) async{
    var url = 'https://ethtest.fabcoinapi.com/' + 'getnonce/' + address + '/latest';
    var client = new http.Client();
    var response = await client.get(url);
    return int.parse(response.body);
  }

  getFabTransactionHex(seed, addressIndexList, toAddress, double amount, double extraTransactionFee, int satoshisPerBytes) async{
    final txb = new TransactionBuilder(network:testnet);
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
      var fabCoinChild = root.derivePath("m/44'/1150'/0'/0/" + index.toString());
      final fromAddress = getAddress(fabCoinChild, testnet);
      print('from address=' + fromAddress);
      if(i == 0) {
        changeAddress = fromAddress;
      }
      final privateKey = fabCoinChild.privateKey;
      var utxos = await this.getFabUtxos(fromAddress);
      if((utxos != null) && (utxos.length > 0)) {
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
        return {'txHex': '', 'errMsg': 'not enough fab coin to make the transaction.'};
      }

      var transFee = (receivePrivateKeyArr.length) * feePerInput + 2 * 34 + 10;

      var output1 = (totalInput
          - amount * 1e8 - extraTransactionFee * 1e8
          - transFee).round();
      var output2 = (amount * 1e8).round();

      if (output1 < 0 || output2 < 0) {
        print('output1 or output2 should be greater than 0.');
        return {'txHex': '', 'errMsg': 'output1 or output2 should be greater than 0.'};
      }

      txb.addOutput(changeAddress, output1);
      txb.addOutput(toAddress, output2);

      for (var i = 0; i < receivePrivateKeyArr.length; i ++) {
        var privateKey = receivePrivateKeyArr[i];
        print('there we go');
        var alice = ECPair.fromPrivateKey(privateKey, compressed:true, network:testnet);
        print('alice.network=');
        print(alice.network);
        txb.sign(i, alice);
      }

      var txHex = txb.build().toHex();
      return {'txHex': txHex, 'errMsg': ''};
    }
  }

  sendTransaction(String coin, seed, List addressIndexList, String toAddress, double amount, options, bool doSubmit) async {
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
    final root = bip32.BIP32.fromSeed(seed);
    if(coin == 'BTC') {
      var bytesPerInput = 148;
      var amountNum = amount * 1e8;
      amountNum += (2 * 34 + 10);
      final txb = new TransactionBuilder(network:testnet);
      // txb.setVersion(1);

      print('addressIndexList=');
      print(addressIndexList);
      print(addressIndexList.length);
      for (var i = 0; i < addressIndexList.length; i++) {
        var index = addressIndexList[i];
        var bitCoinChild = root.derivePath("m/44'/1'/0'/0/" + index.toString());
        final fromAddress = getAddress(bitCoinChild, testnet);
        if(i == 0) {
          changeAddress = fromAddress;
        }
        final privateKey = bitCoinChild.privateKey;
        var utxos = await this.getBtcUtxos(fromAddress);
        print('utxos=');
        print(utxos);
        if((utxos == null) || (utxos.length == 0)) {
          continue;
        }
        for (var j = 0; j < utxos.length; j++) {
          var tx = utxos[j];
          if(tx['idx'] < 0) {
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
        }  fixLength( String str, int length ) {
    var retStr = '';
    int len = str.length;
    int len2 = length - len;
    if (len2 > 0) {
      for(int i=0;i<len2; i++) {
        retStr += '0';
      }
    }
    retStr += str;
    return retStr;
  }
        trimHexPrefix(String str) {
          if(str.startsWith('0x')) {
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

      var transFee = (receivePrivateKeyArr.length) * bytesPerInput * satoshisPerBytes + 2 * 34 + 10;
      var output1 = (totalInput - amount * 1e8 - transFee).round();
      var output2 = (amount * 1e8).round();
      print('111');
      txb.addOutput(changeAddress, output1);
      print('222');
      txb.addOutput(toAddress, output2);
      print('333');
      for (var i = 0; i < receivePrivateKeyArr.length; i ++) {
        var privateKey = receivePrivateKeyArr[i];
        print('there we go');
        var alice = ECPair.fromPrivateKey(privateKey, compressed:true, network:testnet);
        print('alice.network=');
        print(alice.network);
        txb.sign(i, alice);
      }

      txHex = txb.build().toHex();
      if(doSubmit) {
        var res = await postBtcTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      }
      else {

      }

    }

    else if(coin == 'ETH') {
      // Credentials fromHex = EthPrivateKey.fromHex("c87509a[...]dc0d3");
      final ropstenChainId = 3;
      final ethCoinChild = root.derivePath("m/44'/60'/0'/0/0");
      final privateKey = HEX.encode(ethCoinChild.privateKey);
      var amountNum = (amount * 1e18).round();
      Credentials credentials = EthPrivateKey.fromHex(privateKey);

      final address = await credentials.extractAddress();
      final addressHex = address.hex;
      final nonce = await getEthNonce(addressHex);

      var apiUrl = "https://ropsten.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef"; //Replace with your API

      var httpClient = new http.Client();
      var ethClient = new Web3Client(apiUrl, httpClient);

      print('amountNum=');
      print(amountNum);
      final signed = await ethClient.signTransaction(
          credentials,
          Transaction(
            nonce:nonce,
            to: EthereumAddress.fromHex(toAddress),
            gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice.round()),
            maxGas: gasLimit,
            value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amountNum),
          ), chainId:ropstenChainId,fetchChainIdFromNetworkId:false
      );
      print('signed=');
      txHex = '0x' + HEX.encode(signed);

      if (doSubmit) {
        var res = await postEthTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      } else {
      }
    }
    else if(coin == 'FAB') {
      var res1 = await getFabTransactionHex(seed, addressIndexList, toAddress, amount, 0, satoshisPerBytes);
      txHex = res1['txHex'];
      errMsg = res1['errMsg'];
      if ((errMsg == '') && (txHex != '')) {
        if (doSubmit) {
          var res = await postFabTx(txHex);
          print('res therrrr');
          print(res);
          txHash = res['txHash'];
          errMsg = res['errMsg'];
        } else {
        }
      }
    }

    else if (tokenType == 'FAB') {
      var transferAbi = 'a9059cbb';
      var amountSent = (amount * 1e18).round();
      var fxnCallHex = transferAbi
          + fixLength(trimHexPrefix(toAddress), 64)
          + fixLength(trimHexPrefix(amountSent.toRadixString(16)), 64);
      contractAddress = trimHexPrefix(contractAddress);

      var contractInfo  = await getFabSmartContract(contractAddress, fxnCallHex);

      var res1 = await getFabTransactionHex(seed, addressIndexList, contractInfo['contract'], 0, contractInfo['totalFee'], satoshisPerBytes);
      txHex = res1['txHex'];
      errMsg = res1['errMsg'];
      if (txHex != null && txHex != '') {
        if (doSubmit) {
          var res = await this.postFabTx(txHex);
          txHash = res['txHash'];
          errMsg = res['errMsg'];
        } else {
        }
      }
    }
    else if (tokenType == 'ETH') {
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
      var fxnCallHex = transferAbi
          + fixLength(trimHexPrefix(toAddress), 64)
          + fixLength(trimHexPrefix(amountSent.toRadixString(16)), 64);
      var apiUrl = "https://ropsten.infura.io/v3/6c5bdfe73ef54bbab0accf87a6b4b0ef"; //Replace with your API

      var httpClient = new http.Client();
      var ethClient = new Web3Client(apiUrl, httpClient);

      final signed = await ethClient.signTransaction(
          credentials,
          Transaction(
              nonce:nonce,
              to: EthereumAddress.fromHex(contractAddress),
              gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice.round()),
              maxGas: gasLimit,
              value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 0),
              data: Uint8List.fromList(hex2Buffer(fxnCallHex))
          ), chainId:ropstenChainId,fetchChainIdFromNetworkId:false
      );
      print('signed=');
      txHex = '0x' + HEX.encode(signed);

      if (doSubmit) {
        var res = await postEthTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      } else {
      }
    }

    return {'txHex': txHex, 'txHash': txHash, 'errMsg': errMsg};
  }

  getFabSmartContract(String contractAddress, String fxnCallHex) async{
    var gasLimit = 800000;
    var gasPrice = 40;
    var totalAmount = gasLimit * gasPrice / 1e8;
    // let cFee = 3000 / 1e8 // fee for the transaction

    var totalFee = totalAmount;
    var chunks = new List<dynamic>();
    chunks.add(84);
    chunks.add(Uint8List.fromList(number2Buffer(gasLimit)));
    chunks.add(Uint8List.fromList(number2Buffer(gasPrice)));
    chunks.add(Uint8List.fromList(hex2Buffer(fxnCallHex)));
    chunks.add(Uint8List.fromList(hex2Buffer(contractAddress)));
    chunks.add(194);

    print('chunks=');
    print(chunks);
    var contract = script.compile(chunks);
    print('contract=');
    print(contract);
    var contractSize = contract.toString().length;

    totalFee += this.convertLiuToFabcoin(contractSize * 10);

    var res = {
      'contract': contract,
      'totalFee': totalFee
    };
    return res;
  }


}