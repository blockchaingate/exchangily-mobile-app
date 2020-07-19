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

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;
import './wallet_features/gas.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';

class WalletDashboardScreen extends StatelessWidget {
  WalletDashboardScreen({Key key}) : super(key: key);

  final log = getLogger('Dashboard');

  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return BaseScreen<WalletDashboardScreenState>(
      onModelReady: (model) async {
        model.context = context;
        await model.retrieveWalletsFromLocalDatabase();
        await model.init();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
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
                                color: isProduction
                                    ? globals.walletCardColor
                                    : globals.red.withAlpha(200),
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
                                            model.busy
                                                ? Shimmer.fromColors(
                                                    baseColor:
                                                        globals.primaryColor,
                                                    highlightColor:
                                                        globals.white,
                                                    child: Text(
                                                      '${model.totalUsdBalance} USD',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1,
                                                    ),
                                                  )
                                                : Text(
                                                    '${model.totalUsdBalance} USD',
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
                                          child: model.busy
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
                    //Add free FAB container
                    !model.isFreeFabNotUsed
                        ? Container()
                        : Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                                color: globals.primaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: SizedBox(
                              width: 150,
                              height: 20,
                              child: OutlineButton.icon(
                                  padding: EdgeInsets.all(0),
                                  onPressed: model.getFreeFab,
                                  icon: Icon(
                                    Icons.add,
                                    size: 18,
                                    color: white,
                                  ),
                                  label: Text(
                                    'Get Free FAB',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  )),
                            ))
                  ],
                ),
              ),
              // Gas Container
              Container(
                  margin: EdgeInsets.only(left: 8.0),
                  child: model.busy
                      ? Shimmer.fromColors(
                          baseColor: globals.primaryColor,
                          highlightColor: globals.grey,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  Icons.donut_large,
                                  size: 18,
                                  color: globals.primaryColor,
                                ),
                              ),
                              UIHelper.horizontalSpaceSmall,
                              Text(
                                "${AppLocalizations.of(context).gas}: ${model.gasAmount.toStringAsFixed(2)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(wordSpacing: 1.25),
                              ),
                            ],
                          ))
                      : Gas(gasAmount: model.gasAmount)),
              UIHelper.verticalSpaceSmall,

