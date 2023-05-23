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

import 'package:exchangilymobileapp/screen_state/announcement/announcement_list_state.dart';
import 'package:exchangilymobileapp/screen_state/market/MarketPairsTabViewState.dart';
import 'package:exchangilymobileapp/screen_state/nav/MainNavState.dart';
import 'package:exchangilymobileapp/screen_state/otc/otc_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_single_state.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/instructions_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/payment_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/login_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/register_account_screen_state.dart';
//import 'package:exchangilymobileapp/screen_state/settings/language_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/move_to_wallet_viewmodel.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/transaction_history_viewmodel.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/choose_wallet_language_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/confirm_mnemonic_viemodel.dart';
import 'package:exchangilymobileapp/screen_state/settings/settings_viewmodel.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/wallet_features_viewmodel.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/wallet_setup_viewmodel.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/markets_viewmodel.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_exchange_assets/my_exchange_assets_viewmodel.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trade_viewmodel.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/buy_sell/buy_sell_viewmodel.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trading_chart/trading_chart_viewmodel.dart';
import 'package:exchangilymobileapp/screens/lightning-remit/lightning_remit_viewmodel.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/redeposit/redeposit_viewmodel.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/coin_service.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/db/decimal_config_database_service.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_auth_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/order_service.dart';
import 'package:exchangilymobileapp/services/pdf_viewer_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/services/version_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/create_password_viewmodel.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/send_viewmodel.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/move_to_exchange_viewmodel.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:exchangilymobileapp/widget_state/carousel_state.dart';
import 'package:get_it/get_it.dart';
import 'package:exchangilymobileapp/screen_state/otc/otc_details_screen_state.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/team_reward_details_screen_state.dart';

import 'screens/exchange/trade/my_exchange_assets/exchange_balance_service.dart';

GetIt locator = GetIt.instance;

Future serviceLocator() async {
  // Singleton returns the old instance

  // Wallet
  locator.registerLazySingleton(() => WalletService());
  locator.registerLazySingleton(() => CoreWalletDatabaseService());
  locator.registerLazySingleton(() => WalletDatabaseService());

  locator.registerLazySingleton(() => VaultService());
  locator.registerLazySingleton(() => TokenInfoDatabaseService());
  locator.registerLazySingleton(() => UserSettingsDatabaseService());
  locator.registerLazySingleton(() => LocalAuthService());
  locator.registerLazySingleton(() => CoinService());
  // Shared
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => SharedService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => ConfigService());
  locator.registerLazySingleton(() => DecimalConfigDatabaseService());
  // Campaign
  locator.registerLazySingleton(() => CampaignService());
  locator.registerLazySingleton(() => CampaignUserDatabaseService());
  // Trade
  locator.registerLazySingleton(() => TradeService());
  locator.registerLazySingleton(() => TransactionHistoryDatabaseService());
  locator.registerLazySingleton(() => PdfViewerService());
  locator.registerLazySingleton(() => OrderService());
  locator.registerLazySingleton(() => ExchangeBalanceService());

  //Version Service
  locator.registerLazySingleton(() => VersionService());

  // LocalStorageService Singelton
  var instance = (await LocalStorageService.getInstance())!;
  locator.registerSingleton<LocalStorageService>(instance);

  // Factory returns the new instance

  // Wallet
  locator.registerFactory(() => AnnouncementListScreenState());
  locator.registerFactory(() => ConfirmMnemonicViewmodel());
  locator.registerFactory(() => CreatePasswordViewModel());
  locator.registerFactory(() => WalletDashboardViewModel());
  locator.registerFactory(() => WalletFeaturesViewModel());
  locator.registerFactory(() => SendViewModel());
  locator.registerFactory(() => SettingsViewmodel());
  //locator.registerFactory(() => LanguageScreenState());
  locator.registerFactory(() => WalletSetupViewmodel());
  locator.registerFactory(() => ChooseWalletLanguageScreenState());
  locator.registerFactory(() => MoveToExchangeViewModel());
  locator.registerFactory(() => MoveToWalletViewmodel());
  locator.registerFactory(() => TransactionHistoryViewmodel());
  locator.registerFactory(() => RedepositViewModel());
  // OTC
  locator.registerFactory(() => OtcScreenState());
  locator.registerFactory(() => OtcDetailsScreenState());
  // Campaign
  locator.registerFactory(() => CampaignInstructionsScreenState());
  locator.registerFactory(() => CampaignPaymentScreenState());
  locator.registerFactory(() => CampaignDashboardScreenState());
  locator.registerFactory(() => CampaignLoginScreenState());
  locator.registerFactory(() => CampaignRegisterAccountScreenState());
  locator.registerFactory(() => TeamRewardDetailsScreenState());
  locator.registerFactory(() => CampaignSingleScreenState());
  locator.registerFactory(() => CarouselWidgetState());
  // Trade
  locator.registerFactory(() => MarketsViewModel());
  locator.registerFactory(() => TradeViewModel());
  locator.registerFactory(() => BuySellViewModel(tickerNameFromRoute: ''));
  locator.registerFactory(() => MyExchangeAssetsViewModel());
  locator.registerFactory(() => MarketPairsTabViewState());
  locator.registerFactory(() => TradingChartViewModel());

  // LightningRemit
  locator.registerFactory(() => LightningRemitViewmodel());
  // Navigation
  locator.registerFactory(() => MainNavState());
}
