import 'package:bitbox/bitbox.dart' as Bitbox;
import 'package:exchangilymobileapp/constants/colors.dart' as colors;
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/dialog/dialog_response.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/utils/btc_util.dart';
import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:exchangilymobileapp/utils/ltc_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/wallet_coin_address_utils/doge_util.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:bip39/bip39.dart' as bip39;
import '../packages/bip32/bip32_base.dart' as bip32;
import 'package:hex/hex.dart';
import 'dart:typed_data';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import '../shared/globals.dart' as globals;
import '../environments/coins.dart' as coinList;
import '../utils/abi_util.dart';
import '../utils/number_util.dart';
import '../utils/string_util.dart' as stringUtils;
import '../utils/kanban.util.dart';
import '../utils/keypair_util.dart';
import '../utils/eth_util.dart';
import '../utils/fab_util.dart';
import '../utils/coin_util.dart';
import 'dart:io';
import 'package:bitcoin_flutter/src/models/networks.dart';
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:bitcoin_flutter/src/transaction_builder.dart';
import 'package:bitcoin_flutter/src/transaction.dart' as btcTransaction;
import 'package:bitcoin_flutter/src/ecpair.dart';
import 'package:bitcoin_flutter/src/utils/script.dart' as script;
import '../environments/environment.dart';
import 'package:bitcoin_flutter/src/bitcoin_flutter_base.dart';
import 'package:web_socket_channel/io.dart';
import 'package:encrypt/encrypt.dart' as prefix0;
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:decimal/decimal.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart' as BitcoinFlutter;
import 'db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/utils/exaddr.dart';

class WalletService {
  final log = getLogger('Wallet Service');
  ApiService _api = locator<ApiService>();
  double currentTickerUsdValue;
  var txids = [];
  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
  SharedService sharedService = locator<SharedService>();
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  ApiService _apiService = locator<ApiService>();
  double coinUsdBalance;
  List<String> coinTickers = [
    'BTC',
    'ETH',
    'FAB',
    'BCH',
    'USDT',
    'EXG',
    'DUSD',
    'LTC',
    'DOGE',
    'DRGN',
    'HOT',
    'CEL',
    'MATIC',
    'IOST',
    'MANA',
    'WAX',
    'ELF',
    'GNO',
    'POWR',
    'WINGS',
    'MTL',
    'KNC',
    'GVT'
  ];

  List<String> tokenType = [
    '',
    '',
    '',
    '',
    'ETH',
    'FAB',
    'FAB',
    '',
    '',
    'ETH',
    'ETH',
    'ETH',
    'ETH',
    'ETH',
    'ETH',
    'ETH',
    'ETH',
    'ETH',
    'ETH',
    'ETH',
    'ETH',
    'ETH',
    'ETH'
  ];

  List<String> coinNames = [
    'bitcoin',
    'ethereum',
    'fabcoin',
    'bitcoin cash',
    'tether',
    'exchangily',
    'dusd',
    'litecoin',
    'dogecoin',
    'dragon',
    'Holo',
    'Celsius',
    'Matic Network',
    'IOST',
    'Decentraland',
    'wax',
    'aelf',
    'Gnosis',
    'powr',
    'Power Ledger',
    'Metal',
    'Kyber Network',
    'Genesis Vision'
  ];

  Completer<DialogResponse> _completer;

/*----------------------------------------------------------------------
                Get Random Mnemonic
----------------------------------------------------------------------*/

  addTxids(allTxids) {
    txids = [...txids, ...allTxids].toSet().toList();
  }

  String getRandomMnemonic() {
    String randomMnemonic = '';

    randomMnemonic = bip39.generateMnemonic();
    return randomMnemonic;
  }
/*----------------------------------------------------------------------
                Save Encrypted Data to Storage
----------------------------------------------------------------------*/

  Future saveEncryptedData(String data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.byte');
      await deleteEncryptedData();
      await file.writeAsString(data);
      log.w('Encrypted data saved in storage');
    } catch (e) {
      log.e("Couldn't write encrypted datra to file!! $e");
    }
  }
/*----------------------------------------------------------------------
                Delete Encrypted Data
----------------------------------------------------------------------*/

  Future deleteEncryptedData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.byte');
    await file
        .delete()
        .then((res) => log.w('Previous data in the stored file deleted $res'))
        .catchError((error) => log.e('Previous data deletion failed $error'));
  }
/*----------------------------------------------------------------------
                Read Encrypted Data from Storage
----------------------------------------------------------------------*/

  Future<String> readEncryptedData(String userPass) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.byte');

      String test = await file.readAsString();
      prefix0.Encrypted encryptedText = prefix0.Encrypted.fromBase64(test);
      final key = prefix0.Key.fromLength(32);
      final iv = prefix0.IV.fromUtf8(userPass);
      final encrypter = prefix0.Encrypter(prefix0.AES(key));
      final decrypted = encrypter.decrypt(encryptedText, iv: iv);
      return Future.value(decrypted);
    } catch (e) {
      log.e("Couldn't read file -$e");
      return Future.value('');
    }
  }
/*----------------------------------------------------------------------
                Generate Seed
----------------------------------------------------------------------*/

  generateSeed(String mnemonic) {
    Uint8List seed = bip39.mnemonicToSeed(mnemonic);
    log.w('Seed $seed');
    return seed;
  }

  generateBip32Root(Uint8List seed) {
    var root = bip32.BIP32.fromSeed(seed);
    return root;
  }

  // Generate BCH address
  String generateBchAddress(String mnemonic) {
    String tickerName = 'BCH';
    var bchSeed = generateSeed(mnemonic);
    final masterNode = Bitbox.HDNode.fromSeed(bchSeed);
    var coinType = environment["CoinType"]["$tickerName"].toString();
    final accountDerivationPath = "m/44'/" + '$coinType' + "'/0'/0";
    final accountNode = masterNode.derivePath(accountDerivationPath);
    final accountXPriv = accountNode.toXPriv();
    final childNode = accountNode.derive(0);
    final address = childNode.toCashAddress();
    // final address = cashAddress.split(":")[1];
    getBchAddressDetails(address);

    return address;
  }

  // get BCH address details
  Future getBchAddressDetails(String bchAddress) async {
    final addressDetails = await Bitbox.Address.details(bchAddress);
    log.e('Address $bchAddress -- address details $addressDetails');
    return addressDetails;
  }

  // Generate LTC address
  generateDogeAddress(String mnemonic, {index = 0}) async {
    String tickerName = 'DOGE';
    ;
    var seed = generateSeed(mnemonic);
    var root = generateBip32Root(seed);
    // var coinType = environment["CoinType"]["$tickerName"].toString();
    //  log.w('coin type $coinType');
    var node = root.derivePath("m/44'/3'/0'/0/" + index.toString());

    String address1 = new P2PKH(
            data: new BitcoinFlutter.PaymentData(pubkey: node.publicKey),
            network: dogeCoinMainnetNetwork)
        .data
        .address;
    print('ticker: $tickerName --  address1: $address1');

    // String address = '';

    // final keyPair = ECPair.makeRandom(network: liteCoinNetworkType);
    // print('keyPair: ${keyPair.publicKey}');

    // address = new P2PKH(
    //         data: new BitcoinFlutter.PaymentData(pubkey: keyPair.publicKey),
    //         network: liteCoinNetworkType)
    //     .data
    //     .address;
    // log.w('$address');
    return address1;
  }

/*----------------------------------------------------------------------
                    Get Coin Address
----------------------------------------------------------------------*/
  Future getCoinAddresses(String mnemonic) async {
    var seed = generateSeed(mnemonic);
    var root = bip32.BIP32.fromSeed(seed);
    for (int i = 0; i < coinTickers.length; i++) {
      var tickerName = coinTickers[i];
      var addr =
          await getAddressForCoin(root, tickerName, tokenType: tokenType[i]);
      log.w('name $tickerName - address $addr');
      return addr;
    }
  }