/*------------------------------------------------------------------------------
                            Build Wallet List Container
-------------------------------------------------------------------------------*/
              Expanded(
                  child: model.busy
                      ? model.walletInfoCopy == null
                          ? ShimmerLayout(
                              layoutType: 'walletDashboard',
                            )
                          : Container(
                              // margin: EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: model.walletInfoCopy.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _coinDetailsCard(
                                      model.walletInfoCopy[index].tickerName
                                          .toLowerCase(),
                                      model.walletInfoCopy[index]
                                          .availableBalance,
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
                          //   margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SmartRefresher(
                            enablePullDown: true,
                            header:
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? ClassicHeader()
                                    : MaterialClassicHeader(),
                            controller: model.refreshController,
                            onRefresh: model.onRefresh,
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
                                      model.walletInfo,
                                      model.elevation,
                                      context,
                                      model),
                                  // Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
                                  replacement: Visibility(
                                      visible: model.isHideSmallAmountAssets &&
                                          usdVal != 0,
                                      child: _coinDetailsCard(
                                          '$name',
                                          model.walletInfo[index]
                                              .availableBalance,
                                          model.walletInfo[index].lockedBalance,
                                          model.walletInfo[index].inExchange,
                                          model.walletInfo[index].usdValue,
                                          index,
                                          model.walletInfo,
                                          model.elevation,
                                          context,
                                          model)),
                                );
                              },
                            ),
                          ),
                        ))
            ],
          ),
          bottomNavigationBar: BottomNavBar(count: 0),
        ),
      ),
    );
  }

  /*---------------------------------------------------------------------------------------------------------------------------------------------
                                                Coin Details Wallet Card
  ----------------------------------------------------------------------------------------------------------------------------------------------*/

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
      WalletDashboardScreenState model) {
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
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UIHelper.horizontalSpaceSmall,
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
                  width: 35,
                  height: 35),
              UIHelper.horizontalSpaceSmall,
              // Tickername available locked and inexchange column
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '$tickerName'.toUpperCase(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      // Available Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(AppLocalizations.of(context).available,
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          model.busy
                              ? SizedBox(
                                  child: Shimmer.fromColors(
                                  baseColor: globals.red,
                                  highlightColor: globals.white,
                                  child: Text(
                                    available.toStringAsFixed(2),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ))
                              : Expanded(
                                  child: Text(
                                      available == 0
                                          ? '0.0'
                                          : available.toStringAsFixed(4),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                        ],
                      ),
                      // Locked Row
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, right: 5.0, bottom: 2.0),
                            child: Text(AppLocalizations.of(context).locked,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(color: red)),
                          ),
                          model.state == ViewState.Busy
                              ? SizedBox(
                                  child: Shimmer.fromColors(
                                  baseColor: globals.red,
                                  highlightColor: globals.white,
                                  child: Text('$locked',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(color: red)),
                                ))
                              : Expanded(
                                  child: Text(
                                      locked == 0
                                          ? '0.0'
                                          : locked.toStringAsFixed(4),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(color: red)),
                                )
                        ],
                      ),
                      // Inexchange Row
                      Row(
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Text(
                                  AppLocalizations.of(context).inExchange,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6),
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ))
                              : Expanded(
                                  child: Text(
                                      assetsInExchange == 0
                                          ? '0.0'
                                          : assetsInExchange.toStringAsFixed(4),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              color: globals.primaryColor)),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Value USD and deposit - withdraw Container column
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      model.state == ViewState.Busy
                          ? Shimmer.fromColors(
                              baseColor: globals.green,
                              highlightColor: globals.white,
                              child: Text(
                                '${usdValue.toStringAsFixed(2)}',
                                style: TextStyle(color: globals.green),
                              ),
                            )
                          : Row(
                              children: [
                                Text('\$',
                                    style: TextStyle(color: globals.green)),
                                Expanded(
                                  child: Text(
                                      '${usdValue.toStringAsFixed(2)} USD',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: globals.green)),
                                ),
                              ],
                            ),

                      // Deposit and Withdraw Container Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 5.0, left: 2.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context).deposit,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .copyWith(fontSize: 8),
                                      ),
                                      Icon(Icons.arrow_downward,
                                          color: globals.green, size: 16),
                                    ],
                                  )),
                              onTap: () {
                                Navigator.pushNamed(context, '/deposit',
                                    arguments: model.walletInfo[index]);
                              }),
                          Divider(
                            endIndent: 5,
                          ),
                          InkWell(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).withdraw,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(fontSize: 8),
                                    ),
                                    Icon(
                                      Icons.arrow_upward,
                                      color: globals.red,
                                      size: 16,
                                    ),
                                  ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// /*
// * Copyright (c) 2020 Exchangily LLC
// *
// * Licensed under Apache License v2.0
// * You may obtain a copy of the License at
// *
// *      https://www.apache.org/licenses/LICENSE-2.0
// *
// *----------------------------------------------------------------------
// * Author: barry-ruprai@exchangily.com
// *----------------------------------------------------------------------
// */

// import 'package:exchangilymobileapp/constants/colors.dart';
// import 'package:exchangilymobileapp/enums/screen_state.dart';
// import 'package:exchangilymobileapp/localizations.dart';
// import 'package:exchangilymobileapp/logger.dart';
// import 'package:exchangilymobileapp/models/wallet/wallet.dart';
// import 'package:exchangilymobileapp/screens/base_screen.dart';
// import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_screen_state.dart';
// import 'package:exchangilymobileapp/shared/ui_helpers.dart';
// import 'package:exchangilymobileapp/widgets/app_drawer.dart';
// import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
// import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../shared/globals.dart' as globals;
// import './wallet_features/gas.dart';
// import 'package:exchangilymobileapp/environments/environment_type.dart';

// class WalletDashboardScreen extends StatelessWidget {
//   WalletDashboardScreen({Key key}) : super(key: key);

//   final log = getLogger('Dashboard');

//   Widget build(BuildContext context) {
//     final key = new GlobalKey<ScaffoldState>();
//     return BaseScreen<WalletDashboardScreenState>(
//       onModelReady: (model) async {
//         model.context = context;
//         log.w('Retrieving wallets from local storage');
//         await model.retrieveWalletsFromLocalDatabase();
//         await model.init();

