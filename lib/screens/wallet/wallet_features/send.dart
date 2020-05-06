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
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/send_screen_state.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/globals.dart' as globals;

class SendWalletScreen extends StatelessWidget {
  final WalletInfo walletInfo;
  const SendWalletScreen({Key key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double bal = walletInfo.availableBalance;
    String coinName = walletInfo.tickerName;
    String tokenType = walletInfo.tokenType;
    return BaseScreen<SendScreenState>(
      onModelReady: (model) {
        model.context = context;
        model.walletInfo = walletInfo;
        model.initState();
      },
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: globals.walletCardColor,
          title: Text(AppLocalizations.of(context).send,
              style: Theme.of(context).textTheme.headline3),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          // to avoid using ListView without having any list childs to iterate and use column as its child now
          child: Container(
            margin: EdgeInsets.all(10.0),
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
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: globals.grey, width: 0.5)),
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
                                      Theme.of(context).textTheme.headline6),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          )),
                      FlatButton(
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
                              Text(
                                AppLocalizations.of(context).scanBarCode,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w400),
                              )
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
                            //  setState(() {
                            model.amount = double.parse(amount);
                            model.checkAmount(amount);
                            if (model.checkSendAmount == true &&
                                model.amount <= bal) {
                              model.updateTransFee();
                            }
                            //  });
                          },
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true), // numnber keyboard
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: globals.primaryColor)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: globals.grey, width: 0.5)),
                              hintText: '0.00000',
                              hintStyle:
                                  TextStyle(fontSize: 14, color: globals.grey)),
                          style: model.checkSendAmount && model.amount <= bal
                              ? TextStyle(color: globals.grey, fontSize: 14)
                              : TextStyle(color: globals.red, fontSize: 14),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).walletbalance +
                                    ' $bal ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '$coinName'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w400),
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
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).gasFee,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      5), // padding left to keep some space from the text
                              child: model.busy
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: Theme.of(context).platform ==
                                              TargetPlatform.iOS
                                          ? CupertinoActivityIndicator()
                                          : CircularProgressIndicator(
                                              strokeWidth: 0.75,
                                            ))
                                  : Text(
                                      '${model.transFee}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                            )
                          ],
                        ),
                      ),
                      // Switch Row Advance
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).advance,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
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
                              Visibility(
                                  visible: (coinName == 'ETH' ||
                                      tokenType == 'ETH' ||
                                      tokenType == 'FAB'),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .gasPrice,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                      ),
                                      Expanded(
                                          flex: 6,
                                          child: TextField(
                                              controller:
                                                  model.gasPriceTextController,
                                              onChanged: (String amount) {
                                                model.updateTransFee();
                                              },
                                              keyboardType:
                                                  TextInputType.numberWithOptions(
                                                      decimal: true),
                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: globals
                                                                  .primaryColor)),
                                                  enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: globals.grey)),
                                                  hintText: '0.00000',
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400)),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400)))
                                    ],
                                  )),
                              Visibility(
                                  visible: (coinName == 'ETH' ||
                                      tokenType == 'ETH' ||
                                      tokenType == 'FAB'),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .gasLimit,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                      ),
                                      Expanded(
                                          flex: 6,
                                          child: TextField(
                                            controller:
                                                model.gasLimitTextController,
                                            onChanged: (String amount) {
                                              model.updateTransFee();
                                            },
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            decoration: InputDecoration(
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: globals
                                                                .primaryColor)),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 0.5,
                                                            color:
                                                                globals.grey)),
                                                hintText: '0.00000',
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ))
                                    ],
                                  )),
                              Visibility(
                                  visible: (coinName == 'BTC' ||
                                      coinName == 'FAB' ||
                                      tokenType == 'FAB'),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .satoshisPerByte,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ),
                                      //  UIHelper.horizontalSpaceLarge,
                                      Expanded(
                                          flex: 6,
                                          child: TextField(
                                            controller: model
                                                .satoshisPerByteTextController,
                                            onChanged: (String amount) {
                                              model.updateTransFee();
                                            },
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
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
                                                    .headline6
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w300),
                                          ))
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
                                style: Theme.of(context).textTheme.bodyText2,
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
                  // height:
                  //     100, // alignment was not working without the height so ;)
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  // alignment: Alignment(0.0, 1.0),
                  child: model.state == ViewState.Busy
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          disabledColor: model.checkSendAmount
                              ? globals.grey
                              : globals.green,
                          child: Text(AppLocalizations.of(context).send,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.w400)),
                          onPressed: () async {
                            model.txHash = '';
                            model.errorMessage = '';
                            model.walletInfo = walletInfo;
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
                UIHelper.verticalSpaceMedium
              ],
            ),
          ),
        ),
      ),
    );
  }
}
