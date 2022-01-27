import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';

import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/transaction_history_viewmodel.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/transaction_history/transaction_history_card_widget.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TransactionHistoryView extends StatelessWidget {
  final WalletInfo walletInfo;
  TransactionHistoryView({Key key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double customFontSize = 12;
    return ViewModelBuilder<TransactionHistoryViewmodel>.reactive(
        createNewModelOnInsert: true,
        viewModelBuilder: () =>
            TransactionHistoryViewmodel(walletInfo: walletInfo),
        onModelReady: (TransactionHistoryViewmodel model) async {
          model.context = context;
        },
        builder: (context, TransactionHistoryViewmodel model, child) =>
            WillPopScope(
              onWillPop: () async {
                print('isDialogUp ${model.isDialogUp}');
                if (model.isDialogUp) {
                  Navigator.of(context, rootNavigator: true).pop();
                  model.isDialogUp = false;
                  print('isDialogUp in if ${model.isDialogUp}');
                } else
                  Navigator.of(context).pop();

                return Future.value(false);
              },
              child: Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => model.reloadTransactions())
                  ],
                  leading: Container(
                      child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).pop())),
                  centerTitle: true,
                  // actions: [
                  //  IconButton(
                  //     icon: Icon(Icons.refresh),
                  //     onPressed: () => {},
                  //   )
                  // ],
                  title: Text(
                      FlutterI18n.translate(context, "transactionHistory"),
                      style: Theme.of(context).textTheme.headline3),
                  backgroundColor: secondaryColor,
                ),
                body: !model.dataReady || model.isBusy
                    ? Container(
                        width: double.infinity,
                        height: 300,
                        child: model.sharedService.loadingIndicator())
                    : model.transactionHistoryToShowInView.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Center(
                                child: Icon(Icons.insert_drive_file,
                                    color: white)))
                        : Container(
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              children: <Widget>[
                                //  IconButton(icon:Icon(Icons.ac_unit,color:colors.white),onPressed: ()=> model.test(),),
                                Row(
                                  children: [
                                    UIHelper.horizontalSpaceSmall,
                                    Text(
                                        FlutterI18n.translate(
                                            context, "action"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    UIHelper.horizontalSpaceSmall,
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                          FlutterI18n.translate(
                                              context, "date"),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                          FlutterI18n.translate(
                                              context, "quantity"),
                                          textAlign: TextAlign.right,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                            FlutterI18n.translate(
                                                context, "status"),
                                            textAlign: TextAlign.left,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                          FlutterI18n.translate(
                                              context, "details"),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                    ),
                                  ],
                                ),
                                model.isBusy
                                    ? CircularProgressIndicator()
                                    : Expanded(
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: model
                                                .transactionHistoryToShowInView
                                                .length,
                                            itemBuilder: (context, index) {
                                              return TxHisotryCardWidget(
                                                  customFontSize:
                                                      customFontSize,
                                                  transaction: model
                                                          .transactionHistoryToShowInView[
                                                      index],
                                                  model: model);
                                            }),
                                      ),
                              ],
                            )),
              ),
            ));
  }
}
