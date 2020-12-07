import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/exchange/exchange_balance_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:stacked/stacked.dart';

class MyExchangeAssetsViewModel extends FutureViewModel {
  final log = getLogger('MyExchangeAssetsViewModel');
  List myExchangeAssets = [];

  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  ApiService apiService = locator<ApiService>();
  ExchangeBalanceModel exchangeBalance = new ExchangeBalanceModel();
  List<ExchangeBalanceModel> exchangeBalances = [];
  @override
  Future futureToRun() async {
    log.e('In get exchange assets');
    // String exgAddress = await sharedService.getExgAddressFromWalletDatabase();
    var res = await apiService.getAssetsBalance('');
    return res;
    // if (res != null) myExchangeAssets = res;
  }

  @override
  void onData(data) {
    setBusyForObject(exchangeBalance, true);
    exchangeBalances = data;
    setBusyForObject(exchangeBalance, false);
    exchangeBalances.forEach((element) {
      log.w(element.toJson());
    });
  }

  Future getSingleCoinExchangeBalanceFromAll(String tickerName) async {
    setBusy(true);

    await getSingleCoinExchangeBalance(tickerName).then((value) {
      print('exchangeBalance using api ${value.toJson()}');
      exchangeBalance = value;
    });
    if (exchangeBalance.lockedAmount == null) {
      List res = data as List;
      res.forEach((coin) {
        if (coin['coin'] == tickerName) {
          log.w('singleCoinExchangeBalance $coin');
          exchangeBalance.unlockedAmount = coin['amount'];
          exchangeBalance.lockedAmount = coin['lockedAmount'];
          print(
              'exchangeBalance using all coins for loop ${exchangeBalance.toJson()}');
        }
      });
    }
    setBusy(false);
    return exchangeBalance;
  }

  Future<ExchangeBalanceModel> getSingleCoinExchangeBalance(
      String tickerName) async {
    return await apiService.getSingleCoinExchangeBalance(tickerName);
  }
}
