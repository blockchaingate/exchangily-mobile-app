import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class WalletDashboardCoinsDetailsCardWidget
    extends ViewModelBuilderWidget<WalletDashboardViewModel> {
  const WalletDashboardCoinsDetailsCardWidget(
      {Key key, @required this.index, @required this.wallets})
      : super(key: key);
  final int index;
  final List<WalletInfo> wallets;

  @override
  Widget builder(
      BuildContext context, WalletDashboardViewModel model, Widget child) {
    var usedWalletList = wallets;

    // isFav ? model.favWalletInfoList : model.walletInfo;
    var tickerName = usedWalletList[index].tickerName.toLowerCase();

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
    return Container(
      child: Card(
        color: walletCardColor,
        elevation: model.elevation,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            model.navigationService.navigateTo('/walletFeatures',
                arguments: usedWalletList[index]);
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
                              child: Text(
                                  AppLocalizations.of(context).available,
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                            model.isBusy
                                ? SizedBox(
                                    child: Shimmer.fromColors(
                                    baseColor: red,
                                    highlightColor: white,
                                    child: Text(
                                      usedWalletList[index]
                                          .availableBalance
                                          .toStringAsFixed(2),
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ))
                                : Expanded(
                                    child: Text(
                                        usedWalletList[index]
                                                .availableBalance
                                                .isNegative
                                            ? '0.0'
                                            : usedWalletList[index]
                                                .availableBalance
                                                .toStringAsFixed(4),
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
                                    child: Text(
                                        '${usedWalletList[index].lockedBalance}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(color: red)),
                                  ))
                                : Expanded(
                                    child: Text(
                                        usedWalletList[index]
                                                .lockedBalance
                                                .isNegative
                                            ? '0.0'
                                            : usedWalletList[index]
                                                .lockedBalance
                                                .toStringAsFixed(4),
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
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              ),
                            ),
                            model.isBusy
                                ? SizedBox(
                                    child: Shimmer.fromColors(
                                    baseColor: primaryColor,
                                    highlightColor: white,
                                    child: Text(
                                      usedWalletList[index]
                                          .inExchange
                                          .toStringAsFixed(4),
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ))
                                : Expanded(
                                    child: Text(
                                        usedWalletList[index].inExchange == 0
                                            ? '0.0'
                                            : NumberUtil()
                                                .truncateDoubleWithoutRouding(
                                                    usedWalletList[index]
                                                        .inExchange,
                                                    precision: 4)
                                                .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(color: primaryColor)),
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
                                  Text('\$', style: TextStyle(color: green)),
                                  Expanded(
                                    child: Shimmer.fromColors(
                                      baseColor: grey,
                                      highlightColor: white,
                                      child: Text(
                                        '${usedWalletList[index].usdValue.toStringAsFixed(2)}',
                                        style: TextStyle(color: green),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Text('\$', style: TextStyle(color: green)),
                                  Expanded(
                                    child: Text(
                                        '${NumberUtil().truncateDoubleWithoutRouding(usedWalletList[index].usdValue, precision: 2).toString()} USD',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: green)),
                                  ),
                                ],
                              ),

                        // Deposit and Withdraw Container Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                                child: tickerName.toUpperCase() == 'FAB' &&
                                        (model.isShowCaseView ||
                                            model.gasAmount < 0.5) &&
                                        !model.isBusy
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, right: 5.0, left: 2.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)
                                                  .deposit,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(fontSize: 8),
                                            ),
                                            Icon(Icons.arrow_downward,
                                                color: green, size: 16),
                                          ],
                                        ))
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, right: 5.0, left: 2.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)
                                                  .deposit,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(fontSize: 8),
                                            ),
                                            Icon(Icons.arrow_downward,
                                                color: green, size: 16),
                                          ],
                                        )),
                                onTap: () {
                                  model.navigationService.navigateTo('/deposit',
                                      arguments: usedWalletList[index]);
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
                                        color: red,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  model.navigationService.navigateTo(
                                      '/withdraw',
                                      arguments: usedWalletList[index]);
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
      ),
    );
  }

  @override
  WalletDashboardViewModel viewModelBuilder(BuildContext context) =>
      WalletDashboardViewModel();
}

