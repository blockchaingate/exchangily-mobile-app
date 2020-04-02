import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/packages/bip32/utils/ecurve.dart';
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
        if (userData == null) {
          model.initState();
        }
        await model.myReferralsById(userData);
        await model.getCampaignName();
        await model.myRewardById(userData);
      },
      builder: (context, model, child) => Scaffold(
          key: _scaffoldKey,
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
                    Icons.email,
                    color: globals.primaryColor,
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
                    color: globals.primaryColor,
                  ),
                  title: Text('Read Instructions'),
                  onTap: () {
                    Navigator.pushNamed(context, '/campaignInstructions');
                  },
                ),
                Divider(
                  color: globals.grey,
                  height: 1,
                ),
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
          body: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                UIHelper.verticalSpaceMedium,
                // Header of the page container

                Container(
                  margin: EdgeInsets.only(top: 25.0),
                  child:
                      // First row that contains user email, menu button and logout button
                      Row(
                    children: <Widget>[
                      // Burger button and user email row
                      Row(children: [
                        IconButton(
                            padding: EdgeInsets.all(0),
                            iconSize: 28,
                            icon: Icon(
                              Icons.menu,
                              color: globals.primaryColor,
                            ),
                            onPressed: () {
                              _scaffoldKey.currentState.openDrawer();
                            }),
                        Center(
                            child: Text('Welcome ${userData.email}',
                                style: Theme.of(context).textTheme.headline5)),
                      ]),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 45),
                          child: FlatButton(
                              onPressed: () {
                                model.logout();
                              },
                              child: Text(
                                'Logout',
                                style: Theme.of(context).textTheme.headline5,
                                textAlign: TextAlign.end,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                UIHelper.verticalSpaceSmall,
                // Level container
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                      child: Text('Level: ${model.memberLevel}',
                          style: Theme.of(context).textTheme.headline5)),
                ),
                UIHelper.verticalSpaceSmall,

                // Grid Card Container that contains main column and then rows inside
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Card(
                                color: globals.walletCardColor,
                                child: InkWell(
                                  onTap: () {
                                    print('test');
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text('My Total Investment',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                          UIHelper.verticalSpaceSmall,
                                          model.busy == true
                                              ? Shimmer.fromColors(
                                                  baseColor:
                                                      globals.primaryColor,
                                                  highlightColor: globals.grey,
                                                  child: Text(
                                                    ('0.000'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5,
                                                  ))
                                              : Text(
                                                  model.myTotalInvestmentValue
                                                      .toStringAsFixed(2),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5)
                                        ],
                                      )),
                                )),
                          ),
                          Expanded(
                            flex: 5,
                            child: Card(
                                color: globals.walletCardColor,
                                child: InkWell(
                                    onTap: () {
                                      model.myRewardById(userData);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text('Investment Quantity',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                          UIHelper.verticalSpaceSmall,
                                          model.busy == true
                                              ? Shimmer.fromColors(
                                                  baseColor:
                                                      globals.primaryColor,
                                                  highlightColor: globals.grey,
                                                  child: Text(
                                                    ('0.000'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5,
                                                  ))
                                              : Text(
                                                  model.myToalInvestmentQuantity
                                                      .toStringAsFixed(4),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5)
                                        ],
                                      ),
                                    ))),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Card(
                                color: globals.walletCardColor,
                                child: InkWell(
                                  onTap: () {
                                    model.myReferralsById(userData);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text('My Refferals',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                          UIHelper.verticalSpaceSmall,
                                          model.busy == true
                                              ? Shimmer.fromColors(
                                                  baseColor:
                                                      globals.primaryColor,
                                                  highlightColor: globals.grey,
                                                  child: Text(
                                                    ('0'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5,
                                                  ))
                                              : Text(
                                                  model.myReferrals.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5)
                                        ],
                                      )),
                                )),
                          ),
                          Expanded(
                            flex: 5,
                            child: Card(
                              color: globals.walletCardColor,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                    padding: EdgeInsets.all(25.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text('My Referral Code',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5),
                                        UIHelper.verticalSpaceSmall,
                                        userData.referralCode != null
                                            ? Text(
                                                userData.referralCode
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5)
                                            : Text(''),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Card(
                                color: globals.walletCardColor,
                                child: InkWell(
                                    onTap: () {
                                      model.myRewardById(userData);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text('My Total Reward',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                          UIHelper.verticalSpaceSmall,
                                          model.busy == true
                                              ? Shimmer.fromColors(
                                                  baseColor:
                                                      globals.primaryColor,
                                                  highlightColor: globals.grey,
                                                  child: Text(
                                                    ('0.000'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5,
                                                  ))
                                              : Text(
                                                  model.myTotalReward
                                                      .toStringAsFixed(4),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5)
                                        ],
                                      ),
                                    ))),
                          ),
                          Expanded(
                            flex: 5,
                            child: Card(
                                color: globals.buyPrice.withAlpha(150),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/campaignPayment');
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        children: <Widget>[
                                          UIHelper.horizontalSpaceSmall,
                                          Text('Buy',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                          Text('',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5)
                                        ],
                                      )),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(count: 3)),
    );
  }
}
