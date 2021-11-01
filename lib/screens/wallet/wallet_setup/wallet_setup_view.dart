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

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/wallet_setup_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import '../../../shared/globals.dart' as globals;

class WalletSetupView extends StatelessWidget {
  const WalletSetupView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletSetupViewmodel>.reactive(
      viewModelBuilder: () => WalletSetupViewmodel(),
      onModelReady: (model) async {
        model.init();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          model.sharedService.closeApp();
          return new Future(() => false);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          color: walletCardColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Logo Container
              // UIHelper.verticalSpaceLarge,
              // UIHelper.verticalSpaceLarge,
              Column(
                children: [
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
                ],
              ),
              //  UIHelper.verticalSpaceLarge,
              // Middle Graphics Container
              Container(
                padding: EdgeInsets.all(25),
                child:
                    Image.asset('assets/images/start-page/middle-design.png'),
              ),
              // UIHelper.verticalSpaceLarge,

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
                          child: Column(
                            children: [
                              !model.hasAuthenticated &&
                                      !model.isBusy &&
                                      model.storageService
                                          .hasInAppBiometricAuthEnabled &&
                                      model.storageService
                                          .hasPhoneProtectionEnabled
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            StadiumBorder(
                                                side: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 2)),
                                          ),
                                          elevation:
                                              MaterialStateProperty.all(5)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: Icon(
                                              Icons.lock_open_outlined,
                                              color: white,
                                              size: 18,
                                            ),
                                          ),
                                          Text(
                                              AppLocalizations.of(context)
                                                  .unlock,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4),
                                        ],
                                      ),
                                      onPressed: () {
                                        model.checkExistingWallet();
                                      },
                                    )
                                  : Container(),
                              !model.storageService
                                          .hasInAppBiometricAuthEnabled ||
                                      !model.storageService
                                          .hasPhoneProtectionEnabled
                                  ? Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 5),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        5),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        white),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  StadiumBorder(
                                                      side: BorderSide(
                                                          color: globals
                                                              .primaryColor,
                                                          width: 2)),
                                                ),
                                              ),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .createWallet,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4
                                                      .copyWith(
                                                          color: globals
                                                              .primaryColor)),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    BackupMnemonicViewRoute);
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        5),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  StadiumBorder(
                                                      side: BorderSide(
                                                          color: globals
                                                              .primaryColor,
                                                          width: 2)),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        primaryColor)),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .importWallet,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  ImportWalletViewRoute,
                                                  arguments: 'import');
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
              //  UIHelper.verticalSpaceLarge,
            ],
          ),
        ),
      ),
    );
  }
}