// class WalletDashboardCoinsDetailsCard extends StatelessWidget {
//    final WalletInfo walletInfo;
//   const WalletDashboardCoinsDetailsCard({Key key, this.walletInfo}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//   String logoTicker = '';
//   if (walletInfo.tickerName.toUpperCase() == 'BSTE') {
//     walletInfo.tickerName = 'BST(ERC20)';
//     logoTicker = 'BSTE';
//   } else if (walletInfo.tickerName.toUpperCase() == 'DSCE') {
//     walletInfo.tickerName = 'DSC(ERC20)';
//     logoTicker = 'DSCE';
//   } else if (walletInfo.tickerName.toUpperCase() == 'EXGE') {
//     walletInfo.tickerName = 'EXG(ERC20)';
//     logoTicker = 'EXGE';
//   } else if (walletInfo.tickerName.toUpperCase() == 'FABE') {
//     walletInfo.tickerName = 'FAB(ERC20)';
//     logoTicker = 'FABE';
//   } else if (walletInfo.tickerName.toUpperCase() == 'USDTX') {
//     walletInfo.tickerName = 'USDT(TRC20)';
//     logoTicker = 'USDTX';
//   } else if (walletInfo.tickerName.toUpperCase() == 'USDT') {
//     walletInfo.tickerName = 'USDT(ERC20)';
//     logoTicker = 'USDT';
//   } else {
//     logoTicker = walletInfo.tickerName;
//   }
//     return
//      Container(
//       child:  Card(
//     color: walletCardColor,
//     elevation: elevation,
//     child: InkWell(
//       splashColor: Colors.blue.withAlpha(30),
//       onDoubleTap: () => FocusScope.of(context).requestFocus(FocusNode()),
//       onTap: () {
//         model.onSingleCoinCardClick(index);
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             UIHelper.horizontalSpaceSmall,
//             // Card logo container
//             Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                     color: globals.walletCardColor,
//                     borderRadius: BorderRadius.circular(50),
//                     boxShadow: [
//                       BoxShadow(
//                           color: globals.fabLogoColor,
//                           offset: Offset(1.0, 5.0),
//                           blurRadius: 10.0,
//                           spreadRadius: 1.0),
//                     ]),
//                 child: Image.network(
//                     '$WalletCoinsLogoUrl${logoTicker.toLowerCase()}.png'),
//                 //asset('assets/images/wallet-page/$tickerName.png'),
//                 width: 35,
//                 height: 35),
//             UIHelper.horizontalSpaceSmall,
//             // Tickername available locked and inexchange column
//             Expanded(
//               flex: 3,
//               child: Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       '$tickerName'.toUpperCase(),
//                       style: Theme.of(context).textTheme.headline3,
//                     ),
//                     // Available Row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(right: 5.0),
//                           child: Text(AppLocalizations.of(context).available,
//                               style: Theme.of(context).textTheme.headline6),
//                         ),
//                         model.isBusy
//                             ? SizedBox(
//                                 child: Shimmer.fromColors(
//                                 baseColor: globals.red,
//                                 highlightColor: globals.white,
//                                 child: Text(
//                                   walletInfo[index]
//                                       .availableBalance
//                                       .toStringAsFixed(2),
//                                   style: Theme.of(context).textTheme.headline6,
//                                 ),
//                               ))
//                             : Expanded(
//                                 child: Text(
//                                     walletInfo[index]
//                                             .availableBalance
//                                             .isNegative
//                                         ? '0.0'
//                                         : walletInfo[index]
//                                             .availableBalance
//                                             .toStringAsFixed(4),
//                                     style:
//                                         Theme.of(context).textTheme.headline6),
//                               ),
//                       ],
//                     ),
//                     // Locked Row
//                     Row(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 2.0, right: 5.0, bottom: 2.0),
//                           child: Text(AppLocalizations.of(context).locked,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline6
//                                   .copyWith(color: red)),
//                         ),
//                         model.isBusy
//                             ? SizedBox(
//                                 child: Shimmer.fromColors(
//                                 baseColor: globals.red,
//                                 highlightColor: globals.white,
//                                 child: Text(
//                                     '${walletInfo[index].lockedBalance}',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .headline6
//                                         .copyWith(color: red)),
//                               ))
//                             : Expanded(
//                                 child: Text(
//                                     walletInfo[index].lockedBalance.isNegative
//                                         ? '0.0'
//                                         : walletInfo[index]
//                                             .lockedBalance
//                                             .toStringAsFixed(4),
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .headline6
//                                         .copyWith(color: red)),
//                               )
//                       ],
//                     ),
//                     // Inexchange Row
//                     Row(
//                       children: <Widget>[
//                         Container(
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 5.0),
//                             child: Text(AppLocalizations.of(context).inExchange,
//                                 textAlign: TextAlign.center,
//                                 style: Theme.of(context).textTheme.headline6),
//                           ),
//                         ),
//                         model.isBusy
//                             ? SizedBox(
//                                 child: Shimmer.fromColors(
//                                 baseColor: globals.primaryColor,
//                                 highlightColor: globals.white,
//                                 child: Text(
//                                   walletInfo[index]
//                                       .inExchange
//                                       .toStringAsFixed(4),
//                                   textAlign: TextAlign.center,
//                                   style: Theme.of(context).textTheme.headline6,
//                                 ),
//                               ))
//                             : Expanded(
//                                 child: Text(
//                                     walletInfo[index].inExchange == 0
//                                         ? '0.0'
//                                         : NumberUtil()
//                                             .truncateDoubleWithoutRouding(
//                                                 walletInfo[index].inExchange,
//                                                 precision: 4)
//                                             .toString(),
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .headline6
//                                         .copyWith(color: globals.primaryColor)),
//                               ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Value USD and deposit - withdraw Container column
//             Expanded(
//               flex: 2,
//               child: Container(
//                 child: Column(
//                   children: <Widget>[
//                     model.isBusy
//                         ? Row(
//                             children: [
//                               Text('\$',
//                                   style: TextStyle(color: globals.green)),
//                               Expanded(
//                                 child: Shimmer.fromColors(
//                                   baseColor: globals.grey,
//                                   highlightColor: globals.white,
//                                   child: Text(
//                                     '${walletInfo[index].usdValue.toStringAsFixed(2)}',
//                                     style: TextStyle(color: globals.green),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         : Row(
//                             children: [
//                               Text('\$',
//                                   style: TextStyle(color: globals.green)),
//                               Expanded(
//                                 child:
//                                     // model.formattedUsdValueList.isEmpty ||
//                                     //         model.formattedUsdValueList == null
//                                     //     ? Shimmer.fromColors(
//                                     //         baseColor: globals.grey,
//                                     //         highlightColor: globals.white,
//                                     //         child:
//                                     Text(
//                                   '${NumberUtil().truncateDoubleWithoutRouding(walletInfo[index].usdValue, precision: 2).toString()}',
//                                   style: TextStyle(color: globals.green),
//                                 ),
//                               )
//                               // : Text(
//                               //     '${model.formattedUsdValueList[index]} USD',
//                               //     textAlign: TextAlign.start,
//                               //     style: TextStyle(color: globals.green)),
//                               // ),
//                             ],
//                           ),

//                     // Deposit and Withdraw Container Row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         DepositWidget(
//                             model: model, index: index, tickerName: tickerName),
//                         Divider(
//                           endIndent: 5,
//                         ),
//                         InkWell(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     AppLocalizations.of(context).withdraw,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .subtitle2
//                                         .copyWith(fontSize: 8),
//                                   ),
//                                   Icon(
//                                     Icons.arrow_upward,
//                                     color: globals.red,
//                                     size: 16,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             onTap: () {
//                               Navigator.pushNamed(context, '/withdraw',
//                                   arguments: model.walletInfo[index]);
//                             }),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

//     );
//   }
// }