//         await model.getGas();
//       },
//       builder: (context, model, child) => WillPopScope(
//         onWillPop: () async {
//           model.onBackButtonPressed();
//           return new Future(() => false);
//         },
//         child: Scaffold(
//           key: key,
//           //  drawer: AppDrawer(),
//           // body:
// //                   NestedScrollView(
// //                     headerSliverBuilder:
// //                         (BuildContext context, bool innerBoxIsScrolled) {
// //                       return <Widget>[
// //                         //new header area
// //                         SliverPersistentHeader(
// //                           pinned: true,
// //                           floating: true,
// //                           delegate: CustomSliverDelegate(
// //                               expandedHeight: 210,
// //                               myCon: Container(
// //                                   // color: Colors.yellow,
// //                                   child: Column(
// //                                 mainAxisAlignment: MainAxisAlignment.start,
// //                                 children: <Widget>[
// //                                   // globals.svgLogo,
// //                                   Image.asset(
// //                                     "assets/images/wallet-page/exlogo.png",
// //                                     width:
// //                                         MediaQuery.of(context).size.width / 1.2,
// //                                     height: 40,
// //                                     fit: BoxFit.contain,
// //                                   ),
// //                                   Offstage(
// //                                       offstage: isProduction,
// //                                       child: Text("Test Server")),
// //                                   SizedBox(height: 20),
// //                                   Card(
// //                                     elevation: model.elevation,
// //                                     color: globals.cardColor,
// //                                     child: Container(
// //                                       width:
// //                                           MediaQuery.of(context).size.width / 2,
// //                                       padding: EdgeInsets.all(10),
// //                                       child: Column(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.spaceEvenly,
// //                                         children: <Widget>[
// //                                           Container(
// //                                             width: MediaQuery.of(context)
// //                                                     .size
// //                                                     .width /
// //                                                 3,
// //                                             child: model.lang == "zh"
// //                                                 ? Center(
// //                                                     child: Text(
// //                                                         AppLocalizations.of(
// //                                                                 context)
// //                                                             .totalBalance,
// //                                                         style: Theme.of(context)
// //                                                             .textTheme
// //                                                             .headline4
// //                                                             .copyWith(
// //                                                               fontWeight:
// //                                                                   FontWeight
// //                                                                       .bold,
// //                                                             )),
// //                                                   )
// //                                                 : FittedBox(
// //                                                     fit: BoxFit.fitWidth,
// //                                                     child: Text(
// //                                                         AppLocalizations.of(
// //                                                                 context)
// //                                                             .totalBalance,
// //                                                         style: Theme.of(context)
// //                                                             .textTheme
// //                                                             .headline4
// //                                                             .copyWith(
// //                                                               fontWeight:
// //                                                                   FontWeight
// //                                                                       .bold,
// //                                                             )),
// //                                                   ),
// //                                           ),
// //                                           Container(
// //                                             margin: EdgeInsets.symmetric(
// //                                                 vertical: 3),
// //                                             decoration: BoxDecoration(
// //                                                 // color: Colors.blue,
// //                                                 gradient: new LinearGradient(
// //                                               colors: [
// //                                                 const Color(0xFFE86700),
// //                                                 const Color(0xFF9C00B1)
// //                                               ],
// //                                             )),
// //                                             height: 2,
// //                                             width: MediaQuery.of(context)
// //                                                     .size
// //                                                     .width /
// //                                                 3,
// //                                           ),
// //                                           // UIHelper.verticalSpaceSmall,

// //                                           model.busy
// //                                               ? Shimmer.fromColors(
// //                                                   baseColor:
// //                                                       globals.primaryColor,
// //                                                   highlightColor: globals.white,
// //                                                   child: Text(
// //                                                     '${model.totalUsdBalance.toStringAsFixed(2)} USD',
// //                                                     style: Theme.of(context)
// //                                                         .textTheme
// //                                                         .subtitle1,
// //                                                   ),
// //                                                 )
// //                                               : Text(
// //                                                   '${model.totalUsdBalance.toStringAsFixed(2)} USD',
// //                                                   textAlign: TextAlign.center,
// //                                                   style: Theme.of(context)
// //                                                       .textTheme
// //                                                       .subtitle1
// //                                                       .copyWith(
// //                                                           fontWeight:
// //                                                               FontWeight.w400)),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),

// //                                   SizedBox(height: 10),
// //                                   /*-----------------------------------------------------------------
// //                         Hide Small Amount Row
// // -----------------------------------------------------------------*/

