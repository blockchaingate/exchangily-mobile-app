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
import 'package:exchangilymobileapp/enums/connectivity_status.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/announcement/anncounceList.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_dashboard/coin_details_card_widget.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_dashboard/total_balance_card_widget.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/network_status.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
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
    var walletInfo;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => WalletDashboardViewModel(),
        onModelReady: (model) async {
          model.context = context;
          model.globalKeyOne = _one;
          model.globalKeyTwo = _two;
          await model.retrieveWalletsFromLocalDatabase();
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
                    builder: (context) => CustomScrollView(
                      slivers: <Widget>[
/*-------------------------------------------------------------------------------------
                              Build Background and Logo Container
-------------------------------------------------------------------------------------*/

                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          // title: Text(
                          //   'Flutter Slivers Demo',
                          //   style: TextStyle(
                          //       fontSize: 25,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.white),
                          // ),
                          backgroundColor: Color(0xFFEDF2F8),
                          expandedHeight: 80,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.srgbToLinearGamma(),
                                      alignment: Alignment.topCenter,
                                      image: AssetImage(
                                          'assets/images/wallet-page/background.png'),
                                      fit: BoxFit.cover)),
                              child: Stack(children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/start-page/logo.png',
                                    width: 180,
                                    color: globals.white,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                        SliverAppBar(
                          toolbarHeight: 40,
                          //  expandedHeight: 10,
                          collapsedHeight: 40,
                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: false,
                          flexibleSpace: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      alignment: Alignment.center,
                                      image: AssetImage(
                                          'assets/images/wallet-page/background.png'),
                                      fit: BoxFit.fitWidth)),
                              child: WalletDashboardTotalBalanceWidget(
                                  model: model)),
                          pinned: true,
                        ),

                        SliverAppBar(
                          expandedHeight: 20,
                          collapsedHeight: 25,
                          toolbarHeight: 21,
                          backgroundColor: secondaryColor,
                          automaticallyImplyLeading: false,
                          pinned: true,
                          flexibleSpace:
                              /*-----------------------------------------------------------------
                           Hide Small Amount Row
 -----------------------------------------------------------------*/

                              Container(
                            padding:
                                EdgeInsets.only(right: 10, top: 15, bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 2.0, vertical: 2.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      // hide small amount coins
                                      InkWell(
                                        onTap: () {
                                          model.isShowFavCoins
                                              ? print('...')
                                              : model.hideSmallAmountAssets();
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
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
                                            ),
                                            !model.isFreeFabNotUsed
                                                ? Container()
                                                //Add free FAB container
                                                : Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.0),
                                                    decoration: BoxDecoration(
                                                        color: primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          OutlinedButton.icon(
                                                              style: ButtonStyle(
                                                                  padding: MaterialStateProperty.all(
                                                                      EdgeInsets
                                                                          .all(
                                                                              0))),
                                                              onPressed: () => model
                                                                  .getFreeFab(),
                                                              icon: Icon(
                                                                Icons.add,
                                                                size: 18,
                                                                color: white,
                                                              ),
                                                              label: Text(
                                                                AppLocalizations.of(
                                                                            context)
                                                                        .getFree +
                                                                    ' FAB',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6,
                                                              )),
                                                    )),
                                            UIHelper.horizontalSpaceMedium,
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
// Gas Container
                        SliverAppBar(
                            toolbarHeight: 20,
                            backgroundColor: Colors.transparent,
                            automaticallyImplyLeading: false,
                            flexibleSpace: Container(
                              child: model.isBusy
                                  ? Shimmer.fromColors(
                                      baseColor: primaryColor,
                                      highlightColor: grey,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: Icon(
                                              Icons.donut_large,
                                              size: 18,
                                              color: primaryColor,
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
                                            color: green,
                                            padding: EdgeInsets.all(0),
                                            onPressed: () {},
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .addGas,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(color: black),
                                            ),
                                          ),
                                        ],
                                      ))
                                  // when model is not busy then display gas balance, add gas button and search
                                  : Row(
                                      children: [
                                        AddGasRow(model: model),
                                        UIHelper.horizontalSpaceSmall,
                                        GestureDetector(
                                          onTap: () => FocusScope.of(context)
                                              .requestFocus(FocusNode()),
                                          child: Container(
                                            margin: EdgeInsets.only(top: 5),
                                            height: 20,
                                            width: 130,
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
                                                  suffixIcon: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Icon(Icons.search,
                                                          color: white))),
                                              controller: model
                                                  .searchCoinTextController,
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
                                        )
                                      ],
                                    ),
                            )),
                        //SliverPersistentHeader(delegate: SliverPersistentHeaderDelegate() )
                        model.isBusy
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                return WalletDashboardCoinsDetailsCardWidget(
                                  index: index,
                                  wallets: model.walletInfoCopy,
                                );
                              }, childCount: 6))
                            :
                            // SmartRefresher(
                            //     enablePullDown: true,
                            //     header: Theme.of(context).platform ==
                            //             TargetPlatform.iOS
                            //         ? ClassicHeader()
                            //         : MaterialClassicHeader(),
                            //     controller: model.refreshController,
                            //     onRefresh: model.onRefresh,
                            //     child:
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return WalletDashboardCoinsDetailsCardWidget(
                                    index: index,
                                    wallets: model.walletInfo,
                                  );
                                }, childCount: model.walletInfo.length

                                    //  model.isBusy
                                    //     ? model.walletInfoCopy.length
                                    //     : model.walletInfo.length
                                    ),
                              ),
                        //)
