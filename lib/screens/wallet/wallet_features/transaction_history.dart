import 'package:exchangilymobileapp/constants/colors.dart' as colors;
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
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
          child: !model.dataReady
              ? Container(
                  width: double.infinity,
                  height: 300,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).loading,
                    ),
                  ),
                )
              : 
              model.transactionHistory.isEmpty ? Container(
                margin:EdgeInsets.only(top:20),
                child:Center(child: Icon(Icons.insert_drive_file,color:white))) :
              Container(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    children: <Widget>[
                      
                      for (var transaction in model.transactionHistory.reversed)
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
                                        width: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('${transaction.tickerName}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2),
                                            // icon
                                            transaction.tag == model.deposit
                                                ? Icon(
                                                    Icons.arrow_downward,
                                                    size: 24,
                                                    color: colors.buyPrice,
                                                  )
                                                : Icon(
                                                    Icons.arrow_upward,
                                                    size: 24,
                                                    color: colors.sellPrice,
                                                  ),

                                            if (transaction.tag ==
                                                model.withdraw)
                                              Text(
                                                AppLocalizations.of(context)
                                                    .withdraw,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                                textAlign: TextAlign.center,
                                              )
                                            else if (transaction.tag ==
                                                model.send)
                                              Text(
                                                AppLocalizations.of(context)
                                                    .send,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                                textAlign: TextAlign.center,
                                              )
                                            // else if (transaction.tag ==
                                            //     model.bindpay)
                                            //   Text(
                                            //     AppLocalizations.of(context)
                                            //         .bindpay,
                                            //     style: Theme.of(context)
                                            //         .textTheme
                                            //         .subtitle2,
                                            //     textAlign: TextAlign.center,
                                            //   )
                                            else if (transaction.tag ==
                                                model.deposit)
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
                                      UIHelper.horizontalSpaceSmall,
                                      Container(
                                        // width: 200,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: SizedBox(
                                                width: 200,
                                                child: Text(
                                                    '${transaction.txId}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2),
                                              ),
                                            ),
                                            Visibility(
                                              visible: transaction.txId != '',
                                              child: RichText(
                                                text: TextSpan(
                                                    text: AppLocalizations.of(
                                                            context)
                                                        .taphereToCopyTxId,
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
                                                            model.copyAddress(
                                                                transaction
                                                                    .txId);
                                                          }),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(
                                                transaction.date
                                                    .substring(0, 19),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              AppLocalizations.of(context)
                                                  .quantity,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2),
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
                                          UIHelper.verticalSpaceSmall,
                                          transaction.tag != model.send 
                                          // &&
                                          //         transaction.tag !=
                                          //             model.bindpay
                                              ? Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${AppLocalizations.of(context).status}:',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2,
                                                      ),
                                                      if (transaction.status ==
                                                          'Complete')
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
                                                      else if (transaction
                                                              .status ==
                                                          model
                                                              .requireRedeposit)
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
                                                                        model.navigationService.navigateTo(
                                                                            RedepositViewRoute,
                                                                            arguments:
                                                                                model.walletInfo);
                                                                      }),
                                                          ),

                                                          //  Text(
                                                          //     firstCharToUppercase(
                                                          //         AppLocalizations.of(
                                                          //                 context)
                                                          //             .requireRedeposit),
                                                          //     style: TextStyle(
                                                          //         fontSize:
                                                          //             customFontSize,
                                                          //         color: colors
                                                          //             .yellow)),
                                                        )
                                                      else if (transaction
                                                              .status ==
                                                          'Failed')
                                                        Text(
                                                            firstCharToUppercase(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .failed),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    customFontSize,
                                                                color: colors
                                                                    .sellPrice))
                                                      else if (transaction
                                                              .status ==
                                                          'Error')
                                                        Text(
                                                            firstCharToUppercase(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .error),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    customFontSize,
                                                                color: colors
                                                                    .sellPrice))
                                                      else
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
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
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
