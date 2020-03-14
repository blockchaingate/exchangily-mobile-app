import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class RefferalDetailsScreen extends StatelessWidget {
  const RefferalDetailsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text('My Refferal', style: Theme.of(context).textTheme.headline3),
      ),
      body: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              // Static lables row
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Center(
                          child: Text('ID',
                              style: Theme.of(context).textTheme.headline5))),
                  Expanded(
                      flex: 2,
                      child: Center(
                          child: Text('Name ',
                              style: Theme.of(context).textTheme.headline5))),
                  Expanded(
                      flex: 2,
                      child: Center(
                          child: Text('Paid',
                              style: Theme.of(context).textTheme.headline5))),
                  Expanded(
                      flex: 2,
                      child: Center(
                          child: Text('Refferals',
                              style: Theme.of(context).textTheme.headline5)))
                ],
              ),
              UIHelper.horizontalSpaceSmall,
              Container(
                padding: EdgeInsets.all(5.0),
                color: globals.walletCardColor,
                child: Row(
                  children: <Widget>[
                    Expanded(flex: 1, child: Center(child: Text('1'))),
                    Expanded(flex: 2, child: Center(child: Text('Paul'))),
                    Expanded(flex: 2, child: Center(child: Text('200'))),
                    Expanded(flex: 2, child: Center(child: Text('150')))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
