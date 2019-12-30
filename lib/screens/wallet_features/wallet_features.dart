import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/models/wallet.dart';

class WalletFeaturesScreen extends StatelessWidget {
  final WalletInfo walletInfo;
  WalletFeaturesScreen({Key key, this.walletInfo}) : super(key: key);

  final List<WalletFeatureName> _features = [
    WalletFeatureName(
        'Receive', Icons.arrow_downward, 'receive', Colors.redAccent),
    WalletFeatureName('Send', Icons.arrow_upward, 'send', Colors.lightBlue),
    WalletFeatureName(
        'Move & Trade', Icons.equalizer, 'moveToExchange', Colors.purple),
    WalletFeatureName('Withdraw to Wallet', Icons.exit_to_app,
        'withdrawToWallet', Colors.cyan),
  ];
  final double elevation = 5;

  @override
  Widget build(BuildContext context) {
    String tickerName = walletInfo.tickerName;
    String coinName = walletInfo.name;
    double containerWidth = 150;
    double containerHeight = 115;
    return Scaffold(
      key: key,
      body: ListView(
        children: <Widget>[
          new Container(
            height: 250,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage('assets/images/wallet-page/background.png'),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
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
                        Expanded(
                          child: Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Positioned(
                                //   bottom: -15,
                                child: _buildTotalBalanceCard(
                                    context,
                                    walletInfo.tickerName,
                                    walletInfo.availableBalance,
                                    walletInfo.usdValue),
                              )
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Receive and Send Exg',
                      style: Theme.of(context).textTheme.display3,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: containerWidth,
                      height: containerHeight,
                      child: _featuresCard(context, 0),
                    ),
                    Container(
                        width: containerWidth,
                        height: containerHeight,
                        child: _featuresCard(context, 1))
                  ],
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Exchange Exg',
                      style: Theme.of(context).textTheme.display3,
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: containerWidth,
                        height: containerHeight,
                        child: _featuresCard(context, 2),
                      ),
                      Container(
                        width: containerWidth,
                        height: containerHeight,
                        child: _featuresCard(context, 3),
                      )
                    ])
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Visibility(
                visible: (walletInfo.tickerName == 'FAB'),
                child: Container(
                  width: 190,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/smartContract');
                    },
                    child: Text(walletInfo.tickerName + 'Smart Contract',
                        style: TextStyle(fontSize: 15)),
                  ),
                )),
          )
        ],
      ),
      bottomNavigationBar: AppBottomNav(),
    );
  }

  // Build Total Balance Card

  Widget _buildTotalBalanceCard(context, name, balance, usdBal) => Card(
        elevation: elevation,
        color: globals.walletCardColor,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$name '.toUpperCase() + 'Total Balance',
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 2.0, 0.0),
                    child: Icon(
                      Icons.refresh,
                      size: 30,
                      color: globals.primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$usdBal USD',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.headline,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Fab Wallet Balance',
                      style: Theme.of(context).textTheme.headline),
                  Text('Assets in exchange',
                      style: Theme.of(context).textTheme.headline)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('$balance', style: Theme.of(context).textTheme.headline),
                  Text('2000', style: Theme.of(context).textTheme.headline)
                ],
              )
            ],
          ),
        ),
      );

// Four Features Card

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
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: globals.walletCardColor,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          new BoxShadow(
                              color:
                                  _features[index].shadowColor.withOpacity(0.5),
                              offset: new Offset(0, 9),
                              blurRadius: 10,
                              spreadRadius: 3)
                        ]),
                    child: Icon(
                      _features[index].icon,
                      size: 65,
                      color: globals.white,
                    )),
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
