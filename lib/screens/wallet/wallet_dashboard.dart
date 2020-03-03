/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/app_drawer.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;
import './wallet_features/gas.dart';
import 'package:exchangilymobileapp/environments/environment.dart';

class WalletDashboardScreen extends StatelessWidget {
  final List<WalletInfo> walletInfo;
  WalletDashboardScreen({Key key, this.walletInfo}) : super(key: key);

  final log = getLogger('Dashboard');

  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return BaseScreen<WalletDashboardScreenState>(
      onModelReady: (model) async {
        model.context = context;
        if (walletInfo != null) {
          log.w('wallet info not null');
          model.walletInfo = walletInfo;
          await model.refreshBalance();
          model.calcTotalBal(walletInfo.length);
        } else {
          log.w('wallet info empty, Retrieving wallets from local storage');
          await model.retrieveWallets();
        }
        await model.getGas();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.onBackButtonPressed();
          return new Future(() => false);
        },
        child: Scaffold(
          key: key,
          //  drawer: AppDrawer(),
          body: Column(
            children: <Widget>[
/*-------------------------------------------------------------------------------------
                          Build Background and Logo Container
-------------------------------------------------------------------------------------*/
              Container(
                // width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/wallet-page/background.png'),
                        fit: BoxFit.cover)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            // Positioned(
                            //   top: 5,
                            //   right: 5,
                            //   child: IconButton(
                            //     icon: Icon(Icons.menu,
                            //         color: globals.white, size: 40),
                            //     onPressed: () {
                            //       log.i('trying to open the drawer');
                            //       key.currentState.openDrawer();
                            //     },
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      // Comment expand below in production release
                      // Expanded(
                      //     child: Visibility(
                      //   visible: !isProduction,
                      //   child: Text('Debug Version',
                      //       style: TextStyle(color: Colors.white)),
                      // )),
                      Expanded(
                        child: Stack(
                            alignment: Alignment.center,
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Positioned(
                                top: -10,
                                child: Image.asset(
                                  'assets/images/start-page/logo.png',
                                  width: 180,
                                  color: globals.white,
                                ),
                              ),
                            ]),
                      ),

/*------------------------------------------------------------
                      Total Balance Card
------------------------------------------------------------*/
                      Expanded(
                        child: Stack(
                          overflow: Overflow.visible,
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Positioned(
                              bottom: -20,
                              child: Card(
                                elevation: model.elevation,
                                color: globals.walletCardColor,
                                child: Container(
                                  width: 270,
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30)),
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
                                                    .headline4
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400)),
                                            UIHelper.verticalSpaceSmall,
                                            model.state == ViewState.Busy
                                                ? Shimmer.fromColors(
                                                    baseColor:
                                                        globals.primaryColor,
                                                    highlightColor:
                                                        globals.white,
                                                    child: Text(
                                                      '${model.totalUsdBalance.toStringAsFixed(2)} USD',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1,
                                                    ),
                                                  )
                                                : Text(
                                                    '${model.totalUsdBalance.toStringAsFixed(2)} USD',
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
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
                                                  width: 18,
                                                  height: 18,
                                                )
                                              : Icon(
                                                  Icons.refresh,
                                                  color: globals.white,
                                                  size: 28,
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

/*-----------------------------------------------------------------
                      Hide Small Amount Row
-----------------------------------------------------------------*/

              Container(
                padding: EdgeInsets.only(right: 10, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              model.hideSmallAmountAssets();
                            },
                            child: Row(
                              children: <Widget>[
                                model.isHideSmallAmountAssets
                                    ? Icon(
                                        Icons.money_off,
                                        semanticLabel:
                                            'Hide Small Amount Assets',
                                        color: globals.primaryColor,
                                      )
                                    : Icon(
                                        Icons.attach_money,
                                        semanticLabel:
                                            'Hide Small Amount Assets',
                                        color: globals.primaryColor,
                                      ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .hideSmallAmountAssets,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(wordSpacing: 1.25),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Plus sign container
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      decoration: BoxDecoration(
                          color: globals.primaryColor,
                          borderRadius: BorderRadius.circular(50)),
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
                  margin: EdgeInsets.only(left: 8.0),
                  child: model.state == ViewState.Busy
                      ? Shimmer.fromColors(
                          baseColor: globals.primaryColor,
                          highlightColor: globals.grey,
                          child: Gas(gasAmount: model.gasAmount),
                        )
                      : Gas(gasAmount: model.gasAmount)),

/*------------------------------------------------------------------------------
                            Build Wallet List Container
-------------------------------------------------------------------------------*/
              Expanded(
                  child: model.state == ViewState.Busy
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.walletInfoCopy.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _coinDetailsCard(
                                  '${model.walletInfoCopy[index].tickerName.toLowerCase()}',
                                  model.walletInfoCopy[index].availableBalance,
                                  model.walletInfoCopy[index].lockedBalance,
                                  model.walletInfoCopy[index].inExchange,
                                  model.walletInfoCopy[index].usdValue,
                                  index,
                                  model.walletInfoCopy,
                                  model.elevation,
                                  context,
                                  model);
                            },
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.walletInfo.length,
                            itemBuilder: (BuildContext context, int index) {
                              var name = model.walletInfo[index].tickerName
                                  .toLowerCase();
                              var usdVal = model.walletInfo[index].usdValue;

                              return Visibility(
                                // Default visible widget will be visible when usdVal is greater than equals to 0 and isHideSmallAmountAssets is false
                                visible: usdVal >= 0 &&
                                    !model.isHideSmallAmountAssets,
                                child: _coinDetailsCard(
                                    '$name',
                                    model.walletInfo[index].availableBalance,
                                    model.walletInfo[index].lockedBalance,
                                    model.walletInfo[index].inExchange,
                                    model.walletInfo[index].usdValue,
                                    index,
                                    walletInfo,
                                    model.elevation,
                                    context,
                                    model),
                                // Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
                                replacement: Visibility(
                                    visible: model.isHideSmallAmountAssets &&
                                        usdVal != 0,
                                    child: _coinDetailsCard(
                                        '$name',
                                        model
                                            .walletInfo[index].availableBalance,
                                        model.walletInfo[index].lockedBalance,
                                        model.walletInfo[index].inExchange,
                                        model.walletInfo[index].usdValue,
                                        index,
                                        walletInfo,
                                        model.elevation,
                                        context,
                                        model)),
                              );
                            },
                          ),
                        ))
            ],
          ),
          bottomNavigationBar: AppBottomNav(count: 0),
        ),
      ),
    );
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                Coin Details Wallet Card

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _coinDetailsCard(
      String tickerName,
      double available,
      double locked,
      double assetsInExchange,
      double usdValue,
      index,
      walletInfo,
      elevation,
      context,
      model) {
    return Card(
      color: globals.walletCardColor,
      elevation: elevation,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.pushNamed(context, '/walletFeatures',
              arguments: model.walletInfo[index]);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Card logo container
              Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: globals.walletCardColor,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                            color: globals.fabLogoColor,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10.0,
                            spreadRadius: 1.0),
                      ]),
                  child:
                      Image.asset('assets/images/wallet-page/$tickerName.png'),
                  width: 40,
                  height: 40),
              // Tickername available locked and inexchange column
              Container(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$tickerName'.toUpperCase(),
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    // Available Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Text(AppLocalizations.of(context).available,
                              style: Theme.of(context).textTheme.bodyText1),
                        ),
                        model.state == ViewState.Busy
                            ? SizedBox(
                                child: Shimmer.fromColors(
                                baseColor: globals.red,
                                highlightColor: globals.white,
                                child: Text(
                                  '$available',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ))
                            : Expanded(
                                child: Text('$available',
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                              ),
                      ],
                    ),
                    // Locked Row
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Text(AppLocalizations.of(context).locked,
                              style: Theme.of(context).textTheme.bodyText1),
                        ),
                        model.state == ViewState.Busy
                            ? SizedBox(
                                child: Shimmer.fromColors(
                                baseColor: globals.red,
                                highlightColor: globals.white,
                                child: Text('$locked',
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                              ))
                            : Text('$locked',
                                style: Theme.of(context).textTheme.bodyText2)
                      ],
                    ),
                    // Inexchange Row
                    Row(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(AppLocalizations.of(context).inExchange,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ),
                        model.state == ViewState.Busy
                            ? SizedBox(
                                child: Shimmer.fromColors(
                                baseColor: globals.primaryColor,
                                highlightColor: globals.white,
                                child: Text(
                                  '$assetsInExchange',
                                  textAlign: TextAlign.center,
                                ),
                              ))
                            : Text('$assetsInExchange',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: globals.primaryColor)),
                      ],
                    ),
                  ],
                ),
              ),

              // Value USD and deposit - withdraw Container column
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('USD ${AppLocalizations.of(context).value}',
                              style: Theme.of(context).textTheme.headline5),

                          model.state == ViewState.Busy
                              ? Shimmer.fromColors(
                                  baseColor: globals.green,
                                  highlightColor: globals.white,
                                  child: Text(
                                    '${usdValue.toStringAsFixed(2)}',
                                    style: TextStyle(color: globals.green),
                                  ),
                                )
                              : Text('${usdValue.toStringAsFixed(2)}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: globals.green)),

                          // Deposit and Withdraw Container Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, right: 5.0),
                                    child: Icon(Icons.arrow_downward,
                                        color: globals.green, size: 20),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/deposit',
                                        arguments: model.walletInfo[index]);
                                  }),
                              InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 5.0),
                                    child: Icon(
                                      Icons.arrow_upward,
                                      color: globals.red,
                                      size: 20,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/withdraw',
                                        arguments: model.walletInfo[index]);
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
