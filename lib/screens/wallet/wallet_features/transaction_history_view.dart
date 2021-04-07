import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';

import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/transaction_history_viewmodel.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_features/transaction_history/transaction_history_card_widget.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TransactionHistoryView extends StatelessWidget {
  final String tickerName;
  TransactionHistoryView({Key key, this.tickerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double customFontSize = 12;
    return ViewModelBuilder<TransactionHistoryViewmodel>.reactive(
        viewModelBuilder: () =>
            TransactionHistoryViewmodel(tickerName: tickerName),
        onModelReady: (model) async {
          model.context = context;
          model.getWalletFromDb();
        },
        builder: (context, model, child) => WillPopScope(
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
                  title: Text(AppLocalizations.of(context).transactionHistory,
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
                                    Text(AppLocalizations.of(context).action,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    UIHelper.horizontalSpaceMedium,
                                    UIHelper.horizontalSpaceSmall,
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                          AppLocalizations.of(context).date,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                          AppLocalizations.of(context).quantity,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                          AppLocalizations.of(context).status,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                          AppLocalizations.of(context).details,
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
