import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:exchangilymobileapp/services/wallet.dart';
import 'package:exchangilymobileapp/shared/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:pointycastle/pointycastle.dart';
import '../shared/globals.dart' as globals;

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';

class TotalBalance extends StatefulWidget {
  const TotalBalance({Key key}) : super(key: key);

  @override
  _TotalBalanceState createState() => _TotalBalanceState();
}

class _TotalBalanceState extends State<TotalBalance> {
  WalletService walletService = WalletService();
  final key = new GlobalKey<ScaffoldState>();
  final double elevation = 5;

  @override
  Widget build(BuildContext context) {
    /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Widget Final Named Values

    --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

    final randomMnemonic =
        'culture sound obey clean pretty medal churn behind chief cactus alley ready';
    final seed = bip39.mnemonicToSeed(randomMnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final bitCoinChild = root.derivePath("m/44'/1'/0'/0/0");
    final ethCoinChild = root.derivePath("m/44'/60'/0'/0/0");
    final fabCoinChild = root.derivePath("m/44'/1150'/0'/0/0");
    final fabPublicKey = fabCoinChild.publicKey;
    final privateKey = HEX.encode(ethCoinChild.privateKey);
    final String pairName = 'btc';
    final double availableCoins = 124.24587;
    final double amountInExchange = 3000;
    final double usdValue = 235413.251;

    /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                 Widget Main Scaffold

    --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

    return Scaffold(
      key: key,
      body: Column(
        children: <Widget>[
          new Container(
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage('assets/images/wallet-page/background.png'),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  child: Image.asset(
                    'assets/images/start-page/logo.png',
                    width: 250,
                    height: 150,
                    color: globals.white,
                  ),
                ),
                new Container(
                    padding: EdgeInsets.all(25),
                    margin: EdgeInsets.only(top: 45),
                    child: _totalBalanceCard()),
              ],
            ),
          ),
          new Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _hideSmallAmount(),
                _coinDetailsCard(
                    pairName, availableCoins, amountInExchange, usdValue)
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: AppBottomNav(),
    );
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Copy Address Function

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  copyAddress(String walletAddress) {
    Clipboard.setData(new ClipboardData(text: walletAddress));
    key.currentState.showSnackBar(new SnackBar(
      backgroundColor: globals.white,
      content: new Text(
        'Copied to Clipboard',
        textAlign: TextAlign.center,
        style: TextStyle(color: globals.primaryColor),
      ),
    ));
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  All Wallet Addresses in UI

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  addressField(coinName, walletAddress) {
    return TextField(
      onTap: () {
        copyAddress(walletAddress);
      },
      readOnly: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          filled: true, // Filled needs to be true before fillColor
          // Border gives nice padding as well
          border: OutlineInputBorder(
              borderSide: BorderSide(color: globals.white, width: 2)),
          // Hint Styles
          hintText: walletAddress,
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: globals.primaryColor, // Wallet address color
          ),
          helperText: '$coinName address',
          helperStyle: TextStyle(color: globals.white)),
    );
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Card List View

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/
  // Widget _cardList() => ListView.builder(
  //       itemBuilder: (context, position) {
  //         //  return _coinDetailsCard('df');
  //       },
  //       itemCount: 4,
  //     );

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Copy Address Function

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _totalBalanceCard() => Card(
        // margin: EdgeInsets.all(15),
        elevation: elevation,
        color: globals.walletCardColor,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(8),
                decoration: new BoxDecoration(
                    color: globals.iconBackgroundColor,
                    borderRadius: new BorderRadius.circular(50)),
                child: Image.asset(
                  'assets/images/wallet-page/dollar-sign.png',
                  width: 50,
                  height: 50,
                  //  color: globals.white,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Total Balance',
                      style: Theme.of(context).textTheme.headline),
                  Text('123456 USD',
                      style: Theme.of(context).textTheme.headline)
                ],
              ),
              Icon(Icons.refresh)
            ],
          ),
        ),
      );

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Hide Small Amount Row

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _hideSmallAmount() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add_alert,
                  semanticLabel: 'Hide Small Amount Assests',
                  color: globals.primaryColor,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'Hide Small Amount Assests',
                    style: Theme.of(context)
                        .textTheme
                        .display2
                        .copyWith(wordSpacing: 1.25),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: new BoxDecoration(
                color: globals.primaryColor,
                borderRadius: new BorderRadius.circular(50)),
            child: Icon(
              Icons.add,
              color: globals.white,
            ),
          )
        ],
      );

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Coin Details Wallet Card

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _coinDetailsCard(pairName, available, exgAmount, usdValue) => Card(
        color: globals.walletCardColor,
        elevation: elevation,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('card tapped');
            Navigator.pushNamed(context, '/wallet');
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(8),
                  decoration: new BoxDecoration(
                      color: globals.iconBackgroundColor,
                      borderRadius: new BorderRadius.circular(50),
                      boxShadow: [
                        new BoxShadow(
                            color: globals.iconBackgroundColor,
                            offset: new Offset(1.0, 3.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0),
                      ]),
                  child: Image.asset('assets/images/wallet-page/$pairName.png'),
                  width: 40,
                  height: 40,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$pairName'.toUpperCase(),
                      style: Theme.of(context).textTheme.display1,
                    ),
                    Text('Available',
                        style: Theme.of(context).textTheme.display2),
                    Text('$available', style: TextStyle(color: globals.red))
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(''),
                    Text('Exchange Amount',
                        style: Theme.of(context).textTheme.display2),
                    Text('$exgAmount',
                        style: TextStyle(color: globals.primaryColor))
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(''),
                    Text('Value(USD)',
                        style: Theme.of(context).textTheme.display2),
                    Text('$usdValue', style: TextStyle(color: globals.green))
                  ],
                ),
              ],
            ),
          ),
        ),
      );
} // Wallet Screen State Ends Here
