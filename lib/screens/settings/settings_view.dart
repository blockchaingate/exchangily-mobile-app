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

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/screen_state/settings/settings_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/wallet/kyc_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../../service_locator.dart';
import '../../services/local_storage_service.dart';
import '../../shared/globals.dart' as globals;

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocalStorageService storageService = locator<LocalStorageService>();
    var themeService = locator<ThemeService>();
    if (storageService.isDarkMode) {
      themeService.setThemeMode(
        ThemeManagerMode.dark,
      );
    }
    return ViewModelBuilder<SettingsViewModel>.reactive(
      disposeViewModel: true,
      onViewModelReady: (model) async {
        model.context = context;
        await model.init();
      },
      viewModelBuilder: () => SettingsViewModel(),
      builder: (context, model, _) => WillPopScope(
        onWillPop: () async {
          model.onBackButtonPressed();
          return Future(() => false);
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: storageService.isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Scaffold(
            // When the keyboard appears, the Flutter widgets resize to avoid that we use resizeToAvoidBottomInset: false
            // resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: Text(FlutterI18n.translate(context, "settings"),
                  style: Theme.of(context).textTheme.displaySmall),
              backgroundColor: Theme.of(context).canvasColor,
              leading: Container(),
            ),
            body: model.isBusy
                ? Center(child: model.sharedService.loadingIndicator())
                : SettingsContainer(model: model),
            bottomNavigationBar: BottomNavBar(count: 4),
          ),
        ),
      ),
    );
  }
}

class SettingsWidget extends StatelessWidget {
  final SettingsViewModel? model;
  const SettingsWidget({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey one = GlobalKey();
    GlobalKey two = GlobalKey();
    model!.one = one;
    model!.two = two;
    debugPrint('isShow _SettingsWidgetState ${model!.isShowCaseOnce}');
    model!.showcaseEvent(context);
    return SettingsContainer(
      model: model,
    );
  }
}

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({Key? key, this.model}) : super(key: key);

