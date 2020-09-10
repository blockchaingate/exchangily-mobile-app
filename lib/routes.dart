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

import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/bindpay/bindpay_dashboard.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/markets_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trade_view.dart';
import 'package:exchangilymobileapp/screens/otc/otc.dart';
import 'package:exchangilymobileapp/screens/otc/otc_details.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/campaign_dashboard_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/instructions_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/login_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/my_reward/my_referral_view.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/register_account_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/payment_screen.dart';

import 'package:exchangilymobileapp/screens/otc_campaign/my_reward/my_reward_details_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/order_details_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/team/team_referral_view.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/team/team_rewards_details_view.dart';

import 'package:exchangilymobileapp/screens/settings/language.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/transaction_history.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/backup_mnemonic.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_dashboard.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/confirm_mnemonic.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/create_password.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/import_wallet.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/choose_wallet_language.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/move_to_exchange.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/receive.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/send.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/wallet_features.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/wallet_setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screens/market/main.dart';
import 'package:exchangilymobileapp/screens/trade/main.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/add_gas.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/move_to_wallet.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/redeposit.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/smart_contract.dart';
import 'package:exchangilymobileapp/screens/settings/settings.dart';

import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_orders_view.dart';
import 'screens/otc_campaign/token_details_screen.dart';

final log = getLogger('Routes');

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log.w(
        'generateRoute | name: ${settings.name} arguments:${settings.arguments}');
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => ChooseWalletLanguageScreen());

      //main navagation contains several pages
      // case '/mainNav':
      //   return MaterialPageRoute(builder: (_) => MainNav(currentPage: args));
      // return MaterialPageRoute(builder: (_) => MainNavCircle());
      case '/walletSetup':
        return MaterialPageRoute(builder: (_) => WalletSetupScreen());

      case '/importWallet':
        return MaterialPageRoute(builder: (_) => ImportWalletScreen());

      case '/confirmMnemonic':
        return MaterialPageRoute(
            builder: (_) => ConfirmMnemonictWalletScreen(
                randomMnemonicListFromRoute: args));

      case '/backupMnemonic':
        return MaterialPageRoute(builder: (_) => BackupMnemonicWalletScreen());

      case '/createPassword':
        return MaterialPageRoute(
            builder: (_) =>
                CreatePasswordScreen(randomMnemonicFromRoute: args));

      /// WALLET DASHBOARD

      case '/dashboard':
        return MaterialPageRoute(
            settings: RouteSettings(name: 'WalletDashboardScreen'),
            builder: (_) => WalletDashboardScreen());

      case '/walletFeatures':
        return MaterialPageRoute(
            builder: (_) => WalletFeaturesScreen(walletInfo: args));

      case '/receive':
        return MaterialPageRoute(
            builder: (_) => ReceiveWalletScreen(
                  walletInfo: args,
                ));

      case '/send':
        return MaterialPageRoute(
            builder: (_) => SendWalletScreen(
                  walletInfo: args,
                ));

      case '/market':
        return MaterialPageRoute(builder: (_) => Market());

      /// MARKET VIEW

      case '/marketsView':
        return MaterialPageRoute(
            settings: RouteSettings(name: 'MarketsView'),
            builder: (_) => MarketsView(hideSlider: args));

      case '/trade':
        return MaterialPageRoute(builder: (_) => Trade('EXG/USDT'));

      case '/exchangeTrade':
        return MaterialPageRoute(
            builder: (_) => TradeView(pairPriceByRoute: args));

      case '/myExchangeOrders':
        return MaterialPageRoute(
            builder: (_) => MyOrdersView(tickerName: args));

      case '/addGas':
        return MaterialPageRoute(builder: (_) => AddGas());

      case '/smartContract':
        return MaterialPageRoute(builder: (_) => SmartContract());

      case '/deposit':
        return MaterialPageRoute(
            builder: (_) => MoveToExchangeScreen(walletInfo: args));

      case '/redeposit':
        return MaterialPageRoute(builder: (_) => Redeposit(walletInfo: args));

      case '/withdraw':
        return MaterialPageRoute(
            builder: (_) => MoveToWalletScreen(walletInfo: args));

      /// SETTINGS

      case '/settings':
        return MaterialPageRoute(
            settings: RouteSettings(name: 'SettingsScreen'),
            builder: (_) => SettingsScreen());

      case '/transactionHistory':
        return MaterialPageRoute(
            builder: (_) => TransactionHistory(
                  tickerName: args,
                ));

      /// OTC Screen
      case '/otc':
        return MaterialPageRoute(builder: (_) => OtcScreen());

      case '/otcDetails':
        return MaterialPageRoute(builder: (_) => OtcDetailsScreen());

      /// CAMPAIGN INSTRUCTIONS

      case '/campaignInstructions':
        return MaterialPageRoute(
            settings: RouteSettings(name: 'CampaignInstructionScreen'),
            builder: (_) => CampaignInstructionScreen());

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

      case '/switchLanguage':
        return MaterialPageRoute(builder: (_) => LanguageScreen());
      case '/bindpay':
        return MaterialPageRoute(builder: (_) => BindpayDashboardView());

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
