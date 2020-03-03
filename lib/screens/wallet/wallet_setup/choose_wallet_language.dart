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

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/choose_wallet_language_screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/globals.dart' as globals;
import '../../base_screen.dart';

class ChooseWalletLanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return BaseScreen<ChooseWalletLanguageScreenState>(
      onModelReady: (model) async {
        model.context = context;
        await model.checkLanguage();
      },
      builder: (context, model, child) => Container(
        padding: orientation == Orientation.portrait
            ? EdgeInsets.all(40)
            : EdgeInsets.all(80),
        color: globals.walletCardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Logo Container
            Container(
              height: orientation == Orientation.portrait ? 50 : 20,
              margin: EdgeInsets.only(bottom: 10),
              child: Image.asset('assets/images/start-page/logo.png'),
            ),
            // Middle Graphics Container
            Container(
              width: orientation == Orientation.portrait ? 300 : 300,
              padding: EdgeInsets.all(20),
              child: Image.asset('assets/images/start-page/middle-design.png'),
            ),
            // Language Text and Icon Container
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1.0),
                    child: Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text('Please choose the language',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5),
                  )
                ],
              ),
            ),
            // Button Container
            model.state == ViewState.Busy
                ? Shimmer.fromColors(
                    baseColor: globals.primaryColor,
                    highlightColor: globals.white,
                    child: Center(
                      child: Text(
                        'Loading...',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  )
                : Container(
                    // width: 225,
                    height: 150,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          // English Lang Button
                          RaisedButton(
                            child: Text(
                              'English',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            onPressed: () {
                              model.setLangauge('en');
                              AppLocalizations.load(Locale('en', 'US'));
                              Navigator.of(context).pushNamed('/walletSetup');
                            },
                          ),
                          // Chinese Lang Button
                          RaisedButton(
                            shape: StadiumBorder(
                                side: BorderSide(
                                    color: globals.primaryColor, width: 2)),
                            color: globals.secondaryColor,
                            child: Text('中文',
                                style: Theme.of(context).textTheme.headline4),
                            onPressed: () {
                              model.setLangauge('zh');
                              AppLocalizations.load(Locale('zh', 'ZH'));
                              Navigator.of(context).pushNamed('/walletSetup');
                            },
                          )
                        ]),
                  )
          ],
        ),
      ),
    );
  }
}
