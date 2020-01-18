import 'package:exchangilymobileapp/screen_state/confirm_mnemonic_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/settings_state.dart';
import 'package:exchangilymobileapp/screen_state/wallet_features_screen_state.dart';
import 'package:exchangilymobileapp/services/api.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/create_password_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/send_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/dashboard_screen_state.dart';
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
  locator.registerFactory(() => DashboardScreenState());
  locator.registerFactory(() => SendScreenState());
  locator.registerFactory(() => ConfirmMnemonicScreenState());
  locator.registerFactory(() => WalletFeaturesScreenState());
  locator.registerFactory(() => SettingsScreenState());
}
