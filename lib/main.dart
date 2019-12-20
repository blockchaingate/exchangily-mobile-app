import 'package:device_preview/device_preview.dart';
import 'package:exchangilymobileapp/provider_setup.dart';
import 'package:exchangilymobileapp/routes.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import './shared/globals.dart' as globals;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localizations.dart';
import 'models/wallet.dart';
// import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  serviceLocator();
  Logger.level = Level.info;
  // Force user to use only portrait mode until the development of other screen size design
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
        //   DevicePreview(builder: (context) =>
        MyApp()
        // )
        );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // FutureProvider<List<WalletInfo>>.value(
          //  value: WalletService().getAllBalances()),
          FutureProvider<String>.value(
              value: WalletService().getRandomMnemonic())
        ],
        child: MaterialApp(
          // locale: DevicePreview.of(context).locale,
          //  builder: DevicePreview.appBuilder,
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          // locale: Langua,
          supportedLocales: [
            const Locale("en", "US"), // English
            const Locale("hi", ""), // Hindi India
            const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hans'), // Chinese Simplified
            const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hant'), // Chinese Traditional
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context).title,

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
                display2: TextStyle(fontSize: 14, color: globals.grey),
                display3: TextStyle(fontSize: 18, color: globals.white)),
          ),
          // Removed the home and scaffold because initial route has set
          initialRoute: '/',
        ));
  }
}
