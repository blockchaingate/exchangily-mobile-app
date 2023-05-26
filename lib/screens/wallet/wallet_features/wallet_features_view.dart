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
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/wallet_features_viewmodel.dart';

import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class WalletFeaturesView extends StatelessWidget {
  final WalletInfo? walletInfo;
  WalletFeaturesView({Key? key, this.walletInfo}) : super(key: key);
  final log = getLogger('WalletFeatures');

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => WalletFeaturesViewModel(),
      onViewModelReady: (dynamic model) {
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
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/wallet-page/background.png'),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
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
                            color: white,
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  //Navigator.pop(context);
                                  // Navigator.of(context, rootNavigator: true).pop('dialog');
                                  model.navigationService!
                                      .navigateTo(DashboardViewRoute);
                                })),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 20,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: model.isFavorite
                                  ? const Icon(Icons.star,
                                      color: white, size: 22)
                                  : const Icon(Icons.star_border_outlined,
                                      color: yellow, size: 22),
                              onPressed: () => model.updateFavWalletCoinsList(
                                  model.walletInfo!.tickerName),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 25),
                      height: 159,
                      alignment: const FractionalOffset(0.0, 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: <Widget>[
                                Text(model.specialTicker!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 17,
                                  color: white,
                                ),
                                Text(walletInfo!.name ?? '',
                                    style:
                                        Theme.of(context).textTheme.titleMedium)
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
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  UIHelper.horizontalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: model.containerWidth,
                        height: model.containerHeight,
                        child: _featuresCard(context, 0, model),
                      ),
                      SizedBox(
                          width: model.containerWidth,
                          height: model.containerHeight,
                          child: _featuresCard(context, 1, model))
                    ],
                  ),
                  // model.walletInfo.tickerName == 'MATICM'
                  //     ? Container()
                  //     :
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: model.containerWidth,
                          height: model.containerHeight,
                          child: _featuresCard(context, 2, model),
                        ),
                        SizedBox(
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
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: _featuresCard(context, 4, model),
                            )
                          : Container(),
                      walletInfo!.tickerName == 'FAB'
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              width: MediaQuery.of(context).size.width,
                              child: _featuresCard(context, 5, model),
                            )
                          : Container(),
                    ],
                  ),

                  // Transaction History Column
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Card(
                      color: walletCardColor,
                      elevation: model.elevation,
                      child: InkWell(
                        splashColor: primaryColor.withAlpha(30),
                        onTap: () {
                          var route = model.features[6].route;
                          Navigator.pushNamed(context, route,
                              arguments: walletInfo);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 9, horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      color: walletCardColor,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                            color: model.features[6].shadowColor
                                                .withOpacity(0.2),
                                            offset: const Offset(0, 2),
                                            blurRadius: 10,
                                            spreadRadius: 3)
                                      ]),
                                  child: Icon(
                                    model.features[6].icon,
                                    size: 18,
                                    color: white,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  model.features[6].name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.smartContractAddress,
              style: headText5.copyWith(color: primaryColor),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                model.smartContractAddress,
                style: headText6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Total Balance Card

  Widget _buildTotalBalanceCard(
      context, WalletFeaturesViewModel model, walletInfo) {
    String message = AppLocalizations.of(context)!.sameBalanceNote;
    String nativeTicker = model.specialTicker!.split('(')[0];
    return Card(
        elevation: model.elevation,
        color: walletCardColor,
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        //  '${model.specialTicker} ' +
                        AppLocalizations.of(context)!.totalBalance,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: buyPrice),
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
                                child: model.sharedService!.loadingIndicator())
                            : const Center(
                                child: Icon(
                                  Icons.refresh,
                                  color: white,
                                  size: 18,
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo!.usdValue).toString()} USD',
                        textAlign: TextAlign.right,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: buyPrice),
                      ),
                    )
                  ],
                ),
              ),
              UIHelper.verticalSpaceSmall,
              // Middle column row containes wallet balance and in exchange text
              Container(
                color: primaryColor.withAlpha(27),
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.walletbalance,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(
                        '${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo!.availableBalance, precision: model.decimalLimit!).toString()} ${model.specialTicker}',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              // Middle column row containes unconfirmed wallet balance.
              model.walletInfo!.tickerName == 'FAB'
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.unConfirmedBalance,
                              style: Theme.of(context).textTheme.bodyLarge),
                          Text(
                              '${NumberUtil().truncateDoubleWithoutRouding(model.unconfirmedBalance!, precision: model.decimalLimit!).toString()} ${model.specialTicker}',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    )
                  : Container(),
              // row contains wallet balance and exchange balance
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                          '${AppLocalizations.of(context)!.inExchange} ${model.specialTicker!.contains('(') && model.walletInfo!.tickerName != 'USDT' && model.walletInfo!.tickerName != 'MATICM' ? '\n$message $nativeTicker' : ''}',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text(
                            '${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo!.inExchange!, precision: model.decimalLimit!).toString()} ${model.specialTicker}',
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.titleMedium)),
                  ],
                ),
              ),
              // Last container locked wallet balance
              model.walletInfo!.lockedBalance != 0.0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Text(
                                '${AppLocalizations.of(context)!.totalLockedBalance} ${model.specialTicker!.contains('(') && model.walletInfo!.tickerName != 'USDT' ? '\n$message $nativeTicker' : ''}',
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Expanded(
                              flex: 4,
                              child: Text(
                                  '${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo!.lockedBalance!, precision: model.decimalLimit!).toString()} ${model.specialTicker}',
                                  textAlign: TextAlign.right,
                                  style:
                                      Theme.of(context).textTheme.titleMedium)),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }

  // Features Card

  Widget _featuresCard(context, index, WalletFeaturesViewModel model) => Card(
        color: walletCardColor,
        elevation: model.elevation,
        child: InkWell(
          splashColor: primaryColor.withAlpha(30),
          onTap: (model.features[index].route != '')
              ? () {
                  var route = model.features[index].route;
                  model.navigationService!
                      .navigateTo('/$route', arguments: model.walletInfo);
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: walletCardColor,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                              color: model.features[index].shadowColor
                                  .withOpacity(0.5),
                              offset: const Offset(0, 9),
                              blurRadius: 10,
                              spreadRadius: 3)
                        ]),
                    child: Icon(
                      model.features[index].icon,
                      size: 40,
                      color: white,
                    )),
                Text(
                  model.features[index].name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
          ),
        ),
      );
}
