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
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/markets_view.dart';
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
import 'screens/otc_campaign/token_details_screen.dart';

final log = getLogger('Routes');

class RouteGenerator {
  static String _lastRoute = '/';
  static String get lastRoute => _lastRoute;
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log.w(
        'generateRoute | name: ${settings.name} arguments:${settings.arguments}');
    final args = settings.arguments;
    _lastRoute = settings.name;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WalletSetupView());

/*----------------------------------------------------------------------
                          Wallet Setup
----------------------------------------------------------------------*/

      case ChooseWalletLanguageViewRoute:
        return MaterialPageRoute(builder: (_) => ChooseWalletLanguageView());
      case WalletSetupViewRoute:
        return MaterialPageRoute(builder: (_) => WalletSetupView());

      case ImportWalletViewRoute:
        return MaterialPageRoute(builder: (_) => ImportWalletView());

      case BackupMnemonicViewRoute:
        return MaterialPageRoute(builder: (_) => BackupMnemonicWalletScreen());

      case ConfirmMnemonicViewRoute:
        return MaterialPageRoute(
            builder: (_) =>
                ConfirmMnemonicView(randomMnemonicListFromRoute: args));

      case CreatePasswordViewRoute:
        return MaterialPageRoute(
            builder: (_) => CreatePasswordScreen(args: args));

/*----------------------------------------------------------------------
                          Wallet Routes
----------------------------------------------------------------------*/

      case DashboardViewRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: 'WalletDashboardScreen'),
            builder: (_) => WalletDashboardView());

      case AddGasViewRoute:
        return MaterialPageRoute(builder: (_) => AddGas());

      case SmartContractViewRoute:
        return MaterialPageRoute(builder: (_) => SmartContract());

      case DepositViewRoute:
        return MaterialPageRoute(
            builder: (_) => MoveToExchangeScreen(walletInfo: args));

      case RedepositViewRoute:
        return MaterialPageRoute(builder: (_) => Redeposit(walletInfo: args));

      case WithdrawViewRoute:
        return MaterialPageRoute(
            builder: (_) => MoveToWalletScreen(walletInfo: args));

      case WalletFeaturesViewRoute:
        return MaterialPageRoute(
            builder: (_) => WalletFeaturesView(walletInfo: args));

      case ReceiveViewRoute:
        return MaterialPageRoute(
            builder: (_) => ReceiveWalletScreen(
                  walletInfo: args,
                ));

      case SendViewRoute:
        return MaterialPageRoute(
            builder: (_) => SendWalletView(
                  walletInfo: args,
                ));

      case TransactionHistoryViewRoute:
        return MaterialPageRoute(
            builder: (_) => TransactionHistoryView(
                  walletInfo: args,
                ));

/*----------------------------------------------------------------------
                          Exchange Routes
----------------------------------------------------------------------*/

      case MarketsViewRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: 'MarketsView'),
            builder: (_) => MarketsView(hideSlider: args));

      case '/exchangeTrade':
        return MaterialPageRoute(
            builder: (_) => TradeView(pairPriceByRoute: args));

      case '/myExchangeOrders':
        return MaterialPageRoute(
            builder: (_) => MyOrdersView(tickerName: args));

/*----------------------------------------------------------------------
                          Campaign Routes
----------------------------------------------------------------------*/
      case '/campaignInstructions':
        return MaterialPageRoute(
            settings: RouteSettings(name: 'CampaignInstructionScreen'),
            builder: (_) => CampaignInstructionScreen());

      case '/campaignSingle':
        return MaterialPageRoute(
            settings: RouteSettings(name: 'CampaignSingle'),
            builder: (_) => CampaignSingle(args));

      case '/campaignPayment':
        return MaterialPageRoute(builder: (_) => CampaignPaymentScreen());

      case '/campaignDashboard':
        return MaterialPageRoute(builder: (_) => CampaignDashboardScreen());

      case '/campaignTokenDetails':
        return MaterialPageRoute(
            builder: (_) =>
                CampaignTokenDetailsScreen(campaignRewardList: args));

      case '/MyRewardDetails':
        return MaterialPageRoute(
            builder: (_) => MyRewardDetailsScreen(campaignRewardList: args));

      case '/campaignOrderDetails':
        return MaterialPageRoute(
            builder: (_) => CampaignOrderDetailsScreen(orderInfoList: args));

      case '/teamRewardDetails':
        return MaterialPageRoute(
            builder: (_) => TeamRewardDetailsView(team: args));

      case '/teamReferralView':
        return MaterialPageRoute(
            builder: (_) => CampaignTeamReferralView(rewardDetails: args));

      case '/myReferralView':
        return MaterialPageRoute(
            builder: (_) => MyReferralView(referralDetails: args));

      case '/campaignLogin':
        return MaterialPageRoute(
            builder: (_) => CampaignLoginScreen(
                  errorMessage: args,
                ));

      case '/campaignRegisterAccount':
        return MaterialPageRoute(
            builder: (_) => CampaignRegisterAccountScreen());

      // case '/switchLanguage':
      //   return MaterialPageRoute(builder: (_) => LanguageScreen());
/*----------------------------------------------------------------------
                      LightningRemit Routes
----------------------------------------------------------------------*/
      case LightningRemitViewRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: 'LightningRemitView'),
            builder: (_) => LightningRemitView());

/*----------------------------------------------------------------------
                      Navigation Routes
----------------------------------------------------------------------*/
      case SettingViewRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: 'SettingsScreen'),
            builder: (_) => SettingsView());

      /// OTC Screen
      case '/otc':
        return MaterialPageRoute(builder: (_) => OtcScreen());

      case '/otcDetails':
        return MaterialPageRoute(builder: (_) => OtcDetailsScreen());

      default:
        return _errorRoute(settings);
    }
  }

  static Route _errorRoute(settings) {
    BuildContext context;
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).error,
              style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Text(
              AppLocalizations.of(context).noRouteDefined + ' ${settings.name}',
              style: TextStyle(color: Colors.white)),
        ),
      );
    });
  }
}
