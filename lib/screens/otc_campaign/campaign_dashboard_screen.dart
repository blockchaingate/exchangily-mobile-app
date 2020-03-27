import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class CampaignDashboardScreen extends StatelessWidget {
  final CampaignUserData userData;
  const CampaignDashboardScreen({Key key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignDashboardScreenState>(
      onModelReady: (model) {
        if (userData == null) {
          model.initState();
        }
      },
      builder: (context, model, child) => Scaffold(
          body: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  UIHelper.horizontalSpaceLarge,
                  // Header of the page container
                  Container(
                    color: globals.primaryColor,
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Center(
                              child: Text('Welcome ${userData.email}',
                                  style:
                                      Theme.of(context).textTheme.headline4)),
                        ),
                        Expanded(
                          flex: 2,
                          child: FlatButton(
                              onPressed: () {
                                model.logout();
                              },
                              child: Text(
                                'Logout',
                                style: Theme.of(context).textTheme.headline5,
                              )),
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
                                        userData != null
                                            ? Text(userData.referralCode,
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
                          Expanded(
                            flex: 5,
                            child: Card(
                                color: globals.walletCardColor,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/campaignInstructions');
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        children: <Widget>[
                                          UIHelper.horizontalSpaceSmall,
                                          Text('Read Instructions',
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
