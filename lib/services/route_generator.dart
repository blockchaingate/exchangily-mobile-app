import 'package:exchangilymobileapp/screens/backup_seed.dart';
import 'package:exchangilymobileapp/screens/balance.dart';
import 'package:exchangilymobileapp/screens/confirm_seed.dart';
import 'package:exchangilymobileapp/screens/create_wallet.dart';
import 'package:exchangilymobileapp/screens/import_wallet.dart';
import 'package:exchangilymobileapp/screens/start.dart';
import 'package:exchangilymobileapp/screens/wallet/move_and_trade.dart';
import 'package:exchangilymobileapp/screens/wallet/receive.dart';
import 'package:exchangilymobileapp/screens/wallet/send.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_overview.dart';
import 'package:exchangilymobileapp/screens/wallet/withdraw_to_wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => StartScreen());
      case '/importWallet':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => ImportWalletScreen());
        }
        return _errorRoute();
      case '/backupSeed':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => BackupSeedWalletScreen());
        }
        return _errorRoute();
      case '/confirmSeed':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => ConfirmSeedtWalletScreen());
        }
        return _errorRoute();
      case '/createWallet':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => CreateWalletScreen());
        }
        return _errorRoute();
      case '/balance':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => BalanceScreen());
        }
        return _errorRoute();
      case '/walletOverview':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => WalletOverviewScreen());
        }
        return _errorRoute();
      case '/receive':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => ReceiveWalletScreen());
        }
        return _errorRoute();
      case '/send':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => SendWalletScreen());
        }
        return _errorRoute();
      case '/moveToExchange':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => MoveToExchangeScreen());
        }
        return _errorRoute();
      case '/withdrawToWallet':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => WithdrawToWalletScreen());
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
