import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;

class CampaignDashboardScreen extends StatelessWidget {
  final CampaignUserData userData;
  CampaignDashboardScreen({Key key, this.userData}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignDashboardScreenState>(
      onModelReady: (model) async {
        model.context = context;
        // if (userData == null) {
        //   await model.initState();
        // }
        await model.myRewardsByToken();
        await model.getCampaignName();
        await model.myRewardsById(userData);
      },
      builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
/*-------------------------------------------------------------------------------------
                                  App Drawer
-------------------------------------------------------------------------------------*/
          drawer: Drawer(
            elevation: 5,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                AppBar(
                  elevation: 5,
                  automaticallyImplyLeading: false,
                  title: Center(
                      child: Text(
                    model.campaignName,
                    style: Theme.of(context).textTheme.headline4,
                  )),
                ),
                ListTile(
                  trailing: Icon(
                    Icons.person,
                    color: globals.white54,
                  ),
                  title: Text(
                    '${userData.email}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                UIHelper.divider,
                ListTile(
                  trailing: Icon(
                    Icons.event_note,
                    color: globals.green,
                  ),
                  title: Text('Read Campaign Instructions'),
                  onTap: () {
                    Navigator.pushNamed(context, '/campaignInstructions');
                  },
                ),
                UIHelper.divider,
                ListTile(
                  title: Text('My Referral Code'),
                  trailing: userData.referralCode != null
                      ? Text(userData.referralCode.toString(),
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              color: globals.primaryColor,
                              fontWeight: FontWeight.bold))
                      : Text(''),
                  onTap: () {
                    // May call copy to clipboard here
                  },
                ),
                UIHelper.divider,
                ListTile(
                  trailing: Icon(
                    Icons.clear_all,
                    color: globals.red,
                  ),
                  title: Text(
                    'Logout',
                  ),
                  onTap: () {
                    model.logout();
                  },
                ),
              ],
            ),
          ),

/*-------------------------------------------------------------------------------------
                                  Scaffold body Container
-------------------------------------------------------------------------------------*/
          body: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                UIHelper.verticalSpaceMedium,
/*-------------------------------------------------------------------------------------
                            Header with email and logout
-------------------------------------------------------------------------------------*/
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          dense: false,
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: IconButton(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(right: 10),
                                iconSize: 28,
                                icon: Icon(
                                  Icons.menu,
                                  color: globals.primaryColor,
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState.openDrawer();
                                }),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text('Welcome ${userData.email}',
                                style: Theme.of(context).textTheme.headline5),
                          ),
                          trailing: InkWell(
                              onTap: () {
                                model.logout();
                              },
                              child: Text(
                                'Logout',
                                style: Theme.of(context).textTheme.headline5,
                                textAlign: TextAlign.end,
                              )))
                    ],
                  ),
                ),
                UIHelper.verticalSpaceSmall,

/*-------------------------------------------------------------------------------------
                                My total investment container with list tiles
-------------------------------------------------------------------------------------*/
                Container(
                  color: globals.walletCardColor,
                  padding: EdgeInsets.only(top: 5.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          dense: false,
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(
                              Icons.monetization_on,
                              color: globals.buyPrice,
                              size: 24,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: Text(
                                  'Level',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              model.busy
                                  ? Container(
                                      color: globals.grey,
                                      child: Shimmer.fromColors(
                                          baseColor: globals.primaryColor,
                                          highlightColor: globals.grey,
                                          child: Text(
                                            (''),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          )),
                                    )
                                  : Text(model.memberLevel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Color(model.levelTextColor)))
                            ],
                          ),
                          title: Text(
                            'My Total Investment',
                            style: TextStyle(letterSpacing: 1.25),
                          ),
                          subtitle: model.busy
                              ? Shimmer.fromColors(
                                  baseColor: globals.primaryColor,
                                  highlightColor: globals.grey,
                                  child: Text(
                                    ('0.000'),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ))
                              : Text(
                                  model.myTotalInvestmentValue
                                      .toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.headline5))
                    ],
                  ),
                ),