  final SettingsViewModel? model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InkWell(
              splashColor: globals.primaryColor,
              child: Card(
                elevation: 4,
                child: Container(
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(20),
                  child: deleteWalletRow(context),
                ),
              ),
              onTap: () async {
                await model!.deleteWallet();
              },
            ),
            InkWell(
              splashColor: globals.primaryColor,
              child: Card(
                elevation: 5,
                child: showMnemonicContainer(context),
              ),
              onTap: () {
                model!.displayMnemonic();
              },
            ),
            Visibility(
              visible: model!.isVisible,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  model!.mnemonic!,
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
              ),
            ),

            Card(
              elevation: 5,
              color: Theme.of(context).cardColor,
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.all(5.0),
                            child: Text(
                                FlutterI18n.translate(
                                    context, "changeWalletLanguage"),
                                style: Theme.of(context).textTheme.titleSmall)),
                        model!.isBusy
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Row(
                                      children: [
                                        Text('English',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                        Checkbox(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          activeColor: globals.primaryColor,
                                          onChanged: (bool? value) {
                                            String lang = '';
                                            if (value!) {
                                              lang = 'en';
                                            } else {
                                              lang = 'zh';
                                            }

                                            model!.changeWalletLanguage(lang);
                                          },
                                          value: model!.languages[
                                                  model!.selectedLanguage] ==
                                              "English",
                                        )
                                      ],
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    Row(
                                      children: [
                                        Text('Chinese',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                        Checkbox(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          activeColor: globals.primaryColor,
                                          onChanged: (bool? value) {
                                            String lang = '';
                                            if (!value!) {
                                              lang = 'en';
                                            } else {
                                              lang = 'zh';
                                            }

                                            model!.changeWalletLanguage(lang);
                                          },
                                          value: model!.languages[
                                                  model!.selectedLanguage] ==
                                              "简体中文",
                                        )
                                      ],
                                    )
                                  ]),
                      ],
                    )
                  : Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            iconEnabledColor: globals.primaryColor,
                            iconSize: 26,
                            hint: Text(
                              FlutterI18n.translate(
                                  context, "changeWalletLanguage"),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            value: model!.selectedLanguage,
                            onChanged: (dynamic newValue) {
                              model!.changeWalletLanguage(newValue);
                            },
                            items: [
                              DropdownMenuItem(
                                value: model!.languages.keys.first,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/img/flagEn.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 15),
                                    Text("English",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: model!.languages.keys.last,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/img/flagChina.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 15),
                                    Text("简体中文",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
            ),

            // Showcase ON/OFF
            Card(
                elevation: 5,
                color: Theme.of(context).cardColor,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                        child:
                            Icon(Icons.insert_comment, color: white, size: 18),
                      ),
                      Expanded(
                        child: Text(
                            FlutterI18n.translate(
                                context, "settingsShowcaseInstructions"),
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.left),
                      ),
                      SizedBox(
                        height: 20,
                        child: Switch(
                            inactiveThumbColor: grey,
                            activeTrackColor: white,
                            activeColor: primaryColor,
                            inactiveTrackColor: white,
                            value: model!.isShowCaseOnce,
                            onChanged: (value) {
                              model!.setIsShowcase(value);
                            }),
                      ),
                      // ),
                    ],
                  ),
                )),
            // Biometric authentication toggle
            Card(
                elevation: 5,
                color: Theme.of(context).cardColor,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                        child:
                            Icon(Icons.security_sharp, color: white, size: 18),
                      ),
                      Expanded(
                        child: Text(
                            FlutterI18n.translate(
                                context, "enableBiometricAuthentication"),
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.left),
                      ),
                      SizedBox(
                        height: 20,
                        child: Switch(
                            inactiveThumbColor: grey,
                            activeTrackColor: white,
                            activeColor: primaryColor,
                            inactiveTrackColor: white,
                            value: model!
                                .storageService.hasInAppBiometricAuthEnabled,
                            onChanged: (value) {
                              model!.setBiometricAuth();
                            }),
                      ),
                      // ),
                    ],
                  ),
                )),
            // lock app now
            // only shows when user enabled the auth
            // and biometric or pin/password is activated
            model!.storageService.hasInAppBiometricAuthEnabled &&
                    model!.storageService.hasPhoneProtectionEnabled
                ? Card(
                    elevation: 5,
                    color: Theme.of(context).cardColor,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 8.0),
                            child: Icon(Icons.lock_outline_rounded,
                                color: white, size: 18),
                          ),
                          Expanded(
                            child: Text(
                                FlutterI18n.translate(context, "lockAppNow"),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                textAlign: TextAlign.left),
                          ),
                          SizedBox(
                            height: 20,
                            child: Switch(
                                inactiveThumbColor: grey,
                                activeTrackColor: white,
                                activeColor: primaryColor,
                                inactiveTrackColor: white,
                                value: model!.lockAppNow,
                                onChanged: (value) {
                                  model!.setLockAppNowValue();
                                }),
                          ),
                          // ),
                        ],
                      ),
                    ))
                : Container(),
            Card(
                elevation: 5,
                color: Theme.of(context).cardColor,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                        child: Icon(Icons.dark_mode, color: white, size: 18),
                      ),
                      Expanded(
                        child: Text(FlutterI18n.translate(context, "darkMode"),
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.left),
                      ),
                      SizedBox(
                        height: 20,
                        child: Switch(
                            inactiveThumbColor: grey,
                            value: model!.storageService.isDarkMode,
                            onChanged: (value) {
                              model!.toggleTheme();
                            }),
                      ),
                      // ),
                    ],
                  ),
                )),

            Card(
                elevation: 5,
                color: Theme.of(context).cardColor,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                        child: Icon(Icons.storage, color: white, size: 18),
                      ),
                      // Add column here and add text box that shows which node is current
                      Expanded(
                        child: Text(
                            FlutterI18n.translate(context, "useAsiaNode"),
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.left),
                      ),
                      SizedBox(
                        height: 20,
                        child: Switch(
                            inactiveThumbColor: grey,
                            value: model!.storageService.isHKServer,
                            onChanged: (value) {
                              model!.changeBaseAppUrl();
                            }),
                      ),
                      // ),
                    ],
                  ),
                )),

            KycWidget(),
            UIHelper.verticalSpaceLarge,
            Container(
              padding: const EdgeInsets.all(5),
              child: Center(
                child: Text(model!.errorMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.red)),
              ),
            ),
            // Version Code
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'v ${model!.versionName}.${model!.buildNumber}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (!isProduction)
                    const Text(' Debug', style: TextStyle(color: Colors.white))
                ],
              ),
            ),

            UIHelper.verticalSpaceLarge,
            Center(
              child: RichText(
                text: TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      model!.sharedService
                          .launchInBrowser(Uri.parse(exchangilyPrivacyUrl));
                    },
                  text: FlutterI18n.translate(context, "privacyPolicy"),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ),
          ]),
    );
  }

  Container showMnemonicContainer(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(20),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Icon(
            !model!.isVisible
                ? Icons.enhanced_encryption
                : Icons.remove_red_eye,
            color: globals.primaryColor,
            size: 18,
          ),
        ),
        Text(
          !model!.isVisible
              ? FlutterI18n.translate(context, "displayMnemonic")
              : FlutterI18n.translate(context, "hideMnemonic"),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ]),
    );
  }

  Row deleteWalletRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Icon(
            Icons.delete,
            color: globals.sellPrice,
            size: 18,
          ),
        ),
        model!.isDeleting
            ? Text('${FlutterI18n.translate(context, "deleteWallet")}...')
            : Text(
                FlutterI18n.translate(context, "deleteWallet"),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
      ],
    );
  }
}
