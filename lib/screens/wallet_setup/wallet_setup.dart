import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class WalletSetupScreen extends StatelessWidget {
  const WalletSetupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      alignment: Alignment.center,
      color: globals.walletCardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Logo Container
          Container(
            height: 70,
            child: Image.asset('assets/images/start-page/logo.png'),
          ),
          // Middle Graphics Container
          Container(
            child: Image.asset('assets/images/start-page/middle-design.png'),
          ),

          // Button Container
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: RaisedButton(
                      child: Text('Create Wallet',
                          style: Theme.of(context).textTheme.display3),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/backupSeed');
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    shape: StadiumBorder(
                        side: BorderSide(color: globals.white, width: 1)),
                    color: globals.secondaryColor,
                    child: Text(
                      'Import Wallet',
                      style: Theme.of(context).textTheme.display3,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/importWallet');
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