/*----------------------------------------------------------------------
                Future Get Coin Balance By Address
----------------------------------------------------------------------*/

  Future coinBalanceByAddress(
      String name, String address, String tokenType) async {
    log.w(' coinBalanceByAddress $name $address $tokenType');
    var bal =
        await getCoinBalanceByAddress(name, address, tokenType: tokenType);
    // log.w('coinBalanceByAddress $name - $bal');
    if (bal['balance'].isNaN || bal['balance'] == null) {
      return 0.0;
    }
    return bal;
  }

  Future getEthGasPrice() async {
    var gasPrice = await _apiService.getEthGasPrice();
    return gasPrice;
  }

/*----------------------------------------------------------------------
                Get Coin Price By Web Sockets
----------------------------------------------------------------------*/

  // getCoinPriceByWebSocket(String pair) {
  //   currentUsdValue = 0;
  //   final channel = IOWebSocketChannel.connect(
  //       Constants.COIN_PRICE_DETAILS_WS_URL,
  //       pingInterval: Duration(minutes: 1));

  //   channel.stream.listen((prices) async {
  //     List<Price> coinListWithPriceData = Decoder.fromJsonArray(prices);
  //     for (var i = 0; i < coinListWithPriceData.length; i++) {
  //       if (coinListWithPriceData[i].symbol == 'EXGUSDT') {
  //         var d = coinListWithPriceData[i].price;
  //         currentUsdValue = stringUtils.bigNum2Double(d);
  //       }
  //     }
  //   });
  //   Future.delayed(Duration(seconds: 2), () {
  //     channel.sink.close();
  //     log.i('Channel closed');
  //   });
  // }

/*----------------------------------------------------------------------
                Get Current Market Price For The Coin By Name
----------------------------------------------------------------------*/

  Future<double> getCoinMarketPriceByTickerName(String tickerName) async {
    currentTickerUsdValue = 0;
    if (tickerName == 'DUSD') {
      return currentTickerUsdValue = 1.0;
    }
    await _apiService.getCoinCurrencyUsdPrice().then((res) {
      if (res != null) {
        //   log.i('getCoinMarketPriceByTickerName $res');
        currentTickerUsdValue = res['data'][tickerName]['USD'].toDouble();
      }
    });
    return currentTickerUsdValue;
    // } else {
    //   var usdVal = await _api.getCoinsUsdValue();
    //   double tempPriceHolder = usdVal[name]['usd'];
    //   if (tempPriceHolder != null) {
    //     currentUsdValue = tempPriceHolder;
    //   }
    // }
    //  return currentUsdValue;
  }

/*----------------------------------------------------------------------
                Offline Wallet Creation
----------------------------------------------------------------------*/

  Future createOfflineWallets(String mnemonic) async {
    await walletDatabaseService.deleteDb();
    await walletDatabaseService.initDb();
    List<WalletInfo> _walletInfo = [];
    if (_walletInfo != null) {
      _walletInfo.clear();
    } else {
      _walletInfo = [];
    }
    var seed = generateSeed(mnemonic);
    var root = generateBip32Root(seed);

    // BCH address
    String bchAddress = generateBchAddress(mnemonic);

    try {
      for (int i = 0; i < coinTickers.length; i++) {
        String tickerName = coinTickers[i];
        String name = coinNames[i];
        String token = tokenType[i];
        String addr =
            await getAddressForCoin(root, tickerName, tokenType: token);
        WalletInfo wi = new WalletInfo(
            id: null,
            tickerName: tickerName,
            tokenType: token,
            address: tickerName == 'BCH' ? bchAddress : addr,
            availableBalance: 0.0,
            lockedBalance: 0.0,
            usdValue: 0.0,
            name: name);
        _walletInfo.add(wi);
        log.i("Offline wallet ${_walletInfo[i].toJson()}");
        await walletDatabaseService.insert(_walletInfo[i]);
      }
      await walletDatabaseService.getAll();
      return _walletInfo;
    } catch (e) {
      log.e(e);
      log.e('Catch createOfflineWallets $e');
      throw Exception('Catch createOfflineWallets $e');
    }
  }

/*----------------------------------------------------------------------
                Transaction status
----------------------------------------------------------------------*/
  Future<String> checkDepositTransactionStatus(
      TransactionHistory transaction) async {
    String result = '';
    Timer.periodic(Duration(minutes: 1), (Timer t) async {
      TransactionHistory transactionHistory = new TransactionHistory();
      TransactionHistory transactionHistoryByTxId = new TransactionHistory();
      var res = await _apiService.getTransactionStatus(transaction.txId);
      log.w('checkDepositTransactionStatus $res');
// 0 is confirmed
// 1 is pending
// 2 is failed (tx 1 failed),
// 3 is need to redeposit (tx 2 failed)
// -1 is error
      if (res['code'] == -1 ||
          res['code'] == 0 ||
          res['code'] == 2 ||
          res['code'] == -2 ||
          res['code'] == 3 ||
          res['code'] == -3) {
        t.cancel();
        result = res['message'];
        log.i('Timer cancel');

        /// may add deposit or withdraw in front of status for better understanding
        // sharedService.alertDialog(
        //     '${transaction.tickerName} ${transactionHistory.tag}',
        //     stringUtils.firstCharToUppercase(result.toString()),
        //     isWarning: false);
        String date = DateTime.now().toString();

        if (transaction != null) {
          transactionHistoryByTxId = await transactionHistoryDatabaseService
              .getByTxId(transaction.txId);
          showSimpleNotification(
              Column(children: [
                Row(
                  children: [
                    Text('${transactionHistoryByTxId.tickerName} '),
                    Text('${transactionHistoryByTxId.tag}')
                  ],
                ),
                Text(stringUtils.firstCharToUppercase(result.toString())),
              ]),
              position: NotificationPosition.bottom,
              background: primaryColor);
        }

        if (res['code'] == 0) {
          log.e('Transaction history passed arguement ${transaction.toJson()}');
          transactionHistory = TransactionHistory(
              id: transactionHistoryByTxId.id,
              tickerName: transactionHistoryByTxId.tickerName,
              address: '',
              amount: 0.0,
              date: date.toString(),
              txId: transactionHistoryByTxId.txId,
              status: 'Complete',
              quantity: transactionHistoryByTxId.quantity,
              tag: transactionHistoryByTxId.tag);

          // after this method i will test single status update field in the transaciton history
          // await transactionHistoryDatabaseService
          //     .updateStatus(transactionHistoryByTxId);
          // await transactionHistoryDatabaseService.getByTxId(transaction.txId);

        } else if (res['code'] == -1) {
          transactionHistory = TransactionHistory(
              id: transactionHistoryByTxId.id,
              tickerName: transactionHistoryByTxId.tickerName,
              address: '',
              amount: 0.0,
              date: date.toString(),
              txId: transactionHistoryByTxId.txId,
              status: 'Error',
              quantity: transactionHistoryByTxId.quantity,
              tag: transactionHistoryByTxId.tag);

          //  await transactionHistoryDatabaseService.update(transactionHistory);
        } else if (res['code'] == 2 || res['code'] == 2) {
          transactionHistory = TransactionHistory(
              id: transactionHistoryByTxId.id,
              tickerName: transactionHistoryByTxId.tickerName,
              address: '',
              amount: 0.0,
              date: date.toString(),
              txId: transactionHistoryByTxId.txId,
              status: 'Failed',
              quantity: transactionHistoryByTxId.quantity,
              tag: transactionHistoryByTxId.tag);

          //  await transactionHistoryDatabaseService.update(transactionHistory);
        } else if (res['code'] == -3 || res['code'] == 3) {
          transactionHistory = TransactionHistory(
              id: transactionHistoryByTxId.id,
              tickerName: transactionHistoryByTxId.tickerName,
              address: '',
              amount: 0.0,
              date: date.toString(),
              txId: transactionHistoryByTxId.txId,
              status: 'Require redeposit',
              quantity: transactionHistoryByTxId.quantity,
              tag: transactionHistoryByTxId.tag);

          // await transactionHistoryDatabaseService.update(transactionHistory);
        }
      }
      await transactionHistoryDatabaseService.update(transactionHistory);
      await transactionHistoryDatabaseService.getByTxId(transaction.txId);
    });
    return result;
    //  return _completer.future;
  }

  // Completer the _dialogCompleter to resume the Future's execution
  void transactionComplete(DialogResponse response) {
    _completer.complete(response);
    _completer = null;
  }
