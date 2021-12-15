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

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/enums/connectivity_status.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_balance.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/screens/announcement/anncounceList.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:exchangilymobileapp/shared/styles.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/network_status.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layouts/shimmer_wallet_dashboard_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stacked/stacked.dart';
import '../../shared/globals.dart' as globals;
import 'wallet_features/gas.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';

class WalletDashboardView extends StatelessWidget {
  WalletDashboardView({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    GlobalKey _one = GlobalKey();
    GlobalKey _two = GlobalKey();
    final key = new GlobalKey<ScaffoldState>();
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => WalletDashboardViewModel(),
        onModelReady: (model) async {
          model.context = context;
          model.globalKeyOne = _one;
          model.globalKeyTwo = _two;
          //  await model.retrieveWalletsFromLocalDatabase();
          await model.init();
        },
        builder: (context, WalletDashboardViewModel model, child) {
          // var connectionStatus = Provider.of<ConnectivityStatus>(context);
          // if (connectionStatus == ConnectivityStatus.Offline)
          //   return NetworkStausView();
          // else
          return WillPopScope(
            onWillPop: () {
              model.onBackButtonPressed();
              return new Future(() => false);
            },
            child: Scaffold(
              key: key,
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: ShowCaseWidget(
                  onStart: (index, key) {
                    print('onStart: $index, $key');
                  },
                  onComplete: (index, key) {
                    print('onComplete: $index, $key');
                  },
                  onFinish: () {
                    model.storageService.isShowCaseView = false;

                    model.updateShowCaseViewStatus();
                  },
                  builder: Builder(
                    builder: (context) => ListView(
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
                                    clipBehavior: Clip.none,
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
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
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
                                  child: TotalBalanceWidget(model: model),
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
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        model.isShowFavCoins
                                            ? print('...')
                                            : model.hideSmallAmountAssets();
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          model.isHideSmallAmountAssets
                                              ? Icon(
                                                  Icons.money_off,
                                                  semanticLabel:
                                                      'Show all Amount Assets',
                                                  color: globals.primaryColor,
                                                )
                                              : Icon(
                                                  Icons.attach_money,
                                                  semanticLabel:
                                                      'Hide Small Amount Assets',
                                                  color: model.isShowFavCoins
                                                      ? grey
                                                      : globals.primaryColor,
                                                ),
                                          Container(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .hideSmallAmountAssets,
                                              style: model.isShowFavCoins
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(
                                                          wordSpacing: 1.25,
                                                          color: grey)
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(
                                                          wordSpacing: 1.25),
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      decoration: BoxDecoration(
                                          color: globals.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: SizedBox(
                                        width: 120,
                                        height: 20,
                                        child: OutlinedButton.icon(
                                            style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.all(0))),
                                            onPressed: () => model.getFreeFab(),
                                            icon: Icon(
                                              Icons.add,
                                              size: 18,
                                              color: white,
                                            ),
                                            label: Text(
                                              AppLocalizations.of(context)
                                                      .getFree +
                                                  ' FAB',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            )),
                                      )),
                              UIHelper.horizontalSpaceMedium,
                            ],
                          ),
                        ),
                        // Gas Container
                        Container(
                          margin: EdgeInsets.only(left: 8.0),
                          child: model.isBusy
                              ? Shimmer.fromColors(
                                  baseColor: globals.primaryColor,
                                  highlightColor: globals.grey,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Icon(
                                          Icons.donut_large,
                                          size: 18,
                                          color: globals.primaryColor,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Text(
                                        "${AppLocalizations.of(context).gas}: ${NumberUtil().truncateDoubleWithoutRouding(model.gasAmount, precision: 6).toString()}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(wordSpacing: 1.25),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      MaterialButton(
                                        minWidth: 70.0,
                                        height: 24,
                                        color: globals.green,
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {},
                                        child: Text(
                                          AppLocalizations.of(context).addGas,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(color: black),
                                        ),
                                      ),
                                    ],
                                  ))
                              : Row(
                                  children: [
                                    AddGasRow(model: model),
                                    UIHelper.horizontalSpaceSmall,
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => FocusScope.of(context)
                                            .requestFocus(FocusNode()),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 5),
                                          height: 30,
                                          child: TextField(
                                            enabled: model.isShowFavCoins
                                                ? false
                                                : true,
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: primaryColor,
                                                      width: 1),
                                                ),
                                                // helperText: 'Search',
                                                // helperStyle:
                                                //     Theme.of(context).textTheme.bodyText1,
                                                suffixIcon: Icon(Icons.search,
                                                    color: white)),
                                            controller:
                                                model.searchCoinTextController,
                                            onChanged: (String value) {
                                              model.isShowFavCoins
                                                  ? model
                                                      .searchFavCoinsByTickerName(
                                                          value)
                                                  : model
                                                      .searchCoinsByTickerName(
                                                          value);
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        ),

                        UIHelper.verticalSpaceSmall,
                        model.isUpdateWallet
                            ? Container(
                                child: TextButton(
                                child: Text(
                                    AppLocalizations.of(context).updateWallet),
                                onPressed: () => model.updateWallet(),
                              ))
                            : Container(),
/*------------------------------------------------------------------------------
                                Build Wallet List Container
-------------------------------------------------------------------------------*/
                        //   !Platform.isAndroid
                        //      ?
                        SingleChildScrollView(
                          child: DefaultTabController(
                            length: 2,
                            initialIndex: model.currentTabSelection,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TabBar(
                                      labelPadding: EdgeInsets.only(bottom: 5),
                                      onTap: (int tabIndex) {
                                        model.updateTabSelection(tabIndex);
                                      },
                                      indicatorColor: primaryColor,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      // Tab Names

                                      tabs: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.coins,
                                              color: white,
                                              size: 16,
                                            ),
                                            UIHelper.horizontalSpaceSmall,
                                            Text(
                                                model.wallets.length.toString(),
                                                style: TextStyle(
                                                    fontSize: 10, color: grey))
                                          ],
                                        ),
                                        // Text(
                                        //     AppLocalizations.of(context)
                                        //         .allAssets,
                                        //     style: Theme.of(context)
                                        //         .textTheme
                                        //         .bodyText1
                                        //         .copyWith(
                                        //             fontWeight: FontWeight.w500,
                                        //             decorationThickness: 3)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.star,
                                                color: primaryColor, size: 18),
                                            UIHelper.horizontalSpaceSmall,
                                            Text(
                                                model.favWallets.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 10, color: grey))
                                          ],
                                        ),
                                      ]),
                                  UIHelper.verticalSpaceSmall,
                                  // Tabs view container
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                            .55 -
                                        model.minusHeight,
                                    child: TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        // All coins tab
                                        model.isBusy
                                            ? ListView.builder(
                                                itemCount: 8,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        index) {
                                                  return ShimmerWalletDashboardLayout();
                                                },
                                              )
                                            : buildListView(model),

                                        FavTab(),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavBar(count: 0),
              // floatingActionButton: Container(
              //   color: white,
              //   child: IconButton(
              //     icon: model.isTopOfTheList
              //         ? Icon(Icons.arrow_downward)
              //         : Icon(Icons.arrow_upward),
              //     onPressed: () async {
              //       model.routeWithWalletInfoArgs(
              //           WalletBalance(balance: 12, coin: 'cnb'), '');
              //     },
              //   ),
              // ),
            ),
          );
        });
  }

  ListView buildListView(WalletDashboardViewModel model) {
    return ListView.builder(
      controller: model.walletsScrollController,
      shrinkWrap: true,
      itemCount: model.wallets.length,
      itemBuilder: (BuildContext context, int index) {
        var name = model.wallets[index].coin.toLowerCase();
        var usdBalance = model.wallets[index].balance *
            (model.wallets[index].usdValue.usd.isNegative
                ? 0.0
                : model.wallets[index].usdValue.usd);

        return Visibility(
          // Default visible widget will be visible when usdVal is greater than equals to 0 and isHideSmallAmountAssets is false
          visible: usdBalance >= 0 && !model.isHideSmallAmountAssets,
          child: _coinDetailsCard(
              '$name', index, model.wallets, model.elevation, context, model),
          // Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
          replacement: Visibility(
              visible: model.isHideSmallAmountAssets && usdBalance != 0,
              child: _coinDetailsCard('$name', index, model.wallets,
                  model.elevation, context, model)),
        );
      },
    );
  }
}

