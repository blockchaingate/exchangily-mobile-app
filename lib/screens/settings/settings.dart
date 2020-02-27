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

import 'package:exchangilymobileapp/screen_state/settings/settings_screen_state.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../localizations.dart';
import '../../shared/globals.dart' as globals;
import '../base_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<SettingsScreenState>(
      onModelReady: (model) {
        model.context = context;
        model.getAppVersion();
      },
      builder: (context, model, child) => Scaffold(
        // When the keyboard appears, the Flutter widgets resize to avoid that we use resizeToAvoidBottomInset: false
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).settings,
              style: Theme.of(context).textTheme.headline3),
          backgroundColor: globals.secondaryColor,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  splashColor: globals.primaryColor,
                  child: Card(
                    elevation: 4,
                    child: Container(
                      color: globals.walletCardColor,
                      height: 100,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).deleteWallet,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    await model.deleteWallet();
                  },
                ),
                InkWell(
                  splashColor: globals.primaryColor,
                  child: Card(
                    elevation: 5,
                    child: Container(
                      color: globals.walletCardColor,
                      width: 200,
                      height: 100,
                      child: Center(
                        child: Text(
                          !model.isVisible
                              ? AppLocalizations.of(context).displayMnemonic
                              : AppLocalizations.of(context).hideMnemonic,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    model.displayMnemonic();
                  },
                ),
                Visibility(
                  visible: model.isVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      model.mnemonic,
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    color: globals.walletCardColor,
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Theme.of(context).platform == TargetPlatform.iOS
                          ? CupertinoPicker(
                              itemExtent: 1,
                              onSelectedItemChanged: (int value) {
                                // Check if it the widget works in ios device first then provide logic here
                              },
                              children: <Widget>[
                                Center(child: Text('${model.languages}'))
                              ],
                            )
                          : DropdownButton(
                              hint: Text(
                                AppLocalizations.of(context)
                                    .changeWalletLanguage,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              value: model.selectedLanguage,
                              onChanged: (newValue) {
                                model.changeWalletLanguage(newValue);
                              },
                              items: model.languages.map((language) {
                                return DropdownMenuItem(
                                  child: Center(
                                    child: Text(language,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                  ),
                                  value: language,
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ),

                // Version Code
                Card(
                  elevation: 5,
                  child: Container(
                    color: globals.primaryColor,
                    width: 200,
                    height: 50,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'v ${model.versionName}',
                          style: Theme.of(context).textTheme.headline4,
                        )
                      ],
                    )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Text(model.errorMessage,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.red)),
                  ),
                ),
              ]),
        ),
        bottomNavigationBar: AppBottomNav(count: 3),
      ),
    );
  }
}
