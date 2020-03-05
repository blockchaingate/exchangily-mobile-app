import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/transaction_history_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
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
        await model.getTransaction(tickerName);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).transactionHistory,
              style: Theme.of(context).textTheme.headline3),
          backgroundColor: globals.secondaryColor,
        ),
        body: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (var transaction in model.transactionHistory)
                  model.state == ViewState.Busy
                      ? CircularProgressIndicator()
                      : Card(
                          elevation: 4,
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            color: globals.walletCardColor,
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_upward,
                                  size: 35,
                                  color: globals.sellPrice,
                                ),
                                Container(
                                  width: 230,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${transaction.tickerName} : ${transaction.address}',
                                        style: TextStyle(
                                            color: globals.primaryColor),
                                      ),
                                      Text(
                                        transaction.date,
                                        style: TextStyle(
                                            fontSize: 14, color: globals.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      transaction.amount.toString(),
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
              ],
            )),
      ),
    );
  }
}
