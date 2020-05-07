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

import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../localizations.dart';
import '../../../shared/globals.dart' as globals;
import '../../../models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'dart:typed_data';
import 'package:exchangilymobileapp/environments/environment.dart';
import '../../../utils/string_util.dart';

import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter/services.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:flutter/gestures.dart';

class MoveToWalletScreen extends StatefulWidget {
  final WalletInfo walletInfo;
  MoveToWalletScreen({Key key, this.walletInfo}) : super(key: key);

  @override
  _MoveToWalletScreenState createState() => _MoveToWalletScreenState();
}

class _MoveToWalletScreenState extends State<MoveToWalletScreen> {
  String gasFeeUnit = '';
  String feeMeasurement = '';
  final _kanbanGasPriceTextController = TextEditingController();
  final _kanbanGasLimitTextController = TextEditingController();
  double kanbanTransFee = 0.0;
  double minimumAmount = 0.0;
  bool transFeeAdvance = false;

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var gasPrice = environment["chains"]["KANBAN"]["gasPrice"];
    var gasLimit = environment["chains"]["KANBAN"]["gasLimit"];
    minimumAmount =
        environment['minimumWithdraw'][widget.walletInfo.tickerName];
    _kanbanGasPriceTextController.text = gasPrice.toString();
    _kanbanGasLimitTextController.text = gasLimit.toString();

    kanbanTransFee = bigNum2Double(gasPrice * gasLimit);

    if (widget.walletInfo.tickerName == 'ETH' ||
        widget.walletInfo.tickerName == 'USDT') {
      gasFeeUnit = 'WEI';
    } else if (widget.walletInfo.tickerName == 'FAB') {
      gasFeeUnit = 'LIU';
      feeMeasurement = '10^(-8)';
    }
  }

  checkPass(double amount, context) async {
    if (amount == null || amount > widget.walletInfo.inExchange) {
      walletService.showInfoFlushbar(
          AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).pleaseEnterValidNumber,
          Icons.cancel,
          globals.red,
          context);
      return;
    }

    if (amount < environment["minimumWithdraw"][widget.walletInfo.tickerName]) {
      walletService.showInfoFlushbar(
          AppLocalizations.of(context).minimumAmountError,
          AppLocalizations.of(context).yourWithdrawMinimumAmountaIsNotSatisfied,
          Icons.cancel,
          globals.red,
          context);
      return;
    }

    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);
      var tokenType = widget.walletInfo.tokenType;
      var coinName = widget.walletInfo.tickerName;
      var coinAddress = widget.walletInfo.address;
      if (coinName == 'USDT') {
        tokenType = 'ETH';
      }
      if (coinName == 'EXG') {
        tokenType = 'FAB';
      }

      var kanbanPrice = int.tryParse(_kanbanGasPriceTextController.text);
      var kanbanGasLimit = int.tryParse(_kanbanGasLimitTextController.text);

      await walletService
          .withdrawDo(seed, coinName, coinAddress, tokenType, amount,
              kanbanPrice, kanbanGasLimit)
          .then((ret) {
        if (ret["success"]) {
          myController.text = '';
        }
        walletService.showInfoFlushbar(
            ret["success"]
                ? AppLocalizations.of(context).withdrawTransactionSuccessful
                : AppLocalizations.of(context).withdrawTransactionFailed,
            ret["success"]
                ? '${AppLocalizations.of(context).transactionId}' +
                    ret['data']['transactionHash']
                : ret['data'],
            Icons.cancel,
            globals.red,
            context);
      }).catchError((err) {
        print('Withdraw catch $err');
      });
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
  }

  showNotification(context) {
    walletService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        globals.red,
        context);
  }

  updateTransFee() async {
    var kanbanPrice = int.tryParse(_kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(_kanbanGasLimitTextController.text);

    var kanbanPriceBig = BigInt.from(kanbanPrice);
    var kanbanGasLimitBig = BigInt.from(kanbanGasLimit);
    var kanbanTransFeeDouble =
        bigNum2Double(kanbanPriceBig * kanbanGasLimitBig);
    print('Update trans fee $kanbanTransFeeDouble');
    setState(() {
      kanbanTransFee = kanbanTransFeeDouble;
    });
  }

  @override
  Widget build(BuildContext context) {
    double bal = widget.walletInfo.inExchange;
    String coinName = widget.walletInfo.tickerName;

    return Scaffold(
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
              '${AppLocalizations.of(context).move}  ${widget.walletInfo.tickerName}  ${AppLocalizations.of(context).toWallet}',
              style: Theme.of(context).textTheme.headline4),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                    onChanged: (String amount) {
                      updateTransFee();
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
                    controller: myController,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.w300)),
                UIHelper.verticalSpaceSmall,
                // Exchange bal
                Row(
                  children: <Widget>[
                    Text(AppLocalizations.of(context).inExchange + ' $bal',
                        style: Theme.of(context).textTheme.bodyText2),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text('$coinName'.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyText2),
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
                      child: Text('$minimumAmount',
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
                      child: Text('$kanbanTransFee',
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
                      value: transFeeAdvance,
                      inactiveTrackColor: globals.grey,
                      dragStartBehavior: DragStartBehavior.start,
                      activeColor: globals.primaryColor,
                      onChanged: (bool isOn) {
                        setState(() {
                          transFeeAdvance = isOn;
                        });
                      },
                    )
                  ],
                ),

                Visibility(
                    visible: transFeeAdvance,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(AppLocalizations.of(context).kanbanGasPrice,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w300)),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: TextField(
                                        controller:
                                            _kanbanGasPriceTextController,
                                        onChanged: (String amount) {
                                          updateTransFee();
                                        },
                                        keyboardType: TextInputType
                                            .number, // numnber keyboard
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        globals.primaryColor)),
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
                            Text(AppLocalizations.of(context).kanbanGasLimit,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w300)),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: TextField(
                                        controller:
                                            _kanbanGasLimitTextController,
                                        onChanged: (String amount) {
                                          updateTransFee();
                                        },
                                        keyboardType: TextInputType
                                            .number, // numnber keyboard
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        globals.primaryColor)),
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
                                                fontWeight: FontWeight.w300)))),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                      ],
                    )),

                UIHelper.verticalSpaceSmall,
                MaterialButton(
                  padding: EdgeInsets.all(15),
                  color: globals.primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    checkPass(double.parse(myController.text), context);
                  },
                  child: Text(AppLocalizations.of(context).confirm,
                      style: Theme.of(context).textTheme.headline4),
                ),
              ],
            )));
  }
}
