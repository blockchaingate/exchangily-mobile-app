import 'package:device_preview/device_preview.dart';
import 'package:exchangilymobileapp/Managers/dialog_manager.dart';
import 'package:exchangilymobileapp/routes.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import './shared/globals.dart' as globals;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  serviceLocator();
  Logger.level = Level.info;
  SystemChannels.textInput
      .invokeMethod('TextInput.hide'); // Hides keyboard initially
  // Force user to use only portrait mode until the development of other screen size design

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
          //  DevicePreview(builder: (context) =>
          MyApp());
      // ));
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: DevicePreview.of(context).locale,
      builder: (context, widget) => Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => DialogManager(
                    child: widget,
                  ))),

      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      // locale: Langua,
      supportedLocales: [
        const Locale("en", ""), // English
        const Locale("zh", ""), // Chinese
        const Locale("hi", ""), // Hindi India
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
    );
  }
}
