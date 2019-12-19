import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/widgets/app_drawer.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../shared/globals.dart' as globals;

class TotalBalancesScreen extends StatefulWidget {
  const TotalBalancesScreen({Key key}) : super(key: key);

  @override
  _TotalBalancesScreenState createState() => _TotalBalancesScreenState();
}

class _TotalBalancesScreenState extends State<TotalBalancesScreen> {
  final log = getLogger('TotalBalances');

  WalletService walletService = WalletService();
  final key = new GlobalKey<ScaffoldState>();
  final double elevation = 5;
  List<WalletInfo> walletInfo;
  double totalUsdBalance = 0;

  @override
  void initState() {
    super.initState();
    //  totalUsdBalance = walletService.totalWalletUsdBalance();
  }

  Widget build(BuildContext context) {
    walletInfo = Provider.of<List<WalletInfo>>(context);
    if (walletInfo == null) {
      log.e('ERROR $walletInfo');
      Navigator.of(context).pushNamed('/createWallet');
      return null;
    } else {
      return Scaffold(
        key: key,
        drawer: AppDrawer(),
        body: Column(
          children: <Widget>[
            _buildBackgroundAndLogoContainer(walletInfo),
            Container(
              padding: EdgeInsets.only(right: 10, top: 15),
              child: _hideSmallAmount(),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[_buildWalletListContainer(walletInfo)],
              ),
            )
          ],
        ),
        bottomNavigationBar: AppBottomNav(),
      );
    }
  }
  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                          Build Wallet List Container

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Container _buildWalletListContainer(List<WalletInfo> walletInfo) {
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              itemCount: walletInfo.length,
              itemBuilder: (BuildContext context, int index) {
                var name = walletInfo[index].tickerName.toLowerCase();
                return _coinDetailsCard(
                    '$name',
                    walletInfo[index].availableBalance,
                    1000,
                    walletInfo[index].usdValue,
                    walletInfo[index].logoColor,
                    index);
              }),
        ],
      ),
    );
  }
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                          Build Background and Logo Container

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Container _buildBackgroundAndLogoContainer(walletInfo) {
    return new Container(
      // width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/wallet-page/background.png'),
              fit: BoxFit.cover)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: Icon(Icons.menu, color: globals.white, size: 40),
                      onPressed: () {
                        log.i('trying to open the drawer');
                        key.currentState.openDrawer();
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Stack(children: <Widget>[
                Positioned(
                  child: Image.asset(
                    'assets/images/start-page/logo.png',
                    width: 250,
                    color: globals.white,
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Stack(
                //fit: StackFit.passthrough,
                overflow: Overflow.visible,
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Positioned(bottom: -15, child: _totalBalanceCard(walletInfo))
                ],
              ),
            ),
          ]),
    );
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Total Balance Card
  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _totalBalanceCard(walletInfo) => Card(
        // margin: EdgeInsets.all(15),
        elevation: elevation,
        color: globals.walletCardColor,
        child: Container(
          width: 270,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(8),
                decoration: new BoxDecoration(
                    //    color: globals.iconBackgroundColor,
                    borderRadius: new BorderRadius.circular(30)),
                child: Image.asset(
                  'assets/images/wallet-page/dollar-sign.png',
                  width: 50,
                  height: 50,
                  color: globals.iconBackgroundColor, // image background color
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Total Balance',
                      style: Theme.of(context)
                          .textTheme
                          .headline
                          .copyWith(fontWeight: FontWeight.bold)),
                  Text('$totalUsdBalance USD',
                      style: Theme.of(context)
                          .textTheme
                          .headline
                          .copyWith(fontWeight: FontWeight.bold)),
                  //AddGas()
                ],
              ),
              InkWell(
                  onTap: () {
                    totalUsdBalance = walletService.totalWalletUsdBalance();
                    log.v('This is Verbose');
                    log.d('This is a debug message $totalUsdBalance');
                    log.i('This is info, should be used for public calls');
                    log.w('This is warning which might become a problem');
                    log.e('Some is wrong, this is ERROR');
                  },
                  child: Icon(
                    Icons.refresh,
                    color: globals.white,
                  ))
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
                  semanticLabel: 'Hide Small Amount Assets',
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
          tickerName, available, exgAmount, usdValue, color, index) =>
      Card(
        color: globals.walletCardColor,
        elevation: elevation,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, '/walletFeatures',
                arguments: walletInfo[index]);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.all(8),
                    decoration: new BoxDecoration(
                        color: globals.walletCardColor,
                        borderRadius: new BorderRadius.circular(50),
                        boxShadow: [
                          new BoxShadow(
                              color: color,
                              offset: new Offset(1.0, 5.0),
                              blurRadius: 10.0,
                              spreadRadius: 1.0),
                        ]),
                    child: Image.asset(
                        'assets/images/wallet-page/$tickerName.png'),
                    width: 40,
                    height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$tickerName'.toUpperCase(),
                      style: Theme.of(context).textTheme.display1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text('Available',
                          style: Theme.of(context).textTheme.display2),
                    ),
                    Text('$available',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: globals.red))
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 0),
                        child: Text('Assets in exchange',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.display2),
                      ),
                      Text('$exgAmount',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: globals.primaryColor)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.arrow_downward),
                              tooltip: 'Deposit',
                              onPressed: () {
                                Navigator.pushNamed(context, '/deposit',
                                    arguments: walletInfo[index]);
                              }),
                          // IconButton(
                          //     icon: Icon(Icons.arrow_upward),
                          //     tooltip: 'Withdraw',
                          //     onPressed: () {
                          //       Navigator.pushNamed(context, '/withdraw',
                          //           arguments: walletInfo[index]);
                          //     }),
                          IconButton(
                              icon: Icon(Icons.info_outline),
                              tooltip: 'Redeposit',
                              onPressed: () {}),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text('Value(USD)',
                            style: Theme.of(context).textTheme.display2),
                      ),
                      Text('$usdValue', style: TextStyle(color: globals.green))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
} // Wallet Screen State Ends Here
