import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/view_state/base_state.dart';

class TotalBalancesScreenState extends BaseState {
  final log = getLogger('TotalBalancesViewState');
  final double elevation = 5;
  double totalUsdBalance = 0;

  WalletService walletService = locator<WalletService>();
  refreshTotal() {
    totalUsdBalance = walletService.calculateTotalUsdBalance();
    log.w(totalUsdBalance);
    return totalUsdBalance;
  }
}
