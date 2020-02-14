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
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/globals.dart' as globals;
import '../../../models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'dart:typed_data';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:flutter/gestures.dart';
import 'package:decimal/decimal.dart';

// {"success":true,"data":{"transactionID":"7f9d1b3fad00afa85076d28d46fd3457f66300989086b95c73ed84e9b3906de8"}}
class Deposit extends StatefulWidget {
  final WalletInfo walletInfo;

  Deposit({Key key, this.walletInfo}) : super(key: key);

  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();

  final _gasPriceTextController = TextEditingController();
  final _gasLimitTextController = TextEditingController();
  final _satoshisPerByteTextController = TextEditingController();
  final _kanbanGasPriceTextController = TextEditingController();
  final _kanbanGasLimitTextController = TextEditingController();
  double transFee = 0.0;
  double kanbanTransFee = 0.0;
  bool transFeeAdvance = false;
  String coinName = '';
  String tokenType = '';
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    coinName = widget.walletInfo.tickerName;
    tokenType = widget.walletInfo.tokenType;
    print('coinName==' + coinName);
    if (coinName == 'BTC') {
      _satoshisPerByteTextController.text =
          environment["chains"]["BTC"]["satoshisPerBytes"].toString();
    } else if (coinName == 'ETH' || tokenType == 'ETH') {
      _gasPriceTextController.text =
          environment["chains"]["ETH"]["gasPrice"].toString();
      _gasLimitTextController.text =
          environment["chains"]["ETH"]["gasLimit"].toString();
    } else if (coinName == 'FAB') {
      _satoshisPerByteTextController.text =
          environment["chains"]["FAB"]["satoshisPerBytes"].toString();
    } else if (tokenType == 'FAB') {
      _satoshisPerByteTextController.text =
          environment["chains"]["FAB"]["satoshisPerBytes"].toString();
      _gasPriceTextController.text =
          environment["chains"]["FAB"]["gasPrice"].toString();
      _gasLimitTextController.text =
          environment["chains"]["FAB"]["gasLimit"].toString();
    }
    _kanbanGasPriceTextController.text =
        environment["chains"]["KANBAN"]["gasPrice"].toString();
    _kanbanGasLimitTextController.text =
        environment["chains"]["KANBAN"]["gasLimit"].toString();
  }

  checkPass(double amount, context) async {
    if (amount == null || amount > widget.walletInfo.availableBalance) {
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
      if (coinName == 'USDT') {
        tokenType = 'ETH';
      }
      if (coinName == 'EXG') {
        tokenType = 'FAB';
      }

      var gasPrice = int.tryParse(_gasPriceTextController.text);
      var gasLimit = int.tryParse(_gasLimitTextController.text);
      var satoshisPerBytes = int.tryParse(_satoshisPerByteTextController.text);
      var kanbanGasPrice = int.tryParse(_kanbanGasPriceTextController.text);
      var kanbanGasLimit = int.tryParse(_kanbanGasLimitTextController.text);

      var option = {
        "gasPrice": gasPrice,
        "gasLimit": gasLimit,
        "satoshisPerBytes": satoshisPerBytes,
        'kanbanGasPrice': kanbanGasPrice,
        'kanbanGasLimit': kanbanGasLimit,
        'tokenType': tokenType,
        'contractAddress': environment["addresses"]["smartContract"][coinName]
      };

      var ret = await walletService.depositDo(
          seed, coinName, tokenType, amount, option);

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

  updateTransFee() async {
    var to = getOfficalAddress(coinName);
    var amount = double.tryParse(myController.text);
    if (to == null || amount == null || amount <= 0) {
      return;
    }
    var gasPrice = int.tryParse(_gasPriceTextController.text);
    var gasLimit = int.tryParse(_gasLimitTextController.text);
    var satoshisPerBytes = int.tryParse(_satoshisPerByteTextController.text);
    var options = {
      "gasPrice": gasPrice,
      "gasLimit": gasLimit,
      "satoshisPerBytes": satoshisPerBytes,
      "tokenType": widget.walletInfo.tokenType,
      "getTransFeeOnly": true
    };
    var address = widget.walletInfo.address;

    var ret = await walletService.sendTransaction(
        widget.walletInfo.tickerName,
        Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
        [0],
        [address],
        to,
        amount,
        options,
        false);

    var kanbanPrice = int.tryParse(_kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(_kanbanGasLimitTextController.text);
    var kanbanTransFeeDouble = (Decimal.parse(kanbanPrice.toString()) *
            Decimal.parse(kanbanGasLimit.toString()) /
            Decimal.parse('1e18'))
        .toDouble();
    if (ret != null && ret['transFee'] != null) {
      setState(() {
        transFee = ret['transFee'];
        kanbanTransFee = kanbanTransFeeDouble;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double bal = widget.walletInfo.availableBalance;
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
            '${AppLocalizations.of(context).move}  ${widget.walletInfo.tickerName}  ${AppLocalizations.of(context).toExchange}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ListView(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String amount) {
                    updateTransFee();
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0XFF871fff), width: 1.0)),
                    hintText: AppLocalizations.of(context).enterAmount,
                    hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                  controller: myController,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).gasFee,
                            style: Theme.of(context)
                                .textTheme
                                .display3
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    5), // padding left to keep some space from the text
                            child: Text(
                              '$transFee',
                              style: Theme.of(context)
                                  .textTheme
                                  .display3
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      UIHelper.horizontalSpaceSmall,
                      // Kanaban Gas Fee Row
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).kanbanGasFee,
                            style: Theme.of(context)
                                .textTheme
                                .display3
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    5), // padding left to keep some space from the text
                            child: Text(
                              '$kanbanTransFee',
                              style: Theme.of(context)
                                  .textTheme
                                  .display3
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      // Switch Row
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).advance,
                            style: Theme.of(context)
                                .textTheme
                                .display3
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
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
                      // Transaction Fee Advance
                      Visibility(
                          visible: transFeeAdvance,
                          child: Column(
                            children: <Widget>[
                              Visibility(
                                  visible: (coinName == 'ETH' ||
                                      tokenType == 'ETH' ||
                                      tokenType == 'FAB'),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).gasPrice,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display3,
                                      ),
                                      Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  85, 0, 0, 0),
                                              child: TextField(
                                                controller:
                                                    _gasPriceTextController,
                                                onChanged: (String amount) {
                                                  updateTransFee();
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
                                                            borderSide:
                                                                BorderSide(
                                                                    color: globals
                                                                        .grey)),
                                                    hintText: '0.00000',
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .display2
                                                        .copyWith(
                                                            fontSize: 14)),
                                                style: TextStyle(
                                                    color: globals.grey,
                                                    fontSize: 16),
                                              )))
                                    ],
                                  )),
                              Visibility(
                                  visible: (coinName == 'ETH' ||
                                      tokenType == 'ETH' ||
                                      tokenType == 'FAB'),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).gasLimit,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display3,
                                      ),
                                      Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  85, 0, 0, 0),
                                              child: TextField(
                                                controller:
                                                    _gasLimitTextController,
                                                onChanged: (String amount) {
                                                  updateTransFee();
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
                                                            borderSide:
                                                                BorderSide(
                                                                    color: globals
                                                                        .grey)),
                                                    hintText: '0.00000',
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .display2
                                                        .copyWith(
                                                            fontSize: 14)),
                                                style: TextStyle(
                                                    color: globals.grey,
                                                    fontSize: 16),
                                              )))
                                    ],
                                  )),
                              Visibility(
                                  visible: (coinName == 'BTC' ||
                                      coinName == 'FAB' ||
                                      tokenType == 'FAB'),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .satoshisPerByte,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display3,
                                      ),
                                      Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  50, 0, 0, 0),
                                              child: TextField(
                                                controller:
                                                    _satoshisPerByteTextController,
                                                onChanged: (String amount) {
                                                  updateTransFee();
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
                                                            borderSide:
                                                                BorderSide(
                                                                    color: globals
                                                                        .grey)),
                                                    hintText: '0.00000',
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .display2
                                                        .copyWith(
                                                            fontSize: 14)),
                                                style: TextStyle(
                                                    color: globals.grey,
                                                    fontSize: 16),
                                              )))
                                    ],
                                  )),
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context).kanbanGasPrice,
                                    style: Theme.of(context).textTheme.display3,
                                  ),
                                  Expanded(
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: TextField(
                                            controller:
                                                _kanbanGasPriceTextController,
                                            onChanged: (String amount) {
                                              updateTransFee();
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
                                                    .display2
                                                    .copyWith(fontSize: 14)),
                                            style: TextStyle(
                                                color: globals.grey,
                                                fontSize: 16),
                                          )))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context).kanbanGasLimit,
                                    style: Theme.of(context).textTheme.display3,
                                  ),
                                  Expanded(
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: TextField(
                                            controller:
                                                _kanbanGasLimitTextController,
                                            onChanged: (String amount) {
                                              updateTransFee();
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
                                                    .display2
                                                    .copyWith(fontSize: 14)),
                                            style: TextStyle(
                                                color: globals.grey,
                                                fontSize: 16),
                                          )))
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Wallet Balance
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        AppLocalizations.of(context).walletbalance + '  $bal',
                        style: Theme.of(context).textTheme.headline,
                      ),
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
                ),
                UIHelper.horizontalSpaceSmall,
                // Confirm Button
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
              ],
            )));
  }
}
