import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class CampaignDashboardScreen extends StatelessWidget {
  final CampaignUserData userData;
  CampaignDashboardScreen({Key key, this.userData}) : super(key: key);

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignDashboardScreenState>(
      onModelReady: (model) {
        if (userData == null) {
          model.initState();
        }
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
                  automaticallyImplyLeading: false,
                  title: Center(child: Text('Campaign Name')),
                ),
                ListTile(
                  title: Text(
                    '${userData.email}',
                    style: Theme.of(context).textTheme.headline4,
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
                  UIHelper.horizontalSpaceMedium,
                  // Header of the page container

                  Container(
                    padding: EdgeInsets.all(15.0),
                    child:
                        // First row that contains user email, menu button and logout button
                        Row(
                      children: <Widget>[
                        // Burger button and user email row
                        Row(children: [
                          IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: globals.primaryColor,
                              ),
                              onPressed: () {
                                _scaffoldKey.currentState.openDrawer();
                              }),
                          Center(
                              child: Text('Welcome ${userData.email}',
                                  style:
                                      Theme.of(context).textTheme.headline5)),
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
                                  style: Theme.of(context).textTheme.bodyText2,
                                  textAlign: TextAlign.end,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  UIHelper.horizontalSpaceSmall,
                  // Level container
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Center(
                        child: Text('Level: Gold',
                            style: Theme.of(context).textTheme.headline5)),
                  ),
                  UIHelper.horizontalSpaceLarge,
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
                                          UIHelper.horizontalSpaceSmall,
                                          Text('2115',
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
                                      Navigator.pushNamed(
                                          context, '/campaignRewardDetails');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text('My Total Reward',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                          UIHelper.horizontalSpaceSmall,
                                          Text('105',
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
                                    Navigator.pushNamed(
                                        context, '/campaignRefferalDetails');
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text('My Refferals',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                          UIHelper.horizontalSpaceSmall,
                                          Text('15',
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
                                  Navigator.pushNamed(
                                      context, '/campaignRefferalDetails');
                                },
                                child: Container(
                                    padding: EdgeInsets.all(25.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text('My Referral Code',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5),
                                        UIHelper.horizontalSpaceSmall,
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
                      )
                    ],
                  ))
                ]),
          ),
          bottomNavigationBar: BottomNavBar(count: 3)),
    );
  }
}