/*-------------------------------------------------------------------------------------
                                Investment quantity container with list tiles
-------------------------------------------------------------------------------------*/
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        dense: false,
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Icon(
                            Icons.confirmation_number,
                            color: globals.exgLogoColor,
                            size: 22,
                          ),
                        ),
                        title: Text('Total Investment Quantity'),
                        subtitle: model.busy
                            ? Shimmer.fromColors(
                                baseColor: globals.primaryColor,
                                highlightColor: globals.grey,
                                child: Text(
                                  ('0.000'),
                                  style: Theme.of(context).textTheme.headline5,
                                ))
                            : Text(
                                model.myTotalInvestmentQuantity
                                    .toStringAsFixed(4),
                                style: Theme.of(context).textTheme.headline5),
                        // trailing: Icon(
                        //   Icons.navigate_next,
                        //   color: globals.white54,
                        // ),
                      )
                    ],
                  ),
                ),
                UIHelper.divider,

/*-------------------------------------------------------------------------------------
                                Total reward container with list tiles
-------------------------------------------------------------------------------------*/
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          onTap: () {
                            model.navigateByRouteName('/campaignRewardDetails',
                                model.campaignRewardList);
                          },
                          dense: false,
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(
                              Icons.card_giftcard,
                              color: globals.fabLogoColor,
                              size: 22,
                            ),
                          ),
                          title: Text('My Total Reward'),
                          subtitle: model.busy
                              ? Shimmer.fromColors(
                                  baseColor: globals.primaryColor,
                                  highlightColor: globals.grey,
                                  child: Text(
                                    model.errorMessage,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ))
                              : Text(model.myTotalReward.toStringAsFixed(4),
                                  style: Theme.of(context).textTheme.headline5),
                          trailing: Icon(
                            Icons.navigate_next,
                            color: globals.white54,
                          ))
                    ],
                  ),
                ),
                UIHelper.divider,

/*-------------------------------------------------------------------------------------
                                Team container with list tiles
-------------------------------------------------------------------------------------*/
                Container(
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {},
                        dense: false,
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Icon(
                            Icons.people_outline,
                            color: globals.primaryColor,
                            size: 22,
                          ),
                        ),
                        title: Text('Teams Total Value'),
                        subtitle: model.busy
                            ? Shimmer.fromColors(
                                baseColor: globals.primaryColor,
                                highlightColor: globals.grey,
                                child: Text(
                                  ('0.000'),
                                  style: Theme.of(context).textTheme.headline5,
                                ))
                            : Text(model.myTeamsTotalValue.toString(),
                                style: Theme.of(context).textTheme.headline5),
                        // trailing: Icon(
                        //   Icons.navigate_next,
                        //   color: globals.white54,
                        // ),
                      )
                    ],
                  ),
                ),
                UIHelper.divider,

/*-------------------------------------------------------------------------------------
                                My referrals container with list tiles
-------------------------------------------------------------------------------------*/
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {},
                        dense: false,
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Icon(
                            Icons.share,
                            color: globals.primaryColor,
                            size: 22,
                          ),
                        ),
                        title: Text('My Referrals'),
                        subtitle: model.busy
                            ? Shimmer.fromColors(
                                baseColor: globals.primaryColor,
                                highlightColor: globals.grey,
                                child: Text(
                                  ('0.000'),
                                  style: Theme.of(context).textTheme.headline5,
                                ))
                            : Text(model.myTotalReferrals.toString(),
                                style: Theme.of(context).textTheme.headline5),
                        // trailing: Icon(
                        //   Icons.navigate_next,
                        //   color: globals.white54,
                        // ),
                      )
                    ],
                  ),
                ),
                UIHelper.verticalSpaceLarge,
/*-------------------------------------------------------------------------------------
                        Button Container
-------------------------------------------------------------------------------------*/
                Container(
                    child: SizedBox(
                  width: 150,
                  child: RaisedButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pushNamed(context, '/campaignPayment');
                      },
                      child: Text('Buy',
                          style: Theme.of(context).textTheme.headline4)),
                ))
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(count: 3)),
    );
  }
}
