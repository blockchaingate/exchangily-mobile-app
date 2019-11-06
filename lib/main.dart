import 'package:exchangilymobileapp/screens/backup_seed.dart';
import 'package:exchangilymobileapp/screens/create_wallet.dart';
import 'package:exchangilymobileapp/screens/confirm_seed.dart';
import 'package:exchangilymobileapp/screens/choose_language.dart';
import 'package:exchangilymobileapp/screens/wallet/move_and_trade.dart';
import 'package:exchangilymobileapp/screens/wallet/receive.dart';
import 'package:exchangilymobileapp/screens/wallet/send.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/wallet/withdraw_to_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

import './shared/globals.dart' as globals;
import 'screens/total_balance.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/backupSeed': (context) => BackupSeedWalletScreen(),
        '/createWallet': (context) => CreateWalletScreen(),
        '/confirmSeed': (context) => ConfirmSeedtWalletScreen(),
        '/totalBalance': (context) => TotalBalance(),
        '/wallet': (context) => WalletScreen(),
        '/receive': (context) => ReceiveWalletScreen(),
        '/send': (context) => SendWalletScreen(),
        '/moveToExchange': (context) => MoveToExchangeScreen(),
        '/withdrawToWallet': (context) => WithdrawToWalletScreen(),
      },
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
            minWidth: double.infinity,
            buttonColor: globals.primaryColor,
            padding: EdgeInsets.all(15),
            shape: StadiumBorder(),
            textTheme: ButtonTextTheme.primary),
        fontFamily: 'Montserrat',
        canvasColor: globals.secondaryColor,
        primaryColor: globals.primaryColor,
        textTheme: TextTheme(
            button: TextStyle(
                fontSize: 20, letterSpacing: 1.15, color: globals.white),
            headline: TextStyle(fontSize: 15, color: globals.white),
            display1: TextStyle(
                fontSize: 22,
                color: globals.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.25),
            display2: TextStyle(fontSize: 14, color: globals.grey)),
      ),
      home: Scaffold(
          body: Container(
        margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
        padding: EdgeInsets.all(44),
        child: (ChooseLanguageScreen()),
      )),
    );
  }
}