/*---------------------------------------------------------------------------------------------------------------------------------------------
                                                Coin Details Wallet Card
  ----------------------------------------------------------------------------------------------------------------------------------------------*/

Widget _coinDetailsCard(
    String tickerName,
    // double available,
    // double locked,
    // double assetsInExchange,
    // double usdValue,
    index,
    List<WalletBalance> wallets,
    elevation,
    context,
    WalletDashboardViewModel model) {
  String logoTicker = '';
  if (tickerName.toUpperCase() == 'BSTE') {
    tickerName = 'BST(ERC20)';
    logoTicker = 'BSTE';
  } else if (tickerName.toUpperCase() == 'DSCE') {
    tickerName = 'DSC(ERC20)';
    logoTicker = 'DSCE';
  } else if (tickerName.toUpperCase() == 'EXGE') {
    tickerName = 'EXG(ERC20)';
    logoTicker = 'EXGE';
  } else if (tickerName.toUpperCase() == 'FABE') {
    tickerName = 'FAB(ERC20)';
    logoTicker = 'FABE';
  } else if (tickerName.toUpperCase() == 'USDTX') {
    tickerName = 'USDT(TRC20)';
    logoTicker = 'USDTX';
  } else if (tickerName.toUpperCase() == 'USDT') {
    tickerName = 'USDT(ERC20)';
    logoTicker = 'USDT';
  } else if (tickerName.toUpperCase() == 'USDC') {
    tickerName = 'USDC(erc20)';
    logoTicker = 'USDC';
  } else if (tickerName.toUpperCase() == 'USDCX') {
    tickerName = 'USDC(trc20)';
    logoTicker = 'USDC';
  } else {
    logoTicker = tickerName;
  }
//  tickerName = model.walletService
//         .updateSpecialTokensTickerNameForTxHistory(tickerName)['tickerName'];
//     logoTicker = model.walletService
//         .updateSpecialTokensTickerNameForTxHistory(tickerName)['logoTicker'];

  return Card(
    color: globals.walletCardColor,
    elevation: elevation,
    child: InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onDoubleTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      onTap: () {
        model.routeWithWalletInfoArgs(wallets[index], WalletFeaturesViewRoute);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
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
                child: Image.network(
                    '$WalletCoinsLogoUrl${logoTicker.toLowerCase()}.png'),
                //asset('assets/images/wallet-page/$tickerName.png'),
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
                        model.isBusy
                            ? SizedBox(
                                child: Shimmer.fromColors(
                                baseColor: globals.red,
                                highlightColor: globals.white,
                                child: Text(
                                  wallets[index].balance.toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ))
                            : Expanded(
                                child: Text(
                                    wallets[index].balance.isNegative
                                        ? '0.0'
                                        : NumberUtil()
                                            .truncateDoubleWithoutRouding(
                                                model.wallets[index].balance,
                                                precision: 6)
                                            .toString(),
                                    style:
                                        Theme.of(context).textTheme.headline6),
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
                        model.isBusy
                            ? SizedBox(
                                child: Shimmer.fromColors(
                                baseColor: globals.red,
                                highlightColor: globals.white,
                                child: Text('${wallets[index].lockBalance}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(color: red)),
                              ))
                            : Expanded(
                                child: Text(
                                    wallets[index].lockBalance.isNegative
                                        ? '0.0'
                                        : NumberUtil()
                                            .truncateDoubleWithoutRouding(
                                                model
                                                    .wallets[index].lockBalance,
                                                precision: 6)
                                            .toString(),
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
                            child: Text(AppLocalizations.of(context).inExchange,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        ),
                        model.isBusy
                            ? SizedBox(
                                child: Shimmer.fromColors(
                                baseColor: globals.primaryColor,
                                highlightColor: globals.white,
                                child: Text(
                                  wallets[index]
                                      .unlockedExchangeBalance
                                      .toStringAsFixed(4),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ))
                            : Expanded(
                                child: Text(
                                    wallets[index].unlockedExchangeBalance == 0
                                        ? '0.0'
                                        : NumberUtil()
                                            .truncateDoubleWithoutRouding(
                                                wallets[index]
                                                    .unlockedExchangeBalance,
                                                precision: 6)
                                            .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(color: globals.primaryColor)),
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
                    model.isBusy
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('\$',
                                  style: TextStyle(color: globals.green)),
                              Expanded(
                                child: Shimmer.fromColors(
                                  baseColor: globals.grey,
                                  highlightColor: globals.white,
                                  child: Text(
                                    '${NumberUtil().truncateDoubleWithoutRouding(model.wallets[index].balance * model.wallets[index].usdValue.usd, precision: 2).toString()}',
                                    style: TextStyle(color: globals.green),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('\$',
                                  style: TextStyle(color: globals.green)),
                              Expanded(
                                child:
                                    // model.formattedUsdValueList.isEmpty ||
                                    //         model.formattedUsdValueList == null
                                    //     ? Shimmer.fromColors(
                                    //         baseColor: globals.grey,
                                    //         highlightColor: globals.white,
                                    //         child:
                                    Text(
                                  '${NumberUtil().truncateDoubleWithoutRouding(model.wallets[index].balance * model.wallets[index].usdValue.usd, precision: 2).toString()}',
                                  style: TextStyle(color: globals.green),
                                ),
                              )
                              // : Text(
                              //     '${model.formattedUsdValueList[index]} USD',
                              //     textAlign: TextAlign.start,
                              //     style: TextStyle(color: globals.green)),
                              // ),
                            ],
                          ),

                    // Deposit and Withdraw Container Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        DepositWidget(
                            model: model, index: index, tickerName: tickerName),
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
                              model.routeWithWalletInfoArgs(
                                  model.wallets[index], WithdrawViewRoute);
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

// FAB TAB

class FavTab extends ViewModelBuilderWidget<WalletDashboardViewModel> {
  @override
  void onViewModelReady(WalletDashboardViewModel model) async {
    await model.buildFavCoinListV1();
  }

  @override
  Widget builder(
      BuildContext context, WalletDashboardViewModel model, Widget child) {
    print('fav list length before');
    print(model.favWallets.length);
    return model.busy(model.favWallets)
        ? model.sharedService.loadingIndicator()
        : Container(
            child: model.favWallets.isEmpty || model.favWallets == null
                ? Center(
                    child: Image.asset(
                      'assets/images/icons/wallet_empty.png',
                      color: Colors.grey,
                      width: 40,
                      height: 40,
                    ),
                    //Text('Favorite list empty'),
                  )
                :
                //Text('test'));
                Container(
                    child: ListView.builder(
                        controller: model.walletsScrollController,
                        // itemExtent: 95,
                        shrinkWrap: true,
                        itemCount: model.favWallets.length,
                        itemBuilder: (BuildContext context, int index) {
                          var tickerName =
                              model.favWallets[index].coin.toLowerCase();

                          String logoTicker = '';
                          if (tickerName.toUpperCase() == 'BSTE') {
                            tickerName = 'BST(ERC20)';
                            logoTicker = 'BSTE';
                          } else if (tickerName.toUpperCase() == 'DSCE') {
                            tickerName = 'DSC(ERC20)';
                            logoTicker = 'DSCE';
                          } else if (tickerName.toUpperCase() == 'EXGE') {
                            tickerName = 'EXG(ERC20)';
                            logoTicker = 'EXGE';
                          } else if (tickerName.toUpperCase() == 'FABE') {
                            tickerName = 'FAB(ERC20)';
                            logoTicker = 'FABE';
                          } else if (tickerName.toUpperCase() == 'USDTX') {
                            tickerName = 'USDT(TRC20)';
                            logoTicker = 'USDTX';
                          } else if (tickerName.toUpperCase() == 'USDT') {
                            tickerName = 'USDT(ERC20)';
                            logoTicker = 'USDT';
                          } else if (tickerName.toUpperCase() == 'USDC') {
                            tickerName = 'USDC(erc20)';
                            logoTicker = 'USDC';
                          } else if (tickerName.toUpperCase() == 'USDCX') {
                            tickerName = 'USDC(trc20)';
                            logoTicker = 'USDC';
                          } else {
                            logoTicker = tickerName;
                          }

                          return Card(
                            color: globals.walletCardColor,
                            elevation: model.elevation,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                model.routeWithWalletInfoArgs(
                                    model.favWallets[index],
                                    WalletFeaturesViewRoute);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
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
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: globals.fabLogoColor,
                                                  offset: Offset(1.0, 5.0),
                                                  blurRadius: 10.0,
                                                  spreadRadius: 1.0),
                                            ]),
                                        child: Image.network(
                                            '$WalletCoinsLogoUrl${logoTicker.toLowerCase()}.png'),
                                        //asset('assets/images/wallet-page/$tickerName.png'),
                                        width: 35,
                                        height: 35),
                                    UIHelper.horizontalSpaceSmall,
                                    // Tickername available locked and inexchange column
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '$tickerName'.toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                            // Available Row
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5.0),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .available,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6),
                                                ),
                                                model.isBusy
                                                    ? SizedBox(
                                                        child:
                                                            Shimmer.fromColors(
                                                        baseColor: globals.red,
                                                        highlightColor:
                                                            globals.white,
                                                        child: Text(
                                                          model
                                                              .favWallets[index]
                                                              .balance
                                                              .toStringAsFixed(
                                                                  2),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6,
                                                        ),
                                                      ))
                                                    : Expanded(
                                                        child: Text(
                                                            model
                                                                    .favWallets[
                                                                        index]
                                                                    .balance
                                                                    .isNegative
                                                                ? '0.0'
                                                                : NumberUtil()
                                                                    .truncateDoubleWithoutRouding(
                                                                        model
                                                                            .favWallets[
                                                                                index]
                                                                            .balance,
                                                                        precision:
                                                                            6)
                                                                    .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6),
                                                      ),
                                              ],
                                            ),
                                            // Locked Row
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2.0,
                                                          right: 5.0,
                                                          bottom: 2.0),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .locked,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              color: red)),
                                                ),
                                                model.isBusy
                                                    ? SizedBox(
                                                        child:
                                                            Shimmer.fromColors(
                                                        baseColor: globals.red,
                                                        highlightColor:
                                                            globals.white,
                                                        child: Text(
                                                            '${model.favWallets[index].lockBalance}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                    color:
                                                                        red)),
                                                      ))
                                                    : Expanded(
                                                        child: Text(
                                                            model
                                                                    .favWallets[
                                                                        index]
                                                                    .lockBalance
                                                                    .isNegative
                                                                ? '0.0'
                                                                : NumberUtil()
                                                                    .truncateDoubleWithoutRouding(
                                                                        model
                                                                            .favWallets[
                                                                                index]
                                                                            .lockBalance,
                                                                        precision:
                                                                            6)
                                                                    .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                    color:
                                                                        red)),
                                                      )
                                              ],
                                            ),
                                            // Inexchange Row
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0),
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .inExchange,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6),
                                                  ),
                                                ),
                                                model.isBusy
                                                    ? SizedBox(
                                                        child:
                                                            Shimmer.fromColors(
                                                        baseColor: globals
                                                            .primaryColor,
                                                        highlightColor:
                                                            globals.white,
                                                        child: Text(
                                                          model
                                                              .favWallets[index]
                                                              .unlockedExchangeBalance
                                                              .toStringAsFixed(
                                                                  4),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6,
                                                        ),
                                                      ))
                                                    : Expanded(
                                                        child: Text(
                                                            model
                                                                        .favWallets[
                                                                            index]
                                                                        .unlockedExchangeBalance ==
                                                                    0
                                                                ? '0.0'
                                                                : NumberUtil()
                                                                    .truncateDoubleWithoutRouding(
                                                                        model
                                                                            .favWallets[
                                                                                index]
                                                                            .unlockedExchangeBalance,
                                                                        precision:
                                                                            6)
                                                                    .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                    color: globals
                                                                        .primaryColor)),
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
                                            model.isBusy
                                                ? Row(
                                                    children: [
                                                      Text('\$',
                                                          style: TextStyle(
                                                              color: globals
                                                                  .green)),
                                                      Expanded(
                                                        child:
                                                            Shimmer.fromColors(
                                                          baseColor:
                                                              globals.grey,
                                                          highlightColor:
                                                              globals.white,
                                                          child: Text(
                                                            '${NumberUtil().truncateDoubleWithoutRouding(model.favWallets[index].balance * model.favWallets[index].usdValue.usd, precision: 2).toString()}',
                                                            style: TextStyle(
                                                                color: globals
                                                                    .green),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Text('\$',
                                                          style: TextStyle(
                                                              color: globals
                                                                  .green)),
                                                      Expanded(
                                                        child: Text(
                                                            '${NumberUtil().truncateDoubleWithoutRouding(model.wallets[index].balance * model.wallets[index].usdValue.usd, precision: 2).toString()} USD',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: globals
                                                                    .green)),
                                                      ),
                                                    ],
                                                  ),

                                            // Deposit and Withdraw Container Row
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                InkWell(
                                                    child: tickerName.toUpperCase() ==
                                                                'FAB' &&
                                                            (model.isShowCaseView ||
                                                                model.gasAmount <
                                                                    0.01) &&
                                                            !model.isBusy
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0,
                                                                    right: 5.0,
                                                                    left: 2.0),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .deposit,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle2
                                                                      .copyWith(
                                                                          fontSize:
                                                                              8),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .arrow_downward,
                                                                    color: globals
                                                                        .green,
                                                                    size: 16),
                                                              ],
                                                            ))
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0,
                                                                    right: 5.0,
                                                                    left: 2.0),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .deposit,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle2
                                                                      .copyWith(
                                                                          fontSize:
                                                                              8),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .arrow_downward,
                                                                    color: globals
                                                                        .green,
                                                                    size: 16),
                                                              ],
                                                            )),
                                                    onTap: () => model
                                                        .routeWithWalletInfoArgs(
                                                            model
                                                                .favWallets[index],
                                                            DepositViewRoute)),
                                                Divider(
                                                  endIndent: 5,
                                                ),
                                                InkWell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .withdraw,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .subtitle2
                                                                .copyWith(
                                                                    fontSize:
                                                                        8),
                                                          ),
                                                          Icon(
                                                            Icons.arrow_upward,
                                                            color: globals.red,
                                                            size: 16,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () => model
                                                        .routeWithWalletInfoArgs(
                                                            model.favWallets[
                                                                index],
                                                            WithdrawViewRoute)),
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

                        //                   //   Visibility(
                        //                   //     // Default visible widget will be visible when usdVal is greater than equals to 0 and isHideSmallAmountAssets is false
                        //                   //     visible: usdVal >= 0 && !model.isHideSmallAmountAssets,
                        //                   //     child: _coinDetailsCard(
                        //                   //         '$name',
                        //                   //         index,
                        //                   //         model.favWallets,
                        //                   //         model.elevation,
                        //                   //         context,
                        //                   //         model),
                        //                   //     //    Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
                        //                   //     replacement: Visibility(
                        //                   //         visible:
                        //                   //             model.isHideSmallAmountAssets && usdVal != 0,
                        //                   //         child: _coinDetailsCard(
                        //                   //             '$name',
                        //                   //             index,
                        //                   //             model.favWallets,
                        //                   //             model.elevation,
                        //                   //             context,
                        //                   //             model)),
                        //                   //   );
                        //                   // },
                        //                   ),
                        //               // SmartRefresher(
                        //               //   enablePullDown: true,
                        //               //   // header: Theme.of(context).platform == TargetPlatform.iOS
                        //               //   //     ? ClassicHeader()
                        //               //   //     : MaterialClassicHeader(),
                        //               //   controller: model.refreshController,
                        //               //   onRefresh: model.onRefresh,
                        //               //   child:
                        //               //       //Text(model.favWallets.length.toString())

                        //               // ),
                        //             ),
                        )));
  }

  @override
  WalletDashboardViewModel viewModelBuilder(BuildContext context) =>
      WalletDashboardViewModel();
}

