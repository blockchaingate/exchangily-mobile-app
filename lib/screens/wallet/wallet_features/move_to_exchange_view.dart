/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com and barry_ruprai@exchangily.com
*----------------------------------------------------------------------
*/
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/globals.dart' as globals;
import 'package:flutter/gestures.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/move_to_exchange_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'package:exchangilymobileapp/utils/string_util.dart';

// {"success":true,"data":{"transactionID":"7f9d1b3fad00afa85076d28d46fd3457f66300989086b95c73ed84e9b3906de8"}}
class MoveToExchangeScreen extends StatelessWidget {
  final WalletInfo walletInfo;
  MoveToExchangeScreen({Key key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => MoveToExchangeViewModel(),
      onModelReady: (model) {
        model.context = context;
        model.walletInfo = walletInfo;
        model.initState();
      },
      builder: (context, MoveToExchangeViewModel model, child) => Scaffold(
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
            '${AppLocalizations.of(context).move}  ${model.specialTicker}  ${AppLocalizations.of(context).toExchange}',
            style: Theme.of(context).textTheme.headline5,
          ),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  DecimalTextInputFormatter(
                      decimalRange: model.decimalLimit,
                      activatedNegativeValues: false)
                ],
                onChanged: (String amount) {
                  model.updateTransFee();
                },
                decoration: InputDecoration(
                  // suffix: RichText(
                  //   text: TextSpan(
                  //     recognizer: TapGestureRecognizer()
                  //       ..onTap = () {
                  //         model.fillMaxAmount();
                  //       },
                  //     text: AppLocalizations.of(context).maxAmount,
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .bodyText1
                  //         .copyWith(color: primaryColor),
                  //   ),
                  // ),
                  suffix: Text(
                      AppLocalizations.of(context).decimalLimit +
                          ': ' +
                          model.decimalLimit.toString(),
                      style: Theme.of(context).textTheme.headline6),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0XFF871fff), width: 1.0)),
                  hintText: AppLocalizations.of(context).enterAmount,
                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                controller: model.amountController,
                style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w300,
                    color: model.isValid ? white : red),
              ),
              UIHelper.verticalSpaceSmall,
              // Wallet Balance
              Row(
                children: <Widget>[
                  Text(
                      AppLocalizations.of(context).walletbalance +
                          '  ${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo.availableBalance, precision: model.singlePairDecimalConfig.qtyDecimal).toString()}',
                      style: Theme.of(context).textTheme.subtitle2),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    child: Text('${model.specialTicker}'.toUpperCase(),
                        style: Theme.of(context).textTheme.subtitle2),
                  )
                ],
              ),
              UIHelper.verticalSpaceSmall,

              Container(
                child: Column(
                  children: [
                    walletInfo.tickerName == 'TRX' ||
                            walletInfo.tickerName == 'USDTX'
                        ? Container(
                            padding: EdgeInsets.only(top: 10, bottom: 0),
                            alignment: Alignment.topLeft,
                            child: walletInfo.tickerName == 'TRX'
                                ? Text(
                                    '${AppLocalizations.of(context).gasFee}: 1 TRX',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.headline6)
                                : Text(
                                    '${AppLocalizations.of(context).gasFee}: 15 TRX',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.headline6),
                          )
                        : Row(
                            children: <Widget>[
                              Text(AppLocalizations.of(context).gasFee,
                                  style: Theme.of(context).textTheme.headline6),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        5), // padding left to keep some space from the text
                                child: Text(
                                    '${NumberUtil().truncateDoubleWithoutRouding(model.transFee, precision: 4).toString()} ${model.feeUnit}',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              )
                            ],
                          ),
                    UIHelper.verticalSpaceSmall,
                    // Kanaban Gas Fee Row
                    Row(
                      children: <Widget>[
                        Text(AppLocalizations.of(context).kanbanGasFee,
                            style: Theme.of(context).textTheme.headline6),
                        Padding(
                          padding: EdgeInsets.only(
                              left:
                                  5), // padding left to keep some space from the text
                          child: Text(
                              '${NumberUtil().truncateDoubleWithoutRouding(model.kanbanTransFee, precision: 4).toString()} GAS',
                              style: Theme.of(context).textTheme.headline6),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // Switch Row
              Row(
                children: <Widget>[
                  Text(AppLocalizations.of(context).advance,
                      style: Theme.of(context).textTheme.headline6),
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
              // Transaction Fee Advance
              Visibility(
                  visible: model.transFeeAdvance,
                  child: Column(
                    children: <Widget>[
                      Visibility(
                          visible: (model.coinName == 'ETH' ||
                              model.tokenType == 'ETH' ||
                              model.tokenType == 'FAB'),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text(
                                    AppLocalizations.of(context).gasPrice,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontWeight: FontWeight.w300)),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: TextField(
                                      controller: model.gasPriceTextController,
                                      onChanged: (String amount) {
                                        model.updateTransFee();
                                      },
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal:
                                                  true), // numnber keyboard
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: globals.primaryColor)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: globals.grey)),
                                          hintText: '0.00000',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  fontWeight: FontWeight.w300)),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.w300)))
                            ],
                          )),
                      Visibility(
                          visible: (model.coinName == 'ETH' ||
                              model.tokenType == 'ETH' ||
                              model.tokenType == 'FAB'),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                    AppLocalizations.of(context).gasLimit,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontWeight: FontWeight.w300),
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: TextField(
                                      controller: model.gasLimitTextController,
                                      onChanged: (String amount) {
                                        model.updateTransFee();
                                      },
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal:
                                                  true), // numnber keyboard
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: globals.primaryColor)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: globals.grey)),
                                          hintText: '0.00000',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  fontWeight: FontWeight.w300)),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.w300)))
                            ],
                          )),
                      Visibility(
                          visible: (model.coinName == 'BTC' ||
                              model.coinName == 'FAB' ||
                              model.tokenType == 'FAB'),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text(
                                  AppLocalizations.of(context).satoshisPerByte,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(fontWeight: FontWeight.w300),
                                ),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: TextField(
                                    controller:
                                        model.satoshisPerByteTextController,
                                    onChanged: (String amount) {
                                      model.updateTransFee();
                                    },
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true), // numnber keyboard
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: globals.primaryColor)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: globals.grey)),
                                        hintText: '0.00000',
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                fontWeight: FontWeight.w300)),
                                    style: TextStyle(
                                        color: globals.grey, fontSize: 16),
                                  ))
                            ],
                          )),
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Text(
                                AppLocalizations.of(context).kanbanGasPrice,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w300),
                              )),
                          Expanded(
                              flex: 5,
                              child: TextField(
                                  controller:
                                      model.kanbanGasPriceTextController,
                                  onChanged: (String amount) {
                                    model.updateTransFee();
                                  },
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true), // numnber keyboard
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: globals.primaryColor)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: globals.grey)),
                                      hintText: '0.00000',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.w300)),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(fontWeight: FontWeight.w300)))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(
                                AppLocalizations.of(context).kanbanGasLimit,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w300)),
                          ),
                          Expanded(
                              flex: 5,
                              child: TextField(
                                controller: model.kanbanGasLimitTextController,
                                onChanged: (String amount) {
                                  model.updateTransFee();
                                },
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true), // numnber keyboard
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: globals.primaryColor)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: globals.grey)),
                                    hintText: '0.00000',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontWeight: FontWeight.w300)),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w300),
                              ))
                        ],
                      )
                    ],
                  )),
              UIHelper.verticalSpaceSmall,
              // Success/Error container
              Container(
                  child: Visibility(
                      visible: model.message.isNotEmpty,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(model.message),
                          UIHelper.verticalSpaceSmall,
                          RichText(
                            text: TextSpan(
                                text: AppLocalizations.of(context)
                                    .taphereToCopyTxId,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: globals.primaryColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('1');
                                    print(model.message);
                                    print('2');
                                    model
                                        .copyAndShowNotification(model.message);
                                  }),
                          ),
                          UIHelper.verticalSpaceSmall,
                        ],
                      ))),
              UIHelper.verticalSpaceSmall,
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
                                        decoration: TextDecoration.underline),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(firstCharToUppercase(model.serverError),
                            style: Theme.of(context).textTheme.headline5),
                      ),
                    )
                  : Container(),
              UIHelper.verticalSpaceSmall,
              // Confirm Button
              MaterialButton(
                padding: EdgeInsets.all(15),
                color: globals.primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  model.checkPass();
                },
                child: model.isBusy
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ))
                    : Text(AppLocalizations.of(context).confirm,
                        style: Theme.of(context).textTheme.headline4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}