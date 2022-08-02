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
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/constants/ui_var.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_balance.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/screens/announcement/anncounceList.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/wallet_features_view.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layouts/shimmer_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stacked/stacked.dart';
import 'wallet_features/gas.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';

class WalletDashboardView extends StatelessWidget {
  const WalletDashboardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey _one = GlobalKey();
    GlobalKey _two = GlobalKey();
    final key = GlobalKey<ScaffoldState>();
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
          debugPrint('_refreshController disposed in wallet dashboard view');
        },
        builder: (context, WalletDashboardViewModel model, child) {
          // var connectionStatus = Provider.of<ConnectivityStatus>(context);
          // if (connectionStatus == ConnectivityStatus.Offline)
          //   return NetworkStausView();
          // else

          return WillPopScope(
            onWillPop: () {
              model.onBackButtonPressed();
              return Future(() => false);
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
                      debugPrint('onStart: $index, $key');
                    },
                    onComplete: (index, key) {
                      debugPrint('onComplete: $index, $key');
                    },
                    onFinish: () {
                      model.storageService.isShowCaseView = false;

                      model.updateShowCaseViewStatus();
                    },
                    builder: Builder(
                      builder: (context) {
                        return Column(
                          children: <Widget>[
                            LayoutBuilder(builder:
                                (BuildContext ctx, BoxConstraints constraints) {
                              if (constraints.maxWidth < largeSize) {
                                return Container(
                                  height: MediaQuery.of(context).padding.top,
                                );
                              } else {
                                return Column(
                                  children: <Widget>[
                                    topWidget(model, context),
                                    amountAndGas(model, context),
                                  ],
                                );
                              }
                            }),
                            Expanded(
                              child: LayoutBuilder(builder: (BuildContext ctx,
                                  BoxConstraints constraints) {
                                if (constraints.maxWidth < largeSize) {
                                  return coinList(model, ctx);
                                } else {
                                  return Row(
                                    children: [
                                      SizedBox(
                                          width: 300,
                                          height: double.infinity,
                                          child: coinList(model, ctx)),
                                      Expanded(
                                        child: model.wallets == null
                                            ? Container()
                                            : WalletFeaturesView(
                                                walletInfo:
                                                    model.rightWalletInfo),
                                      )
                                    ],
                                  );
                                }
                              }),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                bottomNavigationBar: BottomNavBar(count: 0),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: model.busy(model.selectedCustomTokens)
                    ? Container()
                    : Visibility(
                        visible: model.currentTabSelection == 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: model.currentTabSelection == 2
                                ? primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          width:
                              model.selectedCustomTokens.isNotEmpty ? 140 : 120,
                          child: GestureDetector(
                            onTap: () => model.showCustomTokensBottomSheet(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UIHelper.horizontalSpaceSmall,
                                  Icon(
                                    model.selectedCustomTokens.isNotEmpty
                                        ? Icons.mode_edit_outline_outlined
                                        : FontAwesomeIcons.plus,
                                    size: model.selectedCustomTokens.isNotEmpty
                                        ? 16
                                        : 14,
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
                                            style: const TextStyle(
                                                color: white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            ' ' +
                                                AppLocalizations.of(context)
                                                    .addToken,
                                            style: const TextStyle(
                                                color: white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
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
          visible: usdBalance >= 0 && !model.isHideSmallAssetsButton,
          child: _coinDetailsCard(
              name, index, model.wallets, model.elevation, context, model),
          // Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
          replacement: Visibility(
              visible: model.isHideSmallAssetsButton && usdBalance != 0,
              child: _coinDetailsCard(
                  name, index, model.wallets, model.elevation, context, model)),
        );
      },
    );
  }
}

/*-------------------------------------------------------------------------------------
                Build Background, Logo Container with balance card
-------------------------------------------------------------------------------------*/
Widget topWidget(WalletDashboardViewModel model, BuildContext context) {
  return Container(
    height: 160,
    decoration: const BoxDecoration(),
    child: Stack(children: <Widget>[
      Container(
          // height: 350.0,
          height: 140,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Constants.walletBackgroundLocalUrl),
                  fit: BoxFit.cover))),
      Positioned(
        top: 15,
        left: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Constants.excahngilyLogoLocalUrl,
                // width: 35,
                height: 30,
                color: white,
              ),
            ],
          ),
        ),
      ),

      Swiper(
        itemBuilder: (BuildContext context, int index) {
          // Total Balance Card //
          model.swiperWidgetIndex = index;

          Widget logoWidget;
          String titleWidget;
          if (index == 0) {
            // logoWidget = Image.asset(
            //   Constants.dollarSignImageLocalUrl,
            //   width: 30,
            //   height: 30,
            //   color: iconBackgroundColor, // image background color
            //   fit: BoxFit.contain,
            // );
            // titleWidget = AppLocalizations.of(context).totalWalletBalance;
            return TotalBalanceWidget(model: model, index: index);
          } else if (index == 1) {
            // logoWidget = Container(
            //     decoration: BoxDecoration(
            //         color: iconBackgroundColor, shape: BoxShape.circle),
            //     width: 30,
            //     height: 30,
            //     child: Icon(
            //       // Icons.local_gas_station,
            //       MdiIcons.finance,
            //       color: isProduction ? secondaryColor : red.withAlpha(200),
            //     ));
            // titleWidget = AppLocalizations.of(context).totalExchangeBalance;
            return TotalBalanceWidget2(model: model, index: index);
          }

          // return TotalBalanceCardWidget(
          //   logo: logoWidget,
          //   title: titleWidget,
          // );
        },
        itemCount: 2,
        itemWidth: 500,
        itemHeight: 180.0,
        layout: SwiperLayout.TINDER,
        pagination: const SwiperPagination(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
          builder: DotSwiperPaginationBuilder(
            color: Color(0xccffffff),
          ),
        ),
        autoplay: true,
        autoplayDelay: 7000,
      ),
      // Align(
      //     alignment: Alignment.center,
      //     child: ElevatedButton(
      //         onPressed: (() => model.test()), child: Text('CLICK'))),
      Positioned(
        top: 15,
        child: Stack(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Center(
                child: Container(
                    width: 40,
                    height: 40,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    child: InkWell(
                      onTap: () {
                        if (!model.hasApiError) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AnnouncementList())).then((value) {
                            model.updateAnnce();
                          });
                        } else {
                          debugPrint("API has error");
                        }
                      },
                      child: const SizedBox(
                          width: 40,
                          height: 40,
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          //   color: iconBackgroundColor,
                          // ),
                          child: Icon(
                            Icons.mail,
                            size: 20,
                            color: Color(0xbbffffff),
                          )),
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
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: Center(
                        child: Text(
                          // model
                          //     .announceList
                          //     .length
                          //     .toString(),
                          model.unreadMsgNum.toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ))
          ],
        ), //Announcement Widget end
      ),
      //Refresh BalancesV2
      Positioned(
          top: 15,
          right: 5,
          child: IconButton(
              onPressed: () {
                if (model.currentTabSelection == 0) {
                  model.refreshBalancesV2();
                  debugPrint('getting wallet coins balance');
                } else if (model.currentTabSelection == 2) {
                  model.getBalanceForSelectedCustomTokens();
                  debugPrint('getting custom token balance');
                }
              },
              icon: model.isBusy || model.busy(model.selectedCustomTokens)
                  ? Container(
                      margin: const EdgeInsets.only(left: 3.0),
                      child: model.sharedService.loadingIndicator(),
                    )
                  : const Icon(
                      Icons.refresh,
                      color: Color(0xbbffffff),
                      size: 22,
                    ))),
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
        padding: const EdgeInsets.only(right: 10, top: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: InkWell(
                onTap: () {
                  model.isShowFavCoins || model.isHideSearch
                      ? debugPrint('...just printing...')
                      : model.hideSmallAmountAssets();
                },
                child: Row(
                  children: <Widget>[
                    !model.isHideSmallAssetsButton
                        ? const Icon(
                            Icons.money_off,
                            semanticLabel: 'Show all Amount Assets',
                            color: primaryColor,
                          )
                        : Icon(
                            Icons.attach_money,
                            semanticLabel: 'Hide Small Amount Assets',
                            color: model.isShowFavCoins || model.isHideSearch
                                ? grey
                                : primaryColor,
                          ),
                    Container(
                      width: 110,
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        !model.isHideSmallAssetsButton
                            ? AppLocalizations.of(context).hideSmallAmountAssets
                            : AppLocalizations.of(context)
                                .showSmallAmountAssets,
                        style: model.isShowFavCoins || model.isHideSearch
                            ? Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(wordSpacing: 1.25, color: grey)
                            : Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(wordSpacing: 1.25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: model.isEligibleForFreeGas ? 100 : 40,
              child: Column(
                children: [
                  model.isBusy
                      ? Container()
                      : Expanded(child: Gas(gasAmount: model.gasAmount)),
                  !model.isEligibleForFreeGas
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: SizedBox(
                            width: 120,
                            height: 20,
                            child: OutlinedButton.icon(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(0))),
                                onPressed: model.getFreeFab,
                                icon: const Icon(
                                  Icons.add,
                                  size: 14,
                                  color: white,
                                ),
                                label: Text(
                                  AppLocalizations.of(context).getFree + ' FAB',
                                  style: Theme.of(context).textTheme.headline6,
                                )),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 8.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            height: 30,
            child: TextField(
              enabled: model.isShowFavCoins ||
                      model.isHideSearch ||
                      model.isHideSmallAssetsButton
                  ? false
                  : true,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1),
                  ),
                  // helperText: 'Search',
                  // helperStyle:
                  //     Theme.of(context).textTheme.bodyText1,
                  suffixIcon: Icon(Icons.search, color: white)),
              controller: model.searchCoinTextController,
              onChanged: (String value) {
                model.isShowFavCoins ||
                        model.isHideSearch ||
                        model.isHideSmallAssetsButton
                    ? model.searchFavCoinsByTickerName(value)
                    : model.searchCoinsByTickerName(value);
              },
            ),
          ),
        ),
      ),
      UIHelper.verticalSpaceSmall,
      model.isUpdateWallet
          ? TextButton(
              child: Text(AppLocalizations.of(context).updateWallet),
              onPressed: () => model.updateWallet(),
            )
          : Container(),
    ],
  );
}

Widget coinList(WalletDashboardViewModel model, BuildContext context) {
  // final tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  return DefaultTabController(
      length: 3,
      initialIndex: model.currentTabSelection,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                  // color: Colors.lightBlue,
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  child: topWidget(model, context)),
            ),
            SliverToBoxAdapter(
                child: MediaQuery.of(context).size.width < largeSize
                    ? amountAndGas(model, context)
                    : Container()),
            SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(

                      // controller: ,
                      // labelPadding: EdgeInsets.only(bottom: 14, top: 14),
                      onTap: (int tabIndex) {
                        model.updateTabSelection(tabIndex);
                      },
                      labelColor: white,
                      unselectedLabelColor: primaryColor,
                      indicatorColor: primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        const Tab(
                          icon: Icon(
                            FontAwesomeIcons.coins,
                            // color: white,
                            size: 16,
                          ),
                          iconMargin: EdgeInsets.only(bottom: 3),
                          // child: Text(model.wallets.length.toString(),
                          //     style: TextStyle(fontSize: 10))
                        ),
                        const Tab(
                          icon: Icon(Icons.star,
                              // color: primaryColor,
                              size: 18),
                          iconMargin: EdgeInsets.only(bottom: 3),
                          // child: Text(
                          //     model.favWalletInfoList.length.toString(),
                          //     style: TextStyle(fontSize: 10, color: grey)),
                        ),
                        // custom tokens
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Constants.customTokenLogoLocalUrl,
                                width: 16,
                                color: primaryColor,
                              )
                            ],
                          ),
                        ),
                      ]),
                ))
          ];
        },
        body: Container(
          // color: Colors.amber,
          margin: const EdgeInsets.only(top: 0),
          padding: const EdgeInsets.only(top: 0),
          child: TabBarView(
            //  physics: ClampingScrollPhysics(),
            children: [
              // All coins tab

              model.isBusy || model.busy(model.isHideSmallAssetsButton)
                  ? const ShimmerLayout(
                      layoutType: 'walletDashboard',
                      count: 9,
                    )
                  : buildListView(model),

              // Favorite tab
              FavTab(),
              // custom tokens tab
              model.busy(model.selectedCustomTokens)
                  ? model.sharedService.loadingIndicator()
                  : model.selectedCustomTokens.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              Constants.emptyWalletLocalUrl,
                              color: Colors.grey,
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 5),
                            Text(AppLocalizations.of(context).customTokens,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ],
                        )
                      : Column(
                          children: [
                            UIHelper.verticalSpaceSmall,
                            // symbol balance action text row
                            Container(
                              color: white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context).logo,
                                    style: const TextStyle(
                                        color: black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  UIHelper.horizontalSpaceMedium,
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                          AppLocalizations.of(context).symbol,
                                          style: const TextStyle(
                                              color: black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600))),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        AppLocalizations.of(context).balance,
                                        style: const TextStyle(
                                            color: black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                        //  textAlign: TextAlign.center,
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                          AppLocalizations.of(context).action,
                                          style: const TextStyle(
                                              color: black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)))
                                ],
                              ),
                            ),

                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 10),
                                child: ListView.builder(
                                    padding: const EdgeInsets.only(top: 0),
                                    shrinkWrap: true,
                                    itemCount:
                                        model.selectedCustomTokens.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var customToken =
                                          model.selectedCustomTokens[index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 1),
                                        decoration: BoxDecoration(
                                            color: walletCardColor,
                                            borderRadius:
                                                BorderRadius.circular(9)),
                                        padding: const EdgeInsets.all(3),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // logo
                                            Container(
                                              width: 25,
                                              height: 25,
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        baseBlockchainGateV2Url +
                                                            'issuetoken/${customToken.tokenId}/logo',
                                                      ),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                            ),
                                            UIHelper.horizontalSpaceMedium,

                                            // Symbol and name
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                customToken.symbol
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    color: grey,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            UIHelper.horizontalSpaceMedium,
                                            UIHelper.horizontalSpaceSmall,
                                            // Balance
                                            Expanded(
                                              flex: 2,
                                              child: model.busy(model
                                                      .selectedCustomTokens)
                                                  ? const Text('...')
                                                  : Text(
                                                      customToken.balance
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: white),
                                                    ),
                                            ),
                                            //  Action
                                            Container(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    child: IconButton(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .zero,
                                                      onPressed: () async {
                                                        var wi = WalletInfo(
                                                            address: await model
                                                                .coreWalletDatabaseService
                                                                .getWalletAddressByTickerName(
                                                                    'FAB'));
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
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color:
                                                                        white)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: IconButton(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .zero,
                                                      onPressed: () {
                                                        model.routeCustomToken(
                                                            customToken);
                                                      },
                                                      icon: Column(
                                                        children: [
                                                          const Icon(
                                                            Icons.send_rounded,
                                                            color: primaryColor,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .send,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color:
                                                                        white)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5.0),
                                                    child: IconButton(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .zero,
                                                      onPressed: () {
                                                        model.routeCustomToken(
                                                            customToken,
                                                            isSend: false);
                                                      },
                                                      icon: const Icon(
                                                        Icons.history_rounded,
                                                        color: yellow,
                                                        size: 24,
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
                            ),
                          ],
                        )
            ],
          ),
        ),
      ));
}

