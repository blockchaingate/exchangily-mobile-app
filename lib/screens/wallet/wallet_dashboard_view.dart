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
import 'package:exchangilymobileapp/constants/ui_var.dart';
import 'package:exchangilymobileapp/enums/connectivity_status.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/core_wallet_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_balance.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/screens/announcement/anncounceList.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/wallet_features_view.dart';
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
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => WalletDashboardViewModel(),
        onModelReady: (WalletDashboardViewModel model) async {
          model.context = context;
          model.globalKeyOne = _one;
          model.globalKeyTwo = _two;
          model.refreshController = _refreshController;
          //  await model.retrieveWalletsFromLocalDatabase();
          await model.init();
        },
        onDispose: () {
          _refreshController.dispose();
          print('_refreshController disposed in wallet dashboard view');
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
              endDrawerEnableOpenDragGesture: true,
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
                    builder: (context) => mainWidgets(model, context),
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavBar(count: 0),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: model.busy(model.selectedCustomTokens)
                  ? Container()
                  : Container(
                      // color: red,
                      width: 120,
                      child: model.currentTabSelection == 1
                          ? IconButton(
                              iconSize: model.selectedCustomTokens.isNotEmpty
                                  ? 20
                                  : 26,
                              icon: Row(
                                children: [
                                  Icon(
                                    model.selectedCustomTokens.isNotEmpty
                                        ? Icons.mode_edit_outline_outlined
                                        : Icons.add,
                                    color: model.selectedCustomTokens.isNotEmpty
                                        ? yellow
                                        : green,
                                  ),
                                  Expanded(
                                    child: model.selectedCustomTokens.isNotEmpty
                                        ? Text(
                                            ' ' +
                                                AppLocalizations.of(context)
                                                    .editTokenList,
                                            style: TextStyle(
                                                color: white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            ' ' +
                                                AppLocalizations.of(context)
                                                    .addToken,
                                            style: TextStyle(
                                                color: white, fontSize: 10)),
                                  ),
                                ],
                              ),
                              onPressed: () =>
                                  model.showCustomTokensBottomSheet(),
                            )
                          : Container(),
                    ),
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

        var usdBalance = (!model.wallets[index].balance.isNegative
                ? model.wallets[index].balance
                : 0.0) *
            model.wallets[index].usdValue.usd;

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

Widget mainWidgets(WalletDashboardViewModel model, BuildContext context) {
  return Column(
    children: <Widget>[
      LayoutBuilder(builder: (BuildContext ctx, BoxConstraints constraints) {
        if (constraints.maxWidth < largeSize) {
          return Container(
            height: MediaQuery.of(context).padding.top,
          );
        } else {
          return Container(
            child: Column(
              children: <Widget>[
                topWidget(model, context),
                amountAndGas(model, context),
              ],
            ),
          );
        }
      }),

      /*------------------------------------------------------------------------------
                                        Build Wallet List Container
        -------------------------------------------------------------------------------*/
      //   !Platform.isAndroid
      //      ?
      Expanded(
        child: LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
          if (constraints.maxWidth < largeSize) {
            return coinList(model, ctx);
            // return tester();
          } else {
            return Container(
              // color: Colors.amber,
              child: Row(
                children: [
                  SizedBox(
                      width: 300,
                      height: double.infinity,
                      child: coinList(model, ctx)),
                  Expanded(
                    child: model.wallets == null
                        ? Container()
                        : WalletFeaturesView(walletInfo: model.rightWalletInfo),
                  )
                ],
              ),
            );
          }
        }),
      ),
    ],
  );
}

/*-------------------------------------------------------------------------------------
                Build Background, Logo Container with balance card
-------------------------------------------------------------------------------------*/
Widget topWidget(WalletDashboardViewModel model, BuildContext context) {
  return Container(
    height: 150,
    decoration: BoxDecoration(),
    child: Stack(children: <Widget>[
      Container(
          // height: 350.0,
          height: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/wallet-page/background.png'),
                  fit: BoxFit.cover))),
      Positioned(
        top: 10,
        left: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/wallet-page/exlogo.png',
                // width: 35,
                height: 35,
                color: white,
              ),
            ],
          ),
        ),
      ),

//                Total Balance Card

      Container(child: TotalBalanceWidget(model: model))
    ]),
  );
}

/*-----------------------------------------------------------------
                            Hide Small Amount Row
  -----------------------------------------------------------------*/
