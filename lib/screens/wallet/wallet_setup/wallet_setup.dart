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
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/wallet_setup_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import '../../../shared/globals.dart' as globals;

class WalletSetupScreen extends StatelessWidget {
  const WalletSetupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletSetupViewmodel>.reactive(
      viewModelBuilder: () => WalletSetupViewmodel(),
      onModelReady: (model) async {
        await model.walletService.checkLanguage();
        model.context = context;
        model.sharedService.context = context;
        model.dataBaseService.initDb();
        await model.checkExistingWallet();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          model.sharedService.closeApp();
          return new Future(() => false);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          color: globals.walletCardColor,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Logo Container
                UIHelper.verticalSpaceLarge,
                UIHelper.verticalSpaceLarge,
                Container(
                  height: 50,
                  child: Image.asset('assets/images/start-page/logo.png'),
                ),
                Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context).welcomeText,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.normal),
                    )),
                UIHelper.verticalSpaceLarge,
                // Middle Graphics Container
                Container(
                  padding: EdgeInsets.all(25),
                  child:
                      Image.asset('assets/images/start-page/middle-design.png'),
                ),
                UIHelper.verticalSpaceLarge,

                // Button Container
                model.isBusy
                    ? Shimmer.fromColors(
                        baseColor: globals.primaryColor,
                        highlightColor: globals.white,
                        child: Center(
                          child: Text(
                            '${AppLocalizations.of(context).checkingExistingWallet}...',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      )
                    : model.isWallet
                        ? Shimmer.fromColors(
                            baseColor: globals.primaryColor,
                            highlightColor: globals.white,
                            child: Center(
                              child: Text(
                                '${AppLocalizations.of(context).restoringWallet}...',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          )
                        : Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: RaisedButton(
                                      elevation: 5,
                                      focusElevation: 5,
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .createWallet,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed('/backupMnemonic');
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: RaisedButton(
                                    elevation: 5,
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                            color: globals.primaryColor,
                                            width: 2)),
                                    color: globals.secondaryColor,
                                    child: Text(
                                      AppLocalizations.of(context).importWallet,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          '/importWallet',
                                          arguments: 'import');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                UIHelper.verticalSpaceLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
