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

import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/globals.dart' as globals;
import '../../models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'dart:typed_data';

// {"success":true,"data":{"transactionID":"7f9d1b3fad00afa85076d28d46fd3457f66300989086b95c73ed84e9b3906de8"}}
class Deposit extends StatelessWidget {
  final WalletInfo walletInfo;

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  Deposit({Key key, this.walletInfo}) : super(key: key);
  final myController = TextEditingController();

  checkPass(double amount, context) async {
    if (amount == null || amount > walletInfo.availableBalance) {
      walletService.showInfoFlushbar(
          AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).pleaseEnterValidNumber,
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
      if (coinName == 'USDT') {
        tokenType = 'ETH';
      }
      if (coinName == 'EXG') {
        tokenType = 'FAB';
      }
      var ret =
          await walletService.depositDo(seed, coinName, tokenType, amount);

      if (ret["success"]) {
        myController.text = '';
      }
      var errMsg = ret['data'];
      if (errMsg == null || errMsg == '') {
        errMsg = ret['error'];
      }
      if (errMsg == null || errMsg == '') {
        errMsg = 'Unknown Error';
      }
      walletService.showInfoFlushbar(
          ret["success"]
              ? AppLocalizations.of(context).depositTransactionSuccess
              : AppLocalizations.of(context).depositTransactionFailed,
          ret["success"]
              ? 'transactionID:' + ret['data']['transactionID']
              : errMsg,
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
    double bal = this.walletInfo.availableBalance;
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
            '${AppLocalizations.of(context).move}  ${walletInfo.tickerName}  ${AppLocalizations.of(context).toExchange}',
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
                // Text("Amount:",
                //     style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
                // SizedBox(height: 10),
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
                    //var res = await new WalletService().depositDo('ETH', '', double.parse(myController.text));
                    // var res = await new WalletService().depositDo('USDT', 'ETH', double.parse(myController.text));
                    // var res = await new WalletService().depositDo('FAB', '', double.parse(myController.text));
                    //var res = await new WalletService().depositDo('EXG', 'FAB', double.parse(myController.text));
                    // var res = await new WalletService().depositDo('BTC', '', double.parse(myController.text));
                    //print('res from await depositDo=');
                    //print(res);
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
