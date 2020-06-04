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

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/otc/otc.dart';
import 'package:exchangilymobileapp/screens/otc/otc_details.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/campaign_dashboard_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/instructions_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/login_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/register_account_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/payment_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/refferal_deatils_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/reward_details_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/order_details_screen.dart';

import 'package:exchangilymobileapp/screens/otc_campaign/team_reward_details_screen.dart';
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
import 'package:exchangilymobileapp/widgets/main_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screens/market/main.dart';
import 'package:exchangilymobileapp/screens/trade/main.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/add_gas.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/move_to_wallet.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/redeposit.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/smart_contract.dart';
import 'package:exchangilymobileapp/screens/settings/settings.dart';

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
      case '/mainNav':
        return MaterialPageRoute(builder: (_) => MainNav());

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

      case '/dashboard':
        return MaterialPageRoute(
            builder: (_) => WalletDashboardScreen(walletInfo: args));

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

      case '/trade':
        return MaterialPageRoute(builder: (_) => Trade('EXG/USDT'));

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

      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsScreen());

      case '/transactionHistory':
        return MaterialPageRoute(
            builder: (_) => TransactionHistory(
                  tickerName: args,
                ));

      case '/otc':
        return MaterialPageRoute(builder: (_) => OtcScreen());

      case '/otcDetails':
        return MaterialPageRoute(builder: (_) => OtcDetailsScreen());

      case '/campaignInstructions':
        return MaterialPageRoute(builder: (_) => CampaignInstructionScreen());

      case '/campaignPayment':
        return MaterialPageRoute(builder: (_) => CampaignPaymentScreen());

      case '/campaignDashboard':
        return MaterialPageRoute(
            builder: (_) => CampaignDashboardScreen(
                  userData: args,
                ));

      case '/campaignTokenDetails':
        return MaterialPageRoute(
            builder: (_) =>
                CampaignTokenDetailsScreen(campaignRewardList: args));

      case '/campaignRewardDetails':
        return MaterialPageRoute(
            builder: (_) =>
                CampaignRewardDetailsScreen(campaignRewardList: args));

      case '/campaignOrderDetails':
        return MaterialPageRoute(
            builder: (_) => CampaignOrderDetailsScreen(orderInfoList: args));

      case '/campaignRefferalDetails':
        return MaterialPageRoute(
            builder: (_) => CampaignRefferalDetailsScreen());

      case '/campaignTeamRewardDetails':
        return MaterialPageRoute(
            builder: (_) =>
                CampaignTeamRewardDetailsScreen(teamValueAndReward: args));

      case '/campaignLogin':
        return MaterialPageRoute(builder: (_) => CampaignLoginScreen());

      case '/campaignRegisterAccount':
        return MaterialPageRoute(
            builder: (_) => CampaignRegisterAccountScreen());

      default:
        return _errorRoute(settings);
    }
  }

  static Route _errorRoute(settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error', style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Text('No route defined for ${settings.name}',
              style: TextStyle(color: Colors.white)),
        ),
      );
    });
  }
}
