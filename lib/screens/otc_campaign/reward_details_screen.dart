import 'package:exchangilymobileapp/models/campaign/reward.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class CampaignRewardDetailsScreen extends StatelessWidget {
  final List<CampaignReward> campaignRewardList;
  const CampaignRewardDetailsScreen({Key key, this.campaignRewardList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Reward Details',
            style: Theme.of(context).textTheme.headline3),
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
              UIHelper.verticalSpaceSmall,
// Reward list builder
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: campaignRewardList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          color: globals.walletCardColor,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child: Text(
                                      campaignRewardList[index]
                                          .level
                                          .toString(),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ))),
                                Expanded(
                                    flex: 2,
                                    child: Center(
                                        child: Text(
                                            campaignRewardList[index]
                                                .totalAccounts
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5))),
                                Expanded(
                                    flex: 2,
                                    child: Center(
                                        child: Text(
                                            campaignRewardList[index]
                                                .totalQuantities
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5))),
                                Expanded(
                                    flex: 2,
                                    child: Center(
                                        child: Text(
                                            campaignRewardList[index]
                                                .totalRewardQuantities
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5)))
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          )),
    );
  }
}
