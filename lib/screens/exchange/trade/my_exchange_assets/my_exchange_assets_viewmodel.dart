import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/exchange/exchange_balance_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';

class MyExchangeAssetsViewModel extends FutureViewModel {
  final log = getLogger('MyExchangeAssetsViewModel');
  List myExchangeAssets = [];

  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  TokenInfoDatabaseService tokenListDatabaseService =
      locator<TokenInfoDatabaseService>();
  ApiService apiService = locator<ApiService>();
  ExchangeBalanceModel exchangeBalance = ExchangeBalanceModel();
  List<ExchangeBalanceModel> exchangeBalances = [];
  var storageService = locator<LocalStorageService>();

  String logoUrl = walletCoinsLogoUrl;
  @override
  Future futureToRun() async {
    log.e('In get exchange assets');
    // String exgAddress = await sharedService.getExgAddressFromWalletDatabase();
    var res = await apiService.getAssetsBalance('');
    return res;
    // if (res != null) myExchangeAssets = res;
  }

  @override
  void onData(data) async {
    setBusyForObject(exchangeBalance, true);
    exchangeBalances = data;
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
    setBusyForObject(exchangeBalance, false);
    for (var element in exchangeBalances) {
      log.w(element.toJson());
    }
  }

  // Future getSingleCoinExchangeBalanceFromAll(String tickerName) async {
  //   setBusy(true);

  //   await getSingleCoinExchangeBalance(tickerName).then((value) {
  //     debugPrint('exchangeBalance using api ${value.toJson()}');
  //     exchangeBalance = value;
  //   });
  //   if (exchangeBalance.lockedAmount == null) {
  //     List res = data as List;
  //     for (var coin in res) {
  //       if (coin['coin'] == tickerName) {
  //         log.w('singleCoinExchangeBalance $coin');
  //         exchangeBalance.unlockedAmount = coin['amount'];
  //         exchangeBalance.lockedAmount = coin['lockedAmount'];
  //         debugPrint(
  //             'exchangeBalance using all coins for loop ${exchangeBalance.toJson()}');
  //       }
  //     }
  //   }
  //   setBusy(false);
  //   return exchangeBalance;
  // }

  // Future<ExchangeBalanceModel> getSingleCoinExchangeBalance(
  //     String tickerName) async {
  //   return await apiService.getSingleCoinExchangeBalance(tickerName);
  // }
}
