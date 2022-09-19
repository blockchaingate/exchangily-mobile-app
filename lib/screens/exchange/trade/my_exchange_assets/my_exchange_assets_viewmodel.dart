import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/environments/coins.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/exchange/exchange_balance_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_exchange_assets/exchange_balance_service.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/coin_service.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'locker/locker_model.dart';

class MyExchangeAssetsViewModel extends ReactiveViewModel {
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_exchangeBalanceService];

  final log = getLogger('MyExchangeAssetsViewModel');
  List myExchangeAssets = [];
  BuildContext context;
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  TokenInfoDatabaseService tokenListDatabaseService =
      locator<TokenInfoDatabaseService>();
  ApiService apiService = locator<ApiService>();
  ExchangeBalanceModel exchangeBalance = ExchangeBalanceModel();
  List<ExchangeBalanceModel> exchangeBalances = [];
  var storageService = locator<LocalStorageService>();
  final coinService = locator<CoinService>();
  final _dialogService = locator<DialogService>();
  final _exchangeBalanceService = locator<ExchangeBalanceService>();

  String logoUrl = walletCoinsLogoUrl;

  List<LockerModel> lockers = [];
  int currentTabSelection = 0;
  bool isUnlocking = false;
  String exgAddress = '';

  @override
  void dispose() {
    log.e('MyExchangeAssetsViewModel disposed');
    super.dispose();
  }

  void init() async {
    setBusy(true);
    exgAddress = await sharedService.getExgAddressFromWalletDatabase();
    await getExchangeBalances();

    setBusy(false);
  }

  getExchangeBalances() async {
    setBusyForObject(exchangeBalances, true);

    exchangeBalances = await apiService.getAssetsBalance('');

    for (var element in exchangeBalances) {
      debugPrint(element.toJson().toString());
      if (element.ticker.isEmpty) {
        await tokenListDatabaseService
            .getTickerNameByCoinType(element.coinType)
            .then((ticker) {
          // storageService.tokenList.forEach((newToken){
          //   log.e('new token $newToken');
          // var json = jsonDecode(newToken);
          // Token token = Token.fromJson(json);
          // if (token.tokenType == element.coinType){ log.e(token.tickerName);}
          // });

          setBusy(true);
          element.ticker = ticker; //}
          setBusy(false);
        });
        log.i(
            'exchanageBalanceModel null tickerName added ${element.toJson()}');
      }
    }
    setBusyForObject(exchangeBalances, false);
    for (var element in exchangeBalances) {
      log.w(element.toJson());
    }
  }

  updateTabSelection(int tabIndex) async {
    setBusy(true);
    currentTabSelection = tabIndex;
    //  log.e('currentTabSelection $currentTabSelection');
    if (tabIndex == 0) {
      await getExchangeBalances();
    } else if (tabIndex == 1) {
      _exchangeBalanceService.setRefreshLockerBalances(true);
    }
    setBusy(false);
  }

  Future getSingleCoinExchangeBalanceFromAll(String tickerName) async {
    setBusy(true);

    await getSingleCoinExchangeBalance(tickerName).then((value) {
      debugPrint('exchangeBalance using api ${value.toJson()}');
      exchangeBalance = value;
    });
    if (exchangeBalance.lockedAmount == null) {
      for (var coin in exchangeBalances) {
        if (coin.ticker == tickerName) {
          log.w('singleCoinExchangeBalance $coin');
          exchangeBalance.unlockedAmount = coin.unlockedAmount;
          exchangeBalance.lockedAmount = coin.lockedAmount;
          debugPrint(
              'exchangeBalance using all coins for loop ${exchangeBalance.toJson()}');
        }
      }
    }
    setBusy(false);
    return exchangeBalance;
  }

  Future<ExchangeBalanceModel> getSingleCoinExchangeBalance(
      String tickerName) async {
    return await apiService.getSingleCoinExchangeBalance(tickerName);
  }
}
