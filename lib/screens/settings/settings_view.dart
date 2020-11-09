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
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/screen_state/settings/settings_viewmodel.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:stacked/stacked.dart';
import '../../localizations.dart';
import '../../shared/globals.dart' as globals;

class SettingsView extends StatelessWidget {
  const SettingsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewmodel>.reactive(
      onModelReady: (model) async {
        model.context = context;
        await model.init();
      },
      viewModelBuilder: () => SettingsViewmodel(),
      builder: (context, model, _) => WillPopScope(
        onWillPop: () async {
          model.onBackButtonPressed();
          return new Future(() => false);
        },
        child: Scaffold(
          // When the keyboard appears, the Flutter widgets resize to avoid that we use resizeToAvoidBottomInset: false
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text(AppLocalizations.of(context).settings,
                style: Theme.of(context).textTheme.headline3),
            backgroundColor: globals.secondaryColor,
            leading: Container(),
          ),
          body: model.isBusy
              ? Center(child: model.sharedService.loadingIndicator())
              // : model.isShowCaseOnce == false
              //     ? ShowCaseWidget(
              //         onStart: (index, key) {
              //           print('onStart: $index, $key');
              //         },
              //         onComplete: (index, key) {
              //           print('onComplete: $index, $key');
              //         },
              //         onFinish: () async {
              //           // print('FINISH, set isShowCaseOnce to true as we have shown user the showcase dialogs');
              //           // await model.getStoredDataByKeys('isShowCaseOnce',
              //           //     isSetData: true, value: true);
              //         },
              //         // autoPlay: true,
              //         // autoPlayDelay: Duration(seconds: 3),
              //         // autoPlayLockEnable: true,
              //         builder: Builder(
              //           builder: (context) => SettingsWidget(model: model),
              //         ),
              //       )
              : SettingsContainer(model: model),
          bottomNavigationBar: BottomNavBar(count: 4),
        ),
      ),
    );
  }
}

class SettingsWidget extends StatelessWidget {
  final SettingsViewmodel model;
  SettingsWidget({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey _one = GlobalKey();
    GlobalKey _two = GlobalKey();
    model.one = _one;
    model.two = _two;
    print('isShow _SettingsWidgetState ${model.isShowCaseOnce}');
    model.showcaseEvent(context);
    // WidgetsBinding.instance
    //   .addPostFrameCallback((_) => widget.model.showcaseEvent(context));
    return SettingsContainer(
      model: model,
    );
  }
}

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({Key key, this.model}) : super(key: key);

