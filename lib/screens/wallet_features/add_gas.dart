import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'dart:typed_data';

class AddGas extends StatelessWidget {
  final DialogService _dialogService = locator<DialogService>();
  final WalletService walletService = locator<WalletService>();
  final log = getLogger('AddGas');
  AddGas({Key key}) : super(key: key);

  checkPass(double amount, context) async {
    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.fieldOne;
      Uint8List seed = walletService.generateSeed(mnemonic);
      var ret = await walletService.addGasDo(seed, amount);

      //{'txHex': txHex, 'txHash': txHash, 'errMsg': errMsg}
      print('retfffff=');
      print(ret);
      walletService.showInfoFlushbar(
          (ret["errMsg"] == '')
              ? AppLocalizations.of(context).addGasTransactionSuccess
              : AppLocalizations.of(context).addGasTransactionFailed,
          (ret["errMsg"] == '')
              ? AppLocalizations.of(context).transactionId + ret['txHash']
              : ret["errMsg"],
          Icons.cancel,
          globals.red,
          context);
    } else {
      if (res.fieldOne != 'Closed') {
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
    final myController = TextEditingController();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Text(AppLocalizations.of(context).amount,
                //     style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
                SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Color(0XFF871fff), width: 1.0)),
                    hintText: AppLocalizations.of(context).enterAmount,
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
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
                    double amount = 0;
                    if (myController.text != '') {
                      amount = double.parse(myController.text);
                    }
                    // var res = await AddGasDo(double.parse(myController.text));
                    myController.text == '' || amount == null
                        ? walletService.showInfoFlushbar(
                            AppLocalizations.of(context).invalidAmount,
                            AppLocalizations.of(context).pleaseEnterValidNumber,
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
                )
              ],
            )));
  }
}
