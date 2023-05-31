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
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/redeposit/redeposit_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';

// {"success":true,"data":{"transactionID":"7f9d1b3fad00afa85076d28d46fd3457f66300989086b95c73ed84e9b3906de8"}}
class Redeposit extends StatelessWidget {
  final WalletInfo? walletInfo;

  const Redeposit({Key? key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RedepositViewModel>.reactive(
      onViewModelReady: (model) {
        model.context = context;
        model.walletInfo = walletInfo;
      },
      viewModelBuilder: () => RedepositViewModel(),
      builder: (BuildContext context, model, child) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              '${FlutterI18n.translate(context, "redeposit")}  ${walletInfo!.tickerName}  ${FlutterI18n.translate(context, "toExchange")}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            backgroundColor: const Color(0XFF1f2233),
          ),
          backgroundColor: const Color(0xFF1F2233),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                model.isBusy && !model.isConfirmButtonPressed
                    ? model.sharedService!.loadingIndicator()
                    : Container(
                        color: grey.withOpacity(.2),
                        child: Column(
                          children: model.errDepositList
                              .map((redepositItem) => RadioListTile(
                                    dense: true,
                                    title: Row(
                                      children: <Widget>[
                                        Text(
                                            FlutterI18n.translate(
                                                context, "amount"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium),
                                        UIHelper.horizontalSpaceSmall,
                                        Text(
                                          NumberUtil.rawStringToDecimal(
                                                  redepositItem["amount"])
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ],
                                    ),
                                    activeColor: primaryColor,
                                    value: redepositItem['transactionID'],
                                    groupValue: model.errDepositTransactionID,
                                    onChanged: (dynamic val) {
                                      model.setBusy(true);
                                      model.errDepositTransactionID = val;
                                      debugPrint(
                                          'valllll=${model.errDepositTransactionID!}');
                                      model.setBusy(false);
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                UIHelper.verticalSpaceSmall,
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '${FlutterI18n.translate(context, "walletbalance")} ${model.walletInfo!.availableBalance}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Text(
                            walletInfo!.tickerName!.toUpperCase(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        )
                      ],
                    ),
                    UIHelper.verticalSpaceSmall,
                    Row(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context, "kanbanGasFee"),
                            style: Theme.of(context).textTheme.headlineSmall),
                        UIHelper.horizontalSpaceSmall,
                        Text(
                          '${model.kanbanTransFee}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        )
                      ],
                    ),
                    // Switch Row
                    Row(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context, "advance"),
                            style: Theme.of(context).textTheme.headlineSmall),
                        Switch(
                          value: model.transFeeAdvance,
                          inactiveTrackColor: grey,
                          dragStartBehavior: DragStartBehavior.start,
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
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                      FlutterI18n.translate(
                                          context, "kanbanGasPrice"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                ),
                                Expanded(
                                    flex: 5,
                                    child: TextField(
                                      controller:
                                          model.kanbanGasPriceTextController,
                                      onChanged: (String amount) {
                                        model.updateTransFee();
                                      },
                                      keyboardType: TextInputType
                                          .number, // numnber keyboard
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
                                              .headlineSmall),
                                      style:
                                          TextStyle(color: grey, fontSize: 12),
                                    ))
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
                                          .titleLarge),
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
                                              .headlineSmall),
                                      style:
                                          TextStyle(color: grey, fontSize: 12),
                                    ))
                              ],
                            )
                          ],
                        ))
                  ],
                ),
                model.errorMessage != null || model.errorMessage!.isNotEmpty
                    ? Center(
                        child: Text(
                        model.errorMessage!,
                        style: TextStyle(color: red),
                      ))
                    : Container(),
                UIHelper.verticalSpaceSmall,
                MaterialButton(
                  padding: const EdgeInsets.all(15),
                  color: primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    model.checkPass();
                  },
                  child: model.isBusy && model.isConfirmButtonPressed
                      ? model.sharedService!.loadingIndicator()
                      : Text(
                          FlutterI18n.translate(context, "confirm"),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                ),
              ],
            ),
          )),
    );
  }
}