/*----------------------------------------------------------------------
                  Get Exg Address
----------------------------------------------------------------------*/

  Future<String> getExgAddressFromWalletDatabase() async {
    String address = '';
    await walletDatabaseService
        .getBytickerName('EXG')
        .then((res) => address = res.address);
    return address;
  }
/*----------------------------------------------------------------------
                  Get Wallet Coins (Not in use)
----------------------------------------------------------------------*/

  Future<List<WalletInfo>> getWalletCoins(String mnemonic) async {
    List<WalletInfo> _walletInfo = [];
    List<double> coinUsdMarketPrice = [];
    String exgAddress = '';
    if (_walletInfo != null) {
      _walletInfo.clear();
    } else {
      _walletInfo = [];
    }
    coinUsdMarketPrice.clear();
    var seed = generateSeed(mnemonic);
    var root = bip32.BIP32.fromSeed(seed);
    try {
      for (int i = 0; i < coinTickers.length; i++) {
        String tickerName = coinTickers[i];
        String name = coinNames[i];
        String token = tokenType[i];
        var coinMarketPrice = await getCoinMarketPriceByTickerName(name);
        coinUsdMarketPrice.add(coinMarketPrice);
        String addr =
            await getAddressForCoin(root, tickerName, tokenType: token);
        var bal =
            await getCoinBalanceByAddress(tickerName, addr, tokenType: token);
        log.w('bal in wallet service $bal');
        double walletBal = bal['balance'];
        // double walletLockedBal = bal['lockbalance'];

        if (tickerName == 'EXG') {
          exgAddress = addr;
          log.e(exgAddress);
        }
        WalletInfo wi = new WalletInfo(
            tickerName: tickerName,
            tokenType: token,
            address: addr,
            availableBalance: walletBal,
            lockedBalance: 0.0,
            usdValue: coinUsdBalance,
            name: name);
        _walletInfo.add(wi);
      }
      var res = await getAllExchangeBalances(exgAddress);
      if (res != null) {
        var length = res.length;
        // For loop over asset balance result
        for (var i = 0; i < length; i++) {
          // Get their tickerName to compare with walletInfo tickerName
          String coin = res[i]['coin'];
          // Second For Loop To check WalletInfo TickerName According to its length and
          // compare it with the same coin tickername from asset balance result until the match or loop ends
          for (var j = 0; j < _walletInfo.length; j++) {
            String tickerName = _walletInfo[j].tickerName;
            if (coin == tickerName) {
              _walletInfo[j].inExchange = res[i]['amount'];
              // _walletInfo[j].lockedBalance = res[i]['lockedAmount'];
              // double marketPrice =
              //     await getCoinMarketPriceByTickerName(tickerName);
              // log.e(
              //     'wallet service -- tickername $tickerName - market price $marketPrice - balance: ${_walletInfo[j].availableBalance} - Locked balance: ${_walletInfo[j].lockedBalance}');
              // calculateCoinUsdBalance(marketPrice,
              //     _walletInfo[j].availableBalance, _walletInfo[j].lockedBalance);
              break;
            }
          }
        }
      }

      for (int i = 0; i < _walletInfo.length; i++) {
        await walletDatabaseService.insert(_walletInfo[i]);
      }
      return _walletInfo;
    } catch (e) {
      log.e(e);
      _walletInfo = null;
      log.e('Catch GetAll Wallets Failed $e');
      return _walletInfo;
    }
  }

  // Insert transaction history in database

  void insertTransactionInDatabase(
      TransactionHistory transactionHistory) async {
    log.w('Transaction History ${transactionHistory.toJson()}');
    await transactionHistoryDatabaseService
        .insert(transactionHistory)
        .then((data) async {
      log.w('Saved in transaction history database $data');
      await transactionHistoryDatabaseService.getAll();
    }).catchError((onError) => log.e('Could not save in database $onError'));
  }

/*----------------------------------------------------------------------
                    Gas Balance
----------------------------------------------------------------------*/

  Future<double> gasBalance(String addr) async {
    double gasAmount = 0.0;
    await _api.getGasBalance(addr).then((res) {
      if (res != null &&
          res['balance'] != null &&
          res['balance']['FAB'] != null) {
        var newBal = BigInt.parse(res['balance']['FAB']);
        gasAmount = stringUtils.bigNum2Double(newBal);
      }
    }).timeout(Duration(seconds: 25), onTimeout: () {
      log.e('Timeout');
      gasAmount = 0.0;
    }).catchError((onError) {
      log.w('On error $onError');
      gasAmount = 0.0;
    });
    return gasAmount;
  }
/*----------------------------------------------------------------------
                      Assets Balance
----------------------------------------------------------------------*/

  Future getAllExchangeBalances(String exgAddress) async {
    if (exgAddress.isEmpty)
      exgAddress = await sharedService.getExgAddressFromWalletDatabase();
    try {
      List<Map<String, dynamic>> bal = [];
      var res = await _api.getAssetsBalance(exgAddress);
      log.w('assetsBalance exchange $res');
      for (var i = 0; i < res.length; i++) {
        var tempBal = res[i];
        var coinType = int.parse(tempBal['coinType']);
        var unlockedAmount =
            stringUtils.bigNum2Double(tempBal['unlockedAmount']);
        var lockedAmount = stringUtils.bigNum2Double(tempBal['lockedAmount']);
        var finalBal = {
          'coin': coinList.newCoinTypeMap[coinType.toString()],
          'amount': unlockedAmount,
          'lockedAmount': lockedAmount
        };
        bal.add(finalBal);
      }
      log.w('assetsBalance exchange after conversion $bal');
      return bal;
    } catch (onError) {
      log.e('On error assetsBalance $onError');
      throw Exception('Catch error $onError');
    }
  }

  /* ---------------------------------------------------
                Flushbar Notification bar
    -------------------------------------------------- */

  void showInfoFlushbar(String title, String message, IconData iconData,
      Color leftBarColor, BuildContext context) {
    Flushbar(
      backgroundColor: globals.secondaryColor.withOpacity(0.75),
      title: title,
      message: message,
      icon: Icon(
        iconData,
        size: 24,
        color: colors.primaryColor,
      ),
      leftBarIndicatorColor: leftBarColor,
      duration: Duration(seconds: 3),
    ).show(context);
  }
/*----------------------------------------------------------------------
                Calculate Only Usd Balance For Individual Coin
----------------------------------------------------------------------*/

  double calculateCoinUsdBalance(
      double marketPrice, double actualWalletBalance, double lockedBalance) {
    if (marketPrice != null) {
      coinUsdBalance = marketPrice * (actualWalletBalance + lockedBalance);
      return coinUsdBalance;
    } else {
      coinUsdBalance = 0.0;
      log.i('calculateCoinUsdBalance - Wallet balance 0');
    }
    return coinUsdBalance;
  }

// Add Gas
  Future<int> addGas() async {
    return 0;
  }

/*----------------------------------------------------------------------
                Get Original Message
----------------------------------------------------------------------*/

  getOriginalMessage(
      int coinType, String txHash, BigInt amount, String address) {
    var buf = '';
    buf += stringUtils.fixLength(coinType.toRadixString(16), 8);
    buf += stringUtils.fixLength(txHash, 64);
    var hexString = amount.toRadixString(16);
    buf += stringUtils.fixLength(hexString, 64);
    buf += stringUtils.fixLength(address, 64);

    return buf;
  }

