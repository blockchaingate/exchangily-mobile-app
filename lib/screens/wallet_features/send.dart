/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'dart:typed_data';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/send_screen_state.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/globals.dart' as globals;

class SendWalletScreen extends StatefulWidget {
  final WalletInfo walletInfo;
  const SendWalletScreen({Key key, this.walletInfo}) : super(key: key);

  @override
  _SendWalletScreenState createState() => _SendWalletScreenState();
}

class _SendWalletScreenState extends State<SendWalletScreen> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  WalletService walletService = WalletService();
  final _receiverWalletAddressTextController = TextEditingController();
  final _sendAmountTextController = TextEditingController();
  final _gasPriceTextController = TextEditingController();
  final _gasLimitTextController = TextEditingController();
  final _satoshisPerByteTextController = TextEditingController();
  double transFee = 0.0;
  bool transFeeAdvance = false;
  @override
  void dispose() {
    _receiverWalletAddressTextController.dispose();
    _sendAmountTextController.dispose();

    super.dispose();
  }

  updateTransFee() async {
    var to = getOfficalAddress(widget.walletInfo.tickerName);
    var amount = double.tryParse(_sendAmountTextController.text);
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
    print('widget.walletInfo.address=' + widget.walletInfo.address);
    var address = widget.walletInfo.address;

    var ret = await walletService.sendTransaction(widget.walletInfo.tickerName, Uint8List.fromList([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]), [0], [address], to, amount, options, false);

    print('ret===');
    print(ret);


    if(ret != null && ret['transFee'] != null) {
      setState(() {
        transFee = ret['transFee'];
      });
    }

  }

  @override
  void initState() {
    super.initState();
    String coinName = widget.walletInfo.tickerName;
    String tokenType = widget.walletInfo.tokenType;
    if(coinName == 'BTC') {
      _satoshisPerByteTextController.text = environment["chains"]["BTC"]["satoshisPerBytes"].toString();
    } else
    if(coinName == 'ETH' || tokenType == 'ETH') {
      _gasPriceTextController.text = environment["chains"]["ETH"]["gasPrice"].toString();
      _gasLimitTextController.text = environment["chains"]["ETH"]["gasLimit"].toString();
    } else
    if(coinName == 'FAB') {
      _satoshisPerByteTextController.text = environment["chains"]["FAB"]["satoshisPerBytes"].toString();
    } else
    if (tokenType == 'FAB') {
      _satoshisPerByteTextController.text = environment["chains"]["FAB"]["satoshisPerBytes"].toString();
      _gasPriceTextController.text = environment["chains"]["FAB"]["gasPrice"].toString();
      _gasLimitTextController.text = environment["chains"]["FAB"]["gasLimit"].toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    double bal = widget.walletInfo.availableBalance;
    String coinName = widget.walletInfo.tickerName;
    String tokenType = widget.walletInfo.tokenType;
    return BaseScreen<SendScreenState>(
      onModelReady: (model) {
        model.context = context;
        model.walletInfo = widget.walletInfo;
        model.initState();
      },
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: globals.walletCardColor,
          title: Text(AppLocalizations.of(context).send),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          // to avoid using ListView without having any list childs to iterate and use column as its child now
          child: Container(
            child: Column(
              // I was using ListView here earlier to solve keyboard overflow error
              children: <Widget>[
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                  Receiver's Wallet Address Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  color: globals.walletCardColor,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: GestureDetector(
                            child: TextField(
                              maxLines: 1,
                              controller:
                                  model.receiverWalletAddressTextController,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.content_paste),
                                    onPressed: () async {
                                      await model.pasteClipBoardData();
                                    },
                                    iconSize: 25,
                                    color: globals.primaryColor,
                                  ),
                                  labelText: AppLocalizations.of(context)
                                      .receiverWalletAddress,
                                  labelStyle:
                                      Theme.of(context).textTheme.display2),
                              style: Theme.of(context).textTheme.display2,
                            ),
                          )),
                      RaisedButton(
                          padding: EdgeInsets.all(10),
                          onPressed: () {
                            model.scan();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(Icons.camera_enhance)),
                              Text(AppLocalizations.of(context).scanBarCode)
                            ],
                          ))
                    ],
                  ),
                ),

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                  Send Amount And Available Balance Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
                Container(
                    color: globals.walletCardColor,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          controller: model.sendAmountTextController,
                          onChanged: (String amount) {
                            // checkSendAmount does not directly work if you use it in if as condition so setting state here to make it work
                            model.updateTransFee();
                            setState(() {
                              model.checkSendAmount = model.checkAmount(amount);
                            });
                          },
                          keyboardType:
                              TextInputType.number, // numnber keyboard
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: globals.primaryColor)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: globals.grey)),
                              hintText: '0.00000',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .display2
                                  .copyWith(fontSize: 20)),
                          style: model.checkSendAmount
                              ? TextStyle(color: globals.grey, fontSize: 24)
                              : TextStyle(color: globals.red, fontSize: 24),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).walletbalance +
                                    ' $bal',
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
                          ),
                        )
                      ],
                    )),
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                  Gas fee and Advance Switch Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
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
                                '${model.transFee}',
                                style: Theme.of(context)
                                    .textTheme
                                    .display3
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
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
                            value: model.transFeeAdvance,
                            inactiveTrackColor: globals.grey,
                            dragStartBehavior: DragStartBehavior.start,
                            activeColor: globals.primaryColor,
                            onChanged: (bool isOn) {
                              setState(() {
                                model.transFeeAdvance = isOn;
                              });
                            },
                          )
                        ],
                      ),
                      Visibility(
                          visible: model.transFeeAdvance,
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
                                            .display3
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  55, 0, 0, 0),
                                              child: TextField(
                                                controller: model
                                                    .gasPriceTextController,
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
                                                            borderSide:
                                                                BorderSide(
                                                                    color: globals
                                                                        .grey)),
                                                    hintText: '0.00000',
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .display2
                                                        .copyWith(
                                                            fontSize: 20)),
                                                style: TextStyle(
                                                    color: globals.grey,
                                                    fontSize: 24),
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
                                            .display3
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  55, 0, 0, 0),
                                              child: TextField(
                                                controller: model
                                                    .gasLimitTextController,
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
                                                            borderSide:
                                                                BorderSide(
                                                                    color: globals
                                                                        .grey)),
                                                    hintText: '0.00000',
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .display2
                                                        .copyWith(
                                                            fontSize: 20)),
                                                style: TextStyle(
                                                    color: globals.grey,
                                                    fontSize: 24),
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
                                            .display3
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 0, 0, 0),
                                              child: TextField(
                                                controller: model
                                                    .satoshisPerByteTextController,
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
                                                            borderSide:
                                                                BorderSide(
                                                                    color: globals
                                                                        .grey)),
                                                    hintText: '0.00000',
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .display2
                                                        .copyWith(
                                                            fontSize: 20)),
                                                style: TextStyle(
                                                    color: globals.grey,
                                                    fontSize: 24),
                                              )))
                                    ],
                                  ))
                            ],
                          ))
                    ],
                  ),
                ),
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                  TXID Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

                UIHelper.verticalSpaceSmall,
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: model.txHash.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    text: AppLocalizations.of(context)
                                        .taphereToCopyTxId,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: globals.primaryColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        model.copyAddress(context);
                                      }),
                              ),
                              UIHelper.verticalSpaceSmall,
                              Text(
                                model.txHash,
                                style: Theme.of(context).textTheme.display2,
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                            model.errorMessage,
                            style: TextStyle(color: globals.red),
                          ))),
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                  Send Button Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
                Container(
                  height:
                      100, // alignment was not working without the height so ;)
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment(0.0, 1.0),
                  child: model.state == ViewState.Busy
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          disabledColor: model.checkSendAmount
                              ? globals.grey
                              : globals.primaryColor,
                          child: Text(AppLocalizations.of(context).send),
                          onPressed: () async {
                            model.txHash = '';
                            model.errorMessage = '';
                            model.walletInfo = widget.walletInfo;
                            model.amount = double.tryParse(
                                model.sendAmountTextController.text);
                            model.toAddress =
                                model.receiverWalletAddressTextController.text;
                            model.gasPrice =
                                int.tryParse(model.gasPriceTextController.text);
                            model.gasLimit =
                                int.tryParse(model.gasLimitTextController.text);
                            model.satoshisPerBytes = int.tryParse(
                                model.satoshisPerByteTextController.text);
                            model.checkFields(context);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
