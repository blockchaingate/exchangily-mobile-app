import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/team_reward_details_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/globals.dart' as globals;

class CampaignTeamRewardsView extends StatelessWidget {
  final List team;
  const CampaignTeamRewardsView({Key key, this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<TeamRewardDetailsScreenState>(
      onModelReady: (model) async {
        //  model.teamValueAndRewardWithToken = team;
        //  model.initState();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).teamDetails,
              style: Theme.of(context).textTheme.headline4),
        ),
        body: Container(
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                // Static lables row
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(AppLocalizations.of(context).team,
                                style: Theme.of(context).textTheme.headline6))),
                    Expanded(
                        flex: 2,
                        child: Center(
                            child: Text(AppLocalizations.of(context).members,
                                style: Theme.of(context).textTheme.headline6))),
                    Expanded(
                        flex: 3,
                        child: Center(
                            child: Text(AppLocalizations.of(context).totalValue,
                                style: Theme.of(context).textTheme.headline6))),
                    Expanded(
                        flex: 2,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context).totalQuantity,
                                style: Theme.of(context).textTheme.headline6)))
                  ],
                ),
                UIHelper.verticalSpaceSmall,
// Reward list builder
                team == null
                    ? Shimmer.fromColors(
                        baseColor: globals.primaryColor,
                        highlightColor: globals.grey,
                        child: Text(
                          (AppLocalizations.of(context).loading),
                          style: Theme.of(context).textTheme.headline5,
                        ))
                    : team != null
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: team.length,
                              itemBuilder: (BuildContext context, int index) {
                                int i = index + 1;
                                return Card(
                                  elevation: 5,
                                  color: globals.walletCardColor,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: Text(
                                              i.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            ))),
                                        Expanded(
                                            flex: 2,
                                            child: Center(
                                                child: Text(
                                                    team[index]['members']
                                                        .length
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5))),
                                        Expanded(
                                            flex: 3,
                                            child: Center(
                                                child: Text(
                                                    team[index]['totalValue']
                                                        .toStringAsFixed(2),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5))),
                                        Expanded(
                                            flex: 2,
                                            child: Center(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 3.0),
                                              child: Text(
                                                  team[index]['totalQuantities']
                                                      .toStringAsFixed(3),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5),
                                            )))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container()
              ],
            )),
      ),
    );
  }
}
