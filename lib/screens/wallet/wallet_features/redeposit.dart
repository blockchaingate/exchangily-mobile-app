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
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'dart:typed_data';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:flutter/gestures.dart';
import '../../../utils/kanban.util.dart';
import '../../../utils/keypair_util.dart';
import '../../../utils/abi_util.dart';
import 'package:hex/hex.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import '../../../environments/coins.dart';
import '../../../utils/string_util.dart';

// {"success":true,"data":{"transactionID":"7f9d1b3fad00afa85076d28d46fd3457f66300989086b95c73ed84e9b3906de8"}}
class Redeposit extends StatefulWidget {
  final WalletInfo walletInfo;

  Redeposit({Key key, this.walletInfo}) : super(key: key);

  @override
  _RedepositState createState() => _RedepositState();
}

class _RedepositState extends State<Redeposit> {
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();

  WalletDataBaseService databaseService = locator<WalletDataBaseService>();
  final _kanbanGasPriceTextController = TextEditingController();
  final _kanbanGasLimitTextController = TextEditingController();
  double kanbanTransFee = 0.0;
  bool transFeeAdvance = false;
  String coinName = '';
  String tokenType = '';
  String errDepositTransactionID;
  List errDepositList = new List();

  @override
  void initState() {
    super.initState();
    coinName = widget.walletInfo.tickerName;
    tokenType = widget.walletInfo.tokenType;

    getErrDeposit();
  }

  Future getErrDeposit() async {
    var address = await this.getExgAddress();
    var errDepositData = await walletService.getErrDeposit(address);

    var gasPrice = environment["chains"]["KANBAN"]["gasPrice"];
    var gasLimit = environment["chains"]["KANBAN"]["gasLimit"];
    _kanbanGasPriceTextController.text = gasPrice.toString();
    _kanbanGasLimitTextController.text = gasLimit.toString();

    var kanbanTransFee = bigNum2Double(gasPrice * gasLimit);

    for (var i = 0; i < errDepositData.length; i++) {
      var item = errDepositData[i];
      var coinType = item['coinType'];
      if (coin_list[coinType]['name'] == coinName) {
        errDepositList.add(item);
        break;
      }
    }
    print('errDepositList=== $errDepositList');
    if (errDepositList != null && errDepositList.length > 0) {
      setState(() {
        this.errDepositList = errDepositList;
        this.errDepositTransactionID = errDepositList[0]["transactionID"];
        this.kanbanTransFee = kanbanTransFee;
      });
    }

    return errDepositList;
  }

  Future getExgAddress() async {
    String address = '';
    var res = await databaseService.getAll();
    for (var i = 0; i < res.length; i++) {
      WalletInfo item = res[i];
      if (item.tickerName == 'EXG') {
        address = item.address;
        break;
      }
    }
    return address;
  }

  checkPass(context) async {
    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);
      var keyPairKanban = getExgKeyPair(seed);
      var exgAddress = keyPairKanban['address'];
      var nonce = await getNonce(exgAddress);

      var errDepositItem;
      for (var i = 0; i < errDepositList.length; i++) {
        if (errDepositList[i]["transactionID"] == errDepositTransactionID) {
          errDepositItem = errDepositList[i];
          break;
        }
      }

      if (errDepositItem == null) {
        sharedService.showInfoFlushbar(
            '${AppLocalizations.of(context).redepositError}',
            '${AppLocalizations.of(context).redepositItemNotSelected}',
            Icons.cancel,
            globals.red,
            context);
      }

      print('errDepositItem $errDepositItem');
      num errDepositAmount = num.parse(errDepositItem['amount']);
      print('errDepositAmount $errDepositAmount');
      var amountInLink = BigInt.from(errDepositAmount);
      print('amountInLink $amountInLink');
      var coinType = errDepositItem['coinType'];

      var transactionID = errDepositItem['transactionID'];

