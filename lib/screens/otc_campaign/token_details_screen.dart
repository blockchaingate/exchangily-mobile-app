import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:exchangilymobileapp/models/campaign/reward.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class CampaignTokenDetailsScreen extends StatelessWidget {
  final List<CampaignReward> campaignRewardList;
  const CampaignTokenDetailsScreen({Key key, this.campaignRewardList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(FlutterI18n.translate(context, "tokenDetails"),
              // FlutterI18n.translate(context, "myRewardDetails"),
              style: Theme.of(context).textTheme.headline3),
        ),
        body: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Card(
                color: globals.walletCardColor,
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(FlutterI18n.translate(context, "myOrders")),
                      Text('234513')
                    ],
                  ),
                ),
              ),
              Card(
                color: globals.walletCardColor,
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    Text(FlutterI18n.translate(context, "myRewardTokens")),
                    Text('875444')
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
