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
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/wallet_setup_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import '../../../shared/globals.dart' as globals;

class WalletSetupView extends StatelessWidget {
  const WalletSetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletSetupViewmodel>.reactive(
      viewModelBuilder: () => WalletSetupViewmodel(),
      onViewModelReady: (WalletSetupViewmodel model) async {
        model.context = context;

        model.init();
      },
      builder: (context, WalletSetupViewmodel model, child) => WillPopScope(
        onWillPop: () {
          model.sharedService!.closeApp();
          return Future(() => false);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          color: Theme.of(context).cardColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Logo Container
              UIHelper.verticalSpaceLarge,
              // UIHelper.verticalSpaceLarge,
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Image.asset('assets/images/start-page/logo.png'),
                  ),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        FlutterI18n.translate(context, "welcomeText"),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.normal),
                      )),
                ],
              ),
              //  UIHelper.verticalSpaceLarge,
              // Middle Graphics Container
              Container(
                padding: const EdgeInsets.all(25),
                child:
                    Image.asset('assets/images/start-page/middle-design.png'),
              ),

              model.isDeleting
                  ? Text(
                      FlutterI18n.translate(context, "deletingWallet"),
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  : Container(),
              !model.isBusy && model.errorMessage.isNotEmpty
                  ? Text(
                      model.errorMessage,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  : Container(),
              model.isHideIcon
                  ? Container()
                  : model.isWalletVerifySuccess
                      ? Icon(Icons.check_box_outlined, color: green, size: 32)
                      : const Icon(Icons.cancel_outlined, color: red, size: 32),
              // Button Container
              model.isBusy
                  ? Shimmer.fromColors(
                      baseColor: globals.primaryColor,
                      highlightColor: globals.white,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              '${FlutterI18n.translate(context, "checkingExistingWallet")}...',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            model.isVerifying
                                ? Text(
                                    FlutterI18n.translate(
                                        context, "verifyingWallet"),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    )
                  : model.isWallet
                      ? Shimmer.fromColors(
                          baseColor: globals.primaryColor,
                          highlightColor: globals.white,
                          child: Center(
                            child: Text(
                              '${FlutterI18n.translate(context, "restoringWallet")}...',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            !model.hasAuthenticated &&
                                    !model.isBusy &&
                                    model.storageService!
                                        .hasInAppBiometricAuthEnabled &&
                                    model.storageService!
                                        .hasPhoneProtectionEnabled &&
                                    model.hasData
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          const StadiumBorder(
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
                                        const Padding(
                                          padding: EdgeInsets.only(right: 4),
                                          child: Icon(
                                            Icons.lock_open_outlined,
                                            color: white,
                                            size: 18,
                                          ),
                                        ),
                                        Text(
                                            FlutterI18n.translate(
                                                context, "unlock"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium),
                                      ],
                                    ),
                                    onPressed: () {
                                      model.checkExistingWallet();
                                    },
                                  )
                                : Container(),
                            !model.storageService!.hasInAppBiometricAuthEnabled ||
                                    !model.storageService!
                                        .hasPhoneProtectionEnabled ||
                                    !model.hasData
                                ? model.storageService!.hasPrivacyConsent
                                    ? Row(children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
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
                                                  const StadiumBorder(
                                                      side: BorderSide(
                                                          color: primaryColor,
                                                          width: 2)),
                                                ),
                                              ),
                                              child: Text(
                                                  FlutterI18n.translate(
                                                      context, "createWallet"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall!
                                                      .copyWith(
                                                          color: primaryColor)),
                                              onPressed: () {
                                                if (!model.isBusy) {
                                                  model.importCreateNav(
                                                      'create');
                                                }
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
                                                  const StadiumBorder(
                                                      side: BorderSide(
                                                          color: primaryColor,
                                                          width: 2)),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        primaryColor)),
                                            child: Text(
                                              FlutterI18n.translate(
                                                  context, "importWallet"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(color: white),
                                            ),
                                            onPressed: () {
                                              if (!model.isBusy) {
                                                model.importCreateNav('import');
                                              }
                                            },
                                          ),
                                        ),
                                        // TextButton(
                                        //   child: Text('click'),
                                        //   onPressed: () => model
                                        //       .coreWalletDatabaseService
                                        //       .insert(CoreWalletModel()),
                                        // )
                                      ])
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${FlutterI18n.translate(context, "askPrivacyConsent")}. ${FlutterI18n.translate(context, "userDataUsage")}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                            textAlign: TextAlign.center,
                                          ),
                                          UIHelper.verticalSpaceSmall,
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          5),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    const StadiumBorder(
                                                        side: BorderSide(
                                                            color: primaryColor,
                                                            width: 2)),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          primaryColor)),
                                              child: Text(
                                                FlutterI18n.translate(
                                                    context, "privacyPolicy"),
                                                style: headText5.copyWith(
                                                    color: white),
                                              ),
                                              onPressed: () => model
                                                  .showPrivacyConsentWidget()),
                                        ],
                                      )
                                : Container(),
                          ],
                        ),
              //  UIHelper.verticalSpaceLarge,
              // TextButton(
              //   child: Text('Click'),
              //   onPressed: () {
              //     model.test();
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
