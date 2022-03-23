import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:exchangilymobileapp/environments/coins.dart' as coin_list;
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/core_wallet_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/services/version_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/abi_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletUtil {
  final log = getLogger('WalletUtil');

  final walletDatabaseService = locator<WalletDatabaseService>();
  final versionService = locator<VersionService>();
  final storageService = locator<LocalStorageService>();
  final coreWalletDatabaseService = locator<CoreWalletDatabaseService>();
  final transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  final tokenListDatabaseService = locator<TokenListDatabaseService>();
  final userSettingsDatabaseService = locator<UserSettingsDatabaseService>();
  final _vaultService = locator<VaultService>();
  final walletService = locator<WalletService>();
  var abiUtils = AbiUtils();

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
/*----------------------------------------------------------------------
                Update special tokens tickername in UI
----------------------------------------------------------------------*/
  Map<String, String> updateSpecialTokensTickerNameForTxHistory(
      String tickerName) {
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
    } else if (tickerName.toUpperCase() == 'USDCX') {
      tickerName = 'USDC(trc20)';
      logoTicker = 'USDC';
    } else {
      logoTicker = tickerName;
    }
    return {"tickerName": tickerName, "logoTicker": logoTicker};
  }

// Delete wallet
  Future deleteWallet() async {
    log.w('deleting wallet');
    try {
      await walletDatabaseService
          .deleteDb()
          .whenComplete(() => log.e('wallet database deleted!!'))
          .catchError((err) => log.e('wallet database CATCH $err'));

      await transactionHistoryDatabaseService
          .deleteDb()
          .whenComplete(() => log.e('trnasaction history database deleted!!'))
          .catchError((err) => log.e('tx history database CATCH $err'));

      await _vaultService
          .deleteEncryptedData()
          .whenComplete(() => log.e('encrypted data deleted!!'))
          .catchError((err) => log.e('delete encrypted CATCH $err'));

      await coreWalletDatabaseService
          .deleteDb()
          .whenComplete(() => log.e('coreWalletDatabaseService data deleted!!'))
          .catchError((err) => log.e('coreWalletDatabaseService  CATCH $err'));

      await tokenListDatabaseService
          .deleteDb()
          .whenComplete(() => log.e('Token list database deleted!!'))
          .catchError((err) => log.e('token list database CATCH $err'));

      await userSettingsDatabaseService
          .deleteDb()
          .whenComplete(() => log.e('User settings database deleted!!'))
          .catchError((err) => log.e('user setting database CATCH $err'));

      storageService.walletBalancesBody = '';
      storageService.isShowCaseView = true;
      storageService.clearStorage();
      debugPrint(
          'Checking has verified key value after clearing local storage : ${storageService.hasWalletVerified.toString()}');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      log.e('before wallet removal, local storage has ${prefs.getKeys()}');
      prefs.clear();
      try {
        await _deleteCacheDir();
        await _deleteAppDir();
      } catch (err) {
        log.e('delete cache dir err $err');
      }
    } catch (err) {
      log.e('deleteWallet CATCH -- wallet delete failed: $err');
      throw Exception(['Wallet deletion failed $err']);
    }
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  // verify wallet address
  Future<Map<String, bool>> verifyWalletAddresses(String mnemonic) async {
    Map<String, bool> res = {
      "fabAddressCheck": false,
      "trxAddressCheck": false
    };

    // create wallet address and assign to walletcoremodel object
    CoreWalletModel walletDataFromCreateOfflineWalletV1 = await walletService
        .createOfflineWalletsV1(mnemonic, '', isVerifying: true);

    // get the walletbalancebody from the DB
    var walletBalancesBodyFromStorage;
    if (storageService.walletBalancesBody.isNotEmpty) {
      walletBalancesBodyFromStorage =
          jsonDecode(storageService.walletBalancesBody);
    } else {
      await walletDatabaseService.initDb();
      var fabWallet = await walletDatabaseService.getWalletBytickerName('FAB');
      var trxWallet = await walletDatabaseService.getWalletBytickerName('TRX');
      if (fabWallet != null && trxWallet != null) {
        walletBalancesBodyFromStorage = {
          "fabAddress": fabWallet.address,
          "trxAddress": trxWallet.address
        };
      }
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
      } else {
        res["trxAddressCheck"] = false;
      }
    } else {
      res["fabAddressCheck"] = false;
      log.e('Verification FAILED: did not check TRX $res');
    }
    return res;
  }

  /*----------------------------------------------------------------------
                Get Coin Type Id By Name
----------------------------------------------------------------------*/

  Future<int> getCoinTypeIdByName(String coinName) async {
    int coinType = 0;
    MapEntry<int, String> hardCodedCoinList;
    bool isOldToken = coin_list.newCoinTypeMap.containsValue(coinName);
    debugPrint('is old token value $isOldToken');
    if (isOldToken) {
      hardCodedCoinList = coin_list.newCoinTypeMap.entries
          .firstWhere((coinTypeMap) => coinTypeMap.value == coinName);
    }
    // var coins =
    //     coinList.coin_list.where((coin) => coin['name'] == coinName).toList();
    if (hardCodedCoinList != null) {
      coinType = hardCodedCoinList.key;
    } else {
      await tokenListDatabaseService
          .getCoinTypeByTickerName(coinName)
          .then((value) => coinType = value);
    }
    debugPrint('ticker $coinName -- coin type $coinType');
    return coinType;
  }

// coin type(int) to token type(String)
  String getChainNameByTokenType(int coinType) {
    String tokenType = '';
// 0001 = BTC
// 0002 = FAB
// 0003 = ETH
// 0004 - BCH
// 0005 - LTC
// 0006 - DOGE
// 0007 = TRON
// 0009 = POLYGON

// CEL
// cointype 196612
// converts to 00030004
// so we know that this is an eth token since 0003 = eth chain and 4 !=0

    String hexCoinType =
        abiUtils.fix8LengthCoinType(coinType.toRadixString(16));
    String firstHalf = hexCoinType.substring(0, 4);
    String secondHalf = hexCoinType.substring(4, 8);

    log.i('hexCoinType $hexCoinType - ');
    if (secondHalf == '0000') {
      tokenType = '';
    } else if (firstHalf == '0001' && secondHalf != '0000') {
      tokenType = 'BTC';
    } else if (firstHalf == '0002' && secondHalf != '0000') {
      tokenType = 'FAB';
    } else if (firstHalf == '0003' && secondHalf != '0000') {
      tokenType = 'ETH';
    } else if (firstHalf == '0004' && secondHalf != '0000') {
      tokenType = 'BCH';
    } else if (firstHalf == '0005' && secondHalf != '0000') {
      tokenType = 'LTC';
    } else if (firstHalf == '0006' && secondHalf != '0000') {
      tokenType = 'DOGE';
    } else if (firstHalf == '0007' && secondHalf != '0000') {
      tokenType = 'TRX';
    } else if (firstHalf == '0009' && secondHalf != '0000') {
      tokenType = 'POLYGON';
    }
    log.i('hexCoinType $hexCoinType - tokenType $tokenType');
    return tokenType;
  }
}
