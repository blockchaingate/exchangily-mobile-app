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
import 'package:exchangilymobileapp/screens/wallet/wallet_features/transaction_history.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/backup_mnemonic.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_dashboard.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/confirm_mnemonic.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/create_password.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/import_wallet.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/choose_wallet_language.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/move_and_trade.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/receive.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/send.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/wallet_features.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/withdraw_to_wallet.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/wallet_setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screens/market/main.dart';
import 'package:exchangilymobileapp/screens/trade/main.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/add_gas.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/deposit.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/redeposit.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/withdraw.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/smart_contract.dart';
import 'package:exchangilymobileapp/screens/settings/settings.dart';

final log = getLogger('Routes');

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log.w(
        'generateRoute | name: ${settings.name} arguments:${settings.arguments}');
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => ChooseWalletLanguageScreen());
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

      case '/moveToExchange':
        return MaterialPageRoute(builder: (_) => MoveToExchangeScreen());

      case '/withdrawToWallet':
        return MaterialPageRoute(builder: (_) => WithdrawToWalletScreen());

      case '/market':
        return MaterialPageRoute(builder: (_) => Market());

      case '/trade':
        return MaterialPageRoute(builder: (_) => Trade('EXG/USDT'));

      case '/addGas':
        return MaterialPageRoute(builder: (_) => AddGas());

      case '/smartContract':
        return MaterialPageRoute(builder: (_) => SmartContract());

      case '/deposit':
        return MaterialPageRoute(builder: (_) => Deposit(walletInfo: args));

      case '/redeposit':
        return MaterialPageRoute(builder: (_) => Redeposit(walletInfo: args));

      case '/withdraw':
        return MaterialPageRoute(builder: (_) => Withdraw(walletInfo: args));

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
