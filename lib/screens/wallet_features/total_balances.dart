import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screen_state/total_balances_screen_state.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/app_drawer.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;
import 'gas.dart';

class TotalBalancesScreen extends StatelessWidget {
  final List<WalletInfo> walletInfo;
  TotalBalancesScreen({Key key, this.walletInfo}) : super(key: key);

  final log = getLogger('TotalBalances');

  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return BaseScreen<TotalBalancesScreenState>(
      onModelReady: (model) async {
        model.totalUsdBal();
        model.walletInfo = walletInfo;
        await model.getGas();
      },
      builder: (context, model, child) => Scaffold(
        key: key,
        //  drawer: AppDrawer(),
        body: Column(
          children: <Widget>[
/*-------------------------------------------------------------------------------------
                          Build Background and Logo Container
-------------------------------------------------------------------------------------*/
            Container(
              // width: double.infinity,
              height: 210,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/wallet-page/background.png'),
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
                              icon: Icon(Icons.menu,
                                  color: globals.white, size: 40),
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
                          Positioned(
                            bottom: -15,
/*------------------------------------------------------------
                      Total Balance Card
------------------------------------------------------------*/

                            child: Card(
                              elevation: model.elevation,
                              color: globals.walletCardColor,
                              child: Container(
                                width: 270,
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: new BoxDecoration(
                                          //    color: globals.iconBackgroundColor,
                                          borderRadius:
                                              new BorderRadius.circular(30)),
                                      child: Image.asset(
                                        'assets/images/wallet-page/dollar-sign.png',
                                        width: 40,
                                        height: 40,
                                        color: globals
                                            .iconBackgroundColor, // image background color
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                              AppLocalizations.of(context)
                                                  .totalBalance,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          UIHelper.verticalSpaceSmall,
                                          Text('${model.totalUsdBalance} USD',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline),
                                          //AddGas()
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          await model.refreshBalance();
                                        },
                                        child: model.state == ViewState.Busy
                                            ? SizedBox(
                                                child:
                                                    CircularProgressIndicator(),
                                                width: 20,
                                                height: 20,
                                              )
                                            : Icon(
                                                Icons.refresh,
                                                color: globals.white,
                                                size: 30,
                                              ))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
            Container(
              padding: EdgeInsets.only(right: 10, top: 15),

/*-----------------------------------------------------------------
                      Hide Small Amount Row
-----------------------------------------------------------------*/

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.add_alert,
                              semanticLabel: 'Hide Small Amount Assets',
                              color: globals.primaryColor,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                AppLocalizations.of(context)
                                    .hideSmallAmountAssets,
                                style: Theme.of(context)
                                    .textTheme
                                    .display2
                                    .copyWith(wordSpacing: 1.25),
                              ),
                            )
                          ],
                        ),
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
              ),
            ),
            // Gas Container
            Container(
                padding: EdgeInsets.only(left: 5, top: 2),
                // added model state here and problem of displaying gas amount on the first load solves itself
                child: model.state == ViewState.Busy
                    ? SizedBox(
                        child: CircularProgressIndicator(),
                        width: 20,
                        height: 20,
                      )
                    : Gas(gasAmount: model.gasAmount)),
            // Container(
            //   child: IconButton(
            //     icon: Icon(Icons.assignment_late),
            //     onPressed: () {
            //       model.gasBalance(model.addr);
            //     },
            //   ),
            // ),

/*------------------------------------------------------------------------------
                            Build Wallet List Container
-------------------------------------------------------------------------------*/

            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: walletInfo.length,
                itemBuilder: (BuildContext context, int index) {
                  var name = walletInfo[index].tickerName.toLowerCase();
                  return _coinDetailsCard(
                      '$name',
                      walletInfo[index].availableBalance,
                      walletInfo[index].lockedBalance,
                      1000,
                      walletInfo[index].usdValue,
                      walletInfo[index].logoColor,
                      index,
                      walletInfo,
                      model.elevation,
                      context);
                },
              ),
            ))
          ],
        ),
        bottomNavigationBar: AppBottomNav(),
      ),
    );
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                Coin Details Wallet Card

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _coinDetailsCard(tickerName, available, locked, exgAmount, usdValue,
          color, index, walletInfo, elevation, context) =>
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
                        style: TextStyle(color: globals.red)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text('Locked',
                          style: Theme.of(context).textTheme.display2),
                    ),
                    Text('$locked',
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
                        child: Text(
                            AppLocalizations.of(context).assetInExchange,
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
                          Expanded(
                            child: IconButton(
                                icon: Icon(Icons.arrow_downward),
                                tooltip: 'Deposit',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/deposit',
                                      arguments: walletInfo[index]);
                                }),
                          ),
                          // IconButton(
                          //     icon: Icon(Icons.arrow_upward),
                          //     tooltip: 'Withdraw',
                          //     onPressed: () {
                          //       Navigator.pushNamed(context, '/withdraw',
                          //           arguments: walletInfo[index]);
                          //     }),
                          Expanded(
                            child: IconButton(
                                icon: Icon(Icons.info_outline),
                                tooltip: 'Redeposit',
                                onPressed: () {}),
                          ),
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
                      Text('$usdValue',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: globals.green))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