/*----------------------------------------------------------------------
                withdrawDo
----------------------------------------------------------------------*/
  Future<Map<String, dynamic>> withdrawDo(
      seed,
      String coinName,
      String coinAddress,
      String tokenType,
      double amount,
      kanbanPrice,
      kanbanGasLimit) async {
    var keyPairKanban = getExgKeyPair(seed);
    var addressInKanban = keyPairKanban["address"];
    var amountInLink = BigInt.from(amount * 1e18);

    var addressInWallet = coinAddress;
    if (coinName == 'BTC' ||
        coinName == 'FAB' ||
        coinName == 'LTC' ||
        coinName == 'DOGE' ||
        coinName == 'BCH') {
      /*
      print('addressInWallet before');
      print(addressInWallet);
      var bytes = bs58check.decode(addressInWallet);
      print('bytes');
      print(bytes);
      addressInWallet = HEX.encode(bytes);
      print('addressInWallet after');
      print(addressInWallet);

       */
      addressInWallet = btcToBase58Address(addressInWallet);
      //no 0x appended
    } else if (tokenType == 'FAB') {
      addressInWallet = exgToFabAddress(addressInWallet);
      addressInWallet = btcToBase58Address(addressInWallet);
    }
    var coinType = getCoinTypeIdByName(coinName);
    var abiHex = getWithdrawFuncABI(coinType, amountInLink, addressInWallet);

    var coinPoolAddress = await getCoinPoolAddress();

    var nonce = await getNonce(addressInKanban);

    var txKanbanHex = await signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        coinPoolAddress,
        nonce,
        kanbanPrice,
        kanbanGasLimit);

    var res = await sendKanbanRawTransaction(txKanbanHex);

    if (res['transactionHash'] != '') {
      res['success'] = true;
      res['data'] = res;
    } else {
      res['success'] = false;
      res['data'] = 'error';
    }
    return res;
  }
/*----------------------------------------------------------------------
                Future Deposit Do
----------------------------------------------------------------------*/

  Future<Map<String, dynamic>> depositDo(
      seed, String coinName, String tokenType, double amount, option) async {
    Map<String, dynamic> errRes = new Map<String, dynamic>();
    errRes['success'] = false;

    var officalAddress = getOfficalAddress(coinName);
    print('official address in wallet service deposit do $officalAddress');
    if (officalAddress == null) {
      errRes['data'] = 'no official address';
      return errRes;
    }
    /*
    var option = {};
    if ((coinName != null) &&
        (coinName != '') &&
        (tokenType != null) &&
        (tokenType != '')) {
      option = {
        'tokenType': tokenType,
        'contractAddress': environment["addresses"]["smartContract"][coinName]
      };
    }
    */
    var kanbanGasPrice = option['kanbanGasPrice'];
    var kanbanGasLimit = option['kanbanGasLimit'];
    log.e('before send transaction');
    var resST = await sendTransaction(
        coinName, seed, [0], [], officalAddress, amount, option, false);
    log.i('after send transaction');
    if (resST != null) log.w(resST);
    if (resST['errMsg'] != '') {
      errRes['data'] = resST['errMsg'];
      return errRes;
    }

    if (resST['txHex'] == '' || resST['txHash'] == '') {
      errRes['data'] = 'no txHex or txHash';
      return errRes;
    }

    var txHex = resST['txHex'];
    var txHash = resST['txHash'];

    var txids = resST['txids'];
    var amountInTx = resST['amountInTx'];
    var amountInLink = BigInt.parse(NumberUtil.toBigInt(amount));

    var amountInTxString = amountInTx.toString();
    var amountInLinkString = amountInLink.toString();

    print('amountInTxString===' + amountInTxString);
    print('amountInLinkString===' + amountInLinkString);
    if (amountInLinkString.indexOf(amountInTxString) == -1) {
      errRes['data'] = 'incorrect amount for two transactions';
      return errRes;
    }

    var subString = amountInLinkString.substring(amountInTxString.length);

    if (subString != null && subString != '') {
      var zero = int.parse(subString);
      if (zero != 0) {
        errRes['data'] = 'unequal amount for two transactions';
        return errRes;
      }
    }

    var coinType = getCoinTypeIdByName(coinName);

    if (coinType == 0) {
      errRes['data'] = 'invalid coinType for ' + coinName;
      return errRes;
    }

    var keyPairKanban = getExgKeyPair(seed);
    var addressInKanban = keyPairKanban["address"];
    print('txHash=' + txHash);
    var originalMessage = getOriginalMessage(
        coinType,
        stringUtils.trimHexPrefix(txHash),
        amountInLink,
        stringUtils.trimHexPrefix(addressInKanban));

    var signedMess =
        await signedMessage(originalMessage, seed, coinName, tokenType);
    log.e('Signed message $signedMess');
    print('coin type $coinType');
    log.w('Original message $originalMessage');
    var coinPoolAddress = await getCoinPoolAddress();

    var abiHex = getDepositFuncABI(
        coinType, txHash, amountInLink, addressInKanban, signedMess);

    var nonce = await getNonce(addressInKanban);

    var txKanbanHex = await signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        coinPoolAddress,
        nonce,
        kanbanGasPrice,
        kanbanGasLimit);

    var res = await submitDeposit(txHex, txKanbanHex);

    res['txids'] = txids;
    return res;
  }

  /* --------------------------------------------
              Methods Called in Send State 
  ----------------------------------------------*/

// Get Fab Transaction Status
  Future getFabTxStatus(String txId) async {
    await getFabTransactionStatus(txId);
  }

// Get Fab Transaction Balance
  Future getFabBalance(String address) async {
    await getFabBalanceByAddress(address);
  }

  // Get ETH Transaction Status
  Future getEthTxStatus(String txId) async {
    await getFabTransactionStatus(txId);
  }

// Get ETH Transaction Balance
  Future getEthBalance(String address) async {
    await getFabBalanceByAddress(address);
  }
/*----------------------------------------------------------------------
                Future Add Gas Do
----------------------------------------------------------------------*/

  Future<Map<String, dynamic>> addGasDo(seed, double amount) async {
    var satoshisPerBytes = 14;
    var scarContractAddress = await getScarAddress();
    scarContractAddress = stringUtils.trimHexPrefix(scarContractAddress);

    var fxnDepositCallHex = '4a58db19';
    var contractInfo = await getFabSmartContract(
        scarContractAddress, fxnDepositCallHex, 800000, 50);

    var res1 = await getFabTransactionHex(seed, [0], contractInfo['contract'],
        amount, contractInfo['totalFee'], satoshisPerBytes, [], false);
    var txHex = res1['txHex'];
    var errMsg = res1['errMsg'];

    var txHash = '';
    if (txHex != null && txHex != '') {
      var res = await _api.postFabTx(txHex);
      txHash = res['txHash'];
      errMsg = res['errMsg'];
    }

    return {'txHex': txHex, 'txHash': txHash, 'errMsg': errMsg};
  }

  convertLiuToFabcoin(amount) {
    return (amount * 1e-8);
  }

