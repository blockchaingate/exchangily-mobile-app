import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';

class TotalBalancesScreenState extends BaseState {
  final log = getLogger('TotalBalancesScreenState');
  List<WalletInfo> walletInfo;
  WalletService walletService = locator<WalletService>();
  Api _api = locator<Api>();
  final double elevation = 5;
  double totalUsdBalance = 0;
  var coinUsdBalance;
  double gasAmount = 0;

  Future refreshBalance(List<WalletInfo> _walletInfo) async {
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

        var balance = await walletService.coinBalanceByAddress(
            tName, address, tokenType[i]);
        double bal = balance['balance'];
        double lockedBal = balance['lockedBalance'];
        double marketPrice = await walletService.getCoinMarketPrice(name);
        walletService.calculateCoinUsdBalance(marketPrice, bal);
        coinUsdBalance = walletService.coinUsdBalance;
        log.w('usd Value $name - $coinUsdBalance');
        _walletInfo[i].availableBalance = bal;
        if (lockedBal == null) {
          _walletInfo[i].lockedBalance = 0.0;
        } else {
          _walletInfo[i].lockedBalance = lockedBal;
        }
        if (coinUsdBalance == null) {
          _walletInfo[i].usdValue = 0.0;
        } else {
          _walletInfo[i].usdValue = coinUsdBalance;
        }
      }

      totalUsdBal();
      gasBalance();
      setState(ViewState.Idle);
      return _walletInfo;
    } else {
      setState(ViewState.Idle);
      log.e('In else list 0');
    }
  }

  totalUsdBal() {
    totalUsdBalance = walletService.calculateTotalUsdBalance();
    log.w(totalUsdBalance);
    return totalUsdBalance;
  }

  gasBalance() async {
    var bal = await _api.getGasBalance();
    var newBal = int.parse(bal['balance']['FAB']);
    gasAmount = newBal / 1e18;
    log.w('Gas bal $gasAmount');
    return gasAmount;
  }
}
