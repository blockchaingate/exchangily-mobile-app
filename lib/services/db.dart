import 'dart:convert';
import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:web3dart/credentials.dart';
import 'package:http/http.dart' as http;
import '../services/models.dart';
import '../shared/globals.dart' as globals;

class DatabaseService {
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
  final apiUrl = 'https://btctest.fabcoinapi.com/';
  List<WalletInfo> _walletInfo;
  List _childrens = [
    {'btc': bitCoinChild, 'fab': fabCoinChild}
  ];

  // Get Address

  String getAddress(node, [network]) {
    return P2PKH(data: new P2PKHData(pubkey: node.publicKey), network: network)
        .data
        .address;
  }

  // Get Eth Address

  getEthAddress(privateKey) async {
    Credentials credentials = EthPrivateKey.fromHex(privateKey);

    final address = await credentials.extractAddress();

    return address.hex;
  }

  // Get All Balances

  Future<List<WalletInfo>> getAllBalances() async {
    _childrens.map((f) => {getAddress(f, testnet)});
    await getBtcBalance();
    await getFabBalance();
    await getExgBalance();

    return _walletInfo;
  }

  // Get Btc balance

  getBtcBalance() async {
    btcAddress = getAddress(bitCoinChild, testnet);
    var url = apiUrl + 'getbalance/' + btcAddress;
    var response = await client.get(url);
    btcBalance = double.parse(response.body) / 1e8;
    _walletInfo = [
      WalletInfo('btc', btcAddress, btcBalance, 12345.214, globals.primaryColor)
    ];
  }

// Get Fab Balance

  getFabBalance() async {
    fabAddress = getAddress(fabCoinChild, testnet);
    var url = apiUrl + 'getbalance/' + fabAddress;
    var response = await client.get(url);
    fabBalance = double.parse(response.body) / 1e8;
    _walletInfo.add(WalletInfo(
        'fab', fabAddress, fabBalance, 214212.112, globals.fabLogoColor));
  }

  // Get Exg Balance

  getExgBalance() async {
    var exgSmartContractAddress = '0x867480ba8e577402fa44f43c33875ce74bdc5df6';
    var body = {
      'address': this.trimHexPrefix(exgSmartContractAddress),
      'data': '70a08231' + this.fixLength(this.trimHexPrefix(exgAddress), 64)
    };
    var response = await client
        .post('https://fabtest.fabcoinapi.com/callcontract', body: body);
    var json = jsonDecode(response.body);
    var unlockBalance = json['executionResult']['output'];
    var unlockInt = int.parse("0x$unlockBalance");
    exgBalance = unlockInt / 1e18;
    _walletInfo.add(WalletInfo('exg', exgSmartContractAddress, exgBalance,
        34212.782, globals.exgLogoColor));
  }

  // Get BTC Utxos

  getBtcUtxos(String address) async {
    var url = apiUrl + 'getutxos/' + address;
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }

  // Get Fab Utxos

  Future getFabUtxos(String address) async {
    var url = apiUrl + 'getutxos/' + address;
    print(url);
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    print(json);
    return json;
  }

  // Fix Length

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

  // Trim Hex

  trimHexPrefix(String str) {
    if (str.startsWith('0x')) {
      str = str.substring(2);
    }
    return str;
  }

  // Get Eth Nonce

  getEthNonce(String address) {}

  // Get Btc Utxos

  // Post Btc Tx

  postBtcTx(String txHex) {}

  // Post Eth Tx

  postEthTx(String txHex) {}

  // Post Fab Tx

  postFabTx(String txHex) {}

  // Get Fab Transaction Json

  getFabTransactionJson(String txid) {}

  // Fab Transaction Locked

  isFabTransactionLocked() {}

  // Number -> Buffer

  number2Buffer(num) {}

  // Hex -> buffer

  hex2Buffer(hexString) {}

  // Convert Liu -> Fab Coin

  convertLiuToFabcoin(amount) {}

  // Get Fab Transaction Hex

  getFabTransactionHex() {}

  // Send transaction

  sendTransaction() {}
}