/*----------------------------------------------------------------------
                isFabTransactionLocked
----------------------------------------------------------------------*/
  isFabTransactionLocked(String txid, int idx) async {
    if (idx != 0) {
      return false;
    }
    var response = await _api.getFabTransactionJson(txid);

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

/*----------------------------------------------------------------------
                getFabTransactionHex
----------------------------------------------------------------------*/
  getFabTransactionHex(
      seed,
      addressIndexList,
      toAddress,
      double amount,
      double extraTransactionFee,
      int satoshisPerBytes,
      addressList,
      getTransFeeOnly) async {
    final txb = new TransactionBuilder(
        network: environment["chains"]["BTC"]["network"]);
    final root = bip32.BIP32.fromSeed(seed);
    var totalInput = 0;
    var amountInTx = BigInt.from(0);
    var allTxids = [];
    var changeAddress = '';
    var finished = false;
    var receivePrivateKeyArr = [];

    var totalAmount = amount + extraTransactionFee;
    //var amountNum = totalAmount * 1e8;
    var amountNum = BigInt.parse(NumberUtil.toBigInt(totalAmount, 8)).toInt();
    amountNum += (2 * 34 + 10) * satoshisPerBytes;

    var transFeeDouble = 0.0;
    var bytesPerInput = environment["chains"]["FAB"]["bytesPerInput"];
    var feePerInput = bytesPerInput * satoshisPerBytes;

    for (var i = 0; i < addressIndexList.length; i++) {
      var index = addressIndexList[i];
      var fabCoinChild = root.derivePath("m/44'/" +
          environment["CoinType"]["FAB"].toString() +
          "'/0'/0/" +
          index.toString());
      var fromAddress = getBtcAddressForNode(fabCoinChild);
      if (addressList != null && addressList.length > 0) {
        fromAddress = addressList[i];
      }
      if (i == 0) {
        changeAddress = fromAddress;
      }
      final privateKey = fabCoinChild.privateKey;
      var utxos = await _api.getFabUtxos(fromAddress);
      if ((utxos != null) && (utxos.length > 0)) {
        for (var j = 0; j < utxos.length; j++) {
          var utxo = utxos[j];
          var idx = utxo['idx'];
          var txid = utxo['txid'];
          var value = utxo['value'];
          /*
          var isLocked = await isFabTransactionLocked(txid, idx);
          if (isLocked) {
            continue;
          }
           */

          var txidItem = {'txid': txid, 'idx': idx};

          var existed = false;
          for (var iii = 0; iii < txids.length; iii++) {
            var ttt = txids[iii];
            if ((ttt['txid'] == txidItem['txid']) &&
                (ttt['idx'] == txidItem['idx'])) {
              existed = true;
              break;
            }
          }

          if (existed) {
            continue;
          }

          allTxids.add(txidItem);

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
        return {
          'txHex': '',
          'errMsg': 'not enough fab coin to make the transaction.',
          'transFee': transFeeDouble,
          'amountInTx': amountInTx
        };
      }

      var transFee = (receivePrivateKeyArr.length) * feePerInput +
          (2 * 34 + 10) * satoshisPerBytes;

      var output1 = (totalInput -
              BigInt.parse(NumberUtil.toBigInt(amount + extraTransactionFee, 8))
                  .toInt() -
              transFee)
          .round();

      transFeeDouble = ((Decimal.parse(extraTransactionFee.toString()) +
              Decimal.parse(transFee.toString()) / Decimal.parse('1e8')))
          .toDouble();
      if (getTransFeeOnly) {
        return {'txHex': '', 'errMsg': '', 'transFee': transFeeDouble};
      }
      var output2 = BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt();
      ;
      amountInTx = BigInt.from(output2);
      if (output1 < 0 || output2 < 0) {
        return {
          'txHex': '',
          'errMsg': 'output1 or output2 should be greater than 0.',
          'transFee': transFeeDouble,
          'amountInTx': amountInTx
        };
      }

      txb.addOutput(changeAddress, output1);

      txb.addOutput(toAddress, output2);

      for (var i = 0; i < receivePrivateKeyArr.length; i++) {
        var privateKey = receivePrivateKeyArr[i];
        var alice = ECPair.fromPrivateKey(privateKey,
            compressed: true, network: environment["chains"]["BTC"]["network"]);

        txb.sign(vin: i, keyPair: alice);
      }

      var txHex = txb.build().toHex();

      return {
        'txHex': txHex,
        'errMsg': '',
        'transFee': transFeeDouble,
        'amountInTx': amountInTx,
        'txids': allTxids
      };
    }
  }

/*----------------------------------------------------------------------
                getErrDeposit
----------------------------------------------------------------------*/
  Future getErrDeposit(String address) {
    return getKanbanErrDeposit(address);
  }

  toKbPaymentAddress(String fabAddress) {
    return toKbpayAddress(fabAddress);
  }

  Future txHexforSendCoin(seed, coinType, kbPaymentAddress, amount,
      kanbanGasPrice, kanbanGasLimit) async {
    var abiHex = getSendCoinFuncABI(coinType, kbPaymentAddress, amount);

    var keyPairKanban = getExgKeyPair(seed);
    var address = keyPairKanban['address'];
    var nonce = await getNonce(address);

    var coinpoolAddress = await getCoinPoolAddress();

    var txKanbanHex = await signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        coinpoolAddress,
        nonce,
        kanbanGasPrice,
        kanbanGasLimit);
    print('end txHexforSendCoin');
    return txKanbanHex;
  }

  isValidKbAddress(String kbPaymentAddress) {
    var fabAddress = '';
    try {
      fabAddress = toLegacyAddress(kbPaymentAddress);
    } catch (e) {}
    ;
    return (fabAddress != '');
  }

/*----------------------------------------------------------------------
                Send Coin
----------------------------------------------------------------------*/

  Future sendCoin(
      seed, int coin_type, String kbPaymentAddress, double amount) async {
// example: sendCoin(seed, 1, 'oV1KxZswBx2AUypQJRDEb2CsW2Dq2Wp4L5', 0.123);

    var gasPrice = environment["chains"]["KANBAN"]["gasPrice"];
    var gasLimit = environment["chains"]["KANBAN"]["gasLimit"];
    //var amountInLink = BigInt.from(amount * 1e18);
    var amountInLink = BigInt.parse(NumberUtil.toBigInt(amount, 18));
    var txHex = await txHexforSendCoin(
        seed, coin_type, kbPaymentAddress, amountInLink, gasPrice, gasLimit);
    log.e('txhex $txHex');
    var resKanban = await sendKanbanRawTransaction(txHex);
    print('resKanban=');
    print(resKanban);
    return resKanban;
  }

/*----------------------------------------------------------------------
                Send Transaction
----------------------------------------------------------------------*/
  Future sendTransaction(
      String coin,
      seed,
      List addressIndexList,
      List addressList,
      String toAddress,
      double amount,
      options,
      bool doSubmit) async {
    final root = bip32.BIP32.fromSeed(seed);
    var totalInput = 0;
    var finished = false;
    var gasPrice = 0;
    var gasLimit = 0;
    var satoshisPerBytes = 0;
    var bytesPerInput = 0;
    var allTxids = [];
    var getTransFeeOnly = false;
    var txHex = '';
    var txHash = '';
    var errMsg = '';
    var utxos = [];
    var amountInTx = BigInt.from(0);
    var transFeeDouble = 0.0;
    var amountSent = 0;
    var receivePrivateKeyArr = [];

    var tokenType = options['tokenType'] ?? '';
    var contractAddress = options['contractAddress'] ?? '';
    var changeAddress = '';

    if (options != null) {
      if (options["gasPrice"] != null) {
        gasPrice = options["gasPrice"];
      }
      if (options["gasLimit"] != null) {
        gasLimit = options["gasLimit"];
      }
      if (options["satoshisPerBytes"] != null) {
        satoshisPerBytes = options["satoshisPerBytes"];
      }
      if (options["bytesPerInput"] != null) {
        bytesPerInput = options["bytesPerInput"];
      }
      if (options["getTransFeeOnly"] != null) {
        getTransFeeOnly = options["getTransFeeOnly"];
      }
    }
    //print('tokenType=' + tokenType);

    log.w(
        'gasPrice= $gasPrice -- gasLimit =  $gasLimit -- satoshisPerBytes= $satoshisPerBytes');

    // BTC
    if (coin == 'BTC') {
      if (bytesPerInput == 0) {
        bytesPerInput = environment["chains"]["BTC"]["bytesPerInput"];
      }
      if (satoshisPerBytes == 0) {
        satoshisPerBytes = environment["chains"]["BTC"]["satoshisPerBytes"];
      }
      var amountNum = BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt();
      amountNum += (2 * 34 + 10) * satoshisPerBytes;
      final txb = new TransactionBuilder(
          network: environment["chains"]["BTC"]["network"]);
      // txb.setVersion(1);

      for (var i = 0; i < addressIndexList.length; i++) {
        var index = addressIndexList[i];
        var bitCoinChild = root.derivePath("m/44'/" +
            environment["CoinType"]["BTC"].toString() +
            "'/0'/0/" +
            index.toString());
        var fromAddress = getBtcAddressForNode(bitCoinChild);
        if (addressList.length > 0) {
          fromAddress = addressList[i];
        }
        if (i == 0) {
          changeAddress = fromAddress;
        }
        final privateKey = bitCoinChild.privateKey;
        var utxos = await _api.getBtcUtxos(fromAddress);
        //print('utxos=');
        //print(utxos);
        if ((utxos == null) || (utxos.length == 0)) {
          continue;
        }
        for (var j = 0; j < utxos.length; j++) {
          var tx = utxos[j];
          if (tx['idx'] < 0) {
            continue;
          }
          txb.addInput(tx['txid'], tx['idx']);
          amountNum -= tx['value'];
          amountNum += bytesPerInput * satoshisPerBytes;
          totalInput += tx['value'];
          receivePrivateKeyArr.add(privateKey);
          if (amountNum <= 0) {
            finished = true;
            break;
          }
        }
      }

      if (!finished) {
        txHex = '';
        txHash = '';
        errMsg = 'not enough fund.';
        return {
          'txHex': txHex,
          'txHash': txHash,
          'errMsg': errMsg,
          'amountInTx': amountInTx
        };
      }

      var transFee =
          (receivePrivateKeyArr.length) * bytesPerInput * satoshisPerBytes +
              (2 * 34 + 10) * satoshisPerBytes;

      var output1 = (totalInput -
              BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt() -
              transFee)
          .round();

      if (output1 < 2730) {
        transFee += output1;
      }

      transFeeDouble = transFee / 1e8;
      if (getTransFeeOnly) {
        return {
          'txHex': '',
          'txHash': '',
          'errMsg': '',
          'amountSent': '',
          'transFee': transFeeDouble
        };
      }

      var output2 = BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt();

      if (output1 >= 2730) {
        txb.addOutput(changeAddress, output1);
      }

      amountInTx = BigInt.from(output2);
      txb.addOutput(toAddress, output2);
      for (var i = 0; i < receivePrivateKeyArr.length; i++) {
        var privateKey = receivePrivateKeyArr[i];
        var alice = ECPair.fromPrivateKey(privateKey,
            compressed: true, network: environment["chains"]["BTC"]["network"]);
        txb.sign(vin: i, keyPair: alice);
      }

      var tx = txb.build();
      txHex = tx.toHex();
      if (doSubmit) {
        var res = await _api.postBtcTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
        return {'txHash': txHash, 'errMsg': errMsg, 'amountInTx': amountInTx};
      } else {
        txHash = '0x' + tx.getId();
      }
    }

    // BCH Transaction
    else if (coin == 'BCH') {
      if (bytesPerInput == 0) {
        bytesPerInput = environment["chains"]["BCH"]["bytesPerInput"];
      }
      if (satoshisPerBytes == 0) {
        satoshisPerBytes = environment["chains"]["BCH"]["satoshisPerBytes"];
      }
      var amountNum = BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt();
      amountNum += (2 * 34 + 10) * satoshisPerBytes;

      final txb = Bitbox.Bitbox.transactionBuilder(
          testnet: environment["chains"]["BCH"]["testnet"]);
      final masterNode =
          Bitbox.HDNode.fromSeed(seed, environment["chains"]["BCH"]["testnet"]);
      final childNode =
          "m/44'/" + environment["CoinType"]["BCH"].toString() + "'/0'/0/0";
      final accountNode = masterNode.derivePath(childNode);
      final address = accountNode.toCashAddress();

      final utxos = await _api.getBchUtxos(address);

      if ((utxos == null) || (utxos.length == 0)) {
        return {
          'txHex': '',
          'txHash': '',
          'errMsg': 'not enough fund',
          'amountInTx': amountInTx
        };
      }

      final signatures = <Map>[];

      for (var j = 0; j < utxos.length; j++) {
        var tx = utxos[j];
        if (tx['idx'] < 0) {
          continue;
        }
        txb.addInput(tx['txid'], tx['idx']);

        // add a signature to the list to be used later
        signatures.add({
          "vin": signatures.length,
          "key_pair": accountNode.keyPair,
          "original_amount": tx['value']
        });

        amountNum -= tx['value'];
        amountNum += bytesPerInput * satoshisPerBytes;
        totalInput += tx['value'];
        if (amountNum <= 0) {
          finished = true;
          break;
        }
      }

      if (!finished) {
        return {'txHex': '', 'txHash': '', 'errMsg': 'not enough fund'};
      }

      var transFee = (signatures.length) * bytesPerInput * satoshisPerBytes +
          (2 * 34 + 10) * satoshisPerBytes;
      transFeeDouble = transFee / 1e8;

      if (getTransFeeOnly) {
        return {
          'txHex': '',
          'txHash': '',
          'errMsg': '',
          'amountSent': '',
          'transFee': transFeeDouble,
          'amountInTx': amountInTx
        };
      }

      var output1 = (totalInput -
              BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt() -
              transFee)
          .round();
      var output2 = BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt();

      amountInTx = BigInt.from(output2);
      txb.addOutput(address, output1);
      txb.addOutput(toAddress, output2);

      signatures.forEach((signature) {
        txb.sign(signature["vin"], signature["key_pair"],
            signature["original_amount"]);
      });

      final tx = txb.build();
      txHex = tx.toHex();
      if (doSubmit) {
        var res = await _api.postBchTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
        return {'txHash': txHash, 'errMsg': errMsg, 'amountInTx': amountInTx};
      } else {
        txHash = '0x' + tx.getId();
      }
    }

    // LTC Transaction
    else if (coin == 'LTC') {
      if (bytesPerInput == 0) {
        bytesPerInput = environment["chains"]["LTC"]["bytesPerInput"];
      }
      if (satoshisPerBytes == 0) {
        satoshisPerBytes = environment["chains"]["LTC"]["satoshisPerBytes"];
      }
      var amountNum = BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt();
      amountNum += (2 * 34 + 10) * satoshisPerBytes;
      final txb = new TransactionBuilder(
          network: environment["chains"]["LTC"]["network"]);

      for (var i = 0; i < addressIndexList.length; i++) {
        var index = addressIndexList[i];
        var node = root.derivePath("m/44'/" +
            environment["CoinType"]["LTC"].toString() +
            "'/0'/0/" +
            index.toString());
        var fromAddress = getLtcAddressForNode(node);
        if (addressList.length > 0) {
          fromAddress = addressList[i];
        }
        if (i == 0) {
          changeAddress = fromAddress;
        }
        final privateKey = node.privateKey;
        var utxos = await _api.getLtcUtxos(fromAddress);

        if ((utxos == null) || (utxos.length == 0)) {
          continue;
        }
        for (var j = 0; j < utxos.length; j++) {
          var tx = utxos[j];
          if (tx['idx'] < 0) {
            continue;
          }
          txb.addInput(tx['txid'], tx['idx']);
          amountNum -= tx['value'];
          amountNum += bytesPerInput * satoshisPerBytes;
          totalInput += tx['value'];
          receivePrivateKeyArr.add(privateKey);
          if (amountNum <= 0) {
            finished = true;
            break;
          }
        }
      }

      if (!finished) {
        txHex = '';
        txHash = '';
        errMsg = 'not enough fund.';
        return {
          'txHex': txHex,
          'txHash': txHash,
          'errMsg': errMsg,
          'amountInTx': amountInTx
        };
      }

      var transFee =
          (receivePrivateKeyArr.length) * bytesPerInput * satoshisPerBytes +
              (2 * 34 + 10) * satoshisPerBytes;
      transFeeDouble = transFee / 1e8;

      if (getTransFeeOnly) {
        return {
          'txHex': '',
          'txHash': '',
          'errMsg': '',
          'amountSent': '',
          'transFee': transFeeDouble
        };
      }

      var output1 = (totalInput -
              BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt() -
              transFee)
          .round();
      var output2 = BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt();
      amountInTx = BigInt.from(output2);
      txb.addOutput(changeAddress, output1);
      txb.addOutput(toAddress, output2);
      for (var i = 0; i < receivePrivateKeyArr.length; i++) {
        var privateKey = receivePrivateKeyArr[i];
        var alice = ECPair.fromPrivateKey(privateKey,
            compressed: true, network: environment["chains"]["LTC"]["network"]);
        txb.sign(vin: i, keyPair: alice);
      }

      var tx = txb.build();
      txHex = tx.toHex();
      if (doSubmit) {
        var res = await _api.postLtcTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
        return {'txHash': txHash, 'errMsg': errMsg, 'amountInTx': amountInTx};
      } else {
        txHash = '0x' + tx.getId();
      }
    }

    // DOGE Transaction
    else if (coin == 'DOGE') {
      if (bytesPerInput == 0) {
        bytesPerInput = environment["chains"]["DOGE"]["bytesPerInput"];
      }
      if (satoshisPerBytes == 0) {
        satoshisPerBytes = environment["chains"]["DOGE"]["satoshisPerBytes"];
      }
      var amountNum = BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt();
      amountNum += (2 * 34 + 10) * satoshisPerBytes;
      final txb = new TransactionBuilder(
          network: environment["chains"]["DOGE"]["network"]);

      for (var i = 0; i < addressIndexList.length; i++) {
        var index = addressIndexList[i];
        var node = root.derivePath("m/44'/" +
            environment["CoinType"]["DOGE"].toString() +
            "'/0'/0/" +
            index.toString());
        var fromAddress = getDogeAddressForNode(node);
        print('fromAddress==' + fromAddress);
        if (addressList.length > 0) {
          fromAddress = addressList[i];
        }
        if (i == 0) {
          changeAddress = fromAddress;
        }

        final privateKey = node.privateKey;
        var utxos = await _api.getDogeUtxos(fromAddress);
        //print('utxos=');
        //print(utxos);
        if ((utxos == null) || (utxos.length == 0)) {
          continue;
        }
        for (var j = 0; j < utxos.length; j++) {
          var tx = utxos[j];
          if (tx['idx'] < 0) {
            continue;
          }
          txb.addInput(tx['txid'], tx['idx']);
          amountNum -= tx['value'];
          amountNum += bytesPerInput * satoshisPerBytes;
          totalInput += tx['value'];
          receivePrivateKeyArr.add(privateKey);
          if (amountNum <= 0) {
            finished = true;
            break;
          }
        }
      }

      if (!finished) {
        txHex = '';
        txHash = '';
        errMsg = 'not enough fund.';
        return {
          'txHex': txHex,
          'txHash': txHash,
          'errMsg': errMsg,
          'amountInTx': amountInTx
        };
      }

      var transFee =
          (receivePrivateKeyArr.length) * bytesPerInput * satoshisPerBytes +
              (2 * 34 + 10) * satoshisPerBytes;
      transFeeDouble = transFee / 1e8;

      if (getTransFeeOnly) {
        return {
          'txHex': '',
          'txHash': '',
          'errMsg': '',
          'amountSent': '',
          'transFee': transFeeDouble,
          'amountInTx': amountInTx
        };
      }

      var output1 = (totalInput -
              BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt() -
              transFee)
          .round();
      var output2 = BigInt.parse(NumberUtil.toBigInt(amount, 8)).toInt();
      amountInTx = BigInt.from(output2);
      txb.addOutput(changeAddress, output1);

      txb.addOutput(toAddress, output2);

      for (var i = 0; i < receivePrivateKeyArr.length; i++) {
        var privateKey = receivePrivateKeyArr[i];
        var alice = ECPair.fromPrivateKey(privateKey,
            compressed: true,
            network: environment["chains"]["DOGE"]["network"]);
        txb.sign(vin: i, keyPair: alice);
      }
      var tx = txb.build();
      txHex = tx.toHex();
      if (doSubmit) {
        var res = await _api.postDogeTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
        return {'txHash': txHash, 'errMsg': errMsg, 'amountInTx': amountInTx};
      } else {
        txHash = '0x' + tx.getId();
      }
    }

    // ETH Transaction

    else if (coin == 'ETH') {
      // Credentials fromHex = EthPrivateKey.fromHex("c87509a[...]dc0d3");

      if (gasPrice == 0) {
        gasPrice = environment["chains"]["ETH"]["gasPrice"];
      }
      if (gasLimit == 0) {
        gasLimit = environment["chains"]["ETH"]["gasLimit"];
      }
      transFeeDouble = (BigInt.parse(gasPrice.toString()) *
              BigInt.parse(gasLimit.toString()) /
              BigInt.parse('1000000000'))
          .toDouble();

      if (getTransFeeOnly) {
        return {
          'txHex': '',
          'txHash': '',
          'errMsg': '',
          'amountSent': '',
          'transFee': transFeeDouble
        };
      }

      final chainId = environment["chains"]["ETH"]["chainId"];
      final ethCoinChild = root.derivePath(
          "m/44'/" + environment["CoinType"]["ETH"].toString() + "'/0'/0/0");
      final privateKey = HEX.encode(ethCoinChild.privateKey);
      var amountSentInt = BigInt.parse(NumberUtil.toBigInt(amount, 18));

      Credentials credentials = EthPrivateKey.fromHex(privateKey);

      final address = await credentials.extractAddress();
      final addressHex = address.hex;
      final nonce = await _api.getEthNonce(addressHex);

      var apiUrl =
          environment["chains"]["ETH"]["infura"]; //Replace with your API

      var httpClient = new http.Client();
      var ethClient = new Web3Client(apiUrl, httpClient);

      amountInTx = amountSentInt;
      final signed = await ethClient.signTransaction(
          credentials,
          Transaction(
            nonce: nonce,
            to: EthereumAddress.fromHex(toAddress),
            gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice),
            maxGas: gasLimit,
            value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amountSentInt),
          ),
          chainId: chainId,
          fetchChainIdFromNetworkId: false);

      txHex = '0x' + HEX.encode(signed);

      print('txHex in ETH=' + txHex);
      if (doSubmit) {
        var res = await _api.postEthTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      } else {
        txHash = getTransactionHash(signed);
      }
    } else if (coin == 'FAB') {
      if (bytesPerInput == 0) {
        bytesPerInput = environment["chains"]["FAB"]["bytesPerInput"];
      }
      if (satoshisPerBytes == 0) {
        satoshisPerBytes = environment["chains"]["FAB"]["satoshisPerBytes"];
      }

      var res1 = await getFabTransactionHex(seed, addressIndexList, toAddress,
          amount, 0, satoshisPerBytes, addressList, getTransFeeOnly);
      if (getTransFeeOnly) {
        return {
          'txHex': '',
          'txHash': '',
          'errMsg': '',
          'amountSent': '',
          'transFee': res1["transFee"],
          'amountInTx': res1["amountInTx"]
        };
      }
      txHex = res1['txHex'];
      errMsg = res1['errMsg'];
      allTxids = res1['txids'];
      amountInTx = res1["amountInTx"];

      if ((errMsg == '') && (txHex != '')) {
        if (doSubmit) {
          var res = await _api.postFabTx(txHex);

          txHash = res['txHash'];
          errMsg = res['errMsg'];
        } else {
          var tx = btcTransaction.Transaction.fromHex(txHex);
          txHash = '0x' + tx.getId();
        }
      }
    }

    // Token FAB

    else if (tokenType == 'FAB') {
      if (bytesPerInput == 0) {
        bytesPerInput = environment["chains"]["FAB"]["bytesPerInput"];
      }
      if (satoshisPerBytes == 0) {
        satoshisPerBytes = environment["chains"]["FAB"]["satoshisPerBytes"];
      }
      if (gasPrice == 0) {
        gasPrice = environment["chains"]["FAB"]["gasPrice"];
      }
      if (gasLimit == 0) {
        gasLimit = environment["chains"]["FAB"]["gasLimit"];
      }
      var transferAbi = 'a9059cbb';
      var amountSentInt = BigInt.parse(NumberUtil.toBigInt(amount));

      if (coin == 'DUSD') {
        amountSentInt = BigInt.parse(NumberUtil.toBigInt(amount, 6));
      }

      amountInTx = amountSentInt;
      var amountSentHex = amountSentInt.toRadixString(16);

      var fxnCallHex = transferAbi +
          stringUtils.fixLength(stringUtils.trimHexPrefix(toAddress), 64) +
          stringUtils.fixLength(stringUtils.trimHexPrefix(amountSentHex), 64);

      contractAddress = stringUtils.trimHexPrefix(contractAddress);

      var contractInfo = await getFabSmartContract(
          contractAddress, fxnCallHex, gasLimit, gasPrice);

      if (addressList != null && addressList.length > 0) {
        addressList[0] = exgToFabAddress(addressList[0]);
      }

      var res1 = await getFabTransactionHex(
          seed,
          addressIndexList,
          contractInfo['contract'],
          0,
          contractInfo['totalFee'],
          satoshisPerBytes,
          addressList,
          getTransFeeOnly);

      print('res1 in here=');
      print(res1);

      if (getTransFeeOnly) {
        return {
          'txHex': '',
          'txHash': '',
          'errMsg': '',
          'amountSent': '',
          'transFee': res1["transFee"],
          'amountInTx': amountInTx
        };
      }

      txHex = res1['txHex'];
      errMsg = res1['errMsg'];
      allTxids = res1['txids'];
      if (txHex != null && txHex != '') {
        if (doSubmit) {
          var res = await _api.postFabTx(txHex);
          txHash = res['txHash'];
          errMsg = res['errMsg'];
        } else {
          var tx = btcTransaction.Transaction.fromHex(txHex);
          txHash = '0x' + tx.getId();
        }
      }
    }
    // Token type ETH
    else if (tokenType == 'ETH') {
      if (gasPrice == 0) {
        gasPrice = environment["chains"]["ETH"]["gasPrice"];
      }
      if (gasLimit == 0) {
        gasLimit = environment["chains"]["ETH"]["gasLimitToken"];
      }
      transFeeDouble = (BigInt.parse(gasPrice.toString()) *
              BigInt.parse(gasLimit.toString()) /
              BigInt.parse('1000000000'))
          .toDouble();
      log.i('transFeeDouble===' + transFeeDouble.toString());
      if (getTransFeeOnly) {
        return {
          'txHex': '',
          'txHash': '',
          'errMsg': '',
          'amountSent': '',
          'transFee': transFeeDouble
        };
      }

      final chainId = environment["chains"]["ETH"]["chainId"];
      final ethCoinChild = root.derivePath(
          "m/44'/" + environment["CoinType"]["ETH"].toString() + "'/0'/0/0");
      final privateKey = HEX.encode(ethCoinChild.privateKey);
      Credentials credentials = EthPrivateKey.fromHex(privateKey);

      final address = await credentials.extractAddress();
      final addressHex = address.hex;
      final nonce = await _api.getEthNonce(addressHex);

      //gasLimit = 100000;
      var convertedDecimalAmount;
      if (coin == 'BNB' ||
          coin == 'INB' ||
          coin == 'REP' ||
          coin == 'HOT' ||
          coin == 'MATIC' ||
          coin == 'IOST' ||
          coin == 'MANA' ||
          coin == 'ELF' ||
          coin == 'GNO' ||
          coin == 'WINGS' ||
          coin == 'KNC' ||
          coin == 'GVT' ||
          coin == 'DRGN') {
        convertedDecimalAmount = BigInt.parse(NumberUtil.toBigInt(amount));
        //   (BigInt.from(10).pow(18) * BigInt.from(amount));

        //var amountSentInt = BigInt.parse(toBigInt(amount, 18));
        log.e('amount send $convertedDecimalAmount');
      } else if (coin == 'FUN' || coin == 'WAX' || coin == 'MTL') {
        convertedDecimalAmount = BigInt.parse(NumberUtil.toBigInt(amount, 8));
        log.e('amount send $convertedDecimalAmount');
      } else if (coin == 'POWR' || coin == 'USDT') {
        convertedDecimalAmount = BigInt.parse(NumberUtil.toBigInt(amount, 6));
      } else if (coin == 'CEL') {
        convertedDecimalAmount = BigInt.parse(NumberUtil.toBigInt(amount, 4));
      }

      amountInTx = convertedDecimalAmount;
      var transferAbi = 'a9059cbb';
      var fxnCallHex = transferAbi +
          stringUtils.fixLength(stringUtils.trimHexPrefix(toAddress), 64) +
          stringUtils.fixLength(
              stringUtils
                  .trimHexPrefix(convertedDecimalAmount.toRadixString(16)),
              64);
      var apiUrl =
          environment["chains"]["ETH"]["infura"]; //Replace with your API

      var httpClient = new http.Client();
      var ethClient = new Web3Client(apiUrl, httpClient);
      print('5 $nonce -- $contractAddress -- ${EtherUnit.wei} -- $fxnCallHex');
      final signed = await ethClient.signTransaction(
          credentials,
          Transaction(
              nonce: nonce,
              to: EthereumAddress.fromHex(contractAddress),
              gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice),
              maxGas: gasLimit,
              value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 0),
              data: Uint8List.fromList(stringUtils.hex2Buffer(fxnCallHex))),
          chainId: chainId,
          fetchChainIdFromNetworkId: false);
      log.w('signed=');
      txHex = '0x' + HEX.encode(signed);

      if (doSubmit) {
        var res = await _api.postEthTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      } else {
        txHash = getTransactionHash(signed);
      }
    }
    return {
      'txHex': txHex,
      'txHash': txHash,
      'errMsg': errMsg,
      'amountSent': amount,
      'transFee': transFeeDouble,
      'amountInTx': amountInTx,
      'txids': allTxids
    };
  }

