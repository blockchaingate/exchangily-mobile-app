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

import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/move_to_wallet_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../localizations.dart';
import '../../../shared/globals.dart' as globals;
import '../../../models/wallet.dart';

import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter/services.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:flutter/gestures.dart';

class MoveToWalletScreen extends StatelessWidget {
  final WalletInfo walletInfo;
  MoveToWalletScreen({Key key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double bal = walletInfo.inExchange;
    String coinName = walletInfo.tickerName;

    return BaseScreen<MoveToWalletScreenState>(
      onModelReady: (model) {
        model.context = context;
        model.walletInfo = walletInfo;
        model.initState();
      },
      builder: (context, model, child) => Scaffold(
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
                '${AppLocalizations.of(context).move}  ${walletInfo.tickerName}  ${AppLocalizations.of(context).toWallet}',
                style: Theme.of(context).textTheme.headline4),
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
                            enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Color(0XFF871fff), width: 1.0)),
                            hintText: AppLocalizations.of(context).enterAmount,
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
                        Text(AppLocalizations.of(context).inExchange + ' $bal',
                            style: Theme.of(context).textTheme.subtitle2),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3,
                          ),
                          child: Text('$coinName'.toUpperCase(),
                              style: Theme.of(context).textTheme.subtitle2),
                        )
                      ],
                    ),
                    UIHelper.verticalSpaceSmall,
                    Row(
                      children: <Widget>[
                        Text(AppLocalizations.of(context).minimumAmount,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.w300)),
                        Padding(
                          padding: EdgeInsets.only(
                              left:
                                  5), // padding left to keep some space from the text
                          child: Text('${model.minimumAmount}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.w300)),
                        )
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
                          child: Text('${model.kanbanTransFee}',
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
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                globals.grey)),
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
                    // Success/Error container
                    Container(
                        child: Visibility(
                            visible: model.hasMessage,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(model.message),
                                UIHelper.verticalSpaceSmall,
                                RichText(
                                  text: TextSpan(
                                      text: AppLocalizations.of(context)
                                          .taphereToCopyTxId,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
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
    );
  }
}
