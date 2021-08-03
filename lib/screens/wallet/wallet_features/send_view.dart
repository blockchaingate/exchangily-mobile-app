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
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/send_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class SendWalletView extends StatelessWidget {
  final WalletInfo walletInfo;
  const SendWalletView({Key key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => SendViewModel(),
        onModelReady: (model) async {
          model.context = context;
          model.walletInfo = walletInfo;

          await model.initState();
        },
        builder: (context, SendViewModel model, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: walletCardColor,
              title: Text(AppLocalizations.of(context).send,
                  style: Theme.of(context).textTheme.headline3),
              centerTitle: true,
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
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
                        color: walletCardColor,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  child: TextField(
                                    maxLines: 1,
                                    controller: model
                                        .receiverWalletAddressTextController,
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: grey, width: 0.5)),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.content_paste),
                                          onPressed: () async {
                                            await model.pasteClipBoardData();
                                          },
                                          iconSize: 25,
                                          color: primaryColor,
                                        ),
                                        labelText: AppLocalizations.of(context)
                                            .receiverWalletAddress,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    style:
                                        Theme.of(context).textTheme.headline5,
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
                                          .copyWith(
                                              fontWeight: FontWeight.w400),
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
                          color: walletCardColor,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextField(
                                // change paste text color
                                controller: model.sendAmountTextController,
                                onChanged: (String amount) {
                                  model.amount = double.parse(amount);
                                  model.checkAmount();
                                },
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true), // numnber keyboard
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: grey, width: 0.5)),
                                    hintText: '0.00000',
                                    hintStyle:
                                        TextStyle(fontSize: 14, color: grey)),
                                style: model.checkSendAmount &&
                                        model.amount <=
                                            walletInfo.availableBalance
                                    ? TextStyle(color: grey, fontSize: 14)
                                    : TextStyle(color: red, fontSize: 14),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)
                                                  .walletbalance +
                                              '  ${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo.availableBalance, precision: model.walletInfo.availableBalance.toString().split(".")[1].length) + NumberUtil().truncateDoubleWithoutRouding(model.walletInfo.unconfirmedBalance, precision: model.walletInfo.unconfirmedBalance.toString().split(".")[1].length)} ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          '${model.tickerName}'.toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        )
                                      ],
                                    ),
                                    // RichText(
                                    //   text: TextSpan(
                                    //     recognizer: TapGestureRecognizer()
                                    //       ..onTap = () {
                                    //         model.fillMaxAmount();
                                    //       },
                                    //     text: AppLocalizations.of(context)
                                    //         .maxAmount,
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .bodyText1
                                    //         .copyWith(color: primaryColor),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          )),
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Gas fee and Advance Switch Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: walletInfo.tickerName == 'TRX' ||
                                walletInfo.tickerName == 'USDTX'
                            ? Container(
                                padding: EdgeInsets.only(top: 10, bottom: 0),
                                alignment: Alignment.topLeft,
                                child: walletInfo.tickerName == 'TRX'
                                    ? Text(
                                        '${AppLocalizations.of(context).gasFee}: 1 TRX',
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6)
                                    : Text(
                                        '${AppLocalizations.of(context).gasFee}: 15 TRX',
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                              )
                            : Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 15, bottom: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context).gasFee,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  5), // padding left to keep some space from the text
                                          child: model.isBusy
                                              ? SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: Theme.of(context)
                                                              .platform ==
                                                          TargetPlatform.iOS
                                                      ? CupertinoActivityIndicator()
                                                      : CircularProgressIndicator(
                                                          strokeWidth: 0.75,
                                                        ))
                                              : Text(
                                                  '${NumberUtil().truncateDoubleWithoutRouding(model.transFee, precision: 6)}  ${model.feeUnit}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400),
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
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                      ),
                                      Switch(
                                        value: model.transFeeAdvance,
                                        inactiveTrackColor: grey,
                                        dragStartBehavior:
                                            DragStartBehavior.start,
                                        activeColor: primaryColor,
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
                                              visible: (model.tickerName ==
                                                      'ETH' ||
                                                  model.tokenType == 'ETH' ||
                                                  model.tokenType == 'FAB'),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .gasPrice,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                  ),
                                                  Expanded(
                                                      flex: 6,
                                                      child: TextField(
                                                          controller: model
                                                              .gasPriceTextController,
                                                          onChanged:
                                                              (String amount) {
                                                            model
                                                                .updateTransFee();
                                                          },
                                                          keyboardType: TextInputType.numberWithOptions(
                                                              decimal: true),
                                                          decoration: InputDecoration(
                                                              focusedBorder: UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              primaryColor)),
                                                              enabledBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      width:
                                                                          0.5,
                                                                      color:
                                                                          grey)),
                                                              hintText:
                                                                  '0.00000',
                                                              hintStyle: Theme.of(context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith(
                                                                      fontWeight: FontWeight
                                                                          .w400)),
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .headline6
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight.w400)))
                                                ],
                                              )),
                                          Visibility(
                                              visible: (model.tickerName ==
                                                      'ETH' ||
                                                  model.tokenType == 'ETH' ||
                                                  model.tokenType == 'FAB'),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .gasLimit,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                  ),
                                                  Expanded(
                                                      flex: 6,
                                                      child: TextField(
                                                        controller: model
                                                            .gasLimitTextController,
                                                        onChanged:
                                                            (String amount) {
                                                          model
                                                              .updateTransFee();
                                                        },
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                                decimal: true),
                                                        decoration: InputDecoration(
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                primaryColor)),
                                                            enabledBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width:
                                                                            0.5,
                                                                        color:
                                                                            grey)),
                                                            hintText: '0.00000',
                                                            hintStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ))
                                                ],
                                              )),
                                          Visibility(
                                              visible: (model.tickerName ==
                                                      'BTC' ||
                                                  model.tickerName == 'FAB' ||
                                                  model.tokenType == 'FAB'),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)
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
                                                        onChanged:
                                                            (String amount) {
                                                          model
                                                              .updateTransFee();
                                                        },
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                                decimal: true),
                                                        decoration: InputDecoration(
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                primaryColor)),
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                grey)),
                                                            hintText: '0.00000',
                                                            hintStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: model.txHash.isNotEmpty
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                          text: AppLocalizations.of(context)
                                              .taphereToCopyTxId,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: primaryColor),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              model.copyAddress(context);
                                            }),
                                    ),
                                    UIHelper.verticalSpaceSmall,
                                    Text(
                                      model.txHash,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                  model.errorMessage,
                                  style: TextStyle(color: red),
                                ))),
                      UIHelper.verticalSpaceSmall,
                      // show error details
                      model.isShowErrorDetailsButton
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                decoration:
                                                    TextDecoration.underline),
                                        text:
                                            '${AppLocalizations.of(context).error} ${AppLocalizations.of(context).details}',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            model.showDetailsMessageToggle();
                                          }),
                                  ),
                                ),
                                !model.isShowDetailsMessage
                                    ? Icon(Icons.arrow_drop_down,
                                        color: Colors.red, size: 18)
                                    : Icon(Icons.arrow_drop_up,
                                        color: Colors.red, size: 18)
                              ],
                            )
                          : Container(),
                      model.isShowDetailsMessage
                          ? Center(
                              child: Text(model.serverError,
                                  style: Theme.of(context).textTheme.headline6),
                            )
                          : Container(),
                      UIHelper.verticalSpaceSmall,
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Send Button Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
                      Container(
                        // height:
                        //     100, // alignment was not working without the height so ;)
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        // alignment: Alignment(0.0, 1.0),
                        child: MaterialButton(
                          padding: EdgeInsets.all(15),
                          color: primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            model.checkFields(context);
                          },
                          child: model.isBusy
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: model.sharedService.loadingIndicator())
                              : Text(AppLocalizations.of(context).send,
                                  style: Theme.of(context).textTheme.headline4),
                        ),
                      ),
                      UIHelper.verticalSpaceMedium
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
