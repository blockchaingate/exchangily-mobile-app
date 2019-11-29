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
import 'package:exchangilymobileapp/screens/market/main.dart';
import 'package:exchangilymobileapp/screens/trade/main.dart';
import 'package:exchangilymobileapp/screens/wallet/add_gas.dart';
import 'package:exchangilymobileapp/screens/wallet/deposit.dart';
import 'package:exchangilymobileapp/screens/wallet/withdraw.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print(args);
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => StartScreen());
      case '/importWallet':
        return MaterialPageRoute(builder: (_) => ImportWalletScreen());

      case '/backupSeed':
        return MaterialPageRoute(builder: (_) => BackupSeedWalletScreen());

      case '/confirmSeed':
        return MaterialPageRoute(builder: (_) => ConfirmSeedtWalletScreen());

      case '/createWallet':
        return MaterialPageRoute(builder: (_) => CreateWalletScreen());

      case '/balance':
        return MaterialPageRoute(builder: (_) => BalanceScreen());

      case '/walletOverview':
        return MaterialPageRoute(
            builder: (_) => WalletOverviewScreen(walletInfo: args));

      case '/receive':
        return MaterialPageRoute(
            builder: (_) => ReceiveWalletScreen(
                  address: args,
                ));

      case '/send':
        return MaterialPageRoute(builder: (_) => SendWalletScreen());

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

      case '/deposit':
        return MaterialPageRoute(builder: (_) => Deposit(
            walletInfo: args
        ));

      case '/withdraw':
        return MaterialPageRoute(builder: (_) => Withdraw(
            walletInfo: args
        ));

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
