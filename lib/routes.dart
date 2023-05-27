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

import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/order_info.dart';
import 'package:exchangilymobileapp/models/campaign/reward.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/screens/announcement/events/events_view.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/markets_view.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trade_view.dart';
import 'package:exchangilymobileapp/screens/lightning-remit/lightning_remit_view.dart';
import 'package:exchangilymobileapp/screens/otc/otc.dart';
import 'package:exchangilymobileapp/screens/otc/otc_details.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/campaign_dashboard_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/campaign_single.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/instructions_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/login_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/my_reward/my_referral_view.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/register_account_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/payment_screen.dart';

import 'package:exchangilymobileapp/screens/otc_campaign/my_reward/my_reward_details_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/order_details_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/team/team_referral_view.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/team/team_rewards_details_view.dart';

//import 'package:exchangilymobileapp/screens/settings/language.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/transaction_history_view.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/backup_mnemonic.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_dashboard_view.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/confirm_mnemonic/confirm_mnemonic_view.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/create_password.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/import_wallet.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/choose_wallet_language.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/move_to_exchange_view.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/receive.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/send_view.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/wallet_features_view.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/wallet_setup_view.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/add_gas/add_gas.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/move_to_wallet_view.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/redeposit/redeposit_view.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/smart_contract.dart';
import 'package:exchangilymobileapp/screens/settings/settings_view.dart';

import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_orders_view.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'screens/otc_campaign/token_details_screen.dart';

final log = getLogger('Routes');

class RouteGenerator {
  static String? _lastRoute = '/';
  static String? get lastRoute => _lastRoute;
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log.w(
        'generateRoute | name: ${settings.name} arguments:${settings.arguments}');
    final args = settings.arguments;
    _lastRoute = settings.name;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WalletSetupView());

/*----------------------------------------------------------------------
                          Wallet Setup
----------------------------------------------------------------------*/

      case ChooseWalletLanguageViewRoute:
        return MaterialPageRoute(builder: (_) => ChooseWalletLanguageView());
      case WalletSetupViewRoute:
        return MaterialPageRoute(builder: (_) => const WalletSetupView());

      case ImportWalletViewRoute:
        return MaterialPageRoute(builder: (_) => ImportWalletView());

      case BackupMnemonicViewRoute:
        return MaterialPageRoute(
            builder: (_) => const BackupMnemonicWalletScreen());

      case ConfirmMnemonicViewRoute:
        return MaterialPageRoute(
            builder: (_) => ConfirmMnemonicView(
                randomMnemonicListFromRoute: args as List<String>?));

      case CreatePasswordViewRoute:
        return MaterialPageRoute(
            builder: (_) => CreatePasswordScreen(args: args));

/*----------------------------------------------------------------------
                          Wallet Routes
----------------------------------------------------------------------*/

      case DashboardViewRoute:
        return MaterialPageRoute(
            settings: const RouteSettings(name: 'WalletDashboardScreen'),
            builder: (_) => const WalletDashboardView());

      case AddGasViewRoute:
        return MaterialPageRoute(builder: (_) => AddGas());

      case SmartContractViewRoute:
        return MaterialPageRoute(builder: (_) => const SmartContract());

      case DepositViewRoute:
        return MaterialPageRoute(
            builder: (_) =>
                MoveToExchangeScreen(walletInfo: args as WalletInfo?));

      case RedepositViewRoute:
        return MaterialPageRoute(
            builder: (_) => Redeposit(walletInfo: args as WalletInfo?));

      case WithdrawViewRoute:
        return MaterialPageRoute(
            builder: (_) =>
                MoveToWalletScreen(walletInfo: args as WalletInfo?));

      case WalletFeaturesViewRoute:
        return MaterialPageRoute(
            builder: (_) =>
                WalletFeaturesView(walletInfo: args as WalletInfo?));

      case ReceiveViewRoute:
        return MaterialPageRoute(
            builder: (_) => ReceiveWalletScreen(
                  walletInfo: args as WalletInfo?,
                ));

      case SendViewRoute:
        return MaterialPageRoute(
            builder: (_) => SendWalletView(
                  walletInfo: args as WalletInfo?,
                ));

      case TransactionHistoryViewRoute:
        return MaterialPageRoute(
            builder: (_) => TransactionHistoryView(
                  walletInfo: args as WalletInfo?,
                ));

