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

import 'dart:io';

import 'package:exchangilymobileapp/Managers/dialog_manager.dart';
import 'package:exchangilymobileapp/Managers/life_cycle_manager.dart';
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/enums/connectivity_status.dart';
import 'package:exchangilymobileapp/routes.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/connectivity_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'environments/environment_type.dart';

Future<void> main() async {
  final String defaultLocale = Platform.localeName;
  final String shortLocale = defaultLocale.substring(0, 2);
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar transparent
    ),
  );

  await serviceLocator();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  //init i18n setting
  FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'en',
        basePath: 'assets/i18n',
        forcedLocale: [
          'en',
          'zh',
        ].contains(defaultLocale)
            ? Locale(shortLocale)
            : const Locale("en")),
  );
  await ThemeManager.initialise();
  runApp(MyApp(flutterI18nDelegate, packageInfo));

  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Logger.level = Level.info;
    SystemChannels.textInput
        .invokeMethod('TextInput.hide'); // Hides keyboard initially
    // Force user to use only portrait mode until the development of other screen size design
    await dotenv
        .load(fileName: isProduction ? 'envs/.env' : 'envs/local.env')
        .catchError((err) {
      log.e('dot env can not find local.env, loading default');
      dotenv.load();
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
      (_) {
        runApp(
            //  DevicePreview(builder: (context) =>
            MyApp(flutterI18nDelegate, packageInfo));
        // ));
      },
    );
  } catch (err) {
    debugPrint('main.dart (Catch) Locator setup has failed $err');
  }
}

class MyApp extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;
  final PackageInfo packageInfo;
  const MyApp(this.flutterI18nDelegate, this.packageInfo);

  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      create: (BuildContext context) =>
          ConnectivityService().connectionStatusController.stream,
      initialData: ConnectivityStatus.Cellular,
      child: LifeCycleManager(
        child: ThemeBuilder(
            defaultThemeMode: ThemeMode.light,
            darkTheme: CustomStyles.kThemeData(isDark: true),
            lightTheme: CustomStyles.kThemeData(isDark: false),
            statusBarColorBuilder: (p0) {
              return Colors.transparent;
            },
            builder: (context, regularTheme, darkTheme, themeMode) {
              return OverlaySupport(
                child: MaterialApp(
                  theme: regularTheme,
                  darkTheme: darkTheme,
                  themeMode: themeMode,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: locator<NavigationService>().navigatorKey,
                  builder: (context, widget) => Stack(
                    children: [
                      Navigator(
                          key: locator<DialogService>().navigatorKey,
                          onGenerateRoute: (settings) => MaterialPageRoute(
                              builder: (context) => DialogManager(
                                    child: widget,
                                  ))),
                      Positioned(
                          bottom: 120,
                          right: 0,
                          child: Material(
                            color: Colors.transparent,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Text(
                                // 'v ',
                                'v ${packageInfo.version}.${packageInfo.buildNumber}',
                                style: const TextStyle(
                                    fontSize: 10, color: Color(0x44ffffff)),
                              ),
                            ),
                          ))
                    ],
                  ),
                  localizationsDelegates: [
                    flutterI18nDelegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate
                  ],

                  supportedLocales: const [
                    Locale("en", ""), // English
                    Locale("zh", ""), // Chinese
                    // Locale("hi", ""), // Hindi India
                  ],
                  onGenerateTitle: (BuildContext context) =>
                      FlutterI18n.translate(context, "title"),

                  onGenerateRoute: RouteGenerator.generateRoute,
                  title: 'Exchangily Wallet',

                  // Removed the home and scaffold because initial route has set
                  initialRoute: '/',
                ),
              );
            }),
      ),
    );
  }
}
