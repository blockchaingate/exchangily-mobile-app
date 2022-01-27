import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/team_reward_details_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/globals.dart' as globals;

class TeamRewardDetailsView extends StatelessWidget {
  final List team;
  const TeamRewardDetailsView({Key key, this.team}) : super(key: key);

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
          title: Text(FlutterI18n.translate(context, "teamDetails"),
              style: Theme.of(context).textTheme.headline4),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(4.0),
              child: Column(
                children: <Widget>[
                  // Static lables row
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text(
                                  FlutterI18n.translate(context, "team"),
                                  style:
                                      Theme.of(context).textTheme.subtitle2))),
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text(
                                  FlutterI18n.translate(context, "members"),
                                  style:
                                      Theme.of(context).textTheme.subtitle2))),
                      Expanded(
                          flex: 2,
                          child: Center(
                              child: Text(
                                  FlutterI18n.translate(context, "totalValue"),
                                  style:
                                      Theme.of(context).textTheme.subtitle2))),
                      Expanded(
                          flex: 2,
                          child: Center(
                              child: Text(
                                  FlutterI18n.translate(
                                      context, "totalQuantity"),
                                  style:
                                      Theme.of(context).textTheme.subtitle2))),
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text(
                                  FlutterI18n.translate(context, "percentage"),
                                  style:
                                      Theme.of(context).textTheme.subtitle2)))
                    ],
                  ),
                  UIHelper.verticalSpaceSmall,
// Reward list builder
                  team == null
                      ? Shimmer.fromColors(
                          baseColor: globals.primaryColor,
                          highlightColor: globals.grey,
                          child: Text(
                            (FlutterI18n.translate(context, "loading")),
                            style: Theme.of(context).textTheme.headline5,
                          ))
                      : team != null
                          ? Container(
                              height: UIHelper.getScreenFullHeight(context),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: team.length,
                                itemBuilder: (BuildContext context, int index) {
                                  int i = index + 1;
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          '/teamReferralView',
                                          arguments: team[index]);
                                    },
                                    child: Card(
                                      elevation: 5,
                                      color: globals.walletCardColor,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.0),
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
                                                flex: 1,
                                                child: Center(
                                                    child: Text(
                                                        team[index]['members']
                                                            .length
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5))),
                                            Expanded(
                                                flex: 2,
                                                child: Center(
                                                    child: Text(
                                                        team[index]
                                                                ['totalValue']
                                                            .toStringAsFixed(2),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5))),
                                            Expanded(
                                                flex: 2,
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 3.0),
                                                  child: Text(
                                                      team[index][
                                                              'totalQuantities']
                                                          .toStringAsFixed(3),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5),
                                                ))),
                                            Expanded(
                                                flex: 1,
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 3.0),
                                                  child: Text(
                                                      '${team[index]['percentage'].toStringAsFixed(3)}\%',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5),
                                                )))
                                          ],
                                        ),
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
      ),
    );
  }
}