ListView buildListView(WalletDashboardViewModel model) {
  return ListView.builder(
    padding: const EdgeInsets.only(top: 0),
    shrinkWrap: true,
    itemCount: model.wallets.length,
    itemBuilder: (BuildContext context, int index) {
      var name = model.wallets[index].coin.toLowerCase();

      return _coinDetailsCard(
          name, index, model.wallets, model.elevation, context, model);
      // Visibility(
      //   // Default visible widget will be visible when usdVal is greater than equals to 0 and isHideSmallAmountAssets is false
      //   visible: usdBalance >= 0 && !model.isHideSmallAssetsButton,
      //   child: _coinDetailsCard(
      //       name, index, model.wallets, model.elevation, context, model),
      //   // Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
      //   replacement: Visibility(
      //       visible: model.isHideSmallAssetsButton && usdBalance != 0,
      //       child: _coinDetailsCard(
      //           name, index, model.wallets, model.elevation, context, model)),
      // );
    },
  );
}

/*---------------------------------------------------------------------------------------------------------------------------------------------
                                                Coin Details Wallet Card
  ----------------------------------------------------------------------------------------------------------------------------------------------*/

Widget _coinDetailsCard(String tickerName, index, List<WalletBalance> wallets,
    elevation, context, WalletDashboardViewModel model) {
  String logoTicker = '';
  var specialTokenData = {};
  bool isBalanceNegative = model.wallets[index].balance.isNegative;
  specialTokenData = model.walletUtil.updateSpecialTokensTickerName(tickerName);
  tickerName = specialTokenData['tickerName'];
  logoTicker = specialTokenData['logoTicker'];

  if (model.hideSmallAmountCheck(wallets[index])) {
    return Container();
  } else {
    return Card(
      color: walletCardColor,
      elevation: elevation,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onDoubleTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        onTap: () {
          model.routeWithWalletInfoArgs(
              wallets[index], WalletFeaturesViewRoute);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UIHelper.horizontalSpaceSmall,
              // Card logo container
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: walletCardColor,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                            color: fabLogoColor,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10.0,
                            spreadRadius: 1.0),
                      ]),
                  child: Image.network(
                    '$walletCoinsLogoUrl${logoTicker.toLowerCase()}.png',
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Text(logoTicker.toString(),
                          style: const TextStyle(fontSize: 8, color: white));
                    },
                  ),
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
                        tickerName.toUpperCase(),
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
                                  baseColor: red,
                                  highlightColor: white,
                                  child: Text(
                                    wallets[index].balance.toStringAsFixed(2),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ))
                              : Expanded(
                                  child: Text(
                                      isBalanceNegative
                                          ? AppLocalizations.of(context)
                                              .unavailable
                                          : NumberUtil()
                                              .truncateDoubleWithoutRouding(
                                                  model.wallets[index].balance,
                                                  precision: 6)
                                              .toString(),
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
                          model.isBusy
                              ? SizedBox(
                                  child: Shimmer.fromColors(
                                  baseColor: red,
                                  highlightColor: white,
                                  child: Text('${wallets[index].lockBalance}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(color: red)),
                                ))
                              : Expanded(
                                  child: Text(
                                      wallets[index].lockBalance.isNegative
                                          ? AppLocalizations.of(context)
                                              .unavailable
                                          : NumberUtil()
                                              .truncateDoubleWithoutRouding(
                                                  model.wallets[index]
                                                      .lockBalance,
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
                              child: Text(
                                  AppLocalizations.of(context).inExchange,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                          ),
                          model.isBusy
                              ? SizedBox(
                                  child: Shimmer.fromColors(
                                  baseColor: primaryColor,
                                  highlightColor: white,
                                  child: Text(
                                    wallets[index]
                                        .unlockedExchangeBalance
                                        .toStringAsFixed(4),
                                    textAlign: TextAlign.center,
                                  ),
                                ))
                              : Expanded(
                                  child: Text(
                                      wallets[index]
                                              .unlockedExchangeBalance
                                              .isNegative
                                          ? AppLocalizations.of(context)
                                              .unavailable
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          isBalanceNegative
                              ? Container(
                                  padding: EdgeInsets.only(left: 5),
                                )
                              : model.wallets[index].balance == 0.0
                                  ? UIHelper.horizontalSpaceMedium
                                  : UIHelper.horizontalSpaceSmall,
                          isBalanceNegative
                              ? Container()
                              : Text('\$', style: TextStyle(color: green)),
                          Expanded(
                            child: Text(
                              isBalanceNegative
                                  ? AppLocalizations.of(context).unavailable
                                  : NumberUtil()
                                      .truncateDoubleWithoutRouding(
                                          model.wallets[index].balance *
                                              model.wallets[index].usdValue.usd,
                                          precision: 2)
                                      .toString(),
                              style: isBalanceNegative
                                  ? const TextStyle(color: grey, fontSize: 13)
                                  : TextStyle(color: green),
                            ),
                          )
                        ],
                      ),

                      // Deposit and Withdraw Container Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          DepositWidget(
                              model: model,
                              index: index,
                              tickerName: tickerName),
                          const Divider(
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
                                    const Icon(
                                      Icons.arrow_upward,
                                      color: red,
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
}

// FAB TAB

class FavTab extends ViewModelBuilderWidget<WalletDashboardViewModel> {
  @override
  void onViewModelReady(WalletDashboardViewModel model) async {
    await model.buildFavCoinListV1();
  }

  @override
  bool get initialiseSpecialViewModelsOnce => true;
  @override
  bool get fireOnModelReadyOnce => true;
  @override
  Widget builder(
      BuildContext context, WalletDashboardViewModel model, Widget child) {
    debugPrint('fav list length before');
    debugPrint(model.favWallets.length.toString());

    return model.busy(model.favWallets)
        ? model.sharedService.loadingIndicator()
        : Container(
            child: model.favWallets.isEmpty || model.favWallets == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Constants.emptyWalletLocalUrl,
                        color: Colors.grey,
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(height: 5),
                      Text(AppLocalizations.of(context).favoriteTokens,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white)),
                    ],
                  )
                :
                //Text('test'));
                ListView.builder(
                    controller: model.walletsScrollController,
                    // itemExtent: 95,
                    shrinkWrap: true,
                    itemCount: model.favWallets.length,
                    itemBuilder: (BuildContext context, int index) {
                      var tickerName =
                          model.favWallets[index].coin.toLowerCase();

                      String logoTicker = '';

                      var specialTokenData = {};
                      bool isBalanceNegative =
                          model.wallets[index].balance.isNegative;
                      specialTokenData = model.walletUtil
                          .updateSpecialTokensTickerName(tickerName);
                      tickerName = specialTokenData['tickerName'];
                      logoTicker = specialTokenData['logoTicker'];
                      return Card(
                        color: walletCardColor,
                        elevation: model.elevation,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            model.routeWithWalletInfoArgs(
                                model.favWallets[index],
                                WalletFeaturesViewRoute);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                UIHelper.horizontalSpaceSmall,
                                // Card logo container
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: walletCardColor,
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: fabLogoColor,
                                              offset: Offset(1.0, 5.0),
                                              blurRadius: 10.0,
                                              spreadRadius: 1.0),
                                        ]),
                                    child: Image.network(
                                      '$walletCoinsLogoUrl${logoTicker.toLowerCase()}.png',
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace stackTrace) {
                                        return Text(logoTicker.toString(),
                                            style: const TextStyle(
                                                fontSize: 8, color: white));
                                      },
                                    ),
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
                                          tickerName.toUpperCase(),
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
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .available,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6),
                                            ),
                                            Expanded(
                                              child: Text(
                                                  model.favWallets[index]
                                                          .balance.isNegative
                                                      ? '0.0'
                                                      : NumberUtil()
                                                          .truncateDoubleWithoutRouding(
                                                              model
                                                                  .favWallets[
                                                                      index]
                                                                  .balance,
                                                              precision: 6)
                                                          .toString(),
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
                                                  top: 2.0,
                                                  right: 5.0,
                                                  bottom: 2.0),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .locked,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(color: red)),
                                            ),
                                            Expanded(
                                              child: Text(
                                                  model
                                                          .favWallets[index]
                                                          .lockBalance
                                                          .isNegative
                                                      ? '0.0'
                                                      : NumberUtil()
                                                          .truncateDoubleWithoutRouding(
                                                              model
                                                                  .favWallets[
                                                                      index]
                                                                  .lockBalance,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .inExchange,
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6),
                                            ),
                                            Expanded(
                                              child: Text(
                                                  NumberUtil()
                                                      .truncateDoubleWithoutRouding(
                                                          model
                                                              .favWallets[index]
                                                              .unlockedExchangeBalance,
                                                          precision: 6)
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          color: primaryColor)),
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
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text('\$',
                                              style: TextStyle(color: green)),
                                          Expanded(
                                            child: Text(
                                                '${NumberUtil().truncateDoubleWithoutRouding(model.favWallets[index].balance * model.favWallets[index].usdValue.usd, precision: 2).toString()} USD',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(color: green)),
                                          ),
                                        ],
                                      ),

                                      // Deposit and Withdraw Container Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          InkWell(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          right: 5.0,
                                                          left: 2.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .deposit,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2
                                                            .copyWith(
                                                                fontSize: 8),
                                                      ),
                                                      Icon(Icons.arrow_downward,
                                                          color: green,
                                                          size: 16),
                                                    ],
                                                  )),
                                              onTap: () =>
                                                  model.routeWithWalletInfoArgs(
                                                      model.favWallets[index],
                                                      DepositViewRoute)),
                                          const Divider(
                                            endIndent: 5,
                                          ),
                                          InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .withdraw,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2
                                                          .copyWith(
                                                              fontSize: 8),
                                                    ),
                                                    const Icon(
                                                      Icons.arrow_upward,
                                                      color: red,
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () =>
                                                  model.routeWithWalletInfoArgs(
                                                      model.favWallets[index],
                                                      WithdrawViewRoute)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
  }

  @override
  WalletDashboardViewModel viewModelBuilder(BuildContext context) =>
      WalletDashboardViewModel();
}

