import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';

class TotalBalancesScreenState extends BaseState {
  final log = getLogger('TotalBalancesSCreenState');
  final double elevation = 5;
  double totalUsdBalance = 0;
  var coinUsdBalance;
  List<WalletInfo> walletInfo;
  WalletService walletService = locator<WalletService>();

  refreshBalance(List<WalletInfo> _walletInfo) async {
    // var address = await walletService.test();
    // log.i(address);
    setState(ViewState.Busy);
    walletService.totalUsdBalance.clear();
    log.w(_walletInfo.length);
    int length = _walletInfo.length;
    List<String> tokenType = ['', '', '', 'ETH', 'FAB'];
    if (_walletInfo.isNotEmpty) {
      for (var i = 0; i < length; i++) {
        String tName = _walletInfo[i].tickerName;
        String address = _walletInfo[i].address;
        String name = _walletInfo[i].name;

        double bal = await walletService.coinBalanceByAddress(
            tName, address, tokenType[i]);
        log.w('$tName - $bal');
        double marketPrice = await walletService.getCoinMarketPrice(name);
        walletService.calculateCoinUsdBalance(marketPrice, bal);
        coinUsdBalance = walletService.coinUsdBalance;
        log.w('usd Value $name - $coinUsdBalance');
        _walletInfo[i].availableBalance = bal;
        if (coinUsdBalance == null) {
          _walletInfo[i].usdValue = 0.0;
        }
        _walletInfo[i].usdValue = coinUsdBalance;
      }
      total();
      setState(ViewState.Idle);
      return _walletInfo;
    } else {
      setState(ViewState.Idle);
      log.e('In else list 0');
    }
  }

  total() {
    totalUsdBalance = walletService.calculateTotalUsdBalance();
    log.w(totalUsdBalance);
    return totalUsdBalance;
  }
}
