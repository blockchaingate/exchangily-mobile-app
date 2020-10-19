import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/settings/settings_screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SettingsPortableView extends StatelessWidget {
  const SettingsPortableView({Key key}) : super(key: key);

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
            backgroundColor: secondaryColor,
            leading: Container(),
          ),
          body: model.isBusy
              ? Center(child: model.sharedService.loadingIndicator())
              : SettingsPortableContainer(model: model),
        ),
      ),
    );
  }
}

class SettingsPortableContainer extends StatelessWidget {
  const SettingsPortableContainer({Key key, this.model}) : super(key: key);
  final SettingsScreenViewmodel model;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Card(
          elevation: 5,
          child: Container(
            color: walletCardColor,
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
                              AppLocalizations.of(context).changeWalletLanguage,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          Center(
                            child: Text(
                              "English",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          Center(
                            child: Text(
                              "简体中文",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ])
                  : DropdownButtonHideUnderline(
                      child: DropdownButton(
                          iconEnabledColor: primaryColor,
                          iconSize: 26,
                          hint: Text(
                            AppLocalizations.of(context).changeWalletLanguage,
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
          color: walletCardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(AppLocalizations.of(context).showDialogWarnings,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center),
              Checkbox(
                  activeColor: primaryColor,
                  value: model.isDialogDisplay,
                  onChanged: (value) {
                    model.setDialogWarningValue(value);
                  }),
            ],
          )),

      // Showcase ON/OFF
      Card(
          elevation: 5,
          color: walletCardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Showcase instructions for features',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center),
              Checkbox(
                  activeColor: primaryColor,
                  value: !model.isShowCaseOnce,
                  onChanged: (value) {
                    // set updated value
                    model.storageService.showCaseView = !value;

                    model.setBusy(true);
                    // get new value and assign it to the viewmodel variable
                    model.isShowCaseOnce = model.storageService.showCaseView;
                    model.setBusy(false);
                    print(model.isShowCaseOnce);
                  }),
            ],
          )),
    ]));
  }
}