// //                                   Container(
// //                                     // padding:
// //                                     //     EdgeInsets.only(right: 10, top: 15),
// //                                     child: Row(
// //                                       mainAxisAlignment:
// //                                           MainAxisAlignment.center,
// //                                       mainAxisSize: MainAxisSize.max,
// //                                       children: <Widget>[
// //                                         Container(
// //                                           margin: EdgeInsets.symmetric(
// //                                               horizontal: 8.0, vertical: 5.0),
// //                                           child: Column(
// //                                             crossAxisAlignment:
// //                                                 CrossAxisAlignment.start,
// //                                             children: <Widget>[
// //                                               InkWell(
// //                                                 onTap: () {
// //                                                   model.hideSmallAmountAssets();
// //                                                 },
// //                                                 child: Row(
// //                                                   children: <Widget>[
// //                                                     model.isHideSmallAmountAssets
// //                                                         ? Icon(
// //                                                             Icons.money_off,
// //                                                             semanticLabel:
// //                                                                 'Hide Small Amount Assets',
// //                                                             color: globals
// //                                                                 .primaryColor,
// //                                                           )
// //                                                         : Icon(
// //                                                             Icons.attach_money,
// //                                                             semanticLabel:
// //                                                                 'Hide Small Amount Assets',
// //                                                             color: globals
// //                                                                 .primaryColor,
// //                                                           ),
// //                                                     Container(
// //                                                       padding: EdgeInsets.only(
// //                                                           left: 5),
// //                                                       child: Text(
// //                                                         AppLocalizations.of(
// //                                                                 context)
// //                                                             .hideSmallAmountAssets,
// //                                                         style: Theme.of(context)
// //                                                             .textTheme
// //                                                             .headline5
// //                                                             .copyWith(
// //                                                                 wordSpacing:
// //                                                                     1.25),
// //                                                       ),
// //                                                     )
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ),
// //                                         // Plus sign container
// //                                         // Container(
// //                                         //   margin:
// //                                         //       EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
// //                                         //   decoration: BoxDecoration(
// //                                         //       color: globals.primaryColor,
// //                                         //       borderRadius: BorderRadius.circular(50)),
// //                                         //   child: IconButton(
// //                                         //     onPressed: () {
// //                                         //       Navigator.pushNamed(context, '/campaignInstructions');
// //                                         //     },
// //                                         //     icon: Icon(Icons.add),
// //                                         //     color: globals.white,
// //                                         //   ),
// //                                         // )
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   // Gas Container
// //                                   Container(
// //                                       // margin: EdgeInsets.only(left: 8.0),
// //                                       child: model.busy
// //                                           ? Shimmer.fromColors(
// //                                               baseColor: globals.primaryColor,
// //                                               highlightColor: globals.grey,
// //                                               child: Row(
// //                                                 mainAxisAlignment:
// //                                                     MainAxisAlignment.center,
// //                                                 mainAxisSize: MainAxisSize.max,
// //                                                 children: <Widget>[
// //                                                   Padding(
// //                                                     padding:
// //                                                         const EdgeInsets.only(
// //                                                             left: 5.0),
// //                                                     child: Icon(
// //                                                       Icons.donut_large,
// //                                                       size: 18,
// //                                                       color:
// //                                                           globals.primaryColor,
// //                                                     ),
// //                                                   ),
// //                                                   UIHelper.horizontalSpaceSmall,
// //                                                   Text(
// //                                                     "${AppLocalizations.of(context).gas}: ${model.gasAmount.toStringAsFixed(2)}",
// //                                                     style: Theme.of(context)
// //                                                         .textTheme
// //                                                         .headline5
// //                                                         .copyWith(
// //                                                             wordSpacing: 1.25),
// //                                                   ),
// //                                                 ],
// //                                               ))
// //                                           : Gas(gasAmount: model.gasAmount)),
// //                                   UIHelper.verticalSpaceSmall,
// //                                 ],
// //                               ))),
// //                         ),

