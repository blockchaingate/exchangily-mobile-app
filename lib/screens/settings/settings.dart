import 'package:exchangilymobileapp/screen_state/settings_screen_state.dart';
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
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).settings),
          backgroundColor: globals.secondaryColor,
        ),
        body: Container(
          // width: double.infinity,
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
                      //  width: 200,
                      height: 100,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).deleteWallet,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.display3,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    await model.verify();
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
                          style: Theme.of(context).textTheme.display3,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    model.displayMnemonic();
                    print('mnemonic - ${model.mnemonic}');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    !model.isVisible ? '' : model.mnemonic,
                    style: Theme.of(context).textTheme.headline,
                  )),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    color: globals.walletCardColor,
                    width: 200,
                    height: 100,
                    child: Center(
                      child: DropdownButton(
                        hint: Text(
                          AppLocalizations.of(context).changeWalletLanguage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.display3,
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
                                  style: Theme.of(context).textTheme.display3),
                            ),
                            value: language,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Text(model.errorMessage,
                        style: Theme.of(context)
                            .textTheme
                            .display2
                            .copyWith(color: Colors.red)),
                  ),
                )
              ]),
        ),
        bottomNavigationBar: AppBottomNav(),
      ),
    );
  }
}
