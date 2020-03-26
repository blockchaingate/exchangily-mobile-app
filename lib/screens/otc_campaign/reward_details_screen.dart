import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class CampaignRewardDetailsScreen extends StatelessWidget {
  const CampaignRewardDetailsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Reward', style: Theme.of(context).textTheme.headline3),
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
                          child: Text('Level',
                              style: Theme.of(context).textTheme.headline5))),
                  Expanded(
                      flex: 2,
                      child: Center(
                          child: Text('Refferals',
                              style: Theme.of(context).textTheme.headline5))),
                  Expanded(
                      flex: 2,
                      child: Center(
                          child: Text('Total Amount',
                              style: Theme.of(context).textTheme.headline5))),
                  Expanded(
                      flex: 2,
                      child: Center(
                          child: Text('Reward',
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
                    Expanded(flex: 2, child: Center(child: Text('10'))),
                    Expanded(flex: 2, child: Center(child: Text('1000'))),
                    Expanded(flex: 2, child: Center(child: Text('50')))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
