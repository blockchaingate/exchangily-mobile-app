import 'package:exchangilymobileapp/shared/bottom_nav.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/services/models.dart';

class WalletOverviewScreen extends StatelessWidget {
  final WalletInfo walletInfo;
  WalletOverviewScreen({Key key, this.walletInfo}) : super(key: key);

  final List<WalletFeatures> _features = [
    WalletFeatures('Receive', Icons.arrow_downward, 'receive'),
    WalletFeatures('Send', Icons.arrow_upward, 'send'),
    WalletFeatures('Move & Trade', Icons.dialer_sip, 'moveToExchange'),
    WalletFeatures('Withdraw to Wallet', Icons.check_box, 'withdrawToWallet'),
  ];
  final double elevation = 5;

  @override
  Widget build(BuildContext context) {
    String tickerName = walletInfo.tickerName;
    String coinName = walletInfo.name;
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
                new Container(
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
                Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    height: 120,
                    alignment: FractionalOffset(0.0, 2.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Row(
                            children: <Widget>[
                              Text('$tickerName',
                                  style: Theme.of(context).textTheme.headline),
                              Icon(
                                Icons.arrow_forward,
                                size: 17,
                                color: globals.white,
                              ),
                              Text('$coinName',
                                  style: Theme.of(context).textTheme.headline)
                            ],
                          ),
                        ),
                        buildTotalBalanceCard(context, walletInfo)
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
                  children: <Widget>[
                    _featuresCard(context, 0),
                    _featuresCard(context, 1)
                  ],
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Exchange Exg',
                      style: Theme.of(context).textTheme.display1,
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _featuresCard(context, 2),
                      _featuresCard(context, 3)
                    ])
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: AppBottomNav(),
    );
  }

  Widget buildTotalBalanceCard(BuildContext context, WalletInfo info) {
    return _totalBalanceCard(context, info.tickerName, info.availableBalance);
  }

  Widget _totalBalanceCard(context, name, balance) => Card(
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
                        '$name '.toUpperCase() + 'Total Balance',
                        style: Theme.of(context)
                            .textTheme
                            .headline
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.refresh),
                      Text('$balance')
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

  Widget _featuresCard(context, index) => Card(
        color: globals.walletCardColor,
        elevation: elevation,
        child: InkWell(
          splashColor: globals.primaryColor.withAlpha(30),
          onTap: () {
            var route = _features[index].route;
            Navigator.pushNamed(context, '/$route', arguments: walletInfo);
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
}