// //                       ];
// //                     },
//           body: Column(
//             children: <Widget>[
// /*-------------------------------------------------------------------------------------
//                           Build Background and Logo Container
// -------------------------------------------------------------------------------------*/
//               Container(
//                 // width: double.infinity,
//                 height: 130,
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage(
//                             'assets/images/wallet-page/background.png'),
//                         fit: BoxFit.cover)),
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Expanded(
//                         child: Stack(
//                           overflow: Overflow.visible,
//                           children: <Widget>[],
//                         ),
//                       ),
//                       Expanded(
//                         child: Stack(
//                             alignment: Alignment.center,
//                             overflow: Overflow.visible,
//                             children: <Widget>[
//                               Positioned(
//                                 top: -10,
//                                 child: Image.asset(
//                                   'assets/images/start-page/logo.png',
//                                   width: 180,
//                                   color: globals.white,
//                                 ),
//                               ),
//                             ]),
//                       ),

// /*------------------------------------------------------------
//                         Total Balance Card
// ------------------------------------------------------------*/
//                       Expanded(
//                         child: Stack(
//                           overflow: Overflow.visible,
//                           alignment: Alignment.bottomCenter,
//                           children: <Widget>[
//                             Positioned(
//                               bottom: -20,
//                               child: Card(
//                                 elevation: model.elevation,
//                                 color: isProduction
//                                     ? globals.walletCardColor
//                                     : globals.red.withAlpha(200),
//                                 child: Container(
//                                   width: 270,
//                                   padding: EdgeInsets.all(10),
//                                   child: Row(
//                                     children: <Widget>[
//                                       Container(
//                                         padding: EdgeInsets.all(8),
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(30)),
//                                         child: Image.asset(
//                                           'assets/images/wallet-page/dollar-sign.png',
//                                           width: 40,
//                                           height: 40,
//                                           color: globals
//                                               .iconBackgroundColor, // image background color
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                       UIHelper.horizontalSpaceSmall,
//                                       Expanded(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: <Widget>[
//                                             Text(
//                                                 AppLocalizations.of(context)
//                                                     .totalBalance,
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .headline4
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w400)),
//                                             UIHelper.verticalSpaceSmall,
//                                             model.busy
//                                                 ? Shimmer.fromColors(
//                                                     baseColor:
//                                                         globals.primaryColor,
//                                                     highlightColor:
//                                                         globals.white,
//                                                     child: Text(
//                                                       '${model.totalUsdBalance.toStringAsFixed(2)} USD',
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .subtitle1,
//                                                     ),
//                                                   )
//                                                 : Text(
//                                                     '${model.totalUsdBalance.toStringAsFixed(2)} USD',
//                                                     textAlign: TextAlign.center,
//                                                     style: Theme.of(context)
//                                                         .textTheme
//                                                         .subtitle1
//                                                         .copyWith(
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w400)),
//                                           ],
//                                         ),
//                                       ),
//                                       InkWell(
//                                           onTap: () async {
//                                             await model.refreshBalance();
//                                           },
//                                           child: model.busy
//                                               ? SizedBox(
//                                                   child:
//                                                       CircularProgressIndicator(),
//                                                   width: 18,
//                                                   height: 18,
//                                                 )
//                                               : Icon(
//                                                   Icons.refresh,
//                                                   color: globals.white,
//                                                   size: 28,
//                                                 ))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),

// /*-----------------------------------------------------------------
//                       Hide Small Amount Row
// -----------------------------------------------------------------*/

//                       Container(
//                         padding: EdgeInsets.only(right: 10, top: 15),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           mainAxisSize: MainAxisSize.max,
//                           children: <Widget>[
//                             Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 8.0, vertical: 5.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   InkWell(
//                                     onTap: () {
//                                       model.hideSmallAmountAssets();
//                                     },
//                                     child: Row(
//                                       children: <Widget>[
//                                         model.isHideSmallAmountAssets
//                                             ? Icon(
//                                                 Icons.money_off,
//                                                 semanticLabel:
//                                                     'Hide Small Amount Assets',
//                                                 color: globals.primaryColor,
//                                               )
//                                             : Icon(
//                                                 Icons.attach_money,
//                                                 semanticLabel:
//                                                     'Hide Small Amount Assets',
//                                                 color: globals.primaryColor,
//                                               ),
//                                         Container(
//                                           padding: EdgeInsets.only(left: 5),
//                                           child: Text(
//                                             AppLocalizations.of(context)
//                                                 .hideSmallAmountAssets,
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .headline5
//                                                 .copyWith(wordSpacing: 1.25),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // Plus sign container
//                             Container(
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: 8.0, vertical: 5.0),
//                               decoration: BoxDecoration(
//                                   color: globals.primaryColor,
//                                   borderRadius: BorderRadius.circular(50)),
//                               child: IconButton(
//                                 onPressed: () {
//                                   model.walletService.generateLtcAddress(
//                                       model.walletService.getRandomMnemonic());
//                                 },
//                                 icon: Icon(Icons.add),
//                                 color: globals.white,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       // Gas Container
//                       Container(
//                           margin: EdgeInsets.only(left: 8.0),
//                           child: model.busy
//                               ? Shimmer.fromColors(
//                                   baseColor: globals.primaryColor,
//                                   highlightColor: globals.grey,
//                                   child: Row(
//                                     children: <Widget>[
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(left: 5.0),
//                                         child: Icon(
//                                           Icons.donut_large,
//                                           size: 18,
//                                           color: globals.primaryColor,
//                                         ),
//                                       ),
//                                       UIHelper.horizontalSpaceSmall,
//                                       Text(
//                                         "${AppLocalizations.of(context).gas}: ${model.gasAmount.toStringAsFixed(2)}",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headline5
//                                             .copyWith(wordSpacing: 1.25),
//                                       ),
//                                     ],
//                                   ))
//                               : Gas(gasAmount: model.gasAmount)),
//                       UIHelper.verticalSpaceSmall,
//                     ]),
//               ),

