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
  String addr = '';

  exgAddress() {
    for (var i = 0; i < walletInfo.length; i++) {
      String tName = walletInfo[i].tickerName;
      if (tName == 'EXG') {
        addr = walletInfo[i].address;
        log.d(addr);
        return addr;
      }
    }
  }

  Future refreshBalance() async {
    setState(ViewState.Busy);
    walletService.totalUsdBalance.clear();
    log.w(walletInfo.length);
    int length = walletInfo.length;
    List<String> tokenType = ['', '', '', 'ETH', 'FAB'];
    if (walletInfo.isNotEmpty) {
      for (var i = 0; i < length; i++) {
        String tName = walletInfo[i].tickerName;
        String address = walletInfo[i].address;
        String name = walletInfo[i].name;
        if (tName == 'EXG') {
          addr = walletInfo[i].address;
          log.d(addr);
        }
        var balance = await walletService.coinBalanceByAddress(
            tName, address, tokenType[i]);
        double bal = balance['balance'];
        double lockedBal = balance['lockedBalance'];
        double marketPrice = await walletService.getCoinMarketPrice(name);
        walletService.calculateCoinUsdBalance(marketPrice, bal);
        coinUsdBalance = walletService.coinUsdBalance;
        log.w('usd Value $name - $coinUsdBalance');
        walletInfo[i].availableBalance = bal;
        if (lockedBal == null) {
          walletInfo[i].lockedBalance = 0.0;
        } else {
          walletInfo[i].lockedBalance = lockedBal;
        }
        if (coinUsdBalance == null) {
          walletInfo[i].usdValue = 0.0;
        } else {
          walletInfo[i].usdValue = coinUsdBalance;
        }
      }

      totalUsdBal();
      gasBalance(addr);
      setState(ViewState.Idle);
      return walletInfo;
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

  gasBalance(addr) async {
    await _api.getGasBalance(addr).then((res) {
      var newBal = int.parse(res['balance']['FAB']);
      gasAmount = newBal / 1e18;
      log.w('Gas bal $gasAmount');
      return gasAmount;
    }).catchError((onError) {
      log.w('On error $onError');
      return gasAmount = 0.0;
    });
  }
}
