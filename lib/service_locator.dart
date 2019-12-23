import 'package:exchangilymobileapp/services/api.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/view_state/create_password_view_state.dart';
import 'package:exchangilymobileapp/view_state/send_state.dart';
import 'package:exchangilymobileapp/view_state/total_balances_view_state.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void serviceLocator() {
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => WalletService());
  locator.registerLazySingleton(
      () => VaultService()); // singleton returns the old instance
  locator.registerLazySingleton(() => DialogService());

// factory returns the new instance
  locator.registerFactory(() => CreatePasswordScreenState());
  locator.registerFactory(() => TotalBalancesScreenState());
  locator.registerFactory(() => SendScreenState());
}