/*----------------------------------------------------------------------
                          Exchange Routes
----------------------------------------------------------------------*/

      case MarketsViewRoute:
        return MaterialPageRoute(
            settings: const RouteSettings(name: 'MarketsView'),
            builder: (_) => MarketsView(hideSlider: args as bool?));

      case '/exchangeTrade':
        return MaterialPageRoute(
            builder: (_) => TradeView(pairPriceByRoute: args as Price?));

      case '/myExchangeOrders':
        return MaterialPageRoute(
            builder: (_) => MyOrdersView(tickerName: args as String?));

/*----------------------------------------------------------------------
                          Campaign Routes
----------------------------------------------------------------------*/
      case '/campaignInstructions':
        return MaterialPageRoute(
            settings: const RouteSettings(name: 'CampaignInstructionScreen'),
            builder: (_) => const CampaignInstructionScreen());

      case '/campaignSingle':
        return MaterialPageRoute(
            settings: const RouteSettings(name: 'CampaignSingle'),
            builder: (_) => CampaignSingle(args as String?));

      case '/campaignPayment':
        return MaterialPageRoute(builder: (_) => const CampaignPaymentScreen());

      case '/campaignDashboard':
        return MaterialPageRoute(builder: (_) => CampaignDashboardScreen());

      case '/campaignTokenDetails':
        return MaterialPageRoute(
            builder: (_) => CampaignTokenDetailsScreen(
                campaignRewardList: args as List<CampaignReward>?));

      case '/MyRewardDetails':
        return MaterialPageRoute(
            builder: (_) => MyRewardDetailsScreen(
                campaignRewardList: args as List<CampaignReward>?));

      case '/campaignOrderDetails':
        return MaterialPageRoute(
            builder: (_) => CampaignOrderDetailsScreen(
                orderInfoList: args as List<OrderInfo>?));

      case '/teamRewardDetails':
        return MaterialPageRoute(
            builder: (_) =>
                TeamRewardDetailsView(team: args as List<dynamic>?));

      case '/teamReferralView':
        return MaterialPageRoute(
            builder: (_) => CampaignTeamReferralView(rewardDetails: args));

      case '/myReferralView':
        return MaterialPageRoute(
            builder: (_) =>
                MyReferralView(referralDetails: args as List<String>?));

      case '/campaignLogin':
        return MaterialPageRoute(
            builder: (_) => CampaignLoginScreen(
                  errorMessage: args as String?,
                ));

      case '/campaignRegisterAccount':
        return MaterialPageRoute(
            builder: (_) => const CampaignRegisterAccountScreen());

      case '/eventsView':
        return MaterialPageRoute(
            settings: const RouteSettings(name: 'EventsView'),
            builder: (_) => const EventsView());
/*----------------------------------------------------------------------
                      LightningRemit Routes
----------------------------------------------------------------------*/
      case LightningRemitViewRoute:
        return MaterialPageRoute(
            settings: const RouteSettings(name: 'LightningRemitView'),
            builder: (_) => const LightningRemitView());

/*----------------------------------------------------------------------
                      Navigation Routes
----------------------------------------------------------------------*/
      case SettingViewRoute:
        return MaterialPageRoute(
            settings: const RouteSettings(name: 'SettingsScreen'),
            builder: (_) => const SettingsView());

      /// OTC Screen
      case '/otc':
        return MaterialPageRoute(builder: (_) => const OtcScreen());

      case '/otcDetails':
        return MaterialPageRoute(builder: (_) => const OtcDetailsScreen());

      default:
        return _errorRoute(settings);
    }
  }

  static Route _errorRoute(settings) {
    BuildContext? context;
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context!, "error"),
              style: const TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Text(
              '${FlutterI18n.translate(context, "noRouteDefined")} ${settings.name}',
              style: const TextStyle(color: Colors.white)),
        ),
      );
    });
  }
}
