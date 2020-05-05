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

import 'package:device_preview/device_preview.dart';
import 'package:exchangilymobileapp/Managers/dialog_manager.dart';
import 'package:exchangilymobileapp/routes.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
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
      navigatorKey: locator<NavigationService>().navigatorKey,

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
        fontFamily: 'Roboto',
        canvasColor: globals.secondaryColor,
        primaryColor: globals.primaryColor,
        textTheme: TextTheme(
          button: TextStyle(fontSize: 12, color: globals.white),
          headline1: TextStyle(
              fontSize: 22,
              color: globals.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.25),
          headline2: TextStyle(
              fontSize: 20, color: globals.white, fontWeight: FontWeight.w300),
          headline3: TextStyle(fontSize: 18, color: globals.white),
          headline4: TextStyle(
              fontSize: 16, color: globals.white, fontWeight: FontWeight.w400),
          subtitle1: TextStyle(
              fontSize: 15, color: globals.white, fontWeight: FontWeight.w300),
          headline5: TextStyle(
              fontSize: 14, color: globals.white, fontWeight: FontWeight.w300),
          subtitle2: TextStyle(
              fontSize: 14, color: globals.grey, fontWeight: FontWeight.w300),
          bodyText1: TextStyle(
              fontSize: 13, color: globals.white, fontWeight: FontWeight.w300),
          bodyText2: TextStyle(fontSize: 13, color: globals.red),
          headline6: TextStyle(
              fontSize: 12, color: globals.white, fontWeight: FontWeight.w300),
        ),
      ),
      // Removed the home and scaffold because initial route has set
      initialRoute: '/',
    );
  }
}
