import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/team_reward_details_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/globals.dart' as globals;

class MyReferralView extends StatelessWidget {
  final List<String>? referralDetails;
  const MyReferralView({Key? key, this.referralDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'rewardDetails $referralDetails== members length ${referralDetails!.length}');
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
            // Members List
            UIHelper.verticalSpaceMedium,

            Expanded(
              child: SizedBox(
                height: UIHelper.getScreenFullHeight(context),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: referralDetails!.length,
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
                                child: Text(referralDetails![index].toString(),
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
