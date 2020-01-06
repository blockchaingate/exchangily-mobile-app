import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class ChooseWalletLanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      color: globals.walletCardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Logo Container
          Container(
            height: 70,
            margin: EdgeInsets.only(bottom: 10),
            child: Image.asset('assets/images/start-page/logo.png'),
          ),
          // Middle Graphics Container
          Container(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/images/start-page/middle-design.png'),
          ),
          // Language Text and Icon Container
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 1.0),
                  child: Icon(
                    Icons.language,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text('Please choose the language',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.display3),
                )
              ],
            ),
          ),
          // Button Container
          new Container(
            // width: 225,
            height: 150,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // English Lang Button
                  RaisedButton(
                    child: Text('English'),
                    onPressed: () {
                      AppLocalizations.load(Locale('en', 'US'));
                      Navigator.of(context).pushNamed('/walletSetup');
                    },
                  ),
                  // Chinese Lang Button
                  RaisedButton(
                    shape: StadiumBorder(
                        side:
                            BorderSide(color: globals.primaryColor, width: 2)),
                    color: globals.secondaryColor,
                    child: Text('中文'),
                    onPressed: () {
                      AppLocalizations.load(Locale('zh', 'ZH'));
                      Navigator.of(context).pushNamed('/walletSetup');
                    },
                  )
                ]),
          )
        ],
      ),
    );
  }
}