  final SettingsViewmodel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InkWell(
              splashColor: globals.primaryColor,
              child: Card(
                elevation: 4,
                child: Container(
                  alignment: Alignment.centerLeft,
                  color: globals.walletCardColor,
                  padding: EdgeInsets.all(20),
                  // height: 100,
                  child:
                      // !model.isShowCaseOnce
                      //     ? Showcase(
                      //         key: model.one,
                      //         description: 'Delete wallet from this device',
                      //         child: deleteWalletRow(context),
                      //       )
                      //     :
                      deleteWalletRow(context),
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
                child:
                    //  !model.isShowCaseOnce
                    //     ? Showcase(
                    //         key: model.two,
                    //         title: 'Show/Hide mnemonic',
                    //         description: 'Enter password to see mnemonic',
                    //         child: showMnemonicContainer(context),
                    //       )
                    //     :
                    showMnemonicContainer(context),
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
                  child: Center(
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoPicker(
                            diameterRatio: 1.3,
                            offAxisFraction: 5,
                            scrollController: model.scrollController,
                            itemExtent: 50,
                            onSelectedItemChanged: (int value) {
                              String lang = '';
                              if (value == 1) {
                                lang = 'en';
                              } else if (value == 2) {
                                lang = 'zh';
                              }
                              model.changeWalletLanguage(lang);
                            },
                            children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3.0),
                                        child: Icon(
                                          Icons.language,
                                          color: grey,
                                          size: 18,
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .changeWalletLanguage,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Icon(
                                                Icons.keyboard_arrow_up,
                                                color: primaryColor,
                                                size: 12,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: primaryColor,
                                                size: 12,
                                              ),
                                            ),
                                          ])
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "English",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "简体中文",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ])
                        : DropdownButtonHideUnderline(
                            child: DropdownButton(
                                iconEnabledColor: globals.primaryColor,
                                iconSize: 26,
                                hint: Text(
                                  AppLocalizations.of(context)
                                      .changeWalletLanguage,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                value: model.selectedLanguage,
                                onChanged: (newValue) {
                                  model.changeWalletLanguage(newValue);
                                },
                                items: [
                                  DropdownMenuItem(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/img/flagEn.png",
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(width: 15),
                                        Text("English",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ],
                                    ),
                                    value: model.languages['en'],
                                  ),
                                  DropdownMenuItem(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/img/flagChina.png",
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(width: 15),
                                        Text("简体中文",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ],
                                    ),
                                    value: model.languages['zh'],
                                  ),
                                ]),
                          ),
                  ),
                )),
            // Show/Hide dialog warning checkbox
            Card(
              elevation: 5,
              color: globals.walletCardColor,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(Icons.warning, color: yellow, size: 16),
                    ),
                    Expanded(
                      child: Text(
                          AppLocalizations.of(context).showDialogWarnings,
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.left),
                    ),
                    SizedBox(
                      height: 20,
                      child: Switch(
                          inactiveThumbColor: grey,
                          activeTrackColor: white,
                          activeColor: primaryColor,
                          inactiveTrackColor: white,
                          value: model.isDialogDisplay,
                          onChanged: (value) {
                            model.setIsDialogWarningValue(value);
                          }),
                    ),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.only(right: 5.0),
              //       child: Icon(
              //         Icons.warning,
              //         color: yellow,
              //         size: 18,
              //       ),
              //     ),
              //     Text(AppLocalizations.of(context).showDialogWarnings,
              //         style: Theme.of(context).textTheme.headline5,
              //         textAlign: TextAlign.center),
              //     Checkbox(
              //         activeColor: globals.primaryColor,
              //         value: model.isDialogDisplay,
              //         onChanged: (value) {
              //           model.setDialogWarningValue(value);
              //         }),
              //   ],
              // )
            ),

            // Showcase ON/OFF
            Card(
                elevation: 5,
                color: globals.walletCardColor,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child:
                            Icon(Icons.insert_comment, color: white, size: 18),
                      ),
                      Expanded(
                        child: Text(
                            AppLocalizations.of(context)
                                .settingsShowcaseInstructions,
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.left),
                      ),
                      SizedBox(
                        height: 20,
                        child: Switch(
                            inactiveThumbColor: grey,
                            activeTrackColor: white,
                            activeColor: primaryColor,
                            inactiveTrackColor: white,
                            value: model.isShowCaseOnce,
                            onChanged: (value) {
                              model.setIsShowcase(value);
                              // model.storageService.isShowCaseView = !value;

                              // model.setBusy(true);
                              // // get new value and assign it to the viewmodel variable
                              // model.isShowCaseOnce =
                              //     model.storageService.isShowCaseView;
                              // model.setBusy(false);
                              // print(model.isShowCaseOnce);
                            }),
                      ),
                      // ),
                    ],
                  ),
                )

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     // Padding(
                //     //   padding: const EdgeInsets.only(left: 5.0),
                //     //   child: Icon(
                //     //     Icons.insert_comment,
                //     //     color: white,
                //     //     size: 18,
                //     //   ),
                //     // ),
                //     Expanded(
                //       child: Text(
                //           AppLocalizations.of(context)
                //               .settingsShowcaseInstructions,
                //           style: Theme.of(context).textTheme.headline5,
                //           textAlign: TextAlign.center),
                //     ),
                //     Checkbox(
                //         activeColor: globals.primaryColor,
                //         value: model.isShowCaseOnce,
                //         onChanged: (value) {
                //           model.setIsShowcase(value);
                //         }),
                //   ],
                // ),
                ),
// Server url change
            Card(
              child: FlatButton(
                  onPressed: () => model.reloadApp(),
                  child: Text('Reload app')),
            ),
            // Version Code
            Card(
              elevation: 5,
              child: Container(
                color: globals.primaryColor,
                width: 200,
                height: 40,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'v ${model.versionName}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    if (!isProduction)
                      Text(' Debug', style: TextStyle(color: Colors.white))
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
    );
  }

  Container showMnemonicContainer(BuildContext context) {
    return Container(
      color: globals.walletCardColor,
      padding: EdgeInsets.all(20),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Icon(
            !model.isVisible ? Icons.enhanced_encryption : Icons.remove_red_eye,
            color: globals.primaryColor,
            size: 18,
          ),
        ),
        Text(
          !model.isVisible
              ? AppLocalizations.of(context).displayMnemonic
              : AppLocalizations.of(context).hideMnemonic,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
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
        model.isDeleting
            ? Text(AppLocalizations.of(context).deleteWallet + '...')
            : Text(
                AppLocalizations.of(context).deleteWallet,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
      ],
    );
  }
}
