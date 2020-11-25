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

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'dart:typed_data';

class AddGas extends StatelessWidget {
  final DialogService _dialogService = locator<DialogService>();
  final WalletService walletService = locator<WalletService>();
  final SharedService sharedService = locator<SharedService>();

  final log = getLogger('AddGas');
  final myController = TextEditingController();

  checkPass(double amount, context) async {
    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);
      var ret = await walletService.addGasDo(seed, amount);

      //{'txHex': txHex, 'txHash': txHash, 'errMsg': errMsg}
      String errorMsg = ret["errMsg"];

      String formattedErrorMsg = firstCharToUppercase(errorMsg);

      myController.text = '';
      sharedService.alertDialog(
          (ret["errMsg"] == '')
              ? AppLocalizations.of(context).addGasTransactionSuccess
              : AppLocalizations.of(context).addGasTransactionFailed,
          (ret["errMsg"] == '') ? ret['txHash'] : formattedErrorMsg,
          isWarning: false,
          isCopyTxId: ret["errMsg"] == '' ? true : false,
          path: (ret["errMsg"] == '') ? 'dashboard' : '');
    } else {
      if (res.returnedText != 'Closed') {
        wrongPasswordNotification(context);
      }
    }
  }

  wrongPasswordNotification(context) {
    sharedService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        globals.red,
        context);
  }

  @override
  Widget build(BuildContext context) {
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
            AppLocalizations.of(context).addGas,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: globals.primaryColor),
                    child: Image.asset("assets/images/img/gas.png",
                        width: 100, height: 100)),
                SizedBox(height: 30),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Color(0XFF871fff), width: 1.0)),
                    hintText:
                        AppLocalizations.of(context).enterAmount + '(FAB)',
                    hintStyle: Theme.of(context).textTheme.headline6,
                  ),
                  controller: myController,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: MaterialButton(
                          // borderSide: BorderSide(color: globals.primaryColor),
                          color: globals.primaryColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context).cancel,
                              style: TextStyle(color: Colors.white))),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: OutlineButton(
                        borderSide: BorderSide(color: primaryColor),
                        padding: EdgeInsets.all(15),
                        color: primaryColor,
                        textColor: Colors.white,
                        onPressed: () async {
                          double amount = 0;
                          if (myController.text != '') {
                            amount = double.parse(myController.text);
                          }
                          // var res = await AddGasDo(double.parse(myController.text));
                          myController.text == '' || amount == null
                              ? sharedService.showInfoFlushbar(
                                  AppLocalizations.of(context).invalidAmount,
                                  AppLocalizations.of(context)
                                      .pleaseEnterValidNumber,
                                  Icons.cancel,
                                  globals.red,
                                  context)
                              : checkPass(amount, context);
                          //   print(res);
                        },
                        child: Text(
                          AppLocalizations.of(context).confirm,
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}
