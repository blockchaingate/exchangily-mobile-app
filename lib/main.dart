import 'package:exchangilymobileapp/screens/choose_language.dart';
import 'package:exchangilymobileapp/services/db.dart';
import 'package:exchangilymobileapp/services/models.dart';
import 'package:exchangilymobileapp/services/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:provider/provider.dart';
import './shared/globals.dart' as globals;

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          FutureProvider<List<WalletInfo>>.value(
              value: DatabaseService().getAllBalances())
        ],
        child: MaterialApp(
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
          title: 'Exchangily Wallet',
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
        ));
  }
}
