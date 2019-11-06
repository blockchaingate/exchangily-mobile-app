import 'package:exchangilymobileapp/services/models.dart';
import 'package:exchangilymobileapp/services/wallet.dart';
import 'package:exchangilymobileapp/shared/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  WalletService walletService = WalletService();
  final key = new GlobalKey<ScaffoldState>();
  final double elevation = 5;

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(
                          Icons.list,
                          color: globals.white,
                          size: 50,
                        ),
                        //   ),
                      ],
                    )),
                new Container(
                  child: Image.asset(
                    'assets/images/start-page/logo.png',
                    width: 250,
                    height: 60,
                    color: globals.white,
                  ),
                ),
                new Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Row(
                            children: <Widget>[
                              Text('EXG',
                                  style: Theme.of(context).textTheme.headline),
                              Icon(
                                Icons.arrow_forward,
                                size: 17,
                                color: globals.white,
                              ),
                              Text('Exchange',
                                  style: Theme.of(context).textTheme.headline)
                            ],
                          ),
                        ),
                        _totalBalanceCard(),
                      ],
                    ))
              ],
            ),
          ),
          new Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Receive and Send Exg',
                      style: Theme.of(context).textTheme.display1,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[_featuresCard(0), _featuresCard(1)],
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Exchange Exg',
                      style: Theme.of(context).textTheme.display1,
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[_featuresCard(2), _featuresCard(3)])
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: AppBottomNav(),
    );
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Total Balance Card

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _totalBalanceCard() => Card(
        // margin: EdgeInsets.all(15),
        elevation: elevation,
        color: globals.walletCardColor,
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Exg Total Balance',
                        style: Theme.of(context)
                            .textTheme
                            .headline
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.refresh),
                      Text('516484165 USD')
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Wallet', style: Theme.of(context).textTheme.headline),
                    Text('Assets in exchange',
                        style: Theme.of(context).textTheme.headline)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('1954465.26574',
                        style: Theme.of(context).textTheme.headline),
                    Text('2000', style: Theme.of(context).textTheme.headline)
                  ],
                )
              ],
            )),
      );

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Features Wallet Card

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  List<WalletFeatures> _features = [
    WalletFeatures('Receive', Icons.arrow_downward, 'receive'),
    WalletFeatures('Send', Icons.arrow_upward, 'send'),
    WalletFeatures('Move & Trade', Icons.dialer_sip, 'moveToExchange'),
    WalletFeatures('Withdraw to Wallet', Icons.check_box, 'withdrawToWallet'),
  ];

  Widget _featuresCard(index) => Card(
        color: globals.walletCardColor,
        elevation: elevation,
        child: InkWell(
          splashColor: globals.primaryColor.withAlpha(30),
          onTap: () {
            var route = _features[index].route;
            Navigator.pushNamed(context, '/$route');
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  _features[index].icon,
                  size: 70,
                  color: globals.white,
                ),
                Text(
                  _features[index].name,
                  style: Theme.of(context).textTheme.headline,
                )
              ],
            ),
          ),
        ),
      );
} // Wallet Screen State Ends Here
