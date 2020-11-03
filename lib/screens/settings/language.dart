import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/screen_state/settings/language_screen_state.dart';
import 'package:exchangilymobileapp/screen_state/settings/settings_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../localizations.dart';
import '../../shared/globals.dart' as globals;
import '../base_screen.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<LanguageScreenState>(
      onModelReady: (model) {
        model.context = context;
        model.init();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          // model.onBackButtonPressed();
          return new Future(() => false);
        },
        child: Scaffold(
          // When the keyboard appears, the Flutter widgets resize to avoid that we use resizeToAvoidBottomInset: false
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text(AppLocalizations.of(context).changeWalletLanguage,
                style: Theme.of(context).textTheme.headline3),
            backgroundColor: globals.secondaryColor,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  // model.pauseAllStreams();
                  // _scaffoldKey.currentState.openDrawer();
                  // model.navigationService.goBack();
                  model.navigationService.goBack();
                },
              ),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InkWell(
                    splashColor: globals.primaryColor,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        //padding: EdgeInsets.all(15),
                        color: globals.walletCardColor,
                        child: Center(
                          child: Theme.of(context).platform ==
                                  TargetPlatform.iOS
                              ? CupertinoPicker(
                                  diameterRatio: 1.3,
                                  offAxisFraction: 5,
                                  scrollController: model.scrollController,
                                  itemExtent: 50,
                                  onSelectedItemChanged: (int value) {
                                    String lang = '';
                                    if (value == 0) {
                                      lang = 'en';
                                    } else if (value == 1) {
                                      lang = 'zh';
                                    }
                                    model.changeWalletLanguage(lang);
                                  },
                                  children: List<Widget>.generate(
                                      model.languages.length, (int index) {
                                    return Center(
                                      child: Text(
                                        model.languages[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    );
                                  }))
                              : DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    iconEnabledColor: globals.primaryColor,
                                    iconSize: 26,
                                    hint: Text(
                                      AppLocalizations.of(context)
                                          .changeWalletLanguage,
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline5,
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
                                                  .headline6),
                                        ),
                                        value: language,
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  )
                ]),
          ),
          // bottomNavigationBar: BottomNavBar(count: 3),
        ),
      ),
    );
  }
}