      var addressInKanban = keyPairKanban["address"];
      var originalMessage = walletService.getOriginalMessage(
          coinType,
          trimHexPrefix(transactionID),
          amountInLink,
          trimHexPrefix(addressInKanban));

      var signedMess =
          await signedMessage(originalMessage, seed, coinName, tokenType);

      var resRedeposit = await this.submitredeposit(amountInLink, keyPairKanban,
          nonce, coinType, transactionID, signedMess);

      if ((resRedeposit != null) && (resRedeposit['success'])) {
        sharedService.showInfoFlushbar(
            '${AppLocalizations.of(context).redepositCompleted}',
            '${AppLocalizations.of(context).transactionId}' +
                resRedeposit['data']['transactionID'],
            Icons.cancel,
            globals.white,
            context);
      } else {
        sharedService.showInfoFlushbar(
            AppLocalizations.of(context).redepositFailedError,
            AppLocalizations.of(context).serverError,
            Icons.cancel,
            globals.red,
            context);
      }
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
  }

  submitredeposit(amountInLink, keyPairKanban, nonce, coinType, transactionID,
      signedMess) async {
    log.w('transactionID for submitredeposit:' + transactionID);
    var coinPoolAddress = await getCoinPoolAddress();
    //var signedMess = {'r': r, 's': s, 'v': v};

    var abiHex = getDepositFuncABI(coinType, transactionID, amountInLink,
        keyPairKanban['address'], signedMess);

    var kanbanPrice = int.tryParse(_kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(_kanbanGasLimitTextController.text);

    var txKanbanHex = await signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        coinPoolAddress,
        nonce,
        kanbanPrice,
        kanbanGasLimit);

    var res = await submitReDeposit(txKanbanHex);
    return res;
  }

  showNotification(context) {
    sharedService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        globals.red,
        context);
  }

  updateTransFee() async {
    var kanbanPrice = int.tryParse(_kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(_kanbanGasLimitTextController.text);
    var kanbanTransFeeDouble = bigNum2Double(kanbanPrice * kanbanGasLimit);

    setState(() {
      kanbanTransFee = kanbanTransFeeDouble;
    });
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
            '${AppLocalizations.of(context).redeposit}  ${widget.walletInfo.tickerName}  ${AppLocalizations.of(context).toExchange}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: errDepositList
                      .map((data) => RadioListTile(
                            dense: true,
                            title: Text(
                              bigNum2Double(data["amount"]).toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            value: data['transactionID'],
                            groupValue: errDepositTransactionID,
                            onChanged: (val) {
                              setState(() {
                                errDepositTransactionID = val;
                                print('valllll=' + val);
                              });
                            },
                          ))
                      .toList(),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).walletbalance +
                                ' $bal',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              '$coinName'.toUpperCase(),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          )
                        ],
                      ),
                      UIHelper.verticalSpaceSmall,
                      Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context).kanbanGasFee,
                              style: Theme.of(context).textTheme.headline5),
                          UIHelper.horizontalSpaceSmall,
                          Text(
                            '$kanbanTransFee',
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ],
                      ),
                      // Switch Row
                      Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context).advance,
                              style: Theme.of(context).textTheme.headline5),
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
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .kanbanGasPrice,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                  Expanded(
                                      flex: 5,
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
                                                .headline5),
                                        style: TextStyle(
                                            color: globals.grey, fontSize: 12),
                                      ))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .kanbanGasLimit,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: TextField(
                                        controller:
                                            _kanbanGasLimitTextController,
                                        onChanged: (String amount) {
                                          updateTransFee();
                                        },
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal:
                                                    true), // numnber keyboard
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
                                                .headline5),
                                        style: TextStyle(
                                            color: globals.grey, fontSize: 12),
                                      ))
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                UIHelper.verticalSpaceSmall,
                MaterialButton(
                  padding: EdgeInsets.all(15),
                  color: globals.primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    checkPass(context);
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
