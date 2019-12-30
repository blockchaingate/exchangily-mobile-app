import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'dart:typed_data';
class AddGas extends StatelessWidget {

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  AddGas({Key key}) : super(key: key);

  checkPass(double amount, context) async{
    var res = await _dialogService.showDialog(
        title: 'Enter Password',
        description:
        'Type the same password which you entered while creating the wallet');
    if (res.confirmed) {
      String mnemonic = res.fieldOne;
      Uint8List seed = walletService.generateSeed(mnemonic);
      var ret = await walletService.AddGasDo(seed, amount);

      //{'txHex': txHex, 'txHash': txHash, 'errMsg': errMsg}
      walletService.showInfoFlushbar((ret["errMsg"] == '')?'Add gas transaction was made successfully':'Add gas transaction failed',
          (ret["errMsg"] == '')?'transactionID:' + ret['txHash']:'', Icons.cancel, globals.red, context);

    } else {
      if (res.fieldOne != 'Closed') {
        showNotification(context);
      }
    }
  }

  showNotification(context) {
    walletService.showInfoFlushbar('Password Mismatch',
        'Please enter the correct pasword', Icons.cancel, globals.red, context);
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
            "Add Gas",
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
                Text("Amount:",
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Color(0XFF871fff), width: 1.0)),
                    hintText: 'Enter the amount',
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
                    // var res = await AddGasDo(double.parse(myController.text));
                    checkPass(double.parse(myController.text), context);
                    //   print(res);
                  },
                  child: Text(
                    'Confirm',
                    style: Theme.of(context).textTheme.button,
                  ),
                )
              ],
            )));
  }
}