/*----------------------------------------------------------------------
                      Total Balance Widget
----------------------------------------------------------------------*/

class TotalBalanceWidget extends StatelessWidget {
  const TotalBalanceWidget({Key key, this.model, this.index}) : super(key: key);
  final WalletDashboardViewModel model;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
            bottom: 20,
            right: 30,
            left: 30,
            child: Card(
              elevation: model.elevation,
              color: isProduction ? secondaryColor : red.withAlpha(200),
              child: Container(
                //duration: Duration(milliseconds: 250),
                width: 350,
                height: 90,
                //model.totalBalanceContainerWidth,
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Announcement Widget
                    Expanded(
                        flex: 1,
                        child:

                            // model.announceList == null ||
                            //         model.announceList.length < 1
                            //     ?
                            Image.asset(
                          'assets/images/wallet-page/dollar-sign.png',
                          width: 30,
                          height: 30,
                          color: iconBackgroundColor, // image background color
                          fit: BoxFit.contain,
                        )),
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
                                  baseColor: primaryColor,
                                  highlightColor: white,
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
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          // child: Widget(),
                          ),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class TotalBalanceWidget2 extends StatelessWidget {
  const TotalBalanceWidget2({Key key, this.model, this.index})
      : super(key: key);
  final WalletDashboardViewModel model;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
            bottom: 20,
            right: 30,
            left: 30,
            child: Card(
              elevation: model.elevation,
              color: isProduction ? secondaryColor : red.withAlpha(200),
              child: Container(
                //duration: Duration(milliseconds: 250),
                width: 350,
                height: 90,
                //model.totalBalanceContainerWidth,
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Announcement Widget
                    Expanded(
                        flex: 1,
                        child:

                            // model.announceList == null ||
                            //         model.announceList.length < 1
                            //     ?
                            Container(
                                decoration: const BoxDecoration(
                                    color: iconBackgroundColor,
                                    shape: BoxShape.circle),
                                width: 30,
                                height: 30,
                                child: Icon(
                                  // Icons.local_gas_station,
                                  MdiIcons.finance,
                                  color: isProduction
                                      ? secondaryColor
                                      : red.withAlpha(200),
                                ))),
                    Expanded(
                      flex: 3,
                      child: model.isBusy
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
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
                                              color: white)),
                                ),
                                Shimmer.fromColors(
                                    baseColor: primaryColor,
                                    highlightColor: white,
                                    child: Text(
                                      model.totalExchangeBalance + ' USD',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    )),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                UIHelper.horizontalSpaceSmall,
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .totalExchangeBalance,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              fontWeight: FontWeight.w400)),
                                ),
                                Text(model.totalExchangeBalance + ' USD',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(fontWeight: FontWeight.w400)),
                              ],
                            ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          // child: Widget(),
                          ),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class TotalBalanceWidget3 extends StatelessWidget {
  const TotalBalanceWidget3({Key key, this.model, this.index})
      : super(key: key);
  final WalletDashboardViewModel model;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
            bottom: 20,
            right: 30,
            left: 30,
            child: Card(
              elevation: model.elevation,
              color: isProduction ? secondaryColor : red.withAlpha(200),
              child: Container(
                //duration: Duration(milliseconds: 250),
                width: 350,
                height: 90,
                //model.totalBalanceContainerWidth,
                padding: const EdgeInsets.all(10),
                child: AddGasRow(model: model),
              ),
            )),
      ],
    );
  }
}

