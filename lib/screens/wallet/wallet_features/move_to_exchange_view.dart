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
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import '../../../shared/globals.dart' as globals;
import 'package:flutter/gestures.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/move_to_exchange_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'package:exchangilymobileapp/utils/string_util.dart';

// {"success":true,"data":{"transactionID":"7f9d1b3fad00afa85076d28d46fd3457f66300989086b95c73ed84e9b3906de8"}}
class MoveToExchangeScreen extends StatelessWidget {
  final WalletInfo? walletInfo;
  const MoveToExchangeScreen({Key? key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => MoveToExchangeViewModel(),
      onViewModelReady: (MoveToExchangeViewModel model) {
        model.context = context;
        model.walletInfo = walletInfo;
        model.initState();
      },
      builder: (context, MoveToExchangeViewModel model, child) => Scaffold(
        appBar: CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.only(start: 0),
          leading: CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          middle: Text(
            '${FlutterI18n.translate(context, "move")}  ${model.specialTicker}  ${FlutterI18n.translate(context, "toExchange")}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        backgroundColor: Theme.of(context).cardColor,
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
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
                  model.amount = NumberUtil.parseStringToDecimal(
                    amount,
                  );
                  model.amountAfterFee();
                },
                decoration: InputDecoration(
                  suffix: Text(
                      '${FlutterI18n.translate(context, "decimalLimit")}: ${model.decimalLimit}',
                      style: Theme.of(context).textTheme.titleLarge),
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0XFF871fff), width: 1.0)),
                  hintText: FlutterI18n.translate(context, "enterAmount"),
                  hintStyle:
                      const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                controller: model.amountController,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: model.isValidAmount
                        ? Theme.of(context).hintColor
                        : red),
              ),
              UIHelper.verticalSpaceSmall,
              // Wallet Balance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: <Widget>[
                      model.busy(model.walletInfo)
                          ? Text(
                              '${FlutterI18n.translate(context, "walletbalance")}  ${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo!.availableBalance, precision: model.decimalLimit!).toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: yellow))
                          : Text(
                              '${FlutterI18n.translate(context, "walletbalance")}  ${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo!.availableBalance, precision: model.decimalLimit!).toString()}',
                              style: Theme.of(context).textTheme.bodyLarge),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        child: Text(model.specialTicker!.toUpperCase(),
                            style: Theme.of(context).textTheme.titleSmall),
                      )
                    ],
                  ),
                  model.tokenType!.isNotEmpty
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
                            if (walletInfo!.availableBalance != 0.0) {
                              model.fillMaxAmount();
                            }
                          },
                          child: Text(
                            FlutterI18n.translate(context, "maxAmount"),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: white),
                          ))
                      : Container()
                ],
              ),
              UIHelper.verticalSpaceSmall,

              Column(
                children: [
                  model.isTrx()
                      ? Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 0),
                          alignment: Alignment.topLeft,
                          child: walletInfo!.tickerName == 'TRX'
                              ? Text(
                                  '${FlutterI18n.translate(context, "gasFee")}: ${model.trxGasValueTextController.text} TRX',
                                  textAlign: TextAlign.left,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall)
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${FlutterI18n.translate(context, "gasFee")}: ${model.trxGasValueTextController.text} TRX',
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall),
                                    // chain balance
                                    model.tokenType!.isNotEmpty
                                        ? Row(
                                            children: [
                                              Text(
                                                  '${model.walletInfo!.tokenType!} ${FlutterI18n.translate(context, "balance")}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left:
                                                        5), // padding left to keep some space from the text
                                                child: Text(
                                                    '${NumberUtil.decimalLimiter(model.chainBalance, decimalPlaces: 6).toString()} ${model.feeUnit}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge),
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
                                Text(FlutterI18n.translate(context, "gasFee"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left:
                                          5), // padding left to keep some space from the text
                                  child: Text(
                                      '${NumberUtil.decimalLimiter(model.transFee, decimalPlaces: 6).toString()} ${model.feeUnit}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                )
                              ],
                            ),
                            // chain balance
                            model.tokenType!.isNotEmpty
                                ? Row(
                                    children: [
                                      Text(
                                          '${model.walletInfo!.tokenType!} ${FlutterI18n.translate(context, "balance")}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left:
                                                5), // padding left to keep some space from the text
                                        child: Text(
                                            '${NumberUtil.decimalLimiter(model.chainBalance, decimalPlaces: 6).toString()} ${model.feeUnit}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
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
                      Text(FlutterI18n.translate(context, "kanbanGasFee"),
                          style: Theme.of(context).textTheme.headlineSmall),
                      Padding(
                        padding: const EdgeInsets.only(
                            left:
                                5), // padding left to keep some space from the text
                        child: Text(
                            '${NumberUtil.decimalLimiter(model.kanbanTransFee, decimalPlaces: 6).toString()} GAS',
                            style: Theme.of(context).textTheme.titleLarge),
                      )
                    ],
                  ),
                ],
              ),

              // Switch Row
              Row(
                children: <Widget>[
                  Text(FlutterI18n.translate(context, "advance"),
                      style: Theme.of(context).textTheme.headlineSmall),
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
              model.isTrx()
                  ? Visibility(
                      visible: model.transFeeAdvance,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Text(
                                'TRX ${FlutterI18n.translate(context, "gasFee")}',
                                style: headText5.copyWith(
                                    fontWeight: FontWeight.w300),
                              )),
                          Expanded(
                              flex: 5,
                              child: TextField(
                                  controller: model.trxGasValueTextController,
                                  onChanged: (String fee) {
                                    if (fee.isNotEmpty) {
                                      model.trxGasValueTextController.text =
                                          fee.toString();
                                      model.transFee = Decimal.parse(fee);
                                      model.notifyListeners();
                                    }
                                  },
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true), // numnber keyboard
                                  decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primaryColor)),
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: grey)),
                                      hintText: '0.00000',
                                      hintStyle: headText5.copyWith(
                                          fontWeight: FontWeight.w300)),
                                  style: headText5.copyWith(
                                      fontWeight: FontWeight.w300)))
                        ],
                      ),
                    )
                  : Visibility(
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
                                        FlutterI18n.translate(
                                            context, "gasPrice"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w300)),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: TextField(
                                          controller:
                                              model.gasPriceTextController,
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
                                                  .headlineSmall!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w300)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
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
                                        FlutterI18n.translate(
                                            context, "gasLimit"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w300),
                                      )),
                                  Expanded(
                                      flex: 5,
                                      child: TextField(
                                          controller:
                                              model.gasLimitTextController,
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
                                                  .headlineSmall!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w300)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
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
                                      FlutterI18n.translate(
                                          context, "satoshisPerByte"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w300),
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
                                        keyboardType: const TextInputType
                                                .numberWithOptions(
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
                                                .headlineSmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w300)),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w300),
                                      ))
                                ],
                              )),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                    FlutterI18n.translate(
                                        context, "kanbanGasPrice"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontWeight: FontWeight.w300),
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: TextField(
                                      controller: model
                                          .kanbanGasPriceTextController,
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
                                              .headlineSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w300)),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w300)))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text(
                                    FlutterI18n.translate(
                                        context, "kanbanGasLimit"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontWeight: FontWeight.w300)),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: TextField(
                                    controller:
                                        model.kanbanGasLimitTextController,
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
                                            .headlineSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w300)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontWeight: FontWeight.w300),
                                  ))
                            ],
                          )
                        ],
                      )),
              UIHelper.verticalSpaceSmall,
              // Success/Error container
              Visibility(
                  visible: model.message.isNotEmpty,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(model.message, style: const TextStyle(color: grey)),
                      UIHelper.verticalSpaceSmall,
                      RichText(
                        text: TextSpan(
                            text: FlutterI18n.translate(
                                context, "taphereToCopyTxId"),
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: globals.primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                debugPrint('1');
                                debugPrint(model.message.toString());
                                debugPrint('2');
                                model.copyAndShowNotification(model.message);
                              }),
                      ),
                      UIHelper.verticalSpaceSmall,
                    ],
                  )),
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
                                    .bodyMedium!
                                    .copyWith(
                                        color: red,
                                        decoration: TextDecoration.underline),
                                text:
                                    '${FlutterI18n.translate(context, "error")} ${FlutterI18n.translate(context, "details")}',
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
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                    )
                  : Container(),
              UIHelper.verticalSpaceSmall,
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
                    : Text(FlutterI18n.translate(context, "confirm"),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: model.isValidAmount &&
                                    model.amount != Constants.decimalZero
                                ? white
                                : grey)),
              ),
            ],
          ),
        ),
        //floatingActionButton: TextButton(child: Text('Click'),onPressed: ()=> model.test(),),
      ),
    );
  }
}
