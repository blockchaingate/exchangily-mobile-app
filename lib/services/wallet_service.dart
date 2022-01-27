import 'dart:convert';

import 'package:bitbox/bitbox.dart' as Bitbox;
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/dialog/dialog_response.dart';
import 'package:exchangilymobileapp/models/wallet/token.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/user_settings_model.dart';
import 'package:exchangilymobileapp/models/wallet/core_wallet_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/btc_util.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:exchangilymobileapp/utils/kanban.util.dart';
import 'package:exchangilymobileapp/utils/ltc_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:exchangilymobileapp/utils/wallet_coin_address_utils/doge_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:async';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import 'dart:typed_data';
import 'package:web3dart/web3dart.dart';
import '../environments/coins.dart' as coinList;
import '../utils/abi_util.dart';
import '../utils/number_util.dart';
import '../utils/string_util.dart' as stringUtils;
import '../utils/keypair_util.dart';
import '../utils/eth_util.dart';
import '../utils/fab_util.dart';
import '../utils/coin_util.dart';

import 'package:bitcoin_flutter/src/utils/script.dart' as script;
import '../environments/environment.dart';
import 'package:encrypt/encrypt.dart' as prefix0;
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:decimal/decimal.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart' as BitcoinFlutter;
import 'db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/utils/exaddr.dart';
import 'package:web3dart/crypto.dart' as CryptoWeb3;
import 'package:crypto/crypto.dart' as CryptoHash;

import 'package:exchangilymobileapp/utils/tron_util/trx_generate_address_util.dart'
    as TronAddressUtil;
import 'package:exchangilymobileapp/utils/tron_util/trx_transaction_util.dart'
    as TronTransactionUtil;

class WalletService {
  final log = getLogger('Wallet Service');

  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  ApiService apiService = locator<ApiService>();

  SharedService sharedService = locator<SharedService>();
  final storageService = locator<LocalStorageService>();
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  final coreWalletDatabaseService = locator<CoreWalletDatabaseService>();
  final walletDatabaseService = locator<WalletDatabaseService>();

  double currentTickerUsdValue;
  var txids = [];
  var httpClient = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  double coinUsdBalance;

  Map<String, String> coinTickerAndNameList = {
    'BTC': 'Bitcoin',
    'ETH': 'Ethereum',
    'FAB': 'Fast Access Blockchain',
    'USDT': 'USDT',
    'EXG': 'Exchangily',
    'DUSD': 'DUSD',
    'TRX': 'Tron',
    'BCH': 'Bitcoin Cash',
    'LTC': 'Litecoin',
    'DOGE': 'Dogecoin',
    'INB': 'Insight chain',
    'DRGN': 'Dragonchain',
    'HOT': 'Holo',
    'CEL': 'Celsius',
    'MATIC': 'Matic Network',
    'IOST': 'IOST',
    'MANA': 'Decentraland',
    'WAX': 'Wax',
    'ELF': 'aelf',
    'GNO': 'Gnosis',
    'POWR': 'Power Ledger',
    'WINGS': 'Wings',
    'MTL': 'Metal',
    'KNC': 'Kyber Network',
    'GVT': 'Genesis Vision'
  };
  List<String> coinTickers = [
    'BTC',
    'ETH',
    'FAB',
    'EXG',
    'USDT',
    'DUSD',
    'TRX',
    'BCH',
    'LTC',
    'DOGE',
    'INB',
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
    'FAB',
    'ETH',
    'FAB',
    '',
    '',
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
    'ETH',
    'ETH'
  ];

  List<String> coinNames = [
    'Bitcoin',
    'Ethereum',
    'Fabcoin',
    'Exchangily',
    'Tether',
    'DUSD',
    'Tron',
    'Bitcoin Cash',
    'Litecoin',
    'Dogecoin',
    'Insight chain',
    'Dragonchain',
    'Holo',
    'Celsius',
    'Matic Network',
    'IOST',
    'Decentraland',
    'Wax',
    'aelf',
    'Gnosis',
    'Power Ledger',
    'Wings',
    'Metal',
    'Kyber Network',
    'Genesis Vision'
  ];

  Completer<DialogResponse> _completer;
  final fabUtils = FabUtils();
  final btcUtils = BtcUtils();
  final abiUtils = AbiUtils();
  final coinUtils = CoinUtils();
  final ethUtils = EthUtils();
  final kanbanUtils = KanbanUtils();
  final ltcUtils = LtcUtils();

  Future<String> getAddressFromCoreWalletDatabaseByTickerName(
      String tickerName) async {
    String address = '';

    address = await coreWalletDatabaseService
        .getWalletAddressByTickerName(tickerName);

    return address;
  }

// coin type(int) to token type(String)
  String getTokenType(int coinType) {
    String tokenType = '';
// 0001 = BTC
// 0002 = FAB
// 0003 = ETH
// 0004 - BCH
// 0005 - LTC
// 0006 - DOGE
// 0007 = TRON

// CEL
// cointype 196612
// converts to 00030004
// so we know that this is an eth token since 0003 = eth chain and 4 !=0

    String hexCoinType =
        abiUtils.fix8LengthCoinType(coinType.toRadixString(16));
    String firstHalf = hexCoinType.substring(0, 4);
    String secondHalf = hexCoinType.substring(4, 8);

    log.i('hexCoinType $hexCoinType - ');
    if (secondHalf == '0000')
      // native token
      tokenType = '';
    else if (firstHalf == '0001' && secondHalf != '0000')
      tokenType = 'BTC';
    else if (firstHalf == '0002' && secondHalf != '0000')
      tokenType = 'FAB';
    else if (firstHalf == '0003' && secondHalf != '0000')
      tokenType = 'ETH';
    else if (firstHalf == '0004' && secondHalf != '0000')
      tokenType = 'BCH';
    else if (firstHalf == '0005' && secondHalf != '0000')
      tokenType = 'LTC';
    else if (firstHalf == '0006' && secondHalf != '0000')
      tokenType = 'DOGE';
    else if (firstHalf == '0007' && secondHalf != '0000') tokenType = 'TRON';
    log.i('hexCoinType $hexCoinType - tokenType $tokenType');
    return tokenType;
  }

  storeTokenListInDB() async {
    var existingTokensInTokenDatabase;
    try {
      existingTokensInTokenDatabase = await tokenListDatabaseService.getAll();
    } catch (err) {
      existingTokensInTokenDatabase = [];
      log.e('getTokenList tokenListDatabaseService.getAll CATCH err $err');
    }
    await getTokenListUpdates().then((newTokenListFromTokenUpdateApi) async {
      if (newTokenListFromTokenUpdateApi != null &&
          newTokenListFromTokenUpdateApi.isNotEmpty) {
        if (existingTokensInTokenDatabase == null)
          existingTokensInTokenDatabase = [];
        if (existingTokensInTokenDatabase.length !=
            newTokenListFromTokenUpdateApi.length) {
          await tokenListDatabaseService.deleteDb().whenComplete(() => log.e(
              'token list database cleared before inserting updated token data from api'));

          /// Fill the token list database with new data from the api

          newTokenListFromTokenUpdateApi.forEach((singleNewToken) async {
            await tokenListDatabaseService.insert(singleNewToken);
          });
        } else {
          log.i('storeTokenListInDB -- local token db same length as api\'s ');
        }
      }
    });
  }

/*----------------------------------------------------------------------
                      Is tron coin
----------------------------------------------------------------------*/
  bool isTrx(String tickerName) {
    log.i(
        'tickername $tickerName:  isTrx ${tickerName == 'TRX' || tickerName == 'USDTX'}');
    return tickerName == 'TRX' || tickerName == 'USDTX' ? true : false;
  }

/*----------------------------------------------------------------------
                      Get decimal data
----------------------------------------------------------------------*/

