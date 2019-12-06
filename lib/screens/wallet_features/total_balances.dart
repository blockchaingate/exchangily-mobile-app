import 'package:exchangilymobileapp/services/models.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/globals.dart' as globals;
import './add_gas.dart';

class TotalBalancesScreen extends StatefulWidget {
  const TotalBalancesScreen({Key key}) : super(key: key);

  @override
  _TotalBalancesScreenState createState() => _TotalBalancesScreenState();
}

class _TotalBalancesScreenState extends State<TotalBalancesScreen> {
  WalletService walletService = WalletService();
  final key = new GlobalKey<ScaffoldState>();
  final double elevation = 5;
  List<WalletInfo> walletInfo;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    walletInfo = Provider.of<List<WalletInfo>>(context);
    if (walletInfo == null) {
      Navigator.of(context).pushNamed('walletSetup');
    } else {
      return Scaffold(
        key: key,
        body: Column(
          children: <Widget>[
            new Container(
              width: double.infinity,
              height: 270,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/wallet-page/background.png'),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(top: 45, bottom: 10),
                    child: Image.asset(
                      'assets/images/start-page/logo.png',
                      width: 250,
                      //height: 120,
                      color: globals.white,
                    ),
                  ),
                  new Container(
                      padding: EdgeInsets.all(25),
                      //margin: EdgeInsets.only(top: 15),
                      child: Stack(
                        //   fit: StackFit.passthrough,
                        //   overflow: Overflow.visible,
                        //  alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Positioned(child: _totalBalanceCard())
                        ],
                      )),
                ],
              ),
            ),
            new Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _hideSmallAmount(),
                  new ListView.builder(
                    shrinkWrap: true,
                    itemCount: walletInfo.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildListBody(context, index, walletInfo),
                  ),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: AppBottomNav(),
      );
    }
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                          Card List View

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/
  Widget buildListBody(
      BuildContext context, int index, List<WalletInfo> walletInfo) {
    var name = walletInfo[index].tickerName;
    return _coinDetailsCard('$name', walletInfo[index].availableBalance, 1000,
        walletInfo[index].usdValue, walletInfo[index].logoColor, index);
  }

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
                      style: Theme.of(context).textTheme.headline),
                  //AddGas()
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

  Widget _coinDetailsCard(
          pairName, available, exgAmount, usdValue, color, index) =>
      Card(
        color: globals.walletCardColor,
        elevation: elevation,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, '/walletOverview',
                arguments: walletInfo[index]);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.all(8),
                    decoration: new BoxDecoration(
                        color: color,
                        borderRadius: new BorderRadius.circular(50),
                        boxShadow: [
                          new BoxShadow(
                              color: color,
                              offset: new Offset(1.0, 3.0),
                              blurRadius: 5.0,
                              spreadRadius: 2.0),
                        ]),
                    child:
                        Image.asset('assets/images/wallet-page/$pairName.png'),
                    width: 40,
                    height: 40),
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
                    Text('Assets in exchange',
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
