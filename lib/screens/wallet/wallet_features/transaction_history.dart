import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/transaction_history_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../shared/globals.dart' as globals;

class TransactionHistory extends StatelessWidget {
  final String tickerName;
  TransactionHistory({Key key, this.tickerName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseScreen<TransactionHistoryScreenState>(
      onModelReady: (model) async {
        //  model.transactionHistory = [];
        model.context = context;
        await model.getTransaction(tickerName);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).transactionHistory,
              style: Theme.of(context).textTheme.headline3),
          backgroundColor: globals.secondaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  for (var transaction in model.transactionHistory.reversed)
                    model.state == ViewState.Busy
                        ? CircularProgressIndicator()
                        : Card(
                            elevation: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 5.0),
                              color: globals.walletCardColor,
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
                                        transaction.tag == 'deposit'
                                            ? Icon(
                                                Icons.arrow_downward,
                                                size: 24,
                                                color: globals.buyPrice,
                                              )
                                            : Icon(
                                                Icons.arrow_upward,
                                                size: 24,
                                                color: globals.sellPrice,
                                              ),
                                        if (transaction.tag == 'moveToExchange')
                                          Text(
                                            AppLocalizations.of(context)
                                                .moveAndTrade,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                            textAlign: TextAlign.center,
                                          )
                                        else if (transaction.tag ==
                                            'withdrawToWallet')
                                          Text(
                                            AppLocalizations.of(context)
                                                .withdrawToWallet,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                            textAlign: TextAlign.center,
                                          )
                                        else if (transaction.tag == 'send')
                                          Text(
                                            AppLocalizations.of(context).send,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                            textAlign: TextAlign.center,
                                          )
                                        else if (transaction.tag == 'deposit')
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
                                            child: Text('${transaction.txId}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2),
                                          ),
                                        ),
                                        Visibility(
                                          visible: transaction.txId != '',
                                          child: RichText(
                                            text: TextSpan(
                                                text:
                                                    AppLocalizations.of(context)
                                                        .taphereToCopyTxId,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2
                                                    .copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: globals
                                                            .primaryColor),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        model.copyAddress(
                                                            transaction.txId);
                                                      }),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            transaction.date.substring(0, 19),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations.of(context).quantity,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Text(
                                        transaction.quantity.toStringAsFixed(2),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                      ),
                                      UIHelper.verticalSpaceSmall,
                                      transaction.tag != 'send'
                                          ? Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${AppLocalizations.of(context).status}:',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2,
                                                  ),
                                                  if (transaction.status == 'Complete')
                                                    Text(AppLocalizations.of(context).completed.toUpperCase(),
                                                        style: TextStyle(
                                                            color: globals
                                                                .buyPrice))
                                                  else if (transaction.status ==
                                                      'Require redeposit')
                                                    Text(
                                                        AppLocalizations.of(context)
                                                            .requireRedeposit
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                globals.yellow))
                                                  else if (transaction.status ==
                                                      'Failed')
                                                    Text(AppLocalizations.of(context).failed.toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: globals
                                                                .sellPrice))
                                                  else if (transaction.status ==
                                                      'Error')
                                                    Text(AppLocalizations.of(context).error.toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: globals.sellPrice))
                                                  else
                                                    Text(AppLocalizations.of(context).pending.toUpperCase(), style: TextStyle(fontSize: 10, color: globals.sellPrice))
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