  Future<int> getSingleCoinWalletDecimalLimit(String coinName) async {
    int res = 0;
// first look coin in the local storage
// TODO uncomment code below once save decimaldata in local storage works in wallet service
    // List<Map<String, int>> decimalDataFromStorage =
    //     jsonEncode(storageService.walletDecimalList) as List;
    // decimalDataFromStorage.forEach((decimalDataList) {
    //   if (decimalDataList.containsKey(coinName))
    //     res = decimalDataList[coinName];
    // });

    // if res not found in local storage then call old token list api
    if (res == null || res == 0) {
      await apiService.getTokenList().then((token) {
        token.forEach((token) {
          if (token.tickerName == coinName) res = token.decimal;
        });
      });
    }

    // if res not found in local storage then call new token list api
    if (res == null || res == 0) {
      await apiService.getTokenListUpdates().then((token) {
        token.forEach((token) async {
          //    await tokenListDatabaseService.insert(token);
          if (token.tickerName == coinName) res = token.decimal;
        });
      });
    }
    return res;
  }

  Future<bool> hasSufficientWalletBalance(
      double amount, String tickerName) async {
    bool isValidAmount = true;
    String fabAddress =
        await coreWalletDatabaseService.getWalletAddressByTickerName('FAB');

    String thirdPartyAddress = await coreWalletDatabaseService
        .getWalletAddressByTickerName(tickerName);
    log.w('coinAddress $thirdPartyAddress');
    await apiService
        .getSingleWalletBalance(fabAddress, tickerName, thirdPartyAddress)
        .then((walletBalance) {
      if (walletBalance != null) {
        log.w(walletBalance[0].balance);
        if (walletBalance[0].balance < amount)
          isValidAmount = false;
        else
          isValidAmount = true;
      }
    }).catchError((err) {
      log.e(err);

      throw Exception(err);
    });
    return isValidAmount;
  }

/*----------------------------------------------------------------------
                Update special tokens tickername in UI
----------------------------------------------------------------------*/
  updateSpecialTokensTickerNameForTxHistory(String tickerName) {
    String logoTicker = '';
    if (tickerName.toUpperCase() == 'ETH_BST' ||
        tickerName.toUpperCase() == 'BSTE') {
      tickerName = 'BST(ERC20)';
      logoTicker = 'BSTE';
    } else if (tickerName.toUpperCase() == 'ETH_DSC' ||
        tickerName.toUpperCase() == 'DSCE') {
      tickerName = 'DSC(ERC20)';
      logoTicker = 'DSCE';
    } else if (tickerName.toUpperCase() == 'ETH_EXG' ||
        tickerName.toUpperCase() == 'EXGE') {
      tickerName = 'EXG(ERC20)';
      logoTicker = 'EXGE';
    } else if (tickerName.toUpperCase() == 'ETH_FAB' ||
        tickerName.toUpperCase() == 'FABE') {
      tickerName = 'FAB(ERC20)';
      logoTicker = 'FABE';
    } else if (tickerName.toUpperCase() == 'TRON_USDT' ||
        tickerName.toUpperCase() == 'USDTX') {
      tickerName = 'USDT(TRC20)';
      logoTicker = 'USDTX';
    } else if (tickerName.toUpperCase() == 'USDT') {
      tickerName = 'USDT(ERC20)';
      logoTicker = 'USDT';
    } else {}
    return {"tickerName": tickerName, "logoTicker": logoTicker};
  }

/*----------------------------------------------------------------------
                Get Random Mnemonic
----------------------------------------------------------------------*/
  Future<List<TokenModel>> getTokenListUpdates() async {
    List<TokenModel> newTokens = [];
    await apiService.getTokenListUpdates().then((tokenList) {
      if (tokenList != null) {
        log.w(
            'getTokenListUpdates token list from api length ${tokenList.length}');
        newTokens = tokenList;
      }
    }).catchError((err) {
      log.e('getTokenListUpdates Catch $err');
      return null;
    });
    return newTokens;
  }

  // addTxids(allTxids) {
  //   txids = [...txids, ...allTxids].toSet().toList();
  // }

  /*----------------------------------------------------------------------
                    Check Language
----------------------------------------------------------------------*/
  Future checkLanguage() async {
    UserSettingsDatabaseService userSettingsDatabaseService =
        locator<UserSettingsDatabaseService>();
    //lang = storageService.language;

    await userSettingsDatabaseService.getAll().then((res) {
      if (res == null || res == [] || res.isEmpty) {
        log.e('language empty- setting english');
        storageService.language = "en";
        AppLocalizations.load(Locale('en', 'EN'));
      } else {
        String languageFromDb = res[0].language;
        AppLocalizations.load(
            Locale(languageFromDb, languageFromDb.toUpperCase()));
        storageService.language = languageFromDb;
        log.i('language $languageFromDb found');
      }
    }).catchError((err) => log.e('user setting db empty'));
  }

