import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/team_reward_details_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/globals.dart' as globals;

class CampaignTeamReferralView extends StatelessWidget {
  final rewardDetails;
  const CampaignTeamReferralView({Key? key, this.rewardDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'rewardDetails $rewardDetails== members length ${rewardDetails['members'].length}');
    return BaseScreen<TeamRewardDetailsScreenState>(
      onModelReady: (model) async {
        //  model.teamValueAndRewardWithToken = teamRewardDetails;
        // model.initState();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.memberDetails,
              style: Theme.of(context).textTheme.headline4),
        ),
        body: Container(
            //  margin: EdgeInsets.all(8.0),
            child: Column(
          children: <Widget>[
            Container(
              color: primaryColor.withAlpha(110),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                      child: Text(AppLocalizations.of(context)!.teamLeader,
                          style: Theme.of(context).textTheme.headline5)),
                  Center(
                      child: Text(rewardDetails['name']['email'].toString(),
                          style: Theme.of(context).textTheme.headline5)),
                ],
              ),
            ),
            UIHelper.verticalSpaceMedium,
            // Members List

            Expanded(
              child: SizedBox(
                height: UIHelper.getScreenFullHeight(context),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: rewardDetails['members'].length,
                  itemBuilder: (BuildContext context, int index) {
                    int i = index + 1;
                    return Card(
                      elevation: 2,
                      color: globals.walletCardColor,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: <Widget>[
                            UIHelper.horizontalSpaceSmall,
                            Expanded(
                                flex: 3,
                                child: Text(
                                  i.toString(),
                                  style: Theme.of(context).textTheme.headline5,
                                )),
                            Expanded(
                                flex: 7,
                                child: Text(
                                    rewardDetails['members'][index]['email']
                                        .toString(),
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.headline5)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