//                         Container(
//                           // width: double.infinity,
//                           height: 130,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: AssetImage(
//                                       'assets/images/wallet-page/background.png'),
//                                   fit: BoxFit.cover)),
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: <Widget>[
//                                 Expanded(
//                                   child: Stack(
//                                     clipBehavior: Clip.none,
//                                     children: <Widget>[
//                                       // Positioned(
//                                       //   top: 5,
//                                       //   right: 5,
//                                       //   child: IconButton(
//                                       //     icon: Icon(Icons.menu,
//                                       //         color: globals.white, size: 40),
//                                       //     onPressed: () {
//                                       //       log.i('trying to open the drawer');
//                                       //       key.currentState.openDrawer();
//                                       //     },
//                                       //   ),
//                                       // )
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Stack(
//                                       clipBehavior: Clip.none,
//                                       alignment: Alignment.center,
//                                       children: <Widget>[
//                                         Positioned(
//                                           top: -10,
//                                           child: Image.asset(
//                                             'assets/images/start-page/logo.png',
//                                             width: 180,
//                                             color: globals.white,
//                                           ),
//                                         ),
//                                       ]),
//                                 ),

// /*------------------------------------------------------------
//                           Total Balance Card
// ------------------------------------------------------------*/
//                                 Expanded(
//                                   child: TotalBalanceWidget(model: model),
//                                 ),
//                               ]),
//                         ),

// /*-----------------------------------------------------------------
//                           Hide Small Amount Row
// -----------------------------------------------------------------*/

//                         Container(
//                           padding: EdgeInsets.only(right: 10, top: 15),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             mainAxisSize: MainAxisSize.max,
//                             children: <Widget>[
//                               Container(
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: 8.0, vertical: 5.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     InkWell(
//                                       onTap: () {
//                                         model.isShowFavCoins
//                                             ? print('...')
//                                             : model.hideSmallAmountAssets();
//                                       },
//                                       child: Row(
//                                         children: <Widget>[
//                                           model.isHideSmallAmountAssets
//                                               ? Icon(
//                                                   Icons.money_off,
//                                                   semanticLabel:
//                                                       'Show all Amount Assets',
//                                                   color: globals.primaryColor,
//                                                 )
//                                               : Icon(
//                                                   Icons.attach_money,
//                                                   semanticLabel:
//                                                       'Hide Small Amount Assets',
//                                                   color: model.isShowFavCoins
//                                                       ? grey
//                                                       : globals.primaryColor,
//                                                 ),
//                                           Container(
//                                             padding: EdgeInsets.only(left: 5),
//                                             child: Text(
//                                               AppLocalizations.of(context)
//                                                   .hideSmallAmountAssets,
//                                               style: model.isShowFavCoins
//                                                   ? Theme.of(context)
//                                                       .textTheme
//                                                       .headline5
//                                                       .copyWith(
//                                                           wordSpacing: 1.25,
//                                                           color: grey)
//                                                   : Theme.of(context)
//                                                       .textTheme
//                                                       .headline5
//                                                       .copyWith(
//                                                           wordSpacing: 1.25),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               //Add free FAB container
//                               !model.isFreeFabNotUsed
//                                   ? Container()
//                                   : Container(
//                                       margin:
//                                           EdgeInsets.symmetric(vertical: 5.0),
//                                       decoration: BoxDecoration(
//                                           color: globals.primaryColor,
//                                           borderRadius:
//                                               BorderRadius.circular(30)),
//                                       child: SizedBox(
//                                         width: 120,
//                                         height: 20,
//                                         child: OutlinedButton.icon(
//                                             style: ButtonStyle(
//                                                 padding:
//                                                     MaterialStateProperty.all(
//                                                         EdgeInsets.all(0))),
//                                             onPressed: () => model.getFreeFab(),
//                                             icon: Icon(
//                                               Icons.add,
//                                               size: 18,
//                                               color: white,
//                                             ),
//                                             label: Text(
//                                               AppLocalizations.of(context)
//                                                       .getFree +
//                                                   ' FAB',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .headline6,
//                                             )),
//                                       )),
//                               UIHelper.horizontalSpaceMedium,
//                             ],
//                           ),
//                         ),
//                         // Gas Container
//                         Container(
//                           margin: EdgeInsets.only(left: 8.0),
//                           child: model.isBusy
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
//                                         "${AppLocalizations.of(context).gas}: ${NumberUtil().truncateDoubleWithoutRouding(model.gasAmount, precision: 6).toString()}",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headline5
//                                             .copyWith(wordSpacing: 1.25),
//                                       ),
//                                       UIHelper.horizontalSpaceSmall,
//                                       MaterialButton(
//                                         minWidth: 70.0,
//                                         height: 24,
//                                         color: globals.green,
//                                         padding: EdgeInsets.all(0),
//                                         onPressed: () {},
//                                         child: Text(
//                                           AppLocalizations.of(context).addGas,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headline6
//                                               .copyWith(color: black),
//                                         ),
//                                       ),
//                                     ],
//                                   ))
//                               : Row(
//                                   children: [
//                                     AddGasRow(model: model),
//                                     UIHelper.horizontalSpaceSmall,
//                                     Expanded(
//                                       child: GestureDetector(
//                                         onTap: () => FocusScope.of(context)
//                                             .requestFocus(FocusNode()),
//                                         child: Container(
//                                           margin: EdgeInsets.only(top: 5),
//                                           height: 30,
//                                           child: TextField(
//                                             enabled: model.isShowFavCoins
//                                                 ? false
//                                                 : true,
//                                             decoration: InputDecoration(
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: primaryColor,
//                                                       width: 1),
//                                                 ),
//                                                 // helperText: 'Search',
//                                                 // helperStyle:
//                                                 //     Theme.of(context).textTheme.bodyText1,
//                                                 suffixIcon: Icon(Icons.search,
//                                                     color: white)),
//                                             controller:
//                                                 model.searchCoinTextController,
//                                             onChanged: (String value) {
//                                               model.isShowFavCoins
//                                                   ? model
//                                                       .searchFavCoinsByTickerName(
//                                                           value)
//                                                   : model
//                                                       .searchCoinsByTickerName(
//                                                           value);
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                         ),

//                         UIHelper.verticalSpaceSmall,
//                         model.isUpdateWallet
//                             ? Container(
//                                 child: TextButton(
//                                 child: Text(
//                                     AppLocalizations.of(context).updateWallet),
//                                 onPressed: () => model.updateWallet(),
//                               ))
//                             : Container(),
// /*------------------------------------------------------------------------------
//                                 Build Wallet List Container
// -------------------------------------------------------------------------------*/
//                         //   !Platform.isAndroid
//                         //      ?
//                         SingleChildScrollView(
//                           child: DefaultTabController(
//                             length: 2,
//                             initialIndex: model.currentTabSelection,
//                             child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   TabBar(
//                                       labelPadding: EdgeInsets.only(bottom: 5),
//                                       onTap: (int tabIndex) {
//                                         model.updateTabSelection(tabIndex);
//                                       },
//                                       indicatorColor: primaryColor,
//                                       indicatorSize: TabBarIndicatorSize.tab,
//                                       // Tab Names

//                                       tabs: [
//                                         Icon(
//                                           FontAwesomeIcons.coins,
//                                           color: white,
//                                           size: 16,
//                                         ),
//                                         // Text(
//                                         //     AppLocalizations.of(context)
//                                         //         .allAssets,
//                                         //     style: Theme.of(context)
//                                         //         .textTheme
//                                         //         .bodyText1
//                                         //         .copyWith(
//                                         //             fontWeight: FontWeight.w500,
//                                         //             decorationThickness: 3)),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Icon(Icons.star,
//                                                 color: primaryColor, size: 18),
//                                           ],
//                                         ),
//                                       ]),
//                                   UIHelper.verticalSpaceSmall,
//                                   // Tabs view container
//                                   Container(
//                                     height: MediaQuery.of(context).size.height *
//                                             .55 -
//                                         model.minusHeight,
//                                     child: TabBarView(
//                                       physics: NeverScrollableScrollPhysics(),
//                                       children: [
//                                         // All coins tab
//                                         model.isBusy
//                                             ? ListView.builder(
//                                                 shrinkWrap: true,
//                                                 itemCount:
//                                                     model.walletInfoCopy.length,
//                                                 itemBuilder:
//                                                     (BuildContext context,
//                                                         int index) {
//                                                   return _coinDetailsCard(
//                                                       model
//                                                           .walletInfoCopy[index]
//                                                           .tickerName
//                                                           .toLowerCase(),
//                                                       index,
//                                                       model.walletInfoCopy,
//                                                       model.elevation,
//                                                       context,
//                                                       model);
//                                                 },
//                                               )
//                                             : SmartRefresher(
//                                                 enablePullDown: true,
//                                                 header: Theme.of(context)
//                                                             .platform ==
//                                                         TargetPlatform.iOS
//                                                     ? ClassicHeader()
//                                                     : MaterialClassicHeader(),
//                                                 controller:
//                                                     model.refreshController,
//                                                 onRefresh: model.onRefresh,
//                                                 // child: NotificationListener<
//                                                 //         ScrollEndNotification>(
//                                                 //     onNotification:
//                                                 //         (scrollEnd) {
//                                                 //       var metrics =
//                                                 //           scrollEnd.metrics;
//                                                 //       if (metrics.atEdge) {
//                                                 //         if (metrics.pixels == 0)
//                                                 //           print('At top');
//                                                 //         else
//                                                 //           print('At bottom');
//                                                 //       }
//                                                 //       return true;
//                                                 //     },
//                                                 child: buildListView(model)
//                                                 //),
//                                                 ),

//                                         // Fav coins tab
//                                         // Text(model.favWalletInfoList.length
//                                         //     .toString())
//                                         // model.anyObjectsBusy
//                                         //     ? model.sharedService
//                                         //         .loadingIndicator()
//                                         //     :
//                                         FavTab(),
//                                       ],
//                                     ),
//                                   ),
//                                 ]),
//                           ),
//                         )
                        // : CupertinoSegmentedControl(
                        //     selectedColor: primaryColor,
                        //     children: <int, Widget>{
                        //       0: // All coins tab
                        //          Text('allcoins')
                        //       1: FavTab()
                        //     },
                        //     onValueChanged: (tabValue) =>
                        //         model.updateTabSelection(tabValue),
                        //     groupValue: model.currentTabSelection),
                        // Expanded(
                        //   child: model.isBusy
                        //       ? model.walletInfoCopy == null
                        //           ? ShimmerLayout(
                        //               layoutType: 'walletDashboard',
                        //             )
                        //           : Container(
                        //               // margin: EdgeInsets.symmetric(horizontal: 8.0),
                        //               child: ListView.builder(
                        //                 //  itemExtent: 100,
                        //                 shrinkWrap: true,
                        //                 itemCount: model.walletInfoCopy.length,
                        //                 itemBuilder:
                        //                     (BuildContext context, int index) {
                        //                   return _coinDetailsCard(
                        //                       model.walletInfoCopy[index]
                        //                           .tickerName
                        //                           .toLowerCase(),
                        //                       model.walletInfoCopy[index]
                        //                           .availableBalance,
                        //                       model.walletInfoCopy[index]
                        //                           .lockedBalance,
                        //                       model.walletInfoCopy[index]
                        //                           .inExchange,
                        //                       model.walletInfoCopy[index]
                        //                           .usdValue,
                        //                       index,
                        //                       model.walletInfoCopy,
                        //                       model.elevation,
                        //                       context,
                        //                       model);
                        //                 },
                        //               ),
                        //             )
                        //       : Container(
                        //           //   margin: EdgeInsets.symmetric(horizontal: 8.0),
                        //           child: SmartRefresher(
                        //             enablePullDown: true,
                        //             header: Theme.of(context).platform ==
                        //                     TargetPlatform.iOS
                        //                 ? ClassicHeader()
                        //                 : MaterialClassicHeader(),
                        //             controller: model.refreshController,
                        //             onRefresh: model.onRefresh,
                        //             child: ListView.builder(
                        //               controller: model.scrollController,
                        //               // itemExtent: 95,
                        //               shrinkWrap: true,
                        //               itemCount: model.walletInfo.length,
                        //               itemBuilder:
                        //                   (BuildContext context, int index) {
                        //                 var name = model
                        //                     .walletInfo[index].tickerName
                        //                     .toLowerCase();
                        //                 var usdVal =
                        //                     model.walletInfo[index].usdValue;

                        //                 return Visibility(
                        //                   // Default visible widget will be visible when usdVal is greater than equals to 0 and isHideSmallAmountAssets is false
                        //                   visible: usdVal >= 0 &&
                        //                       !model.isHideSmallAmountAssets,
                        //                   child: _coinDetailsCard(
                        //                       '$name',
                        //                       model.walletInfo[index]
                        //                           .availableBalance,
                        //                       model.walletInfo[index]
                        //                           .lockedBalance,
                        //                       model
                        //                           .walletInfo[index].inExchange,
                        //                       model.walletInfo[index].usdValue,
                        //                       index,
                        //                       model.walletInfo,
                        //                       model.elevation,
                        //                       context,
                        //                       model),
                        //                   // Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
                        //                   replacement: Visibility(
                        //                       visible: model
                        //                               .isHideSmallAmountAssets &&
                        //                           usdVal != 0,
                        //                       child: _coinDetailsCard(
                        //                           '$name',
                        //                           model.walletInfo[index]
                        //                               .availableBalance,
                        //                           model.walletInfo[index]
                        //                               .lockedBalance,
                        //                           model.walletInfo[index]
                        //                               .inExchange,
                        //                           model.walletInfo[index]
                        //                               .usdValue,
                        //                           index,
                        //                           model.walletInfo,
                        //                           model.elevation,
                        //                           context,
                        //                           model)),
                        //                 );
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        // ),
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
              //       model.moveDown();
              //     },
              //   ),
              // ),
            ),
          );
        });
  }

  // ListView buildListView(WalletDashboardViewModel model) {
  //   return ListView.builder(
  //     controller: model.walletsScrollController,
  //     shrinkWrap: true,
  //     itemCount: model.walletInfo.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       var name = model.walletInfo[index].tickerName.toLowerCase();
  //       var usdVal = model.walletInfo[index].usdValue;

  //       return Visibility(
  //         // Default visible widget will be visible when usdVal is greater than equals to 0 and isHideSmallAmountAssets is false
  //         visible: usdVal >= 0 && !model.isHideSmallAmountAssets,
  //         child: _coinDetailsCard('$name', index, model.walletInfo,
  //             model.elevation, context, model),
  //         // Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
  //         replacement: Visibility(
  //             visible: model.isHideSmallAmountAssets && usdVal != 0,
  //             child: _coinDetailsCard('$name', index, model.walletInfo,
  //                 model.elevation, context, model)),
  //       );
  //     },
  //   );
  // }
}

/*---------------------------------------------------------------------------------------------------------------------------------------------
                                                Coin Details Wallet Card
  ----------------------------------------------------------------------------------------------------------------------------------------------*/

// FAB TAB

/*----------------------------------------------------------------------
                      Total Balance Widget
----------------------------------------------------------------------*/

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
        onTap: () {
          Navigator.pushNamed(context, '/deposit',
              arguments: model.walletInfo[index]);
        });
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