// /*------------------------------------------------------------------------------
//                             Build Wallet List Container
// -------------------------------------------------------------------------------*/
//               Expanded(
//                   child: model.busy
//                       ? model.walletInfoCopy == null
//                           ? ShimmerLayout(
//                               layoutType: 'walletDashboard',
//                             )
//                           : Container(
//                               // margin: EdgeInsets.symmetric(horizontal: 8.0),
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 itemCount: model.walletInfoCopy.length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return _coinDetailsCard(
//                                       model.walletInfoCopy[index].tickerName
//                                           .toLowerCase(),
//                                       model.walletInfoCopy[index]
//                                           .availableBalance,
//                                       model.walletInfoCopy[index].lockedBalance,
//                                       model.walletInfoCopy[index].inExchange,
//                                       model.walletInfoCopy[index].usdValue,
//                                       index,
//                                       model.walletInfoCopy,
//                                       model.elevation,
//                                       context,
//                                       model);
//                                 },
//                               ),
//                             )
//                       : Container(
//                           //   margin: EdgeInsets.symmetric(horizontal: 8.0),
//                           child: SmartRefresher(
//                             enablePullDown: true,
//                             header:
//                                 Theme.of(context).platform == TargetPlatform.iOS
//                                     ? ClassicHeader()
//                                     : MaterialClassicHeader(),
//                             controller: model.refreshController,
//                             onRefresh: model.onRefresh,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: model.walletInfo.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 var name = model.walletInfo[index].tickerName
//                                     .toLowerCase();
//                                 var usdVal = model.walletInfo[index].usdValue;

//                                 return Visibility(
//                                   // Default visible widget will be visible when usdVal is greater than equals to 0 and isHideSmallAmountAssets is false
//                                   visible: usdVal >= 0 &&
//                                       !model.isHideSmallAmountAssets,
//                                   child: _coinDetailsCard(
//                                       '$name',
//                                       model.walletInfo[index].availableBalance,
//                                       model.walletInfo[index].lockedBalance,
//                                       model.walletInfo[index].inExchange,
//                                       model.walletInfo[index].usdValue,
//                                       index,
//                                       model.walletInfo,
//                                       model.elevation,
//                                       context,
//                                       model),
//                                   // Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
//                                   replacement: Visibility(
//                                       visible: model.isHideSmallAmountAssets &&
//                                           usdVal != 0,
//                                       child: _coinDetailsCard(
//                                           '$name',
//                                           model.walletInfo[index]
//                                               .availableBalance,
//                                           model.walletInfo[index].lockedBalance,
//                                           model.walletInfo[index].inExchange,
//                                           model.walletInfo[index].usdValue,
//                                           index,
//                                           model.walletInfo,
//                                           model.elevation,
//                                           context,
//                                           model)),
//                                 );
//                               },
//                             ),
//                           ),
//                         ))
//             ],
//           ),
//           // bottomNavigationBar: BottomNavBar(count: 0),
//         ),
//       ),
//     );
//   }

//   /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

//                                                 Coin Details Wallet Card

//   --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

//   Widget _coinDetailsCard(
//       String tickerName,
//       double available,
//       double locked,
//       double assetsInExchange,
//       double usdValue,
//       index,
//       walletInfo,
//       elevation,
//       context,
//       WalletDashboardScreenState model) {
//     // print('single wallet ${walletInfo[index].toJson()}');
//     return Card(
//       color: globals.walletCardColor,
//       elevation: elevation,
//       child: InkWell(
//         splashColor: Colors.blue.withAlpha(30),
//         onTap: () {
//           Navigator.pushNamed(context, '/walletFeatures',
//               arguments: model.walletInfo[index]);
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 10),
//           child: Row(
//             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               UIHelper.horizontalSpaceSmall,
//               // Card logo container
//               Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: globals.walletCardColor,
//                       borderRadius: BorderRadius.circular(50),
//                       boxShadow: [
//                         BoxShadow(
//                             color: globals.fabLogoColor,
//                             offset: Offset(1.0, 5.0),
//                             blurRadius: 10.0,
//                             spreadRadius: 1.0),
//                       ]),
//                   child:
//                       Image.asset('assets/images/wallet-page/$tickerName.png'),
//                   width: 35,
//                   height: 35),
//               UIHelper.horizontalSpaceSmall,
//               // Tickername available locked and inexchange column
//               Expanded(
//                 flex: 3,
//                 child: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         '$tickerName'.toUpperCase(),
//                         style: Theme.of(context).textTheme.headline3,
//                       ),
//                       // Available Row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(right: 5.0),
//                             child: Text(AppLocalizations.of(context).available,
//                                 style: Theme.of(context).textTheme.headline6),
//                           ),
//                           model.busy
//                               ? SizedBox(
//                                   child: Shimmer.fromColors(
//                                   baseColor: globals.red,
//                                   highlightColor: globals.white,
//                                   child: Text(
//                                     available.toStringAsFixed(2),
//                                     style:
//                                         Theme.of(context).textTheme.headline6,
//                                   ),
//                                 ))
//                               : Expanded(
//                                   child: Text(
//                                       available == 0
//                                           ? '0.0'
//                                           : available.toStringAsFixed(4),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headline6),
//                                 ),
//                         ],
//                       ),
//                       // Locked Row
//                       Row(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 2.0, right: 5.0, bottom: 2.0),
//                             child: Text(AppLocalizations.of(context).locked,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .headline6
//                                     .copyWith(color: red)),
//                           ),
//                           model.state == ViewState.Busy
//                               ? SizedBox(
//                                   child: Shimmer.fromColors(
//                                   baseColor: globals.red,
//                                   highlightColor: globals.white,
//                                   child: Text('$locked',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headline6
//                                           .copyWith(color: red)),
//                                 ))
//                               : Expanded(
//                                   child: Text(
//                                       locked == 0
//                                           ? '0.0'
//                                           : locked.toStringAsFixed(4),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headline6
//                                           .copyWith(color: red)),
//                                 )
//                         ],
//                       ),
//                       // Inexchange Row
//                       Row(
//                         children: <Widget>[
//                           Container(
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 5.0),
//                               child: Text(
//                                   AppLocalizations.of(context).inExchange,
//                                   textAlign: TextAlign.center,
//                                   style: Theme.of(context).textTheme.headline6),
//                             ),
//                           ),
//                           model.state == ViewState.Busy
//                               ? SizedBox(
//                                   child: Shimmer.fromColors(
//                                   baseColor: globals.primaryColor,
//                                   highlightColor: globals.white,
//                                   child: Text(
//                                     '$assetsInExchange',
//                                     textAlign: TextAlign.center,
//                                     style:
//                                         Theme.of(context).textTheme.headline6,
//                                   ),
//                                 ))
//                               : Expanded(
//                                   child: Text(
//                                       assetsInExchange == 0
//                                           ? '0.0'
//                                           : assetsInExchange.toStringAsFixed(4),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headline6
//                                           .copyWith(
//                                               color: globals.primaryColor)),
//                                 ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Value USD and deposit - withdraw Container column
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   child: Column(
//                     children: <Widget>[
//                       model.state == ViewState.Busy
//                           ? Shimmer.fromColors(
//                               baseColor: globals.green,
//                               highlightColor: globals.white,
//                               child: Text(
//                                 '${usdValue.toStringAsFixed(2)}',
//                                 style: TextStyle(color: globals.green),
//                               ),
//                             )
//                           : Row(
//                               children: [
//                                 Text('\$',
//                                     style: TextStyle(color: globals.green)),
//                                 Expanded(
//                                   child: Text(
//                                       '${usdValue.toStringAsFixed(2)} USD',
//                                       textAlign: TextAlign.start,
//                                       style: TextStyle(color: globals.green)),
//                                 ),
//                               ],
//                             ),

//                       // Deposit and Withdraw Container Row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           InkWell(
//                               child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 8.0, right: 5.0, left: 2.0),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         AppLocalizations.of(context).deposit,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .subtitle2
//                                             .copyWith(fontSize: 8),
//                                       ),
//                                       Icon(Icons.arrow_downward,
//                                           color: globals.green, size: 16),
//                                     ],
//                                   )),
//                               onTap: () {
//                                 Navigator.pushNamed(context, '/deposit',
//                                     arguments: model.walletInfo[index]);
//                               }),
//                           Divider(
//                             endIndent: 5,
//                           ),
//                           InkWell(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       AppLocalizations.of(context).withdraw,
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .subtitle2
//                                           .copyWith(fontSize: 8),
//                                     ),
//                                     Icon(
//                                       Icons.arrow_upward,
//                                       color: globals.red,
//                                       size: 16,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               onTap: () {
//                                 Navigator.pushNamed(context, '/withdraw',
//                                     arguments: model.walletInfo[index]);
//                               }),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
// //   final double expandedHeight;
// //   final bool hideTitleWhenExpanded;
// //   final Container myCon;
// //   CustomSliverDelegate({
// //     @required this.expandedHeight,
// //     @required this.myCon,
// //     this.hideTitleWhenExpanded = true,
// //   });

// //   @override
// //   Widget build(
// //       BuildContext context, double shrinkOffset, bool overlapsContent) {
// //     final appBarSize = expandedHeight - shrinkOffset;
// //     final cardTopPosition = expandedHeight / 2 - shrinkOffset;
// //     final proportion = 2 - (expandedHeight / appBarSize);
// //     final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
// //     return SizedBox(
// //       height: expandedHeight + expandedHeight / 2,
// //       child: Stack(
// //         children: [
// //           // right gradient cycle
// //           Positioned(
// //             top: expandedHeight * 0.5,
// //             right: MediaQuery.of(context).size.width / 6,
// //             // right: 0,
// //             // bottom: 0,
// //             height: MediaQuery.of(context).size.width / 6,
// //             width: MediaQuery.of(context).size.width / 6,
// //             child: Container(
// //               margin: EdgeInsets.symmetric(vertical: 3),
// //               decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   gradient: new LinearGradient(
// //                     colors: [const Color(0xFFE86700), const Color(0xFF9C00B1)],
// //                     begin: const FractionalOffset(0.0, 0.0),
// //                     end: const FractionalOffset(1.0, 1.0),
// //                   )),
// //             ),
// //           ),
// //           // left gradient cycle
// //           Positioned(
// //             top: expandedHeight * 0.7,
// //             left: MediaQuery.of(context).size.width / 6,
// //             // right: 0,
// //             // bottom: 0,
// //             height: MediaQuery.of(context).size.width / 5,
// //             width: MediaQuery.of(context).size.width / 5,
// //             child: Container(
// //               margin: EdgeInsets.symmetric(vertical: 3),
// //               decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   gradient: new LinearGradient(
// //                     colors: [const Color(0xFFE86700), const Color(0xFF9C00B1)],
// //                     begin: const FractionalOffset(0.0, 0.0),
// //                     end: const FractionalOffset(1.0, 1.0),
// //                   )),
// //             ),
// //           ),
// //           //Custom AppBar
// //           Container(
// //             // color: Colors.blue,
// //             child: SizedBox(
// //               // height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,
// //               height: kToolbarHeight,
// //               child: AnimatedOpacity(
// //                   opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
// //                   duration: Duration(milliseconds: 100),
// //                   child: Container(
// //                     height: kToolbarHeight,
// //                     width: MediaQuery.of(context).size.width,
// //                     color: globals.cardColor,
// //                     child: Center(
// //                       child: Container(
// //                         width: MediaQuery.of(context).size.width / 2.2,
// //                         child: SvgPicture.asset(
// //                           "assets/images/wallet-page/exlogo.svg",
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ),
// //                   )

// //                   // AppBar(
// //                   //     backgroundColor: globals.cardColor,
// //                   //     leading: Container(),
// //                   //     elevation: 0.0,
// //                   //     title: SvgPicture.asset(
// //                   //       "assets/images/wallet-page/exlogo.svg",
// //                   //       color: Colors.white,
// //                   //     ))
// //                   ),
// //             ),
// //           ),
// //           Positioned(
// //             left: 0.0,
// //             right: 0.0,
// //             top: cardTopPosition > 0 ? kToolbarHeight : 0,
// //             //cardTopPosition > 0 ? cardTopPosition : 0,
// //             // bottom: 0.0,
// //             child: Opacity(
// //               opacity: percent,
// //               child: Container(
// //                   // padding: EdgeInsets.symmetric(horizontal: 30 * percent),
// //                   child: myCon
// //                   // Card(
// //                   //   elevation: 20.0,
// //                   //   child: Center(
// //                   //     child: Text("Header"),
// //                   //   ),
// //                   // ),
// //                   ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   double get maxExtent => expandedHeight + expandedHeight / 2;

// //   @override
// //   double get minExtent => kToolbarHeight;

// //   @override
// //   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
// //     return true;
// //   }
// // }
