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

import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/screen_state/settings/settings_screen_state.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:stacked/stacked.dart';
import '../../localizations.dart';
import '../../shared/globals.dart' as globals;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsScreenViewmodel>.reactive(
      onModelReady: (model) async {
        model.context = context;
        await model.init();
      },
      viewModelBuilder: () => SettingsScreenViewmodel(),
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
              : model.isShowCaseOnce == false
                  ? ShowCaseWidget(
                      onStart: (index, key) {
                        print('onStart: $index, $key');
                      },
                      onComplete: (index, key) {
                        print('onComplete: $index, $key');
                      },
                      onFinish: () async {
                        // print('FINISH, set isShowCaseOnce to true as we have shown user the showcase dialogs');
                        // await model.getStoredDataByKeys('isShowCaseOnce',
                        //     isSetData: true, value: true);
                      },
                      // autoPlay: true,
                      // autoPlayDelay: Duration(seconds: 3),
                      // autoPlayLockEnable: true,
                      builder: Builder(
                        builder: (context) =>
                            SettingsStatefulWidget(model: model),
                      ),
                    )
                  : SettingsContainer(model: model),
          bottomNavigationBar: BottomNavBar(count: 4),
        ),
      ),
    );
  }
}

class SettingsStatefulWidget extends StatefulWidget {
  final SettingsScreenViewmodel model;
  const SettingsStatefulWidget({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  _SettingsStatefulWidgetState createState() => _SettingsStatefulWidgetState();
}

class _SettingsStatefulWidgetState extends State<SettingsStatefulWidget> {
  BuildContext myContext;
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  @override
  void initState() {
    super.initState();
    widget.model.one = _one;
    widget.model.two = _two;
    print('isShow _SettingsWidgetState ${widget.model.isShowCaseOnce}');
    widget.model.showcaseEvent(context);
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance
    //   .addPostFrameCallback((_) => widget.model.showcaseEvent(context));
    return SettingsContainer(
      model: widget.model,
    );
  }
}

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({Key key, this.model}) : super(key: key);

  final SettingsScreenViewmodel model;

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
                  alignment: Alignment.center,
                  color: globals.walletCardColor,
                  padding: EdgeInsets.all(20),
                  // height: 100,
                  child: !model.isShowCaseOnce
                      ? Showcase(
                          key: model.one,
                          description: '1) Click here to see menu options',
                          child: deleteWalletRow(context),
                        )
                      : deleteWalletRow(context),
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
                child: !model.isShowCaseOnce
                    ? Showcase(
                        key: model.two,
                        title: 'Show/Hide mnemonic',
                        description: 'Enter password to see mnemonic',
                        child: showMnemonicContainer(context),
                      )
                    : showMnemonicContainer(context),
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
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .changeWalletLanguage,
                                    style:
                                        Theme.of(context).textTheme.headline5,
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
                                    value: model.languages[0],
                                  ),
                                  DropdownMenuItem(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    value: model.languages[1],
                                  ),
                                ]),
                          ),
                  ),
                )),
            // Show/Hide dialog warning checkbox
            Card(
                elevation: 5,
                color: globals.walletCardColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).showDialogWarnings,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center),
                    Checkbox(
                        activeColor: globals.primaryColor,
                        value: model.isDialogDisplay,
                        onChanged: (value) {
                          model.setDialogWarningValue(value);
                        }),
                  ],
                )),

            // Showcase ON/OFF
            Card(
                elevation: 5,
                color: globals.walletCardColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Showcase instructions for features',
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center),
                    Checkbox(
                        activeColor: globals.primaryColor,
                        value: !model.isShowCaseOnce,
                        onChanged: (value) {
                          // set updated value
                          model.storageService.showCaseView = !value;

                          model.setBusy(true);
                          // get new value and assign it to the viewmodel variable
                          model.isShowCaseOnce =
                              model.storageService.showCaseView;
                          model.setBusy(false);
                          print(model.isShowCaseOnce);
                        }),
                  ],
                )),

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
            ? Text('Deleting wallet...')
            : Text(
                AppLocalizations.of(context).deleteWallet,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
      ],
    );
  }
}

// OLD language switch, KEEP IT
// InkWell(
//   child: Card(
//     elevation: 4,
//     child: Container(
//       alignment: Alignment.center,
//       color: globals.walletCardColor,
//       padding: EdgeInsets.all(20),
//       // height: 100,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 3.0),
//             child: Icon(
//               Icons.language,
//               color: Colors.deepOrange,
//               size: 18,
//             ),
//           ),
//           Text(
//             AppLocalizations.of(context).changeWalletLanguage,
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.headline5,
//           ),
//         ],
//       ),
//     ),
//   ),
//   onTap: () {
//     Navigator.pushNamed(context, '/switchLanguage');
//   },
// ),
