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
import 'package:exchangilymobileapp/Managers/life_cycle_manager.dart';
import 'package:exchangilymobileapp/routes.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/connectivity_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import './shared/globals.dart' as globals;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  try {
    await serviceLocator();
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
  } catch (err) {
    print('main.dart (Catch) Locator setup has failed $err');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      create: (BuildContext context) =>
          ConnectivityService().connectionStatusController.stream,
      child: LifeCycleManager(
        child: OverlaySupport(
          child: Phoenix(
            child: MaterialApp(
              // locale: DevicePreview.of(context).locale,
              navigatorKey: locator<NavigationService>().navigatorKey,
              //or locator<DialogService>().navigatorKey,

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
                disabledColor: globals.grey.withAlpha(100),
                primaryColor: globals.primaryColor,
                accentColor: globals.secondaryColor,
                backgroundColor: globals.secondaryColor,
                cardColor: globals.walletCardColor,
                canvasColor: globals.secondaryColor,
                buttonTheme: ButtonThemeData(
                    minWidth: double.infinity,
                    buttonColor: globals.primaryColor,
                    padding: EdgeInsets.all(15),
                    shape: StadiumBorder(),
                    textTheme: ButtonTextTheme.primary),
                fontFamily: 'Roboto',
                textTheme: TextTheme(
                    button: TextStyle(fontSize: 14, color: globals.white),
                    headline1: TextStyle(
                        fontSize: 22,
                        color: globals.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.25),
                    headline2: TextStyle(
                        fontSize: 18,
                        color: globals.white,
                        fontWeight: FontWeight.w300),
                    headline3: TextStyle(fontSize: 16, color: globals.white),
                    headline4: TextStyle(
                        fontSize: 15,
                        color: globals.white,
                        fontWeight: FontWeight.w300),
                    subtitle1: TextStyle(
                        fontSize: 14,
                        color: globals.white,
                        fontWeight: FontWeight.w300),
                    headline5: TextStyle(
                        fontSize: 12.5,
                        color: globals.white,
                        fontWeight: FontWeight.w300),
                    subtitle2: TextStyle(
                        fontSize: 10.3,
                        color: globals.grey,
                        fontWeight: FontWeight.w300),
                    bodyText1: TextStyle(
                        fontSize: 13,
                        color: globals.white,
                        fontWeight: FontWeight.w300),
                    bodyText2: TextStyle(fontSize: 13, color: globals.red),
                    headline6: TextStyle(
                        fontSize: 10.5,
                        color: globals.white,
                        fontWeight: FontWeight.w500)),
              ),
              // Removed the home and scaffold because initial route has set
              initialRoute: '/',
            ),
          ),
        ),
      ),
    );
  }
}
