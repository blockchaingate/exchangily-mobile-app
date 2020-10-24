/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com, ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/wallet_features_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';

import 'package:exchangilymobileapp/shared/ui_helpers.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;
import '../../../environments/coins.dart';

class WalletFeaturesScreen extends StatelessWidget {
  final WalletInfo walletInfo;
  WalletFeaturesScreen({Key key, this.walletInfo}) : super(key: key);
  final log = getLogger('WalletFeatures');

  @override
  Widget build(BuildContext context) {
    return BaseScreen<WalletFeaturesScreenState>(
      onModelReady: (model) {
        model.walletInfo = walletInfo;
        model.context = context;
        model.getWalletFeatures();
        model.getErrDeposit();
      },
      builder: (context, model, child) => Scaffold(
        // appBar: AppBar(),
        key: key,
        body: ListView(
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/wallet-page/background.png'),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/start-page/logo.png',
                            width: 200,
                            height: 60,
                            color: globals.white,
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  //  Navigator.pop(context);
                                  // Navigator.of(context, rootNavigator: true).pop('dialog');
                                  model.navigationService
                                      .navigateTo('/dashboard');
                                }))
                      ],
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                      height: 120,
                      alignment: FractionalOffset(0.0, 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Row(
                              children: <Widget>[
                                Text('${walletInfo.tickerName}',
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 17,
                                  color: globals.white,
                                ),
                                Text('${walletInfo.name}',
                                    style:
                                        Theme.of(context).textTheme.subtitle1)
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
                                      context, model, walletInfo),
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
              //   height: 400,
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Padding(
                  //     padding: EdgeInsets.all(10),
                  //     child: Text(
                  //       'Receive and Send Exg',
                  //       style: Theme.of(context).textTheme.display3,
                  //     )),
                  UIHelper.horizontalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: model.containerWidth,
                        height: model.containerHeight,
                        child: _featuresCard(context, 0, model),
                      ),
                      Container(
                          width: model.containerWidth,
                          height: model.containerHeight,
                          child: _featuresCard(context, 1, model))
                    ],
                  ),
                  // Padding(
                  //     padding: EdgeInsets.all(10),
                  //     child: Text(
                  //       'Exchange Exg',
                  //       style: Theme.of(context).textTheme.display3,
                  //     )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: model.containerWidth,
                          height: model.containerHeight,
                          child: _featuresCard(context, 2, model),
                        ),
                        Container(
                          width: model.containerWidth,
                          height: model.containerHeight,
                          child: _featuresCard(context, 3, model),
                        ),
                      ]),
                  FutureBuilder(
                      future: model.getErrDeposit(),
                      initialData: [],
                      builder: (context, snapShot) {
                        var errDepositData = snapShot.data;
                        if (snapShot.data != null) {
                          for (var i = 0; i < errDepositData.length; i++) {
                            var item = errDepositData[i];
                            var coinType = item['coinType'];
                            if (coin_list[coinType]['name'] ==
                                walletInfo.tickerName) {
                              model.errDepositItem = item;
                              break;
                            }
                          }
                        }
                        if (model.errDepositItem != null) {
                          if (walletInfo.tickerName == 'FAB') {
                            return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () async {
                                        // model.checkPass(context);
                                      },
                                      child: Container(
                                        width: model.containerWidth,
                                        height: model.containerHeight,
                                        child: _featuresCard(context, 4, model),
                                      )),
                                  Container(
                                    width: model.containerWidth,
                                    height: model.containerHeight,
                                    child: _featuresCard(context, 5, model),
                                  )
                                ]);
                          } else {
                            return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () async {
                                        // model.checkPass(context);
                                      },
                                      child: Container(
                                        width: model.containerWidth,
                                        height: model.containerHeight,
                                        child: _featuresCard(context, 4, model),
                                      )),
                                  Opacity(
                                      opacity: 0.0,
                                      child: Container(
                                        width: model.containerWidth,
                                        height: model.containerHeight,
                                        child: _featuresCard(context, 5, model),
                                      ))
                                ]);
                          }
                        } else {
                          if (walletInfo.tickerName == 'FAB') {
                            return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    width: model.containerWidth,
                                    height: model.containerHeight,
                                    child: _featuresCard(context, 5, model),
                                  ),
                                  Opacity(
                                      opacity: 0.0,
                                      child: Container(
                                        width: model.containerWidth,
                                        height: model.containerHeight,
                                        child: _featuresCard(context, 4, model),
                                      ))
                                ]);
                          }
                        }
                        return Row();
                      }),
                  UIHelper.horizontalSpaceSmall,
                  // Transaction History Column
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.0, vertical: 5.0),
                    child: Card(
                      color: globals.walletCardColor,
                      elevation: model.elevation,
                      child: InkWell(
                        splashColor: globals.primaryColor.withAlpha(30),
                        onTap: () {
                          var route = model.features[6].route;
                          Navigator.pushNamed(context, '/$route',
                              arguments: walletInfo.tickerName);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      color: globals.walletCardColor,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                            color: model.features[6].shadowColor
                                                .withOpacity(0.2),
                                            offset: Offset(0, 2),
                                            blurRadius: 10,
                                            spreadRadius: 3)
                                      ]),
                                  child: Icon(
                                    model.features[6].icon,
                                    size: 20,
                                    color: globals.white,
                                  )),
                              Text(
                                model.features[6].name,
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        // bottomNavigationBar: BottomNavBar(count: 0),
      ),
    );
  }

  // Build Total Balance Card

  Widget _buildTotalBalanceCard(context, model, walletInfo) => Card(
        elevation: model.elevation,
        color: globals.walletCardColor,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      '${walletInfo.tickerName} ' +
                          AppLocalizations.of(context).totalBalance,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: globals.buyPrice),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () async {
                        await model.refreshErrDeposit();
                        await model.refreshBalance();
                      },
                      child: model.state == ViewState.Busy
                          ? SizedBox(
                              child: CircularProgressIndicator(),
                              width: 20,
                              height: 20,
                            )
                          : Center(
                              child: Icon(
                                Icons.refresh,
                                color: globals.white,
                                size: 18,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      '${model.walletInfo.usdValue.toStringAsFixed(2)} USD',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: globals.buyPrice),
                    ),
                  )
                ],
              ),
              // Middle column row containes wallet balance and in exchnage text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${walletInfo.tickerName} '.toUpperCase() +
                          AppLocalizations.of(context).walletbalance,
                      style: Theme.of(context).textTheme.subtitle1),
                  Text(AppLocalizations.of(context).inExchange,
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              ),
              // Last column row contains wallet balance and exchange balance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${model.walletInfo.availableBalance}',
                      style: Theme.of(context).textTheme.subtitle1),
                  Text('${model.walletInfo.inExchange}',
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              )
            ],
          ),
        ),
      );

  // Features Card

  Widget _featuresCard(context, index, model) => Card(
        color: globals.walletCardColor,
        elevation: model.elevation,
        child: InkWell(
          splashColor: globals.primaryColor.withAlpha(30),
          onTap: (model.features[index].route != null &&
                  model.features[index].route != '')
              ? () {
                  var route = model.features[index].route;
                  Navigator.pushNamed(context, '/$route',
                      arguments: model.walletInfo);
                }
              : null,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: globals.walletCardColor,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          new BoxShadow(
                              color: model.features[index].shadowColor
                                  .withOpacity(0.5),
                              offset: new Offset(0, 9),
                              blurRadius: 10,
                              spreadRadius: 3)
                        ]),
                    child: Icon(
                      model.features[index].icon,
                      size: 40,
                      color: globals.white,
                    )),
                Text(
                  model.features[index].name,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          ),
        ),
      );
}
