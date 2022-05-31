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

import 'package:exchangily_mobile_wallet/src/screen_state/announcement/announcement_list_state.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/market/MarketPairsTabViewState.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/nav/MainNavState.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/otc/otc_screen_state.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/otc_campaign/campaign_dashboard_screen_state.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/otc_campaign/campaign_single_state.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/otc_campaign/instructions_screen_state.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/otc_campaign/payment_screen_state.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/otc_campaign/login_screen_state.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/otc_campaign/register_account_screen_state.dart';
//import 'package:exchangily_mobile_wallet/src/screen_state/settings/language_screen_state.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/wallet/wallet_features/move_to_wallet_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/wallet/wallet_features/transaction_history_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/wallet/wallet_setup/choose_wallet_language_screen_state.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/wallet/wallet_setup/confirm_mnemonic_viemodel.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/settings/settings_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/wallet/wallet_features/wallet_features_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/wallet/wallet_setup/wallet_setup_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screens/exchange/markets/markets_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screens/exchange/trade/my_exchange_assets/my_exchange_assets_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screens/exchange/trade/trade_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screens/exchange/trade/buy_sell/buy_sell_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screens/exchange/trade/trading_chart/trading_chart_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screens/lightning-remit/lightning_remit_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screens/wallet/wallet_features/redeposit/redeposit_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/services/api_service.dart';
import 'package:exchangily_mobile_wallet/src/services/coin_service.dart';
import 'package:exchangily_mobile_wallet/src/services/config_service.dart';
import 'package:exchangily_mobile_wallet/src/services/db/campaign_user_database_service.dart';
import 'package:exchangily_mobile_wallet/src/services/db/decimal_config_database_service.dart';
import 'package:exchangily_mobile_wallet/src/services/db/token_list_database_service.dart';
import 'package:exchangily_mobile_wallet/src/services/db/transaction_history_database_service.dart';
import 'package:exchangily_mobile_wallet/src/services/db/user_settings_database_service.dart';
import 'package:exchangily_mobile_wallet/src/services/db/core_wallet_database_service.dart';
import 'package:exchangily_mobile_wallet/src/services/db/wallet_database_service.dart';
import 'package:exchangily_mobile_wallet/src/services/dialog_service.dart';
import 'package:exchangily_mobile_wallet/src/services/local_auth_service.dart';
import 'package:exchangily_mobile_wallet/src/services/navigation_service.dart';
import 'package:exchangily_mobile_wallet/src/services/order_service.dart';
import 'package:exchangily_mobile_wallet/src/services/pdf_viewer_service.dart';
import 'package:exchangily_mobile_wallet/src/services/shared_service.dart';
import 'package:exchangily_mobile_wallet/src/services/vault_service.dart';
import 'package:exchangily_mobile_wallet/src/services/version_service.dart';
import 'package:exchangily_mobile_wallet/src/services/wallet_service.dart';
import 'package:exchangily_mobile_wallet/src/services/campaign_service.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/wallet/wallet_setup/create_password_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/wallet/wallet_features/send_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/wallet/wallet_features/move_to_exchange_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:exchangily_mobile_wallet/src/widget_state/carousel_state.dart';
import 'package:get_it/get_it.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/otc/otc_details_screen_state.dart';
import 'package:exchangily_mobile_wallet/src/services/local_storage_service.dart';
import 'package:exchangily_mobile_wallet/src/screen_state/otc_campaign/team_reward_details_screen_state.dart';

GetIt locator = GetIt.instance;

Future serviceLocator() async {
  // Singleton returns the old instance

  // Wallet
  locator.registerLazySingleton(() => WalletService());
  locator.registerLazySingleton(() => CoreWalletDatabaseService());
  locator.registerLazySingleton(() => WalletDatabaseService());

  locator.registerLazySingleton(() => VaultService());
  locator.registerLazySingleton(() => TokenListDatabaseService());
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

  //Version Service
  locator.registerLazySingleton(() => VersionService());

  // LocalStorageService Singelton
  var instance = await LocalStorageService.getInstance();
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
  locator.registerFactory(() => BuySellViewModel());
  locator.registerFactory(() => MyExchangeAssetsViewModel());
  locator.registerFactory(() => MarketPairsTabViewState());
  locator.registerFactory(() => TradingChartViewModel());

  // LightningRemit
  locator.registerFactory(() => LightningRemitViewmodel());
  // Navigation
  locator.registerFactory(() => MainNavState());
}
