import 'package:exchangilymobileapp/models/campaign/reward.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import '../../shared/globals.dart' as globals;

class CampaignTokenDetailsScreen extends StatelessWidget {
  final List<CampaignReward>? campaignRewardList;
  const CampaignTokenDetailsScreen({Key? key, this.campaignRewardList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(FlutterI18n.translate(context, "tokenDetails"),
              // AppLocalizations.of(context).myRewardDetails,
              style: Theme.of(context).textTheme.displaySmall),
        ),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Card(
                color: Theme.of(context).cardColor,
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(context, "myOrders"),
                      ),
                      const Text('234513')
                    ],
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).cardColor,
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(context, "myRewardTokens"),
                    ),
                    const Text('875444')
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
