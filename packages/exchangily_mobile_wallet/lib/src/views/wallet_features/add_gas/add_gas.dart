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

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/add_gas/add_gas_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddGas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddGasViewModel>.reactive(
        onModelReady: (model) async {
          model.context = context;
          await model.init();
        },
        viewModelBuilder: () => AddGasViewModel(),
        builder: (context, AddGasViewModel model, _) => Scaffold(
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
                AppLocalizations.of(context).addGas,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0XFF1f2233),
            ),
            backgroundColor: const Color(0xFF1F2233),
            body: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: primaryColor),
                        child: Image.asset("assets/images/img/gas.png",
                            width: 100, height: 100)),
                    const SizedBox(height: 30),
                    TextField(
                      inputFormatters: [
                        DecimalTextInputFormatter(
                            decimalRange: 6, activatedNegativeValues: false)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (v) => model.updateTransFee(),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0XFF871fff), width: 1.0)),
                        hintText:
                            AppLocalizations.of(context).enterAmount + '(FAB)',
                        hintStyle: Theme.of(context).textTheme.headline6,
                      ),
                      controller: model.amountController,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: model.isAmountInvalid ? red : Colors.white),
                    ),
                    UIHelper.verticalSpaceSmall,
                    // Balance
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2.0, right: 4.0, top: 2.0),
                        child: Text(
                            '${AppLocalizations.of(context).gas} ${AppLocalizations.of(context).balance}',
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white)),
                      ),
                      Text(model.gasBalance.toString(),
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.white))
                    ]),
                    UIHelper.verticalSpaceSmall,
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2.0, right: 4.0, top: 2.0),
                        child: Text(
                            'FAB ${AppLocalizations.of(context).balance}',
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white)),
                      ),
                      Text(model.fabBalance.toString(),
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.white))
                    ]),
                    UIHelper.verticalSpaceSmall,
                    // Gas Fee
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2.0, right: 4.0, top: 2.0),
                        child: Text(AppLocalizations.of(context).gasFee,
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white)),
                      ),
                      Text(model.transFee.toString() + ' FAB',
                          style: const TextStyle(
                              fontSize: 13.0, color: Colors.white))
                    ]),
                    // Slider
                    Slider(
                      divisions: 100,
                      label: '${model.sliderValue.toStringAsFixed(2)}%',
                      activeColor: primaryColor,
                      min: 0.0,
                      max: 100.0,
                      onChanged: (newValue) {
                        model.sliderOnchange(newValue);
                      },
                      value: model.sliderValue,
                    ),
                    // Advance
                    Row(children: <Widget>[
                      Text(AppLocalizations.of(context).advance,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontWeight: FontWeight.w300)),
                      Switch(
                        value: model.isAdvance,
                        inactiveTrackColor: grey,
                        dragStartBehavior: DragStartBehavior.start,
                        activeColor: primaryColor,
                        onChanged: (bool isOn) {
                          model.setBusy(true);
                          model.isAdvance = isOn;
                          model.setBusy(false);
                        },
                      ),
                    ]),
                    model.isAdvance
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        //   model.updateTransFee();
                                      },
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal:
                                                  true), // numnber keyboard
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: grey)),
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
                          )
                        : Container(),
                    model.isAdvance
                        ? Row(
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
                                        // updateTransFee();
                                      },
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal:
                                                  true), // numnber keyboard
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: grey)),
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
                          )
                        : Container(),
                    const SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: MaterialButton(
                              // borderSide: BorderSide(color: globals.primaryColor),
                              color: primaryColor,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context).cancel,
                                  style: const TextStyle(color: Colors.white))),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: OutlineButton(
                            borderSide: BorderSide(color: primaryColor),
                            padding: const EdgeInsets.all(15),
                            color: primaryColor,
                            textColor: Colors.white,
                            onPressed: () async {
                              double amount = 0;
                              if (model.amountController.text != '') {
                                amount =
                                    double.parse(model.amountController.text);
                              }
                              // var res = await AddGasDo(double.parse(myController.text));
                              model.amountController.text == '' ||
                                      amount == null
                                  ? model.sharedService
                                      .showInfoFlushbar(
                                          AppLocalizations.of(context)
                                              .invalidAmount,
                                          AppLocalizations.of(context)
                                              .pleaseEnterValidNumber,
                                          Icons.cancel,
                                          red,
                                          context)
                                  : model.checkPass(amount, context);
                              //   debugPrint(res);
                            },
                            child: Text(
                              AppLocalizations.of(context).confirm,
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ))));
  }
}
