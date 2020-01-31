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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../localizations.dart';
import '../../shared/globals.dart' as globals;
import '../../models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'dart:typed_data';
import 'package:exchangilymobileapp/environments/environment.dart';

class Withdraw extends StatelessWidget {
  final WalletInfo walletInfo;

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();

  Withdraw({Key key, this.walletInfo}) : super(key: key);
  final myController = TextEditingController();
  checkPass(double amount, context) async {
    if (amount == null || amount > walletInfo.assetsInExchange) {
      walletService.showInfoFlushbar(
          AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).pleaseEnterValidNumber,
          Icons.cancel,
          globals.red,
          context);
      return;
    }

    if (amount < environment["minimumWithdraw"][walletInfo.tickerName]) {
      walletService.showInfoFlushbar(
          'Minimum amount error',
          'Your withdraw minimum amount is not satisfied',
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
      var tokenType = this.walletInfo.tokenType;
      var coinName = this.walletInfo.tickerName;
      var coinAddress = this.walletInfo.address;
      if (coinName == 'USDT') {
        tokenType = 'ETH';
      }
      if (coinName == 'EXG') {
        tokenType = 'FAB';
      }
      var ret = await walletService.withdrawDo(
          seed, coinName, coinAddress, tokenType, amount);

      if (ret["success"]) {
        myController.text = '';
      }

      walletService.showInfoFlushbar(
          ret["success"]
              ? 'Withdraw transaction was made successfully'
              : 'Withdraw transaction failed',
          ret["success"]
              ? 'transactionID:' + ret['data']['transactionHash']
              : ret['data'],
          Icons.cancel,
          globals.red,
          context);
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

  @override
  Widget build(BuildContext context) {
    double bal = this.walletInfo.assetsInExchange;
    String coinName = this.walletInfo.tickerName;

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
            '${AppLocalizations.of(context).move}  ${walletInfo.tickerName}  ${AppLocalizations.of(context).toWallet}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Color(0XFF871fff), width: 1.0)),
                    hintText: AppLocalizations.of(context).enterAmount,
                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
                  ),
                  controller: myController,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  padding: EdgeInsets.all(15),
                  color: globals.primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    checkPass(double.parse(myController.text), context);
                  },
                  child: Text(
                    AppLocalizations.of(context).confirm,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).walletbalance + ' $bal',
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        '$coinName'.toUpperCase(),
                        style: Theme.of(context).textTheme.headline,
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}
