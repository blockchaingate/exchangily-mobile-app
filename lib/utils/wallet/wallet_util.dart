import 'package:exchangilymobileapp/models/wallet/wallet_balance.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/services/coin_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:flutter/widgets.dart';
import 'package:exchangilymobileapp/environments/coins.dart' as coin_list;
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/utils/abi_util.dart';
import 'package:path_provider/path_provider.dart';

class WalletUtil {
  final log = getLogger('WalletUtil');

  final tokenListDatabaseService = locator<TokenInfoDatabaseService>();

  var abiUtils = AbiUtils();
  final coinService = locator<CoinService>();
  var coreWalletDatabaseService = locator<CoreWalletDatabaseService>();

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
        'Binance Coin'
  ];

  // get wallet info object with address using single wallet balance
  Future<WalletInfo> getWalletInfoObjFromWalletBalance(
      WalletBalance wallet) async {
    //FocusScope.of(context).requestFocus(FocusNode());

    // take the tickername and then get the coin type
    // either from token or token updates api/local storage

    String tickerName = wallet.coin.toUpperCase();
    String walletAddress = '';

    int coinType = await coinService.getCoinTypeByTickerName(tickerName);

    // use coin type to get the token type
    String tokenType = getChainNameByTokenType(coinType);

    // get wallet address
    if (tickerName == 'ETH' ||
        tokenType == 'ETH' ||
        tickerName == 'MATICM' ||
        tokenType == 'POLYGON' ||
        tickerName == "BNB" ||
        tokenType == "BNB") {
      walletAddress =
          await coreWalletDatabaseService.getWalletAddressByTickerName('ETH');
    } else if (tickerName == 'FAB' || tokenType == 'FAB') {
      walletAddress =
          await coreWalletDatabaseService.getWalletAddressByTickerName('FAB');
    } else if (tickerName == 'TRX' ||
        tickerName == 'TRON' ||
        tokenType == 'TRON' ||
        tokenType == 'TRX') {
      walletAddress =
          await coreWalletDatabaseService.getWalletAddressByTickerName('TRX');
    } else {
      walletAddress = await coreWalletDatabaseService
          .getWalletAddressByTickerName(tickerName);
    }
    String coinName = '';
    for (var i = 0; i < coinTickerAndNameList.length; i++) {
      if (coinTickerAndNameList.containsKey(wallet.coin)) {
        coinName = coinTickerAndNameList[wallet.coin];
      }
      break;
    }

    // assign address from local DB to walletinfo object
    var walletInfo = WalletInfo(
        tickerName: wallet.coin,
        availableBalance: wallet.balance,
        tokenType: tokenType,
        usdValue: wallet.balance * wallet.usdValue.usd,
        inExchange: wallet.unlockedExchangeBalance,
        address: walletAddress,
        name: coinName);

    log.w('routeWithWalletInfoArgs walletInfo ${walletInfo.toJson()}');
    return walletInfo;
  }

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
      tickerName = 'USDC(TRC20)';
      logoTicker = 'USDCX';
    } else if (tickerName.toUpperCase() == 'MATICM') {
      tickerName = 'MATIC(POLYGON)';
      logoTicker = 'MATICM';
    } else if (tickerName.toUpperCase() == 'USDTM') {
      tickerName = 'USDT(MATIC)';
      logoTicker = 'USDTM';
    } else if (tickerName.toUpperCase() == 'FABB') {
      tickerName = 'FAB(BEP20)';
      logoTicker = 'FABB';
    } else if (tickerName.toUpperCase() == 'MATIC') {
      tickerName = 'MATIC(ERC20)';
      logoTicker = 'MATIC';
    } else {
      logoTicker = tickerName;
    }
    return {"tickerName": tickerName, "logoTicker": logoTicker};
  }

// Delete wallet

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
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