/*----------------------------------------------------------------------
                getFabSmartContract
----------------------------------------------------------------------*/
  getFabSmartContract(
      String contractAddress, String fxnCallHex, gasLimit, gasPrice) async {
    contractAddress = stringUtils.trimHexPrefix(contractAddress);
    fxnCallHex = stringUtils.trimHexPrefix(fxnCallHex);

    var totalAmount = (Decimal.parse(gasLimit.toString()) *
            Decimal.parse(gasPrice.toString()) /
            Decimal.parse('1e8'))
        .toDouble();
    // let cFee = 3000 / 1e8 // fee for the transaction

    var totalFee = totalAmount;
    var chunks = new List<dynamic>();
    log.w('Address $contractAddress');
    chunks.add(84);
    chunks.add(Uint8List.fromList(stringUtils.number2Buffer(gasLimit)));
    chunks.add(Uint8List.fromList(stringUtils.number2Buffer(gasPrice)));
    chunks.add(Uint8List.fromList(stringUtils.hex2Buffer(fxnCallHex)));
    chunks.add(Uint8List.fromList(stringUtils.hex2Buffer(contractAddress)));
    chunks.add(194);

    var contract = script.compile(chunks);

    var contractSize = contract.toString().length;

    totalFee += convertLiuToFabcoin(contractSize * 10);

    var res = {'contract': contract, 'totalFee': totalFee};
    return res;
  }
}