/*----------------------------------------------------------------------
                      Total Balance Widget
----------------------------------------------------------------------*/

class TotalBalanceWidget extends StatelessWidget {
  const TotalBalanceWidget({Key key, this.model}) : super(key: key);
  final WalletDashboardViewModel model;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
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
              //duration: Duration(milliseconds: 250),
              width: 300,
              //model.totalBalanceContainerWidth,
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  //Announcement Widget
                  model.announceList == null || model.announceList.length < 1
                      ? Image.asset(
                          'assets/images/wallet-page/dollar-sign.png',
                          width: 25,
                          height: 25,
                          color: globals
                              .iconBackgroundColor, // image background color
                          fit: BoxFit.cover,
                        )
                      : Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: InkWell(
                                      onTap: () {
                                        if (!model.hasApiError)
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AnnouncementList()))
                                              .then((value) {
                                            model.updateAnnce();
                                          });
                                        else
                                          print("API has error");
                                      },
                                      child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: globals.iconBackgroundColor,
                                          ),
                                          child: Icon(Icons.mail_outline,
                                              color: globals.walletCardColor)),
                                    )),
                              ),
                            ),
                            model.unreadMsgNum < 1
                                ? Container()
                                : Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red),
                                      child: Center(
                                        child: Text(
                                          // model
                                          //     .announceList
                                          //     .length
                                          //     .toString(),
                                          model.unreadMsgNum.toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ))
                          ],
                        ), //Announcement Widget end
                  UIHelper.horizontalSpaceSmall,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).totalWalletBalance,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w400)),
                        model.isBusy
                            ? Shimmer.fromColors(
                                baseColor: globals.primaryColor,
                                highlightColor: globals.white,
                                child: Text(
                                  '${model.totalUsdBalance} USD',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            : Text('${model.totalUsdBalance} USD',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.w400)),
                        UIHelper.verticalSpaceSmall,
                        model.isBusy
                            ? Container()
                            : Row(
                                children: [
                                  // Column(
                                  //   children: [
                                  //     Text(AppLocalizations.of(context).walletbalance,
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .headline6
                                  //             .copyWith(fontWeight: FontWeight.w400)),
                                  //     Text(model.totalWalletBalance,
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .headline6
                                  //             .copyWith(fontWeight: FontWeight.w400)),
                                  //   ],
                                  // ),
                                  UIHelper.horizontalSpaceSmall,
                                  Padding(
                                    padding: const EdgeInsets.only(right: 3.0),
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .totalExchangeBalance,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: grey)),
                                  ),
                                  Text(model.totalExchangeBalance + ' USD',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: grey)),
                                ],
                              ),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        await model.refreshBalancesV2();
                      },
                      child: model.isBusy
                          ? Container(
                              margin: EdgeInsets.only(left: 3.0),
                              child: SizedBox(
                                child: model.sharedService.loadingIndicator(),
                                width: 16,
                                height: 16,
                              ),
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
    );
  }
}