  updateUserSettingsDb(UserSettings userSettings, isUserSettingsEmpty) async {
    UserSettingsDatabaseService userSettingsDatabaseService =
        locator<UserSettingsDatabaseService>();
    isUserSettingsEmpty
        ? await userSettingsDatabaseService
            .insert(userSettings)
            .then((value) => null)
            .catchError((err) async {
            log.e(
                'In updateUserSettingsDb -- INSERT Catch- deleting the database and re-inserting the data');
            await userSettingsDatabaseService.deleteDb().then((value) => () {
                  userSettingsDatabaseService.insert(userSettings);
                });
          })
        : await userSettingsDatabaseService
            .update(userSettings)
            .then((value) => null)
            .catchError((err) async {
            log.e(
                'In updateUserSettingsDb -- UPDATE Catch- deleting the database and re-inserting the data');
            await userSettingsDatabaseService.deleteDb().then((value) => () {
                  userSettingsDatabaseService.update(userSettings);
                });
          });
    await userSettingsDatabaseService.getAll();
  }

/*----------------------------------------------------------------------
                Get Random Mnemonic
----------------------------------------------------------------------*/
  String getRandomMnemonic() {
    String randomMnemonic = '';

    randomMnemonic = bip39.generateMnemonic();
    return randomMnemonic;
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

  sha256Twice(bytes) {
    var digest1 = CryptoHash.sha256.convert(bytes);
    var digest2 = CryptoHash.sha256.convert(digest1.bytes);
    //SHA256(addressHex);
    print('digest2  -- $digest2');
    return digest2;
  }

/*----------------------------------------------------------------------
                    Generate TRX address
----------------------------------------------------------------------*/

  generateTrxAddress(String mnemonic) {
    var seed = generateSeed(mnemonic);
    var root = generateBip32Root(seed);
    print('root $root');
    String ct = '195';
    bip32.BIP32 node =
        root.derivePath("m/44'/" + ct + "'/0'/0/" + 0.toString());
    print('node $node');
    var privKey = node.privateKey;
    //  var pubKey = node.publicKey;
    //  log.w('pub key $pubKey -- length ${pubKey.length}');
    var uncompressedPubKey =
        BitcoinFlutter.ECPair.fromPrivateKey(privKey, compressed: false)
            .publicKey;
    log.e('uncompressedPubKey  length ${uncompressedPubKey.length}');
    log.w('uncompressedPubKey ${uint8ListToHex(uncompressedPubKey)}');

    if (uncompressedPubKey.length == 65) {
      uncompressedPubKey = uncompressedPubKey.sublist(1);
      log.w(
          'uncompressedPubKey > 65 ${uint8ListToHex(uncompressedPubKey)} -- length ${uncompressedPubKey.length}');
    }

    var hash = CryptoWeb3.keccak256(uncompressedPubKey);
    log.w('hash $hash');

    log.e('hex ${uint8ListToHex(hash)}');
// take 20 bytes at the end from hash
    var last20Bytes = hash.sublist(12);
    print('last20Bytes $last20Bytes');
    List<int> updatedHash = [];
    //  var addressHex = Uint8List.fromList(hash);
    int i = 1;
    last20Bytes.forEach((f) {
      if (i == 1) {
        updatedHash.add(65);
        i++;
      }
      updatedHash.add(f);
      i++;
    });
    log.w('updatedHash $updatedHash');
    // take 0x41 or 65 + (hash[12:32] means take last 20 bytes from addressHex)
    // to do sha256 twice and get 4 bytes checksum
    var sha256Hash = sha256Twice(updatedHash);

    // first 4 bytes checksum
    var checksum = sha256Hash.bytes.sublist(0, 4);
    print('checksum  -- $checksum');
    log.i('checksum hex ${uint8ListToHex(checksum)}');
    updatedHash.addAll(checksum);
    log.w('updatedHash with checksum $updatedHash');

    // use base58 on (0x41 + hash[12:32] + checksum)
    // or base 58 on updateHash which first need to convert to Iint8List to get address
    Uint8List uIntUpdatedHash = Uint8List.fromList(updatedHash);
    var address = bs58check.base58.encode(uIntUpdatedHash);
    print('address $address');
    return address;
  }

  computeAddress(String pubBytes) {
    log.i('in compute');
    if (pubBytes.length == 65) pubBytes = pubBytes.substring(1);
    // var signature = sign(keccak256(concat), privateKey);
    print('1 $pubBytes');
    var hash = CryptoWeb3.keccakUtf8(pubBytes);
    print('hash $hash');
    //   var addressHex = "41" + hash.substring(24);
    //   print('address hex $addressHex');
    // var output = hex.encode(outputHashData);
    //  return hexStr2byteArray(addressHex);
  }

// Get address From Private Key
  getAddressFromPrivKey(privKey) {
    //ProtobufEnum.initByValue(byIndex)
  }

/*----------------------------------------------------------------------
                Generate BCH address
----------------------------------------------------------------------*/

  Future<String> generateBchAddress(String mnemonic) async {
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
    await getBchAddressDetails(address);

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

    var seed = generateSeed(mnemonic);
    var root = generateBip32Root(seed);
    // var coinType = environment["CoinType"]["$tickerName"].toString();
    //  log.w('coin type $coinType');
    var node = root.derivePath("m/44'/3'/0'/0/" + index.toString());

    String address1 = new BitcoinFlutter.P2PKH(
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
      var addr = await coinUtils.getAddressForCoin(root, tickerName,
          tokenType: tokenType[i]);
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
    var bal = await coinUtils.getCoinBalanceByAddress(name, address,
        tokenType: tokenType);
    log.w('coinBalanceByAddress $name - $bal');

    // if (bal == null) {
    //   print('coinBalanceByAddress $name- bal $bal');
    //   return 0.0;
    // }
    return bal;
  }

  Future getEthGasPrice() async {
    var gasPrice = await apiService.getEthGasPrice();
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
    await apiService.getCoinCurrencyUsdPrice().then((res) {
      if (res != null) {
        currentTickerUsdValue = res['data'][tickerName]['USD'].toDouble();
        log.i('getting price for $tickerName - $currentTickerUsdValue');
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

  // verify wallet address
  Future<Map<String, bool>> verifyWalletAddresses(String mnemonic) async {
    Map<String, bool> res = {
      "fabAddressCheck": false,
      "trxAddressCheck": false
    };

    // create wallet address and assign to walletcoremodel object
    CoreWalletModel walletDataFromCreateOfflineWalletV1 =
        await createOfflineWalletsV1(mnemonic, '', isVerifying: true);

    // get the walletbalancebody from the DB
    var walletBalancesBodyFromStorage;
    if (storageService.walletBalancesBody.isNotEmpty) {
      walletBalancesBodyFromStorage =
          jsonDecode(storageService.walletBalancesBody);
    } else {
      await walletDatabaseService.initDb();
      var fabWallet = await walletDatabaseService.getWalletBytickerName('FAB');
      var trxWallet = await walletDatabaseService.getWalletBytickerName('TRX');
      walletBalancesBodyFromStorage = {
        "fabAddress": fabWallet.address,
        "trxAddress": trxWallet.address
      };
    }

    // Compare the address if matched then don't notify otherwise raise flag

    String fabAddressFromCreate = jsonDecode(
        walletDataFromCreateOfflineWalletV1.walletBalancesBody)['fabAddress'];
    String trxAddressFromCreate = jsonDecode(
        walletDataFromCreateOfflineWalletV1.walletBalancesBody)['trxAddress'];

    String fabAddressFromStorage = '';
    String trxAddressFromStorage = '';

    String fabAddressFromCoreWalletDb = '';
    String trxAddressFromCoreWalletDb = '';
    if (walletBalancesBodyFromStorage != null) {
      fabAddressFromStorage = walletBalancesBodyFromStorage['fabAddress'];

      trxAddressFromStorage = walletBalancesBodyFromStorage['trxAddress'];
    } else if (await coreWalletDatabaseService.getWalletBalancesBody() !=
        null) {
      fabAddressFromCoreWalletDb =
          await coreWalletDatabaseService.getWalletAddressByTickerName('FAB');
      trxAddressFromCoreWalletDb =
          await coreWalletDatabaseService.getWalletAddressByTickerName('TRX');
    }
    log.i(
        'fabAddressFromCreate $fabAddressFromCreate -- fabAddressFromStorage $fabAddressFromStorage -- fabAddressFromCoreWalletDb $fabAddressFromCoreWalletDb');
    var fabAddressFromStorageToCompare = fabAddressFromStorage.isEmpty
        ? fabAddressFromCoreWalletDb
        : fabAddressFromStorage;
    var trxAddressFromStorageToCompare = trxAddressFromStorage.isEmpty
        ? trxAddressFromCoreWalletDb
        : trxAddressFromStorage;
    if (fabAddressFromCreate == fabAddressFromStorageToCompare) {
      res["fabAddressCheck"] = true;
      log.w('FabVerification passed $res');
      if (trxAddressFromCreate == trxAddressFromStorageToCompare) {
        res["trxAddressCheck"] = true;
        log.i('Trx Verification passed $res');
        // need to store the wallet balance body in the
        // new single db especially for older apps where
        // there is no concept of walletBalancesBody or
        // app before new wallet balance api
        var walletCoreModel = CoreWalletModel(
          id: 1,
          walletBalancesBody:
              walletDataFromCreateOfflineWalletV1.walletBalancesBody,
        );
        // store in single core database
        await coreWalletDatabaseService.update(walletCoreModel);
      } else
        res["trxAddressCheck"] = false;
    } else {
      res["fabAddressCheck"] = false;
      log.e('Verification FAILED: did not check TRX $res');
    }
    return res;
  }

/*----------------------------------------------------------------------
                Offline Wallet Creation
----------------------------------------------------------------------*/

// create Offline Wallets V1
  Future<CoreWalletModel> createOfflineWalletsV1(String mnemonic, String key,
      {isVerifying = false}) async {
    CoreWalletModel walletCoreModel = CoreWalletModel();
    var vaultService = locator<VaultService>();
    Map<String, dynamic> wbb = {
      'btcAddress': '',
      'ethAddress': '',
      'fabAddress': '',
      'ltcAddress': '',
      'dogeAddress': '',
      'bchAddress': '',
      'trxAddress': '',
      "showEXGAssets": "true"
    };

    List<String> coinTickers = [
      'BTC',
      'ETH',
      'FAB',
      'LTC',
      'DOGE',
      'BCH',
      'TRX'
    ];

    var seed = generateSeed(mnemonic);
    var root = generateBip32Root(seed);

    // BCH address
    String bchAddress = await generateBchAddress(mnemonic);
    String trxAddress = generateTrxAddress(mnemonic);

    try {
      for (int i = 0; i < coinTickers.length; i++) {
        String tickerName = coinTickers[i];
        String token = '';
        String address = '';
        if (tickerName == 'BCH') {
          address = bchAddress;
        } else if (tickerName == 'TRX') {
          address = trxAddress;
        } else
          address = await coinUtils.getAddressForCoin(root, tickerName,
              tokenType: token);
        if (tickerName == 'BTC') {
          wbb['btcAddress'] = address;
        } else if (tickerName == 'ETH') {
          wbb['ethAddress'] = address;
        } else if (tickerName == 'FAB') {
          wbb['fabAddress'] = address;
        } else if (tickerName == 'LTC') {
          wbb['ltcAddress'] = address;
        } else if (tickerName == 'DOGE') {
          wbb['dogeAddress'] = address;
        } else if (tickerName == 'BCH') {
          wbb['bchAddress'] = address;
        } else if (tickerName == 'TRX') {
          wbb['trxAddress'] = address;
        }

        // convert map to json string
        var walletBalanceBodyJsonString = jsonEncode(wbb);
        walletCoreModel = CoreWalletModel(
          id: 1,
          walletBalancesBody: walletBalanceBodyJsonString,
        );
      } // for loop ends
      // await coreWalletDatabaseService.getEncryptedMnemonic().then((res) async {
      //   if (res.isNotEmpty) {
      //     await coreWalletDatabaseService.deleteDb();
      //   }
      // });

      log.i("Wallet core model json ${walletCoreModel.toJson()}");

      if (!isVerifying) {
        // encrypt the mnemonic
        if (key.isNotEmpty && mnemonic.isNotEmpty) {
          var encryptedMnemonic = vaultService.encryptMnemonic(key, mnemonic);

          log.i('encryptedMnemonic $encryptedMnemonic');

          // store those json string address and encrypted mnemonic in the wallet core database
          walletCoreModel.mnemonic = encryptedMnemonic;
          log.w(
              'createOfflineWalletsV1 walletCoreModel -- before inserting in the core wallet DB ${walletCoreModel.toJson()}');

          // store in single core database
          await coreWalletDatabaseService.insert(walletCoreModel);
        }
      }
      return walletCoreModel;
    } catch (e) {
      log.e('Catch createOfflineWalletsV1 $e');
      throw Exception('Catch createOfflineWalletsV1 $e');
    }
  }

  Future createOfflineWallets(String mnemonic) async {
    // await walletDatabaseService.deleteDb();
    // await walletDatabaseService.initDb();
    List<WalletInfo> _walletInfo = [];
    if (_walletInfo != null) {
      _walletInfo.clear();
    } else {
      _walletInfo = [];
    }
    var seed = generateSeed(mnemonic);
    var root = generateBip32Root(seed);

    // BCH address
    String bchAddress = await generateBchAddress(mnemonic);
    String trxAddress = generateTrxAddress(mnemonic);

    try {
      for (int i = 0; i < coinTickers.length; i++) {
        String tickerName = coinTickers[i];
        String name = coinNames[i];
        String token = tokenType[i];
        String addr = '';
        if (tickerName == 'BCH') {
          addr = bchAddress;
        } else if (tickerName == 'TRX') {
          addr = trxAddress;
        } else
          addr = await coinUtils.getAddressForCoin(root, tickerName,
              tokenType: token);
        WalletInfo wi = new WalletInfo(
            id: null,
            tickerName: tickerName,
            tokenType: token,
            address: addr,
            availableBalance: 0.0,
            lockedBalance: 0.0,
            usdValue: 0.0,
            name: name);
        _walletInfo.add(wi);
        log.i("Offline wallet ${_walletInfo[i].toJson()}");
        // await walletDatabaseService.insert(_walletInfo[i]);
      }

      //  await walletDatabaseService.getAll();
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

  checkTxStatus(TransactionHistory transaction) {
    transaction.tag == 'deposit'
        ? checkDepositTransactionStatus(transaction)
        : checkWithdrawTxStatus(transaction);
  }

  // WITHDRAW TX status
  checkWithdrawTxStatus(TransactionHistory transaction) async {
    int baseTime = 30;
    List result = [];
    String kanbanTxId = transaction.kanbanTxId;
    TransactionHistory transactionByTxid = new TransactionHistory();
    Timer.periodic(Duration(seconds: baseTime), (Timer t) async {
      log.w('Base time $baseTime -- local t.id $kanbanTxId');
      await apiService.withdrawTxStatus().then((res) async {
        if (res != null) {
          // result = res;
          //  log.e(' -- res $res');
          // transactionByTxId = await transactionHistoryDatabaseService
          //     .getByTxId(transaction.txId);
          res.forEach((singleTx) async {
            var kanbanTxid = singleTx['kanbanTxid'];
            log.w(
                'res not null -- condition -- k.id $kanbanTxid -- t.id $kanbanTxId');

            // If kanban txid is equals to local txid
            if (singleTx['kanbanTxid'] == kanbanTxId) {
              // log.w('single withdraw entry $singleTx');
              baseTime = 60;
              // log.i(
              //     'Withdraw Txid match found so time extended by 50 sec as blockchain will take time to generate txid');
              // if blockchain txid is not empty means withdraw tx has completed
              if (singleTx['blockchainTxid'] != "") {
                String blockchainTxid = singleTx['blockchainTxid'].toString();
                log.i('Blockchain Txid $blockchainTxid -- timer cancel');
                t.cancel();

                var storedTx = await transactionHistoryDatabaseService
                    .getByKanbanTxId(transaction.kanbanTxId);
                showSimpleNotification(
                    Row(
                      children: [
                        Text('${singleTx['coinName']} '),
                        Text('${transaction.tag}'),
                        UIHelper.horizontalSpaceSmall,
                        Icon(Icons.check)
                        //  Text(FlutterI18n.translate(context, "completed")),
                      ],
                    ),
                    position: NotificationPosition.bottom,
                    background: primaryColor);
                String date = DateTime.now().toString();
                transactionByTxid = TransactionHistory(
                    id: storedTx.id,
                    tickerName: storedTx.tickerName,
                    address: '',
                    amount: 0.0,
                    date: date.toString(),
                    kanbanTxId: storedTx.kanbanTxId,
                    tickerChainTxStatus: 'Complete',
                    quantity: storedTx.quantity,
                    tag: storedTx.tag);
                transactionHistoryDatabaseService.update(transactionByTxid);
              }
            }
          });
          log.i('After res for each');
        }
      });
    });
  }

  // DEPOSIT TX status
  Future<String> checkDepositTransactionStatus(
      TransactionHistory transaction) async {
    String result = '';
    Timer.periodic(Duration(minutes: 1), (Timer t) async {
      TransactionHistory transactionHistory = new TransactionHistory();
      TransactionHistory transactionByTxId = new TransactionHistory();
      var res = await apiService.getTransactionStatus(transaction.kanbanTxId);

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

        String date = DateTime.now().toString();

        if (transaction != null) {
          transactionByTxId = await transactionHistoryDatabaseService
              .getByKanbanTxId(transaction.kanbanTxId);
          showSimpleNotification(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('${transactionByTxId.tickerName} '),
                  Text('${transactionByTxId.tag}'),
                  Text(stringUtils.firstCharToUppercase(result.toString())),
                ],
              ),
              position: NotificationPosition.bottom,
              background: primaryColor);
        }

        if (res['code'] == 0) {
          log.e('Transaction history passed arguement ${transaction.toJson()}');
          transactionHistory = TransactionHistory(
              id: transactionByTxId.id,
              tickerName: transactionByTxId.tickerName,
              address: '',
              amount: 0.0,
              date: date.toString(),
              kanbanTxId: transactionByTxId.kanbanTxId,
              tickerChainTxStatus: 'Complete',
              quantity: transactionByTxId.quantity,
              tag: transactionByTxId.tag);

          // after this method i will test single status update field in the transaciton history
          // await transactionHistoryDatabaseService
          //     .updateStatus(transactionHistoryByTxId);
          // await transactionHistoryDatabaseService.getByTxId(transaction.txId);

        } else if (res['code'] == -1) {
          transactionHistory = TransactionHistory(
              id: transactionByTxId.id,
              tickerName: transactionByTxId.tickerName,
              address: '',
              amount: 0.0,
              date: date.toString(),
              kanbanTxId: transactionByTxId.kanbanTxId,
              tickerChainTxStatus: 'Error',
              quantity: transactionByTxId.quantity,
              tag: transactionByTxId.tag);

          //  await transactionHistoryDatabaseService.update(transactionHistory);
        } else if (res['code'] == 2 || res['code'] == 2) {
          transactionHistory = TransactionHistory(
              id: transactionByTxId.id,
              tickerName: transactionByTxId.tickerName,
              address: '',
              amount: 0.0,
              date: date.toString(),
              kanbanTxId: transactionByTxId.kanbanTxId,
              tickerChainTxStatus: 'Failed',
              quantity: transactionByTxId.quantity,
              tag: transactionByTxId.tag);

          //  await transactionHistoryDatabaseService.update(transactionHistory);
        } else if (res['code'] == -3 || res['code'] == 3) {
          transactionHistory = TransactionHistory(
              id: transactionByTxId.id,
              tickerName: transactionByTxId.tickerName,
              address: '',
              amount: 0.0,
              date: date.toString(),
              kanbanTxId: transactionByTxId.kanbanTxId,
              tickerChainTxStatus: 'Require redeposit',
              quantity: transactionByTxId.quantity,
              tag: transactionByTxId.tag);

          // await transactionHistoryDatabaseService.update(transactionHistory);
        }
      }
      await transactionHistoryDatabaseService.update(transactionHistory);
      await transactionHistoryDatabaseService
          .getByKanbanTxId(transaction.kanbanTxId);
    });
    return result;
    //  return _completer.future;
  }

  // Completer the _dialogCompleter to resume the Future's execution
  void transactionComplete(DialogResponse response) {
    _completer.complete(response);
    _completer = null;
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
    }).catchError((onError) async {
      log.e('Could not save in database $onError');
      await transactionHistoryDatabaseService.deleteDb().then((value) async {
        log.e('transactionHistoryDatabase deleted');
        await transactionHistoryDatabaseService
            .insert(transactionHistory)
            .then((data) async {
          log.w('Saved in transaction history database $data');
        });
      });
    });
  }

/*----------------------------------------------------------------------
                    Gas Balance
----------------------------------------------------------------------*/

  Future<double> gasBalance(String addr) async {
    double gasAmount = 0.0;
    await apiService.getGasBalance(addr).then((res) {
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
      var res = await apiService.getAssetsBalance(exgAddress);
      log.w('assetsBalance exchange $res');
      for (var i = 0; i < res.length; i++) {
        var tempBal = res[i];
        var coinType = res[i].coinType;
        var unlockedAmount = res[i].unlockedAmount;
        var lockedAmount = res[i].lockedAmount;
        var finalBal = {
          'coin': coinList.newCoinTypeMap[coinType],
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

/*----------------------------------------------------------------------
                Calculate Only Usd Balance For Individual Coin
----------------------------------------------------------------------*/

  double calculateCoinUsdBalance(
      double marketPrice, double actualWalletBalance, double lockedBalance) {
    if (marketPrice != null) {
      if (actualWalletBalance.isNegative) actualWalletBalance = 0.0;
      if (lockedBalance.isNegative) lockedBalance = 0.0;
      log.w(
          'market price $marketPrice -- available bal $actualWalletBalance-- locked bal $lockedBalance');
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
      kanbanGasLimit,
      isSpeicalTronTokenWithdraw) async {
    var keyPairKanban = getExgKeyPair(seed);
    var addressInKanban = keyPairKanban["address"];
    var amountInLink = BigInt.parse(NumberUtil.toBigInt(amount));
    //amount * BigInt.from(1e18);
    log.i(
        'AMount in link $amountInLink -- coin name $coinName -- token type $tokenType');

    var addressInWallet = coinAddress;
    if ((coinName == 'BTC' ||
            coinName == 'FAB' ||
            coinName == 'LTC' ||
            coinName == 'DOGE' ||
            coinName == 'BCH') &&
        tokenType == '') {
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
      addressInWallet = btcUtils.btcToBase58Address(addressInWallet);
      //no 0x appended
    } else if (tokenType == 'FAB') {
      addressInWallet = fabUtils.exgToFabAddress(addressInWallet);
      addressInWallet = btcUtils.btcToBase58Address(addressInWallet);
    }
    int coinType;
    await coinUtils
        .getCoinTypeIdByName(coinName)
        .then((value) => coinType = value);
    log.i('cointype $coinType');

    var sepcialcoinType;
    var abiHex;
    if (coinName == 'DSCE' || coinName == 'DSC') {
      sepcialcoinType = await coinUtils.getCoinTypeIdByName('DSC');
      abiHex = abiUtils.getWithdrawFuncABI(
          sepcialcoinType, amountInLink, addressInWallet,
          isSpecialDeposit: true, chain: tokenType);
      log.e('cointype $coinType -- abihex $abiHex');
    } else if (coinName == 'BSTE' || coinName == 'BST') {
      sepcialcoinType = await coinUtils.getCoinTypeIdByName('BST');
      abiHex = abiUtils.getWithdrawFuncABI(
          sepcialcoinType, amountInLink, addressInWallet,
          isSpecialDeposit: true, chain: tokenType);
      log.e('cointype $coinType -- abihex $abiHex');
    } else if (coinName == 'EXGE' || coinName == 'EXG') {
      sepcialcoinType = await coinUtils.getCoinTypeIdByName('EXG');
      abiHex = abiUtils.getWithdrawFuncABI(
          sepcialcoinType, amountInLink, addressInWallet,
          isSpecialDeposit: true, chain: tokenType);
      log.e('cointype $coinType -- abihex $abiHex');
    } else if (coinName == 'FABE' ||
        (coinName == 'FAB' && tokenType == 'ETH')) {
      sepcialcoinType = await coinUtils.getCoinTypeIdByName('FAB');
      abiHex = abiUtils.getWithdrawFuncABI(
          sepcialcoinType, amountInLink, addressInWallet,
          isSpecialDeposit: true, chain: tokenType);

      log.e('cointype $coinType -- abihex $abiHex');
    } else if (isSpeicalTronTokenWithdraw) {
      addressInWallet = btcUtils.btcToBase58Address(addressInWallet);
      abiHex = abiUtils.getWithdrawFuncABI(
          coinType, amountInLink, addressInWallet,
          isSpecialDeposit: true, chain: tokenType);
      log.e('cointype $coinType -- abihex $abiHex');
    } else {
      abiHex =
          abiUtils.getWithdrawFuncABI(coinType, amountInLink, addressInWallet);
    }
    var coinPoolAddress = await kanbanUtils.getCoinPoolAddress();
    print('1');
    var nonce = await kanbanUtils.getNonce(addressInKanban);

    var txKanbanHex = await abiUtils.signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        coinPoolAddress,
        nonce,
        kanbanPrice,
        kanbanGasLimit);

    var res = await kanbanUtils.sendKanbanRawTransaction(txKanbanHex);
    if (res['transactionHash'] == null) {
      return res;
    }
    if (res['transactionHash'] != '') {
      res['success'] = true;
      res['data'] = res;
    } else {
      res['success'] = false;
      res['data'] = res;
    }
    return res;
  }

/*----------------------------------------------------------------------
                withdraw Tron
----------------------------------------------------------------------*/
  Future<Map<String, dynamic>> withdrawTron(
      seed,
      String coinName,
      String coinAddress,
      String tokenType,
      double amount,
      kanbanPrice,
      kanbanGasLimit) async {
    var keyPairKanban = getExgKeyPair(seed);
    var addressInKanban = keyPairKanban["address"];
    var amountInLink = BigInt.parse(NumberUtil.toBigInt(amount));
    //amount * BigInt.from(1e18);
    log.i(
        'AMount in link $amountInLink -- coin name $coinName -- token type $tokenType');
    var addressInWallet = coinAddress;
    addressInWallet = btcUtils.btcToBase58Address(addressInWallet);

    int coinType;
    await coinUtils
        .getCoinTypeIdByName(coinName)
        .then((value) => coinType = value);
    log.i('cointype $coinType');

    var sepcialcoinType;
    var abiHex;
    if (coinName == 'USDTX') {
      sepcialcoinType = await coinUtils.getCoinTypeIdByName('USDT');
      abiHex = abiUtils.getWithdrawFuncABI(
          sepcialcoinType, amountInLink, addressInWallet,
          isSpecialDeposit: true, chain: tokenType);
      log.e('cointype $coinType -- abihex $abiHex');
    } else {
      abiHex =
          abiUtils.getWithdrawFuncABI(coinType, amountInLink, addressInWallet);
    }
    var coinPoolAddress = await kanbanUtils.getCoinPoolAddress();

    var nonce = await kanbanUtils.getNonce(addressInKanban);

    var txKanbanHex = await abiUtils.signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        coinPoolAddress,
        nonce,
        kanbanPrice,
        kanbanGasLimit);

    var res = await kanbanUtils.sendKanbanRawTransaction(txKanbanHex);

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
                    Tron Deposit
----------------------------------------------------------------------*/
  Future depositTron(
      {String mnemonic,
      WalletInfo walletInfo,
      double amount,
      bool isTrxUsdt,
      bool isBroadcast,
      @required options}) async {
    log.i(
        'depositTron -- amount $amount -- istrxusdt $isTrxUsdt -- isBroadcast $isBroadcast');
    int kanbanGasPrice = options['kanbanGasPrice'];
    int kanbanGasLimit = options['kanbanGasLimit'];

    print('kanbanGasPrice $kanbanGasPrice');
    print('kanbanGasLimit $kanbanGasLimit');
    var officalAddress = coinUtils.getOfficalAddress(walletInfo.tickerName,
        tokenType: walletInfo.tokenType);
    print('official address in wallet service deposit do $officalAddress');
    if (officalAddress == null) {
      //errRes['data'] = 'no official address';
      return;
    }
    var privateKey = TronAddressUtil.generateTrxPrivKey(mnemonic);

    /// get signed raw transaction hash(txid) and hashed raw tx before sign(txhash)
    /// use that to submit deposit
    ///
    var rawTxRes = await TronTransactionUtil.generateTrxTransactionContract(
        privateKey: privateKey,
        fromAddr: walletInfo.address,
        toAddr: officalAddress,
        amount: amount,
        isTrxUsdt: isTrxUsdt,
        tickerName: walletInfo.tickerName,
        isBroadcast: isBroadcast);

    log.w('depositTron signed raw tx $rawTxRes');
    var txHash;
    var txHex = rawTxRes["rawTxBufferHexAfterSign"];
    CryptoHash.Digest hashedTxHash = rawTxRes["hashedRawTxBufferBeforeSign"];
    // txHex is the result of raw tx after sign but we don't broadcast
    txHash = CryptoWeb3.bytesToHex(hashedTxHash.bytes);

// code  from depositDo

    var coinType = await coinUtils.getCoinTypeIdByName(walletInfo.tickerName);
    log.i('coin type $coinType');

    var amountInLink = BigInt.parse(NumberUtil.toBigInt(amount));

    var seed = generateSeed(mnemonic);
    var keyPairKanban = getExgKeyPair(seed);
    var addressInKanban = keyPairKanban["address"];

    var originalMessage = getOriginalMessage(
        coinType,
        stringUtils.trimHexPrefix(txHash),
        amountInLink,
        stringUtils.trimHexPrefix(addressInKanban));
    log.w('Original message $originalMessage');

    var signedMess = await coinUtils.signedMessage(
        originalMessage, seed, walletInfo.tickerName, walletInfo.tokenType);
    log.e('Signed message $signedMess');
    var coinPoolAddress = await kanbanUtils.getCoinPoolAddress();

    /// assinging coin type accoringly
    /// If special deposits then take the coin type of the respective chain coin
    var sepcialcoinType;
    var abiHex;
    if (walletInfo.tickerName == 'USDTX') {
      sepcialcoinType = await coinUtils.getCoinTypeIdByName('USDT');
      abiHex = abiUtils.getDepositFuncABI(
          sepcialcoinType, txHash, amountInLink, addressInKanban, signedMess,
          chain: walletInfo.tokenType, isSpecialDeposit: true);

      log.e('cointype $coinType -- abihex $abiHex');
    } else {
      print('in else');
      abiHex = abiUtils.getDepositFuncABI(
          coinType, txHash, amountInLink, addressInKanban, signedMess,
          chain: walletInfo.tokenType);
      log.i('cointype $coinType -- abihex $abiHex');
    }
    var nonce = await kanbanUtils.getNonce(addressInKanban);
    debugPrint('nonce $nonce');
    var txKanbanHex = await abiUtils.signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        coinPoolAddress,
        nonce,
        kanbanGasPrice,
        kanbanGasLimit);
    debugPrint('txKanbanHex $txKanbanHex');
    var res = await kanbanUtils.submitDeposit(txHex, txKanbanHex);
    return res;

    // TRON deposit ends here
  }

/*----------------------------------------------------------------------
                Future Deposit Do
----------------------------------------------------------------------*/

  Future<Map<String, dynamic>> depositDo(
      seed, String coinName, String tokenType, double amount, option) async {
    Map<String, dynamic> errRes = new Map<String, dynamic>();
    errRes['success'] = false;

    var officalAddress =
        coinUtils.getOfficalAddress(coinName, tokenType: tokenType);
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
    if (resST != null) log.w('res $resST');
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
    // int decimal = 0;
    //  if (coinName == 'FAB') decimal = 8;
    var amountInLink = BigInt.parse(NumberUtil.toBigInt(amount));

    var amountInTxString = amountInTx.toString();
    var amountInLinkString = amountInLink.toString();

    print('amountInTxString===' + amountInTxString);
    print('amountInLinkString===' + amountInLinkString);
    // 0 means equal
    // 1 means >
    // -1 means <
    // if (amountInLink.compareTo(amountInTx) != 0) {
    //   errRes['data'] = 'incorrect amount for two transactions';
    //   return errRes;
    // }
    if (amountInLinkString.indexOf(amountInTxString) != 0) {
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

    var coinType = await coinUtils.getCoinTypeIdByName(coinName);
    log.i('coin type $coinType');
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

    var signedMess = await coinUtils.signedMessage(
        originalMessage, seed, coinName, tokenType);
    log.e('Signed message $signedMess');
    print('coin type $coinType');
    log.w('Original message $originalMessage');
    var coinPoolAddress = await kanbanUtils.getCoinPoolAddress();

    /// assinging coin type accoringly
    /// If special deposits then take the coin type of the respective chain coin
    var specialCoinType;
    var abiHex;
    bool isSpecial = false;
    Constants.specialTokens.forEach((specialTokenTicker) {
      if (coinName == specialTokenTicker) isSpecial = true;
    });
    if (isSpecial) {
      specialCoinType = await coinUtils
          .getCoinTypeIdByName(coinName.substring(0, coinName.length - 1));
    }

    var coinTypeUsed = isSpecial ? specialCoinType : coinType;
    abiHex = abiUtils.getDepositFuncABI(
        coinTypeUsed, txHash, amountInLink, addressInKanban, signedMess,
        chain: tokenType, isSpecialDeposit: isSpecial);

    var amountInAbi = abiUtils.getAmountFromDepositAbiHex(abiHex);

    var nonce = await kanbanUtils.getNonce(addressInKanban);

    var txKanbanHex = await abiUtils.signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        coinPoolAddress,
        nonce,
        kanbanGasPrice,
        kanbanGasLimit);

    var res = await kanbanUtils.submitDeposit(txHex, txKanbanHex);

    res['txids'] = txids;
    return res;
  }

  /* --------------------------------------------
              Methods Called in Send State 
  ----------------------------------------------*/

// Get Fab Transaction Status
  Future getFabTxStatus(String txId) async {
    await fabUtils.getFabTransactionStatus(txId);
  }

// Get Fab Transaction Balance
  Future getFabBalance(String address) async {
    await fabUtils.getFabBalanceByAddress(address);
  }

  // Get ETH Transaction Status
  Future getEthTxStatus(String txId) async {
    await fabUtils.getFabTransactionStatus(txId);
  }

// Get ETH Transaction Balance
  Future getEthBalance(String address) async {
    await fabUtils.getFabBalanceByAddress(address);
  }
/*----------------------------------------------------------------------
                Future Add Gas Do
----------------------------------------------------------------------*/

  Future<Map<String, dynamic>> addGasDo(seed, double amount, {options}) async {
    var satoshisPerBytes = 14;
    var scarContractAddress = await kanbanUtils.getScarAddress();
    scarContractAddress = stringUtils.trimHexPrefix(scarContractAddress);

    var fxnDepositCallHex = '4a58db19';
    var contractInfo = await getFabSmartContract(scarContractAddress,
        fxnDepositCallHex, options['gasLimit'], options['gasPrice']);

    var res1 = await getFabTransactionHex(seed, [0], contractInfo['contract'],
        amount, contractInfo['totalFee'], satoshisPerBytes, [], false);
    var txHex = res1['txHex'];
    var errMsg = res1['errMsg'];

    var txHash = '';
    if (txHex != null && txHex != '') {
      var res = await btcUtils.postFabTx(txHex);
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
    var response = await apiService.getFabTransactionJson(txid);

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
    amount = amount ?? 0.0;
    final txb = new BitcoinFlutter.TransactionBuilder(
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
      var fromAddress = btcUtils.getBtcAddressForNode(fabCoinChild);
      if (addressList != null && addressList.length > 0) {
        fromAddress = addressList[i];
      }
      if (i == 0) {
        changeAddress = fromAddress;
      }
      final privateKey = fabCoinChild.privateKey;
      var utxos = await apiService.getFabUtxos(fromAddress);
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
        var alice = BitcoinFlutter.ECPair.fromPrivateKey(privateKey,
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
    return kanbanUtils.getKanbanErrDeposit(address);
  }

  toKbPaymentAddress(String fabAddress) {
    return toKbpayAddress(fabAddress);
  }

  Future txHexforSendCoin(seed, coinType, kbPaymentAddress, amount,
      kanbanGasPrice, kanbanGasLimit) async {
    var abiHex =
        abiUtils.getSendCoinFuncABI(coinType, kbPaymentAddress, amount);

    var keyPairKanban = getExgKeyPair(seed);
    var address = keyPairKanban['address'];
    var nonce = await kanbanUtils.getNonce(address);

    var coinpoolAddress = await kanbanUtils.getCoinPoolAddress();

    var txKanbanHex = await abiUtils.signAbiHexWithPrivateKey(
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

    return (fabAddress != '');
  }

/*----------------------------------------------------------------------
                Send Coin
----------------------------------------------------------------------*/

  Future sendCoin(
      seed, int coinType, String kbPaymentAddress, double amount) async {
// example: sendCoin(seed, 1, 'oV1KxZswBx2AUypQJRDEb2CsW2Dq2Wp4L5', 0.123);

    var gasPrice = environment["chains"]["KANBAN"]["gasPrice"];
    var gasLimit = environment["chains"]["KANBAN"]["gasLimit"];
    //var amountInLink = BigInt.from(amount * 1e18);
    var amountInLink = BigInt.parse(NumberUtil.toBigInt(amount, 18));
    var txHex = await txHexforSendCoin(
        seed, coinType, kbPaymentAddress, amountInLink, gasPrice, gasLimit);
    log.e('txhex $txHex');
    var resKanban = await kanbanUtils.sendKanbanRawTransaction(txHex);
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

    var amountInTx = BigInt.from(0);
    var transFeeDouble = 0.0;

    var receivePrivateKeyArr = [];

    var tokenType = options['tokenType'] ?? '';
    var decimal = options['decimal'];
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
      final txb = new BitcoinFlutter.TransactionBuilder(
          network: environment["chains"]["BTC"]["network"]);
      // txb.setVersion(1);

      for (var i = 0; i < addressIndexList.length; i++) {
        var index = addressIndexList[i];
        var bitCoinChild = root.derivePath("m/44'/" +
            environment["CoinType"]["BTC"].toString() +
            "'/0'/0/" +
            index.toString());
        var fromAddress = btcUtils.getBtcAddressForNode(bitCoinChild);
        if (addressList.length > 0) {
          fromAddress = addressList[i];
        }
        if (i == 0) {
          changeAddress = fromAddress;
        }
        final privateKey = bitCoinChild.privateKey;
        var utxos = await btcUtils.getBtcUtxos(fromAddress);
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
        var alice = BitcoinFlutter.ECPair.fromPrivateKey(privateKey,
            compressed: true, network: environment["chains"]["BTC"]["network"]);
        txb.sign(vin: i, keyPair: alice);
      }

      var tx = txb.build();
      txHex = tx.toHex();
      if (doSubmit) {
        var res = await apiService.postBtcTx(txHex);
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

      final utxos = await apiService.getBchUtxos(address);

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
        var res = await apiService.postBchTx(txHex);
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
      final txb = new BitcoinFlutter.TransactionBuilder(
          network: environment["chains"]["LTC"]["network"]);

      for (var i = 0; i < addressIndexList.length; i++) {
        var index = addressIndexList[i];
        var node = root.derivePath("m/44'/" +
            environment["CoinType"]["LTC"].toString() +
            "'/0'/0/" +
            index.toString());
        var fromAddress = ltcUtils.getLtcAddressForNode(node);
        if (addressList.length > 0) {
          fromAddress = addressList[i];
        }
        if (i == 0) {
          changeAddress = fromAddress;
        }
        final privateKey = node.privateKey;
        var utxos = await apiService.getLtcUtxos(fromAddress);

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
        var alice = BitcoinFlutter.ECPair.fromPrivateKey(privateKey,
            compressed: true, network: environment["chains"]["LTC"]["network"]);
        txb.sign(vin: i, keyPair: alice);
      }

      var tx = txb.build();
      txHex = tx.toHex();
      if (doSubmit) {
        var res = await apiService.postLtcTx(txHex);
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
      final txb = new BitcoinFlutter.TransactionBuilder(
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
        var utxos = await apiService.getDogeUtxos(fromAddress);
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
        var alice = BitcoinFlutter.ECPair.fromPrivateKey(privateKey,
            compressed: true,
            network: environment["chains"]["DOGE"]["network"]);
        txb.sign(vin: i, keyPair: alice);
      }
      var tx = txb.build();
      txHex = tx.toHex();
      if (doSubmit) {
        var res = await apiService.postDogeTx(txHex);
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
      final nonce = await apiService.getEthNonce(addressHex);

      var apiUrl =
          environment["chains"]["ETH"]["infura"]; //Replace with your API

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
        var res = await apiService.postEthTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      } else {
        txHash = ethUtils.getTransactionHash(signed);
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
          var res = await fabUtils.postFabTx(txHex);

          txHash = res['txHash'];
          errMsg = res['errMsg'];
        } else {
          var tx = BitcoinFlutter.Transaction.fromHex(txHex);
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
      var amountSentInt = BigInt.parse(NumberUtil.toBigInt(amount, decimal));

      if (coin == 'DUSD') {
        amountSentInt = BigInt.parse(NumberUtil.toBigInt(amount, 6));
      }

      amountInTx = amountSentInt;
      var amountSentHex = amountSentInt.toRadixString(16);

      var fxnCallHex = transferAbi +
          stringUtils.fixLength(stringUtils.trimHexPrefix(toAddress), 64) +
          stringUtils.fixLength(stringUtils.trimHexPrefix(amountSentHex), 64);

      contractAddress = stringUtils.trimHexPrefix(contractAddress);

      log.i(coin);
      var contractInfo = await getFabSmartContract(
          contractAddress, fxnCallHex, gasLimit, gasPrice);
      if (addressList != null && addressList.length > 0) {
        addressList[0] =
            await getAddressFromCoreWalletDatabaseByTickerName('FAB') !=
                    addressList[0]
                ? fabUtils.exgToFabAddress(addressList[0])
                : addressList[0];
      }
//8f08d6e1b8978fdba995dc44f1f01a3a26fa572a78f6a0450fa9c547239201b7
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
      log.w('res1: $res1');

      if (getTransFeeOnly) {
        return {
          'txHex': '',
          'txHash': '',
          'errMsg': res1["errMsg"] ?? '',
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
          var res = await fabUtils.postFabTx(txHex);
          txHash = res['txHash'];
          errMsg = res['errMsg'];
        } else {
          var tx = BitcoinFlutter.Transaction.fromHex(txHex);
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
      final nonce = await apiService.getEthNonce(addressHex);

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
      } else {
        convertedDecimalAmount =
            BigInt.parse(NumberUtil.toBigInt(amount, decimal));
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
        var res = await apiService.postEthTx(txHex);
        txHash = res['txHash'];
        errMsg = res['errMsg'];
      } else {
        txHash = ethUtils.getTransactionHash(signed);
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
    var chunks = [];
    log.w('Smart contract Address $contractAddress');
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