class AddGasRow extends StatelessWidget {
  const AddGasRow({Key key, this.model}) : super(key: key);
  final WalletDashboardViewModel model;

  @override
  Widget build(BuildContext context) {
    var begin = const Offset(0.0, 1.0);
    var end = Offset.zero;
    var tween = Tween(begin: begin, end: end);

    // if (model.isShowCaseView && model.gasAmount < 0.5 && !model.isBusy) {
    //   model.showcaseEvent(context);
    // }
    return
        // model.isShowCaseView || model.gasAmount < 0.5
        //     ? SafeArea(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Showcase(
        //               key: model.globalKeyOne,
        //               //  titleTextStyle:TextStyle(decoration:T ),
        //               title: AppLocalizations.of(context).note + ':',
        //               description:
        //                   AppLocalizations.of(context).walletDashboardInstruction1,
        //               child: TweenAnimationBuilder(
        //                   duration: const Duration(milliseconds: 500),
        //                   tween: tween,
        //                   builder: (_, Offset offset, __) {
        //                     return Container(
        //                         child: (Gas(gasAmount: model.gasAmount)));
        //                   }),
        //             ),
        //           ],
        //         ),
        //       )
        //     :
        Gas(gasAmount: model.gasAmount);
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
                descTextStyle: const TextStyle(fontSize: 9, color: black),
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
            Icon(Icons.arrow_downward, color: green, size: 16),
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
    return Container(
      child: _tabBar,
      color: secondaryColor,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