Widget amountAndGas(WalletDashboardViewModel model, BuildContext context) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(right: 10, top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
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
                                semanticLabel: 'Show all Amount Assets',
                                color: globals.primaryColor,
                              )
                            : Icon(
                                Icons.attach_money,
                                semanticLabel: 'Hide Small Amount Assets',
                                color: model.isShowFavCoins
                                    ? grey
                                    : globals.primaryColor,
                              ),
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            AppLocalizations.of(context).hideSmallAmountAssets,
                            style: model.isShowFavCoins
                                ? Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(wordSpacing: 1.25, color: grey)
                                : Theme.of(context)
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
                      width: 120,
                      height: 20,
                      child: OutlinedButton.icon(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(0))),
                          onPressed: () => model.getFreeFab(),
                          icon: Icon(
                            Icons.add,
                            size: 18,
                            color: white,
                          ),
                          label: Text(
                            AppLocalizations.of(context).getFree + ' FAB',
                            style: Theme.of(context).textTheme.headline6,
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
                      padding: const EdgeInsets.only(left: 5.0),
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
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 30,
                        child: TextField(
                          enabled: model.isShowFavCoins ? false : true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 1),
                              ),
                              // helperText: 'Search',
                              // helperStyle:
                              //     Theme.of(context).textTheme.bodyText1,
                              suffixIcon: Icon(Icons.search, color: white)),
                          controller: model.searchCoinTextController,
                          onChanged: (String value) {
                            model.isShowFavCoins
                                ? model.searchFavCoinsByTickerName(value)
                                : model.searchCoinsByTickerName(value);
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
              child: Text(AppLocalizations.of(context).updateWallet),
              onPressed: () => model.updateWallet(),
            ))
          : Container(),
    ],
  );
}

