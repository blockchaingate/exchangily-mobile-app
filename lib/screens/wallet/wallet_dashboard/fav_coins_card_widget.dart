import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class FavTab extends ViewModelBuilderWidget<WalletDashboardViewModel> {
  @override
  void onViewModelReady(WalletDashboardViewModel model) async {
    await model.buildFavCoinList();
  }

  @override
  Widget builder(
      BuildContext context, WalletDashboardViewModel model, Widget child) {
    print('fav list length before');
    print(model.favWalletInfoList.length);
    return Container(
        child: model.favWalletInfoList.isEmpty ||
                model.favWalletInfoList == null
            ? Center(child: Icon(Icons.hourglass_empty, color: white)
                //Text('Favorite list empty'),
                )
            :
            //Text('test'));
            Container(
                child: ListView.builder(
                    controller: model.walletsScrollController,
                    // itemExtent: 95,
                    shrinkWrap: true,
                    itemCount: model.favWalletInfoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var tickerName = model.favWalletInfoList[index].tickerName
                          .toLowerCase();

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
                      } else {
                        logoTicker = tickerName;
                      }

                      return Card(
                        color: walletCardColor,
                        elevation: model.elevation,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            model.navigationService.navigateTo(
                                '/walletFeatures',
                                arguments: model.favWalletInfoList[index]);
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
                                        color: walletCardColor,
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: [
                                          BoxShadow(
                                              color: fabLogoColor,
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
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .available,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6),
                                            ),
                                            model.isBusy
                                                ? SizedBox(
                                                    child: Shimmer.fromColors(
                                                    baseColor: red,
                                                    highlightColor: white,
                                                    child: Text(
                                                      model
                                                          .favWalletInfoList[
                                                              index]
                                                          .availableBalance
                                                          .toStringAsFixed(2),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                    ),
                                                  ))
                                                : Expanded(
                                                    child: Text(
                                                        model
                                                                .favWalletInfoList[
                                                                    index]
                                                                .availableBalance
                                                                .isNegative
                                                            ? '0.0'
                                                            : model
                                                                .favWalletInfoList[
                                                                    index]
                                                                .availableBalance
                                                                .toStringAsFixed(
                                                                    4),
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
                                            model.isBusy
                                                ? SizedBox(
                                                    child: Shimmer.fromColors(
                                                    baseColor: red,
                                                    highlightColor: white,
                                                    child: Text(
                                                        '${model.favWalletInfoList[index].lockedBalance}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .copyWith(
                                                                color: red)),
                                                  ))
                                                : Expanded(
                                                    child: Text(
                                                        model
                                                                .favWalletInfoList[
                                                                    index]
                                                                .lockedBalance
                                                                .isNegative
                                                            ? '0.0'
                                                            : model
                                                                .favWalletInfoList[
                                                                    index]
                                                                .lockedBalance
                                                                .toStringAsFixed(
                                                                    4),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .copyWith(
                                                                color: red)),
                                                  )
                                          ],
                                        ),
                                        // Inexchange Row
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Padding(
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
                                            ),
                                            model.isBusy
                                                ? SizedBox(
                                                    child: Shimmer.fromColors(
                                                    baseColor: primaryColor,
                                                    highlightColor: white,
                                                    child: Text(
                                                      model
                                                          .favWalletInfoList[
                                                              index]
                                                          .inExchange
                                                          .toStringAsFixed(4),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                    ),
                                                  ))
                                                : Expanded(
                                                    child: Text(
                                                        model
                                                                    .favWalletInfoList[
                                                                        index]
                                                                    .inExchange ==
                                                                0
                                                            ? '0.0'
                                                            : NumberUtil()
                                                                .truncateDoubleWithoutRouding(
                                                                    model
                                                                        .favWalletInfoList[
                                                                            index]
                                                                        .inExchange,
                                                                    precision:
                                                                        4)
                                                                .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .copyWith(
                                                                color:
                                                                    primaryColor)),
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
                                                          color: green)),
                                                  Expanded(
                                                    child: Shimmer.fromColors(
                                                      baseColor: grey,
                                                      highlightColor: white,
                                                      child: Text(
                                                        '${model.favWalletInfoList[index].usdValue.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: green),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Text('\$',
                                                      style: TextStyle(
                                                          color: green)),
                                                  Expanded(
                                                    child: Text(
                                                        '${NumberUtil().truncateDoubleWithoutRouding(model.favWalletInfoList[index].usdValue, precision: 2).toString()} USD',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: green)),
                                                  ),
                                                ],
                                              ),

                                        // Deposit and Withdraw Container Row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            InkWell(
                                                child: tickerName
                                                                .toUpperCase() ==
                                                            'FAB' &&
                                                        (model.isShowCaseView ||
                                                            model.gasAmount <
                                                                0.5) &&
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
                                                                color: green,
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
                                                                color: green,
                                                                size: 16),
                                                          ],
                                                        )),
                                                onTap: () {
                                                  model.navigationService
                                                      .navigateTo('/deposit',
                                                          arguments: model
                                                                  .favWalletInfoList[
                                                              index]);
                                                }),
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
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2
                                                            .copyWith(
                                                                fontSize: 8),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_upward,
                                                        color: red,
                                                        size: 16,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  model.navigationService
                                                      .navigateTo('/withdraw',
                                                          arguments: model
                                                                  .favWalletInfoList[
                                                              index]);
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

                    //                   //   Visibility(
                    //                   //     // Default visible widget will be visible when usdVal is greater than equals to 0 and isHideSmallAmountAssets is false
                    //                   //     visible: usdVal >= 0 && !model.isHideSmallAmountAssets,
                    //                   //     child: _coinDetailsCard(
                    //                   //         '$name',
                    //                   //         index,
                    //                   //         model.favWalletInfoList,
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
                    //                   //             model.favWalletInfoList,
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
                    //               //       //Text(model.favWalletInfoList.length.toString())

                    //               // ),
                    //             ),
                    )));
  }

  @override
  WalletDashboardViewModel viewModelBuilder(BuildContext context) =>
      WalletDashboardViewModel();
}
