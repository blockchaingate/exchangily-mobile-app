/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/move_to_wallet_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../localizations.dart';
import '../../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter/gestures.dart';

class MoveToWalletScreen extends StatelessWidget {
  final WalletInfo walletInfo;
  const MoveToWalletScreen({Key key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MoveToWalletViewmodel>.reactive(
      viewModelBuilder: () => MoveToWalletViewmodel(),
      onModelReady: (model) {
        model.context = context;
        model.walletInfo = walletInfo;
        model.initState();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          print('is Alert ${model.isAlert}');
          if (model.isAlert) {
            Navigator.of(context, rootNavigator: true).pop();
            model.isAlert = false;
            print('i Alert in if ${model.isAlert}');
          } else {
            Navigator.of(context).pop();
          }

          return Future.value(false);
        },
        child: Scaffold(
            appBar: CupertinoNavigationBar(
              padding: const EdgeInsetsDirectional.only(start: 0),
              leading: CupertinoButton(
                padding: const EdgeInsets.all(0),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),
              middle: Text(
                  '${AppLocalizations.of(context).move}  ${model.specialTickerForTxHistory}  ${AppLocalizations.of(context).toWallet}',
                  style: Theme.of(context).textTheme.headline5),
              backgroundColor: const Color(0XFF1f2233),
            ),
            backgroundColor: const Color(0xFF1F2233),
            body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                          onChanged: (String amount) {
                            model.updateTransFee();
                          },
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            DecimalTextInputFormatter(
                                decimalRange: model.token.decimal,
                                activatedNegativeValues: false)
                          ],
                          decoration: InputDecoration(
                              suffix: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)
                                                  .minimumAmount +
                                              ': ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(
                                          model.token.minWithdraw == null
                                              ? AppLocalizations.of(context)
                                                  .loading
                                              : model.token.minWithdraw
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)
                                                  .decimalLimit +
                                              ': ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(model.token.decimal.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ],
                                  ),
                                ],
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0XFF871fff), width: 1.0)),
                              hintText:
                                  AppLocalizations.of(context).enterAmount,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.w300)),
                          controller: model.amountController,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontWeight: FontWeight.w300)),
                      UIHelper.verticalSpaceSmall,
                      // Exchange bal
                      Row(
                        children: <Widget>[
                          Text(
                              AppLocalizations.of(context).inExchange +
                                  ' ${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo.inExchange, precision: model.decimalLimit).toString()}',
                              style: Theme.of(context).textTheme.subtitle2),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3,
                            ),
                            child: walletInfo.tickerName == 'USDTX'
                                ? Text('USDT'.toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.subtitle2)
                                : Text(
                                    model.specialTickerForTxHistory
                                        .toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.subtitle2),
                          ),
                          model.isWithdrawChoice
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.info_outline,
                                        color: primaryColor,
                                        size: 16,
                                      ),
                                      onPressed: () =>
                                          model.showInfoDialog(false)),
                                )
                              : Container()
                          // min withdraw
                        ],
                      ),

                      UIHelper.verticalSpaceSmall,
                      // Kanban Gas Fee
                      // walletInfo.tickerName == 'TRX' ||
                      //         walletInfo.tickerName == 'USDTX' ||
                      //         model.isShowTrxTsWalletBalance
                      //     ? Container(
                      //         padding: EdgeInsets.only(top: 10, bottom: 0),
                      //         alignment: Alignment.topLeft,
                      //         child: walletInfo.tickerName == 'TRX'
                      //             ? Text(
                      //                 '${AppLocalizations.of(context).gasFee}: 1 TRX',
                      //                 textAlign: TextAlign.left,
                      //                 style:
                      //                     Theme.of(context).textTheme.headline6)
                      //             : Text(
                      //                 '${AppLocalizations.of(context).gasFee}: 15 TRX',
                      //                 textAlign: TextAlign.left,
                      //                 style: Theme.of(context)
                      //                     .textTheme
                      //                     .headline6),
                      //       )
                      //     : Container(),
                      //
                      // // withdraw choice radio
                      model.isWithdrawChoice
                          ? Container(
                              child: Row(
                                children: [
                                  model.isShowTrxTsWalletBalance ||
                                          model.walletInfo.tickerName ==
                                              "USDT" ||
                                          model.walletInfo.tickerName == "USDTX"
                                      ? Row(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: Radio(
                                                  activeColor:
                                                      globals.primaryColor,
                                                  onChanged: (value) {
                                                    model.radioButtonSelection(
                                                        value);
                                                  },
                                                  groupValue: model.groupValue,
                                                  value: 'TRX'),
                                            ),
                                            UIHelper.horizontalSpaceSmall,
                                            Text('TRC20',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                          ],
                                        )
                                      : Row(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                              width: 20,
                                              child: Radio(
                                                  //  model.groupValue == 'FAB'? fillColor: MaterialStateColor
                                                  //       .resolveWith(
                                                  //           (states) => Colors.blue),
                                                  activeColor:
                                                      globals.primaryColor,
                                                  onChanged: (value) {
                                                    model.radioButtonSelection(
                                                        value);
                                                  },
                                                  groupValue: model.groupValue,
                                                  value: 'FAB'),
                                            ),
                                            UIHelper.horizontalSpaceSmall,
                                            Text('FAB Chain',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                          ],
                                        ),
                                  UIHelper.horizontalSpaceMedium,
                                  // erc20 radio button
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                        width: 20,
                                        child: Radio(
                                            activeColor: globals.primaryColor,
                                            onChanged: (value) {
                                              model.radioButtonSelection(value);
                                            },
                                            groupValue: model.groupValue,
                                            value: 'ETH'),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Text('ERC20',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      // kanban gas fee
                      model.isWithdrawChoice
                          ? UIHelper.verticalSpaceMedium
                          : Container(),
                      // withdraw fee
                      Row(
                        children: <Widget>[
                          Text(
                              AppLocalizations.of(context).withdraw +
                                  AppLocalizations.of(context).fee,
                              style: Theme.of(context).textTheme.headline6),
                          UIHelper.horizontalSpaceSmall,
                          Padding(
                            padding: const EdgeInsets.only(
                                left:
                                    5), // padding left to keep some space from the text
                            child: model.isBusy
                                ? const Text('..')
                                : Text(
                                    '${model.token.feeWithdraw} ${model.specialTickerForTxHistory.contains('(') ? model.specialTickerForTxHistory.split('(')[0] : model.specialTickerForTxHistory}',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                          )
                        ],
                      ),
                      UIHelper.verticalSpaceSmall,
                      Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context).kanbanGasFee,
                              style: Theme.of(context).textTheme.headline6),
                          Padding(
                            padding: const EdgeInsets.only(
                                left:
                                    5), // padding left to keep some space from the text
                            child: Text(
                                '${model.kanbanTransFee.toStringAsFixed(4)} GAS',
                                style: Theme.of(context).textTheme.headline6),
                          )
                        ],
                      ),
                      // Switch Row
                      UIHelper.verticalSpaceSmall,
                      Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context).advance,
                              style: Theme.of(context).textTheme.headline6),
                          SizedBox(
                            height: 15,
                            child: Switch(
                              value: model.transFeeAdvance,
                              inactiveTrackColor: globals.grey,
                              dragStartBehavior: DragStartBehavior.start,
                              activeColor: globals.primaryColor,
                              onChanged: (bool isOn) {
                                model.setBusy(true);
                                model.transFeeAdvance = isOn;
                                model.setBusy(false);
                              },
                            ),
                          )
                        ],
                      ),
                      UIHelper.verticalSpaceSmall,
                      Visibility(
                          visible: model.transFeeAdvance,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .kanbanGasPrice,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                fontWeight: FontWeight.w300)),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: TextField(
                                              controller: model
                                                  .kanbanGasPriceTextController,
                                              onChanged: (String amount) {
                                                model.updateTransFee();
                                              },
                                              keyboardType:
                                                  const TextInputType.numberWithOptions(
                                                      decimal:
                                                          true), // numnber keyboard
                                              decoration: InputDecoration(
                                                  focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: globals
                                                              .primaryColor)),
                                                  enabledBorder: const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: globals.grey)),
                                                  hintText: '0.00000',
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w300)),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  .copyWith(
                                                      fontWeight: FontWeight.w300))))
                                ],
                              ),
                              // Kanban Gas Limit

                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .kanbanGasLimit,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                fontWeight: FontWeight.w300),
                                      )),
                                  Expanded(
                                      flex: 5,
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: TextField(
                                              controller: model
                                                  .kanbanGasLimitTextController,
                                              onChanged: (String amount) {
                                                model.updateTransFee();
                                              },
                                              keyboardType: TextInputType
                                                  .number, // numnber keyboard
                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: globals
                                                                  .primaryColor)),
                                                  enabledBorder: const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: globals.grey)),
                                                  hintText: '0.00000',
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w300)),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w300)))),
                                ],
                              ),
                              UIHelper.verticalSpaceSmall,
                            ],
                          )),

                      UIHelper.verticalSpaceSmall,

                      // TS wallet balance show
                      // Expanded(
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //           child: Row(
                      //         mainAxisAlignment:
                      //             MainAxisAlignment.center,
                      //         children: [
                      //           Text(
                      //             'TS ${AppLocalizations.of(context).wallet}',
                      //             style: Theme.of(context)
                      //                 .textTheme
                      //                 .subtitle2,
                      //           ),
                      //           Text(
                      //             '${AppLocalizations.of(context).balance}: ',
                      //             style: Theme.of(context)
                      //                 .textTheme
                      //                 .subtitle2,
                      //           ),
                      //           model.isWithdrawChoice
                      //               ? SizedBox(
                      //                   width: 20,
                      //                   height: 20,
                      //                   child: IconButton(
                      //                       padding: EdgeInsets.zero,
                      //                       icon: Icon(
                      //                         Icons.info_outline,
                      //                         color: primaryColor,
                      //                         size: 16,
                      //                       ),
                      //                       onPressed: () =>
                      //                           model.showInfoDialog(
                      //                               true)),
                      //                 )
                      //               : Container()
                      //         ],
                      //       )),

                      //       // show ts wallet balance for tron chain
                      //       model.walletInfo.tickerName == 'USDT' ||
                      //               model.walletInfo.tickerName ==
                      //                   'USDTX'
                      //           ? Container(
                      //               margin:
                      //                   EdgeInsets.only(left: 5.0),
                      //               child: model.trxTsWalletBalance !=
                      //                           null &&
                      //                       model.ethChainBalance !=
                      //                           null
                      //                   ? model
                      //                           .isShowTrxTsWalletBalance
                      //                       ? Text(
                      //                           model
                      //                               .trxTsWalletBalance
                      //                               .toString(),
                      //                           maxLines: 2,
                      //                           style:
                      //                               Theme.of(context)
                      //                                   .textTheme
                      //                                   .headline6,
                      //                         )
                      //                       : Text(
                      //                           model.ethChainBalance
                      //                               .toString(),
                      //                           maxLines: 2,
                      //                           style:
                      //                               Theme.of(context)
                      //                                   .textTheme
                      //                                   .headline6,
                      //                         )
                      //                   : Container(
                      //                       child: Text(
                      //                           AppLocalizations.of(context)
                      //                               .loading)))
                      //           : Container(
                      //               margin:
                      //                   EdgeInsets.only(left: 5.0),
                      //               child: model.fabChainBalance !=
                      //                           null &&
                      //                       model.ethChainBalance !=
                      //                           null
                      //                   ? model.isShowFabChainBalance
                      //                       ? Text(
                      //                           model.fabChainBalance
                      //                               .toString(),
                      //                           maxLines: 2,
                      //                           style:
                      //                               Theme.of(context)
                      //                                   .textTheme
                      //                                   .headline6,
                      //                         )
                      //                       : Text(
                      //                           model.ethChainBalance
                      //                               .toString(),
                      //                           maxLines: 2,
                      //                           style:
                      //                               Theme.of(context)
                      //                                   .textTheme
                      //                                   .headline6,
                      //                         )
                      //                   : Container(
                      //                       child: Text(
                      //                           AppLocalizations.of(context)
                      //                               .loading))),
                      //     ],
                      //   ),
                      // ),

                      // Success/Error container
                      Container(
                          child: Visibility(
                              visible: model.message.isNotEmpty,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    model.message ?? '',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  RichText(
                                    text: TextSpan(
                                        text: AppLocalizations.of(context)
                                            .taphereToCopyTxId,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: primaryColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            model.copyAndShowNotificatio(
                                                model.message);
                                          }),
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                ],
                              ))),

                      UIHelper.verticalSpaceSmall,
                      model.isShowErrorDetailsButton
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                color: red,
                                                decoration:
                                                    TextDecoration.underline),
                                        text:
                                            '${AppLocalizations.of(context).error} ${AppLocalizations.of(context).details}',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            model.showDetailsMessageToggle();
                                          }),
                                  ),
                                ),
                                !model.isShowDetailsMessage
                                    ? const Icon(Icons.arrow_drop_down,
                                        color: Colors.red, size: 20)
                                    : const Icon(Icons.arrow_drop_up,
                                        color: Colors.red, size: 20)
                              ],
                            )
                          : Container(),
                      UIHelper.verticalSpaceSmall,
                      model.isShowDetailsMessage
                          ? Center(
                              child: Text(model.serverError,
                                  style: Theme.of(context).textTheme.headline6),
                            )
                          : Container(),
                      UIHelper.verticalSpaceMedium,
                      // Confirm Button
                      MaterialButton(
                        padding: const EdgeInsets.all(15),
                        color: globals.primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          model.checkPass();
                        },
                        child: model.isBusy
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                ))
                            : Text(AppLocalizations.of(context).confirm,
                                style: Theme.of(context).textTheme.headline4),
                      ),
                    ],
                  )),
            )),
      ),
    );
  }
}
