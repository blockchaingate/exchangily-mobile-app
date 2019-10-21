import 'package:exchangilymobileapp/screens/create_wallet.dart';
import 'package:exchangilymobileapp/screens/import_wallet.dart';
import 'package:exchangilymobileapp/screens/start.dart';
import 'package:flutter/material.dart';

import './shared/globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/createWallet': (context) => CreateWalletScreen(),
        '/importWallet': (context) => ImportWalletScreen()
      },
      theme: ThemeData(
          buttonTheme: ButtonThemeData(
              minWidth: double.infinity,
              buttonColor: globals.primary,
              padding: EdgeInsets.all(15),
              shape: StadiumBorder(),
              textTheme: ButtonTextTheme.primary),
          fontFamily: 'Montserrat',
          canvasColor: globals.secondary,
          primaryColor: globals.primary,
          textTheme: TextTheme(
            button: TextStyle(
                fontSize: 20, letterSpacing: 1.15, color: globals.white),
            headline: TextStyle(fontSize: 15, color: globals.white),
          )),
      home: Scaffold(
          body: Container(
        margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
        padding: EdgeInsets.all(44),
        child: (StartScreen()),
      )),
    );
  }
}
