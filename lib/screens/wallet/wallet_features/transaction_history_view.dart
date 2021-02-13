import 'package:exchangilymobileapp/constants/colors.dart' as colors;
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/transaction_history_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/gestures.dart';
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
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).transactionHistory,
              style: Theme.of(context).textTheme.headline3),
          backgroundColor: colors.secondaryColor,
        ),
        body: SingleChildScrollView(
          child: !model.dataReady || model.isBusy
              ? Container(
                  width: double.infinity,
                  height: 300,
                  child: model.sharedService.loadingIndicator())
              : model.transactionHistoryToShowInView.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                          child: Icon(Icons.insert_drive_file,
                              color: colors.white)))
                  : Container(
                      padding: EdgeInsets.all(4.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            
                            children: [UIHelper.horizontalSpaceSmall, Text(
                                                    'Action',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2),UIHelper.horizontalSpaceMedium,UIHelper.horizontalSpaceSmall,
                              
                             Expanded(flex: 1,
                                                            child: Text(
                                                    AppLocalizations.of(context)
                                                        .date,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2),
                             ),
 Expanded(flex: 1,
    child: Text(
                                                    AppLocalizations.of(context)
                                                        .quantity,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2),
 ),
                                                       Expanded(flex: 1,
                                                                                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .status,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2),
                                                       ),
                          ],),
                          for (var transaction
                              in model.transactionHistoryToShowInView)
                            model.isBusy
                                ? CircularProgressIndicator()
                                : Card(
                                    elevation: 4,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      color: colors.walletCardColor,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                          //  width: 55,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                             
                                              children: [
                                                Text(
                                                    '${transaction.tickerName}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2),
                                                // icon
                                                transaction.tag.toUpperCase() ==
                                                        model.deposit
                                                            .toUpperCase()
                                                    ? Icon(
                                                        Icons.arrow_downward,
                                                        size: 20,
                                                        color: colors.buyPrice,
                                                      )
                                                    : Icon(
                                                        Icons.arrow_upward,
                                                        size: 20,
                                                        color: colors.sellPrice,
                                                      ),

                                                if (transaction.tag
                                                        .toUpperCase() ==
                                                    model.withdraw
                                                        .toUpperCase())
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .withdraw,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2,
                                                    textAlign: TextAlign.center,
                                                  )
                                                else if (transaction.tag
                                                        .toUpperCase() ==
                                                    model.send.toUpperCase())
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .send,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2,
                                                    textAlign: TextAlign.center,
                                                  )
                                                else if (transaction.tag
                                                        .toUpperCase() ==
                                                    model.deposit.toUpperCase())
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .deposit,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2,
                                                    textAlign: TextAlign.center,
                                                  )
                                              ],
                                            ),
                                          ),
                                          UIHelper.horizontalSpaceMedium,
                                          // DATE
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                    top: 5.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  transaction.date.split(" ")[0]
                                                      ,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight
                                                                  .w400),
                                                ),   Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Text(
                                                    transaction.date.split(" ")[1]
                                                        ,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          UIHelper.horizontalSpaceLarge,
                                          // Quantity
                                          Text(
                                            transaction.quantity
                                                .toStringAsFixed(
                                                    // model
                                                    //   .decimalConfig
                                                    //   .quantityDecimal
                                                    2),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                          UIHelper.horizontalSpaceMedium,
                                          // Tag
                                          transaction.tag != model.send
                                              ? Container(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      
                                                
                                                      // If deposit is success in both Ticker chain and kanabn chain then show completed
                                                      if (transaction.tag
                                                                  .toUpperCase() ==
                                                              model.deposit
                                                                  .toUpperCase() &&
                                                          transaction
                                                                  .tickerChainTxStatus ==
                                                              model
                                                                  .success &&
                                                          transaction
                                                                  .kanbanTxStatus ==
                                                              model.success)
                                                        Text(
                                                            firstCharToUppercase(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .completed),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    customFontSize,
                                                                color: colors
                                                                    .buyPrice))
                                                                      // If deposit is success in only Ticker chain and not in kanban chain then show sent
                                                                   else if (transaction.tag
                                                                  .toUpperCase() ==
                                                              model.deposit
                                                                  .toUpperCase() &&
                                                          transaction
                                                                  .tickerChainTxStatus ==
                                                              model
                                                                  .success &&
                                                          transaction
                                                                  .kanbanTxStatus ==
                                                              model.success)
                                                        Text(
                                                            firstCharToUppercase(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .sent),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    customFontSize,
                                                                color: colors
                                                                    .buyPrice))
                                                                    // depsoit pending if ticker chain staus is pending
                                                      else if (transaction.tag
                                                                  .toUpperCase() ==
                                                              model.deposit
                                                                  .toUpperCase()&&transaction
                                                              .tickerChainTxStatus ==
                                                          model.pending)
                                                        Text(
                                                            firstCharToUppercase(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .pending),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    customFontSize,
                                                                color: colors
                                                                    .yellow))
                                                      
                                                      else if (transaction.tag
                                                                  .toUpperCase() ==
                                                              model.deposit
                                                                  .toUpperCase()&&transaction
                                                                  .kanbanTxStatus ==
                                                              model
                                                                  .rejected ||
                                                          transaction
                                                                  .kanbanTxStatus ==
                                                              model
                                                                  .rejected)
                                                           
                                                        SizedBox(
                                                          width: 80,
                                                          child: RichText(
                                                            text: TextSpan(
                                                                text: AppLocalizations.of(
                                                                        context)
                                                                    .redeposit,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    color: colors
                                                                        .red),
                                                                recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () {
                                                                        model.navigationService.navigateTo(RedepositViewRoute,
                                                                            arguments: model.walletInfo);
                                                                      }),
                                                          ),
                                                        )            // if withdraw status is success on kanban but null on ticker chain then display sent
                                                      else if (transaction
                                                                  .tag
                                                                  .toUpperCase() ==
                                                              model
                                                                  .withdraw
                                                                  .toUpperCase() &&
                                                          transaction
                                                                  .kanbanTxStatus ==
                                                              model.success && transaction.tickerChainTxId == '')
                                                        Text(
                                                            firstCharToUppercase(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .sent),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    customFontSize,
                                                                color: colors
                                                                    .buyPrice))              // if withdraw status is success on kanban but null on ticker chain then display sent
                                                      else if (transaction
                                                                  .tag
                                                                  .toUpperCase() ==
                                                              model
                                                                  .withdraw
                                                                  .toUpperCase() &&
                                                          transaction
                                                                  .kanbanTxStatus ==
                                                              model.success && transaction.tickerChainTxStatus.startsWith('sent'))
                                                        Text(
                                                            firstCharToUppercase(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .completed),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    customFontSize,
                                                                color: colors
                                                                    .buyPrice)),
                                                                    
                                                                           UIHelper.horizontalSpaceSmall,
                                                                      RichText(
                                                  text: TextSpan(
                                                      text: AppLocalizations.of(
                                                              context)
                                                          .details,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2
                                                          .copyWith(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              color: colors
                                                                  .primaryColor),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              model.showTxDetailDialog(
                                                                  transaction);
                                                              // model.copyAddress(
                                                              //     transaction
                                                              //         .kanbanTxId);
                                                            }),
                                                ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                        ],
                      )),
        ),
      ),
    );
  }
}
