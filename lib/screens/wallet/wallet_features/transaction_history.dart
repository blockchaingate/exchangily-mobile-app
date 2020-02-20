import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

import '../../../shared/globals.dart' as globals;

class TransactionHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).transactionHistory),
        backgroundColor: globals.secondaryColor,
      ),
      body: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                elevation: 4,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  color: globals.walletCardColor,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_downward,
                        size: 35,
                        color: globals.grey,
                      ),
                      Container(
                        width: 230,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('BTC',
                                style: TextStyle(
                                    fontSize: 17, color: globals.white)),
                            Text(
                              'fhhjd3bnfjndlcd909dfn00d0033nnfdknfl3nd',
                              style: TextStyle(color: globals.primaryColor),
                            ),
                            Text(
                              'Feb 01',
                              style:
                                  TextStyle(fontSize: 14, color: globals.grey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            '0.2',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                    fontSize: 18, color: globals.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