//coin list
Widget coinList(WalletDashboardViewModel model, BuildContext context) {
  var top = 0.0;
  return DefaultTabController(
      length: 3,
      initialIndex: model.currentTabSelection,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            MediaQuery.of(context).size.width < largeSize
                ? SliverAppBar(
                    elevation: 0,
                    backgroundColor: secondaryColor,
                    expandedHeight: 120.0,
                    floating: false,
                    pinned: true,
                    leading: Container(),
                    flexibleSpace: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      // print('constraints=' + constraints.toString());
                      top = constraints.biggest.height;
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.all(0),
                        title: AnimatedOpacity(
                          duration: Duration(milliseconds: 50),
                          opacity: top ==
                                  MediaQuery.of(context).padding.top +
                                      kToolbarHeight
                              ? 1.0
                              : 0.0,
                          child: TotalBalanceWidget(model: model),
                        ),
                        background: topWidget(model, context),
                      );
                    }))
                : SliverToBoxAdapter(),
            SliverToBoxAdapter(
                child: MediaQuery.of(context).size.width < largeSize
                    ? amountAndGas(model, context)
                    : Container()),
            SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  new TabBar(
                      // labelPadding: EdgeInsets.only(bottom: 14, top: 14),
                      onTap: (int tabIndex) {
                        model.updateTabSelection(tabIndex);
                      },
                      labelColor: white,
                      unselectedLabelColor: primaryColor,
                      indicatorColor: primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          icon: Icon(
                            FontAwesomeIcons.coins,
                            // color: white,
                            size: 16,
                          ),
                          iconMargin: EdgeInsets.only(bottom: 3),
                          // child: Text(
                          //     model.walletInfoCopy.length.toString(),
                          //     style: TextStyle(fontSize: 10, color: grey))
                        ),
                        // custom tokens
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.dashboard_customize,
                                  color: primaryColor, size: 16),
                              Text(
                                  ' ' +
                                      AppLocalizations.of(context).customTokens,
                                  style: TextStyle(fontSize: 10, color: white)),
                              // UIHelper.horizontalSpaceSmall,
                              // Text(model.selectedCustomTokens.length.toString(),
                              //     style: TextStyle(fontSize: 10, color: grey))
                            ],
                          ),
                        ),
                        Tab(
                          icon: Icon(Icons.star,
                              // color: primaryColor,
                              size: 18),
                          iconMargin: EdgeInsets.only(bottom: 3),
                          // child: Text(
                          //     model.favWalletInfoList.length.toString(),
                          //     style: TextStyle(fontSize: 10, color: grey)),
                        )
                      ]),
                ))
          ];
        },
        body: Container(
          // color: Colors.amber,
          margin: EdgeInsets.only(top: 0),
          padding: EdgeInsets.only(top: 0),
          child: TabBarView(
            //  physics: ClampingScrollPhysics(),
            children: [
              // All coins tab

              model.isBusy
                  ? ShimmerLayout(
                      layoutType: 'walletDashboard',
                      count: 9,
                    )
                  : buildListView(model),

              model.busy(model.selectedCustomTokens)
                  ? model.sharedService.loadingIndicator()
                  : model.selectedCustomTokens.isEmpty
                      ? Center(
                          child: Image.asset(
                            'assets/images/icons/wallet_empty.png',
                            color: Colors.grey,
                            width: 40,
                            height: 40,
                          ),
                          //Text('Favorite list empty'),
                        )
                      : Column(
                          children: [
                            UIHelper.verticalSpaceSmall,
                            // symbol balance action text row
                            Container(
                              color: globals.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Row(
                                children: [
                                  Text(AppLocalizations.of(context).logo),
                                  UIHelper.horizontalSpaceMedium,
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                          AppLocalizations.of(context).symbol)),
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        AppLocalizations.of(context).balance,
                                        textAlign: TextAlign.center,
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                          AppLocalizations.of(context).action))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: ListView.builder(
                                  padding: EdgeInsets.only(top: 0),
                                  shrinkWrap: true,
                                  itemCount: model.selectedCustomTokens.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var customToken =
                                        model.selectedCustomTokens[index];
                                    return Container(
                                      padding: EdgeInsets.all(3),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // logo

                                          Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                      'https://test.blockchaingate.com/v2/issuetoken/${customToken.tokenId}/logo',
                                                    ),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                          ),
                                          UIHelper.horizontalSpaceMedium,
                                          UIHelper.horizontalSpaceSmall,
                                          // Symbol and name
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                // UIHelper
                                                //     .verticalSpaceSmall,
                                                Text(
                                                  customToken.symbol
                                                      .toUpperCase(),
                                                  style: TextStyle(color: grey),
                                                ),
                                                Text(
                                                  customToken.name,
                                                  style:
                                                      TextStyle(color: white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          UIHelper.horizontalSpaceSmall,
                                          // Balance
                                          Expanded(
                                            flex: 2,
                                            child: model.busy(
                                                    model.selectedCustomTokens)
                                                ? Text('...')
                                                : Text(
                                                    customToken.balance
                                                        .toString(),
                                                    style:
                                                        TextStyle(color: white),
                                                    textAlign: TextAlign.center,
                                                  ),
                                          ),

                                          // Send Action
                                          Container(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(2),
                                                  child: IconButton(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .zero,
                                                    onPressed: () {
                                                      var wi = WalletInfo(
                                                          address: customToken
                                                              .owner);
                                                      model.navigationService
                                                          .navigateTo(
                                                              ReceiveViewRoute,
                                                              arguments: wi);
                                                    },
                                                    icon: Column(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .download_for_offline_rounded,
                                                          color: green,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .receive,
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color:
                                                                      white)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.all(2),
                                                  child: IconButton(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .zero,
                                                    onPressed: () {
                                                      model.sendCustomToken(
                                                          customToken);
                                                    },
                                                    icon: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.send_rounded,
                                                          color: primaryColor,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .send,
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color:
                                                                      white)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),

              FavTab(),
            ],
          ),
        ),
      ));
}

ListView buildListView(WalletDashboardViewModel model) {
  return ListView.builder(
    //  physics: ClampingScrollPhysics(),
    // controller: model.walletsScrollController,
    padding: EdgeInsets.only(top: 0),
    shrinkWrap: true,
    itemCount: model.wallets.length,
    itemBuilder: (BuildContext context, int index) {
      var name = model.wallets[index].coin.toLowerCase();
      var usdVal = model.wallets[index].usdValue;

      return Visibility(
        // Default visible widget will be visible when usdVal is greater than equals to 0 and isHideSmallAmountAssets is false
        visible: usdVal.usd >= 0 && !model.isHideSmallAmountAssets,
        child: _coinDetailsCard(
            '$name', index, model.wallets, model.elevation, context, model),
        // Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
        replacement: Visibility(
            visible: model.isHideSmallAmountAssets && usdVal != 0,
            child: _coinDetailsCard('$name', index, model.wallets,
                model.elevation, context, model)),
      );
    },
  );
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
                                        .copyWith(color: white)),
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
                                    '${NumberUtil().truncateDoubleWithoutRouding((!model.wallets[index].balance.isNegative ? model.wallets[index].balance : 0.0) * model.wallets[index].usdValue.usd, precision: 2).toString()}',
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
                                  '${NumberUtil().truncateDoubleWithoutRouding((!model.wallets[index].balance.isNegative ? model.wallets[index].balance : 0.0) * model.wallets[index].usdValue.usd, precision: 2).toString()}',
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
                        })));
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
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
            bottom: -15,
            right: 30,
            left: 30,
            child: Card(
              elevation: model.elevation,
              color: isProduction
                  ? globals.secondaryColor
                  : globals.red.withAlpha(200),
              child: Container(
                //duration: Duration(milliseconds: 250),
                width: 350,
                //model.totalBalanceContainerWidth,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Announcement Widget
                    Expanded(
                      flex: 1,
                      child: model.announceList == null ||
                              model.announceList.length < 1
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
                                        width: 40,
                                        height: 40,
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
                                                color:
                                                    globals.iconBackgroundColor,
                                              ),
                                              child: Icon(Icons.mail_outline,
                                                  color:
                                                      globals.walletCardColor)),
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
                    ),
                    Expanded(
                      flex: 3,
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
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
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
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    UIHelper.horizontalSpaceSmall,
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 3.0),
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
                                    Shimmer.fromColors(
                                      baseColor: globals.primaryColor,
                                      highlightColor: globals.white,
                                      child: Text(
                                          model.totalExchangeBalance + ' USD',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: grey)),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    UIHelper.horizontalSpaceSmall,
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 3.0),
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
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () => model.refreshBalancesV2(),
                          icon: model.isBusy
                              ? Container(
                                  margin: EdgeInsets.only(left: 3.0),
                                  child: model.sharedService.loadingIndicator(),
                                )
                              : Icon(
                                  Icons.refresh,
                                  color: globals.white,
                                  size: 28,
                                )),
                    )
                  ],
                ),
              ),
            )),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
      color: secondaryColor,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
