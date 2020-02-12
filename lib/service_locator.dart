/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/screen_state/buy_sell_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/choose_wallet_language_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/confirm_mnemonic_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/settings_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/wallet_features_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/wallet_setup_screen_state.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/create_password_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/send_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/dashboard_screen_state.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void serviceLocator() {
  // singleton returns the old instance
  locator.registerLazySingleton(() => WalletService());
  locator.registerLazySingleton(() => VaultService());
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => WalletDataBaseService());
  locator.registerLazySingleton(() => SharedService());
  locator.registerLazySingleton(() => TradeService());

// factory returns the new instance
  locator.registerFactory(() => ConfirmMnemonicScreenState());
  locator.registerFactory(() => CreatePasswordScreenState());
  locator.registerFactory(() => DashboardScreenState());
  locator.registerFactory(() => WalletFeaturesScreenState());
  locator.registerFactory(() => SendScreenState());
  locator.registerFactory(() => SettingsScreenState());
  locator.registerFactory(() => WalletSetupScreenState());
  locator.registerFactory(() => ChooseWalletLanguageScreenState());
  locator.registerFactory(() => BuySellScreenState());
}
