import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/campaign/reward.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;

class MyRewardDetailsScreen extends StatelessWidget {
  final List<CampaignReward>? campaignRewardList;
  const MyRewardDetailsScreen({Key? key, this.campaignRewardList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.myRewardDetails,
            style: Theme.of(context).textTheme.headline4),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          // Static lables row
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(AppLocalizations.of(context)!.level,
                            style: Theme.of(context).textTheme.subtitle2))),
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(AppLocalizations.of(context)!.referrals,
                            style: Theme.of(context).textTheme.subtitle2))),
                Expanded(
                    flex: 3,
                    child: Center(
                        child: Text(
                            AppLocalizations.of(context)!.totalTokenAmount,
                            style: Theme.of(context).textTheme.subtitle2))),
                Expanded(
                    flex: 2,
                    child: Center(
                        child: Text(AppLocalizations.of(context)!.rewardsToken,
                            style: Theme.of(context).textTheme.subtitle2))),
                Expanded(
                    flex: 2,
                    child: Center(
                        child: Text(AppLocalizations.of(context)!.totalValue,
                            style: Theme.of(context).textTheme.subtitle2)))
              ],
            ),
          ),
          UIHelper.verticalSpaceSmall,
// Reward list builder
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: campaignRewardList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/myReferralView',
                            arguments: campaignRewardList![index].users);
                      },
                      child: Card(
                        elevation: 5,
                        color: globals.walletCardColor,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 2),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    campaignRewardList![index].level.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ))),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                          campaignRewardList![index]
                                              .totalAccounts
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6))),
                              Expanded(
                                  flex: 3,
                                  child: Center(
                                      child: Text(
                                          campaignRewardList![index]
                                              .totalQuantities!
                                              .toStringAsFixed(3),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6))),
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Text(
                                          campaignRewardList![index]
                                              .totalRewardQuantities!
                                              .toStringAsFixed(3),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6))),
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Text(
                                          campaignRewardList![index]
                                              .totalValue!
                                              .toStringAsFixed(3),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  color: Colors.greenAccent,
                                                  fontWeight:
                                                      FontWeight.bold))))
                            ],
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      )),
    );
  }
}
