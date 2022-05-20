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
import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/constants/font_style.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/app_wallet_model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;
import 'package:flutter/gestures.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/move_to_exchange_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'package:exchangilymobileapp/utils/string_util.dart';

// {"success":true,"data":{"transactionID":"7f9d1b3fad00afa85076d28d46fd3457f66300989086b95c73ed84e9b3906de8"}}
class MoveToExchangeScreen extends StatelessWidget {
  final AppWallet appWallet;
  const MoveToExchangeScreen({Key key, this.appWallet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => MoveToExchangeViewModel(),
      onModelReady: (MoveToExchangeViewModel model) {
        model.context = context;
        model.appWallet = appWallet;
        model.initState();
      },
      builder: (context, MoveToExchangeViewModel model, child) => Scaffold(
        appBar: CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.only(start: 0),
          leading: CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: const Icon(
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
          backgroundColor: const Color(0XFF1f2233),
        ),
        backgroundColor: const Color(0xFF1F2233),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  DecimalTextInputFormatter(
                      decimalRange: model.decimalLimit,
                      activatedNegativeValues: false)
                ],
                onChanged: (String amount) {
                  model.amountAfterFee();
                },
                decoration: InputDecoration(
                  suffix: Text(
                      '${AppLocalizations.of(context).decimalLimit}: ${model.decimalLimit}',
                      style: Theme.of(context).textTheme.headline6),
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0XFF871fff), width: 1.0)),
                  hintText: AppLocalizations.of(context).enterAmount,
                  hintStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                controller: model.amountController,
                style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w700,
                    color: model.isValidAmount ? white : red),
              ),
              UIHelper.verticalSpaceSmall,
              // Wallet Balance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: <Widget>[
                      model.busy(model.appWallet)
                          ? Text(
                              '${AppLocalizations.of(context).walletbalance}  ${NumberUtil.decimalLimiter(model.appWallet.balance, decimalPrecision: model.decimalLimit).toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(color: yellow))
                          : Text(
                              '${AppLocalizations.of(context).walletbalance}  ${NumberUtil.decimalLimiter(model.appWallet.balance, decimalPrecision: model.decimalLimit).toString()}',
                              style: headText5.copyWith(color: grey)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        child: Text(model.specialTicker.toUpperCase(),
                            style: headText5.copyWith(color: grey)),
                      )
                    ],
                  ),
                  model.tokenType.isNotEmpty
                      ? OutlinedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                const Size.square(20)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5)),
                            backgroundColor: MaterialStateProperty.all(green),
                          ),
                          onPressed: () {
                            if (appWallet.balance != Decimal.zero) {
                              model.fillMaxAmount();
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context).maxAmount,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: white),
                          ))
                      : Container()
                ],
              ),
              UIHelper.verticalSpaceSmall,
              model.appWallet.tickerName == 'FAB'
                  ? Text(
                      '${AppLocalizations.of(context).unConfirmedBalance}  ${NumberUtil.decimalLimiter(model.appWallet.unconfirmedBalance, decimalPrecision: model.decimalLimit).toString()}',
                      style: headText5.copyWith(color: grey))
                  : Container(),
              UIHelper.verticalSpaceSmall,

              Container(
                child: Column(
                  children: [
                    appWallet.tickerName == 'TRX' ||
                            appWallet.tickerName == 'USDTX'
                        ? Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 0),
                            alignment: Alignment.topLeft,
                            child: appWallet.tickerName == 'TRX'
                                ? Text(
                                    '${AppLocalizations.of(context).gasFee}: 1 TRX',
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.headline5)
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${AppLocalizations.of(context).gasFee}: 15 TRX',
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      // chain balance
                                      model.tokenType.isNotEmpty
                                          ? Row(
                                              children: [
                                                Text(
                                                    '${model.appWallet.tokenType} ${AppLocalizations.of(context).balance}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .only(
                                                      left:
                                                          5), // padding left to keep some space from the text
                                                  child: Text(
                                                      '${NumberUtil.decimalLimiter(model.chainBalance, decimalPrecision: 6).toString()} ${model.feeUnit}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6),
                                                )
                                              ],
                                            )
                                          : Container()
                                    ],
                                  ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(AppLocalizations.of(context).gasFee,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left:
                                            5), // padding left to keep some space from the text
                                    child: Text(
                                        '${NumberUtil.decimalLimiter(model.transFee, decimalPrecision: 6).toString()} ${model.feeUnit}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  )
                                ],
                              ),
                              // chain balance
                              model.tokenType.isNotEmpty
                                  ? Row(
                                      children: [
                                        Text(
                                            '${model.appWallet.tokenType} ${AppLocalizations.of(context).balance}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left:
                                                  5), // padding left to keep some space from the text
                                          child: Text(
                                              '${NumberUtil.decimalLimiter(model.chainBalance, decimalPrecision: 6).toString()} ${model.feeUnit}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6),
                                        )
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                    UIHelper.verticalSpaceSmall,
                    // Kanaban Gas Fee Row
                    Row(
                      children: <Widget>[
                        Text(AppLocalizations.of(context).kanbanGasFee,
                            style: Theme.of(context).textTheme.headline5),
                        Padding(
                          padding: const EdgeInsets.only(
                              left:
                                  5), // padding left to keep some space from the text
                          child: Text(
                              '${NumberUtil.decimalLimiter(model.kanbanTransFee, decimalPrecision: 6).toString()} GAS',
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
                      style: Theme.of(context).textTheme.headline5),
                  Container(
                    child: Switch(
                      value: model.transFeeAdvance,
                      inactiveTrackColor: globals.grey,
                      dragStartBehavior: DragStartBehavior.start,
                      activeColor: globals.primaryColor,
                      onChanged: (bool isOn) {
                        model.setBusy(true);
                        model.transFeeAdvance = isOn;
                        model.setBusy(false);
                      },
                    ),
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
                                          const TextInputType.numberWithOptions(
                                              decimal:
                                                  true), // numnber keyboard
                                      decoration: InputDecoration(
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: globals
                                                          .primaryColor)),
                                          enabledBorder:
                                              const UnderlineInputBorder(
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
                                          const TextInputType.numberWithOptions(
                                              decimal:
                                                  true), // numnber keyboard
                                      decoration: InputDecoration(
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: globals
                                                          .primaryColor)),
                                          enabledBorder:
                                              const UnderlineInputBorder(
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
                                        const TextInputType.numberWithOptions(
                                            decimal: true), // numnber keyboard
                                    decoration: InputDecoration(
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: globals
                                                        .primaryColor)),
                                        enabledBorder:
                                            const UnderlineInputBorder(
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
                                        .copyWith(fontWeight: FontWeight.w300),
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
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true), // numnber keyboard
                                  decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: globals.primaryColor)),
                                      enabledBorder: const UnderlineInputBorder(
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
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true), // numnber keyboard
                                decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: globals.primaryColor)),
                                    enabledBorder: const UnderlineInputBorder(
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
                          Text(model.message,
                              style: const TextStyle(color: grey)),
                          UIHelper.verticalSpaceSmall,
                          RichText(
                            text: TextSpan(
                                text: AppLocalizations.of(context)
                                    .taphereToCopyTxId,
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: globals.primaryColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    debugPrint('1');
                                    debugPrint(model.message.toString());
                                    debugPrint('2');
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
                                        color: red,
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
                            ? const Icon(Icons.arrow_drop_down,
                                color: Colors.red, size: 18)
                            : const Icon(Icons.arrow_drop_up,
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

// test code
              // Column(
              //   children: [
              //     TextField(
              //       controller: model.tec1,
              //     ),
              //     TextButton(
              //         onPressed: () => model.t1(),
              //         child: const Text('Test Me')),
              //     Text(
              //       model.oldIntOutputInBigInt.toString(),
              //       style: const TextStyle(color: grey),
              //     ),
              //     Text(
              //       model.oldBigIntOutputInInt.toString(),
              //       style: const TextStyle(color: white),
              //     ),
              //     const Text(
              //       'New ',
              //       style: TextStyle(color: white),
              //     ),
              //     Text(
              //       model.newdoubleOutputInBigInt.toString(),
              //       style: TextStyle(color: green),
              //     )
              //   ],
              // ),
              UIHelper.divider,
              UIHelper.verticalSpaceMedium,
              // Confirm Button
              MaterialButton(
                padding: const EdgeInsets.all(15),
                color: globals.primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  if (model.isValidAmount &&
                      model.amount != Constants.decimalZero) {
                    model.checkPass();
                  }
                },
                child: model.isBusy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ))
                    : Text(AppLocalizations.of(context).confirm,
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: model.isValidAmount &&
                                    model.amount != Constants.decimalZero
                                ? white
                                : grey)),
              ),

              TextButton(
                  onPressed: () {
                    var amount1e6 = model.amount * Decimal.fromInt(1000000);
                    debugPrint(
                        'new decimal amount multiply with 1e6 $amount1e6}');

                    var amountToBigIntNew = amount1e6.toBigInt();
                    //1123400000000000000000000
                    //BigInt.from(amount1e6.toDouble());
                    debugPrint('new decimal to big int $amountToBigIntNew');
                    var y = amountToBigIntNew.toRadixString(16);
                    debugPrint('new big int to hex $y');

                    var amountToBigInt =
                        BigInt.from(model.amount.toDouble() * 1e6);
                    debugPrint(' old amountToBigInt $amountToBigInt');

                    var x = amountToBigInt.toRadixString(16);
                    debugPrint('big int to hex $x');
                  },
                  child: const Text('Click me'))
            ],
          ),
        ),
        //floatingActionButton: TextButton(child: Text('Click'),onPressed: ()=> model.test(),),
      ),
    );
  }
}
