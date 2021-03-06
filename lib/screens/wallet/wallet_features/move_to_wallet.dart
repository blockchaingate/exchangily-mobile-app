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

import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/move_to_wallet_viewmodel.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../localizations.dart';
import '../../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

class MoveToWalletScreen extends StatelessWidget {
  final WalletInfo walletInfo;
  MoveToWalletScreen({Key key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  double bal = walletInfo.inExchange;
    String coinName = walletInfo.tickerName;

    return BaseScreen<MoveToWalletViewmodel>(
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
          } else
            Navigator.of(context).pop();

          return Future.value(false);
        },
        child: Scaffold(
            appBar: CupertinoNavigationBar(
              padding: EdgeInsetsDirectional.only(start: 0),
              leading: CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Icon(
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
                  '${AppLocalizations.of(context).move}  ${model.specialTicker}  ${AppLocalizations.of(context).toWallet}',
                  style: Theme.of(context).textTheme.headline5),
              backgroundColor: Color(0XFF1f2233),
            ),
            backgroundColor: Color(0xFF1F2233),
            body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                          onChanged: (String amount) {
                            model.updateTransFee();
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              suffix: Text(
                                  AppLocalizations.of(context).minimumAmount +
                                      ': ' +
                                      model.withdrawLimit.toString(),
                                  style: Theme.of(context).textTheme.headline6),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(
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
                                  ' ${walletInfo.inExchange.toStringAsFixed(model.singlePairDecimalConfig.qtyDecimal)}',
                              style: Theme.of(context).textTheme.subtitle2),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3,
                            ),
                            child: Text('$coinName'.toUpperCase(),
                                style: Theme.of(context).textTheme.subtitle2),
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
                        ],
                      ),

                      UIHelper.verticalSpaceSmall,
                      // Kanban Gas Fee
                      Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context).kanbanGasFee,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.w300)),
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    5), // padding left to keep some space from the text
                            child: Text(
                                '${model.kanbanTransFee.toStringAsFixed(4)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w300)),
                          )
                        ],
                      ),
                      // Switch Row
                      UIHelper.verticalSpaceSmall,
                      Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context).advance,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.w300)),
                          Switch(
                            value: model.transFeeAdvance,
                            inactiveTrackColor: globals.grey,
                            dragStartBehavior: DragStartBehavior.start,
                            activeColor: globals.primaryColor,
                            onChanged: (bool isOn) {
                              model.setBusy(true);
                              model.transFeeAdvance = isOn;
                              model.setBusy(false);
                            },
                          )
                        ],
                      ),

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
                                              EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: TextField(
                                              controller: model
                                                  .kanbanGasPriceTextController,
                                              onChanged: (String amount) {
                                                model.updateTransFee();
                                              },
                                              keyboardType:
                                                  TextInputType.numberWithOptions(
                                                      decimal:
                                                          true), // numnber keyboard
                                              decoration: InputDecoration(
                                                  focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: globals
                                                              .primaryColor)),
                                                  enabledBorder: UnderlineInputBorder(
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
                                              EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                                                  enabledBorder: UnderlineInputBorder(
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

                      model.isWithdrawChoice
                          ? Container(
                              child: Row(
                              children: [
                                // for (var chainBalance in model.chainBalances)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('FAB Chain',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    Radio(
                                        activeColor: globals.primaryColor,
                                        onChanged: (value) {
                                          model.radioButtonSelection(value);
                                        },
                                        groupValue: model.groupValue,
                                        value: 'FAB'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('ERC20',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    Radio(
                                        activeColor: globals.primaryColor,
                                        onChanged: (value) {
                                          model.radioButtonSelection(value);
                                        },
                                        groupValue: model.groupValue,
                                        value: 'ETH'),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'TS ${AppLocalizations.of(context).wallet}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context).balance}: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
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
                                                          model.showInfoDialog(
                                                              true)),
                                                )
                                              : Container()
                                        ],
                                      )),
                                      Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          child: model.fabChainBalance !=
                                                      null &&
                                                  model.ethChainBalance != null
                                              ? model.isShowFabChainBalance
                                                  ? Text(
                                                      model.fabChainBalance
                                                          .toString(),
                                                      maxLines: 2,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                    )
                                                  : Text(
                                                      model.ethChainBalance
                                                          .toString(),
                                                      maxLines: 2,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                    )
                                              : Container()),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                          : Container(),
                      // Success/Error container
                      Container(
                          child: Visibility(
                              visible: model.hasMessage,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(model.message != null
                                      ? model.message
                                      : ''),
                                  UIHelper.verticalSpaceSmall,
                                  RichText(
                                    text: TextSpan(
                                        text: AppLocalizations.of(context)
                                            .taphereToCopyTxId,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: globals.primaryColor),
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
                                            .bodyText2
                                            .copyWith(
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
                                    ? Icon(Icons.arrow_drop_down,
                                        color: Colors.red, size: 18)
                                    : Icon(Icons.arrow_drop_up,
                                        color: Colors.red, size: 18)
                              ],
                            )
                          : Container(),

                      model.isShowDetailsMessage
                          ? Center(
                              child: Text(model.serverError,
                                  style: Theme.of(context).textTheme.headline6),
                            )
                          : Container(),
                      UIHelper.verticalSpaceSmall,
                      // Confirm Button
                      MaterialButton(
                        padding: EdgeInsets.all(15),
                        color: globals.primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          model.checkPass();
                        },
                        child: model.busy
                            ? SizedBox(
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