class AddGasRow extends StatelessWidget {
  const AddGasRow({Key key, this.model}) : super(key: key);
  final WalletDashboardViewModel model;

  // @override
  // void initState() {
  //   super.initState();
  //   widget.model.globalKeyOne = _one;

  //   widget.model.showcaseEvent(context);
  // }

  @override
  Widget build(BuildContext context) {
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var tween = Tween(begin: begin, end: end);
    if (model.isShowCaseView && model.gasAmount < 0.5 && !model.isBusy)
      model.showcaseEvent(context);
    return model.isShowCaseView || model.gasAmount < 0.5
        ? SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Showcase(
                  key: model.globalKeyOne,
                  //  titleTextStyle:TextStyle(decoration:T ),
                  title: AppLocalizations.of(context).note + ':',
                  description:
                      AppLocalizations.of(context).walletDashboardInstruction1,
                  child: TweenAnimationBuilder(
                      duration: Duration(milliseconds: 500),
                      tween: tween,
                      builder: (_, Offset offset, __) {
                        return Container(
                            child: (Gas(gasAmount: model.gasAmount)));
                      }),
                ),
              ],
            ),
          )
        : Gas(gasAmount: model.gasAmount);
  }
}

class DepositWidget extends StatelessWidget {
  const DepositWidget({Key key, this.model, this.index, this.tickerName})
      : super(key: key);

  final WalletDashboardViewModel model;
  final int index;
  final String tickerName;

  @override
  Widget build(BuildContext context) {
    // model.showcaseEvent(context);
    return InkWell(
        child: tickerName.toUpperCase() == 'FAB' &&
                (model.isShowCaseView || model.gasAmount < 0.5) &&
                !model.isBusy
            ? Showcase(
                key: model.globalKeyTwo,
                descTextStyle: TextStyle(fontSize: 9, color: black),
                description:
                    AppLocalizations.of(context).walletDashboardInstruction2,
                child: buildPaddingDeposit(context),
              )
            : buildPaddingDeposit(context),
        onTap: () => model.routeWithWalletInfoArgs(
            model.wallets[index], DepositViewRoute));
  }

  Padding buildPaddingDeposit(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 5.0, left: 2.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context).deposit,
              style:
                  Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 8),
            ),
            Icon(Icons.arrow_downward, color: globals.green, size: 16),
          ],
        ));
  }
}
