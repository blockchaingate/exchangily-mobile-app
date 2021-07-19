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

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/wallet_features_viewmodel.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/redeposit/redeposit_viewmodel.dart';

import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../shared/globals.dart' as globals;

class WalletFeaturesView extends StatelessWidget {
  final WalletInfo walletInfo;
  WalletFeaturesView({Key key, this.walletInfo}) : super(key: key);
  final log = getLogger('WalletFeatures');

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => WalletFeaturesViewModel(),
      onModelReady: (model) {
        model.walletInfo = walletInfo;
        model.context = context;
        model.init();
      },
      builder: (context, WalletFeaturesViewModel model, child) => Scaffold(
        //  appBar: AppBar(),
        key: key,
        body: ListView(
          children: <Widget>[
            Container(
              height: 225,
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
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  //Navigator.pop(context);
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
                      height: 153,
                      alignment: FractionalOffset(0.0, 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Row(
                              children: <Widget>[
                                Text('${model.specialTicker}',
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 17,
                                  color: globals.white,
                                ),
                                Text('${walletInfo.name ?? ''}',
                                    style:
                                        Theme.of(context).textTheme.subtitle1)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              clipBehavior: Clip.antiAlias,
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
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
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
                  Column(
                    //  mainAxisSize: MainAxisSize.max,
                    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      model.errDepositItem != null
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: _featuresCard(context, 4, model),
                            )
                          : Container(),
                      walletInfo.tickerName == 'FAB'
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              width: MediaQuery.of(context).size.width,
                              child: _featuresCard(context, 5, model),
                            )
                          : Container(),
                    ],
                  ),

                  // Transaction History Column
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.0),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Card(
                      color: globals.walletCardColor,
                      elevation: model.elevation,
                      child: InkWell(
                        splashColor: globals.primaryColor.withAlpha(30),
                        onTap: () {
                          var route = model.features[6].route;
                          Navigator.pushNamed(context, '$route',
                              arguments: walletInfo.tickerName);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 6),
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
                                    size: 18,
                                    color: globals.white,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  model.features[6].name,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
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

  Widget _buildTotalBalanceCard(
      context, WalletFeaturesViewModel model, walletInfo) {
    String message = AppLocalizations.of(context).sameBalanceNote;
    String nativeTicker = model.specialTicker.split('(')[0];
    return Card(
        elevation: model.elevation,
        color: globals.walletCardColor,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        //  '${model.specialTicker} ' +
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
                          await model.refreshBalance();
                        },
                        child: model.isBusy
                            ? SizedBox(
                                height: 20,
                                child: model.sharedService.loadingIndicator())
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
                        '${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo.usdValue).toString()} USD',
                        textAlign: TextAlign.right,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: globals.buyPrice),
                      ),
                    )
                  ],
                ),
              ),
              UIHelper.verticalSpaceSmall,
              // Middle column row containes wallet balance and in exchnage text
              Container(
                color: primaryColor.withAlpha(27),
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        //  '${model.specialTicker} '.toUpperCase() +
                        AppLocalizations.of(context).walletbalance,
                        style: Theme.of(context).textTheme.subtitle1),
                    Text(
                        '${model.walletInfo.availableBalance.toStringAsFixed(model.singlePairDecimalConfig.qtyDecimal)} ${model.specialTicker}',
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
              // Last column row contains wallet balance and exchange balance
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                          '${AppLocalizations.of(context).inExchange} ${model.specialTicker.contains('(') ? '\n' + message + ' ' + nativeTicker : ''}',
                          style: Theme.of(context).textTheme.subtitle1),
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 20,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: model.isFavorite
                              ? Icon(Icons.star, color: primaryColor, size: 20)
                              : Icon(Icons.star_border_outlined,
                                  color: white, size: 18),
                          onPressed: () => model.updateFavWalletCoinsList(
                              model.walletInfo.tickerName),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text(
                            '${model.walletInfo.inExchange.toStringAsFixed(model.singlePairDecimalConfig.qtyDecimal)}',
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.subtitle1)),
                  ],
                ),
              )
            ],
          ),
        ));
  }

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
