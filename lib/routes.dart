import 'package:exchangilymobileapp/screens/wallet_setup/backup_seed.dart';
import 'package:exchangilymobileapp/screens/wallet_features/total_balances.dart';
import 'package:exchangilymobileapp/screens/wallet_setup/confirm_seed.dart';
import 'package:exchangilymobileapp/screens/wallet_setup/create_wallet.dart';
import 'package:exchangilymobileapp/screens/wallet_setup/import_wallet.dart';
import 'package:exchangilymobileapp/screens/wallet_setup/wallet_language.dart';
import 'package:exchangilymobileapp/screens/wallet_features/move_and_trade.dart';
import 'package:exchangilymobileapp/screens/wallet_features/receive.dart';
import 'package:exchangilymobileapp/screens/wallet_features/send.dart';
import 'package:exchangilymobileapp/screens/wallet_features/wallet_features.dart';
import 'package:exchangilymobileapp/screens/wallet_features/withdraw_to_wallet.dart';
import 'package:exchangilymobileapp/screens/wallet_setup/wallet_setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screens/market/main.dart';
import 'package:exchangilymobileapp/screens/trade/main.dart';
import 'package:exchangilymobileapp/screens/wallet_features/add_gas.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print(args);
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WalletLanguageScreen());
      case '/walletSetup':
        return MaterialPageRoute(builder: (_) => WalletSetupScreen());
      case '/importWallet':
        return MaterialPageRoute(builder: (_) => ImportWalletScreen());

      case '/backupSeed':
        return MaterialPageRoute(builder: (_) => BackupSeedWalletScreen());

      case '/confirmSeed':
        return MaterialPageRoute(builder: (_) => ConfirmSeedtWalletScreen());

      case '/createWallet':
        return MaterialPageRoute(builder: (_) => CreateWalletScreen());

      case '/balance':
        return MaterialPageRoute(builder: (_) => TotalBalancesScreen());

      case '/walletOverview':
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
