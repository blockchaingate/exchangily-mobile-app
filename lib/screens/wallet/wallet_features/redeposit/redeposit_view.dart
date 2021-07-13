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
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/redeposit/redeposit_viewmodel.dart';

import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:stacked/stacked.dart';
import '../../../../utils/string_util.dart';

// {"success":true,"data":{"transactionID":"7f9d1b3fad00afa85076d28d46fd3457f66300989086b95c73ed84e9b3906de8"}}
class Redeposit extends StatelessWidget {
  final WalletInfo walletInfo;

  Redeposit({Key key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RedepositViewModel>.reactive(
      onModelReady: (model) {
        model.context = context;
        model.walletInfo = walletInfo;
      },
      viewModelBuilder: () => RedepositViewModel(),
      builder: (BuildContext context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '${AppLocalizations.of(context).redeposit}  ${walletInfo.tickerName}  ${AppLocalizations.of(context).toExchange}',
            style: Theme.of(context).textTheme.headline4,
          ),
          backgroundColor: Color(0XFF1f2233),
        ),
        backgroundColor: Color(0xFF1F2233),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              model.isBusy
                  ? model.sharedService.loadingIndicator()
                  : Container(
                      color: grey.withOpacity(.2),
                      child: Column(
                        children: model.errDepositList
                            .map((data) => RadioListTile(
                                  dense: true,
                                  title: Row(
                                    children: <Widget>[
                                      Text(AppLocalizations.of(context).amount,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      UIHelper.horizontalSpaceSmall,
                                      Text(
                                        bigNum2Double(data["amount"])
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                  value: data['transactionID'],
                                  groupValue: model.errDepositTransactionID,
                                  onChanged: (val) {
                                    model.setBusy(true);
                                    model.errDepositTransactionID = val;
                                    print('valllll=' +
                                        model.errDepositTransactionID);
                                    model.setBusy(false);
                                  },
                                ))
                            .toList(),
                      ),
                    ),
              UIHelper.verticalSpaceSmall,
              Container(
                // padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).walletbalance +
                              ' ${walletInfo.availableBalance}',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Text(
                            '${walletInfo.tickerName}'.toUpperCase(),
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
                          '${model.kanbanTransFee}',
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
                                              .headline5),
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
                                          model.kanbanGasLimitTextController,
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
                                                  color: primaryColor)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: grey)),
                                          hintText: '0.00000',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      style:
                                          TextStyle(color: grey, fontSize: 12),
                                    ))
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              ),
              model.errorMessage.isNotEmpty
                  ? Center(child: Text(model.errorMessage))
                  : Container(),
              UIHelper.verticalSpaceSmall,
              MaterialButton(
                padding: EdgeInsets.all(15),
                color: primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  model.checkPass();
                },
                child: model.isBusy
                    ? model.sharedService.loadingIndicator()
                    : Text(
                        AppLocalizations.of(context).confirm,
                        style: Theme.of(context).textTheme.button,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
