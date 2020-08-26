import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_dashboard_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;

class CampaignDashboardScreen extends StatelessWidget {
  CampaignDashboardScreen({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignDashboardScreenState>(
      onModelReady: (model) async {
        model.context = context;

        await model.init();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.onBackButtonPressed();
          return new Future(() => false);
        },
        child: Scaffold(
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
                    title: model.campaignUserData == null
                        ? Text('')
                        : Text(
                            '${model.campaignUserData.email}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                  ),
                  UIHelper.divider,
                  ListTile(
                    trailing: Icon(
                      Icons.event_note,
                      color: globals.green,
                    ),
                    title: Text(
                        AppLocalizations.of(context).readCampaignInstructions),
                    onTap: () {
                      Navigator.pushNamed(context, '/campaignInstructions');
                    },
                  ),
                  UIHelper.divider,
                  ListTile(
                    title: model.campaignUserData != null
                        ? Text(
                            '${AppLocalizations.of(context).myReferralCode} ${model.campaignUserData.referralCode.toString()}',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    color: globals.primaryColor,
                                    decoration: TextDecoration.underline))
                        : Text(''),
                    trailing: Icon(Icons.share, color: globals.white54),
                    onTap: () {
                      Share.share(
                          'Here is my referral code ${model.campaignUserData.referralCode.toString()} for campaign ${model.campaignName}');
                    },
                  ),
                  UIHelper.divider,
                  ListTile(
                    trailing: Icon(
                      Icons.clear_all,
                      color: globals.red,
                    ),
                    title: Text(
                      AppLocalizations.of(context).logout,
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
                              child: model.campaignUserData == null
                                  ? Text('')
                                  : Text(
                                      '${AppLocalizations.of(context).welcome} ${model.campaignUserData.email}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                            ),
                            trailing: InkWell(
                                onTap: () {
                                  model.logout();
                                },
                                child: Text(
                                  AppLocalizations.of(context).logout,
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.end,
                                )))
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceSmall,

/*-------------------------------------------------------------------------------------
                                  My total Asset container with list tiles
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
                              Icons.verified_user,
                              color: globals.primaryColor,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            AppLocalizations.of(context).myTotalAssets,
                            style: TextStyle(letterSpacing: 1.1),
                          ),
                          subtitle: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(AppLocalizations.of(context).quantity,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    UIHelper.horizontalSpaceSmall,
                                    model.busy
                                        ? Shimmer.fromColors(
                                            baseColor: globals.primaryColor,
                                            highlightColor: globals.grey,
                                            child: Text(
                                              ('0.000'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            ))
                                        : Text(
                                            model.myTotalAssetQuantity
                                                .toStringAsFixed(2),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: model.busy
                              ? Shimmer.fromColors(
                                  baseColor: globals.primaryColor,
                                  highlightColor: globals.grey,
                                  child: Text(
                                    ('0.000'),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ))
                              : SizedBox(
                                  width: 120,
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3.0),
                                        child: Icon(Icons.monetization_on,
                                            color: globals.buyPrice, size: 18),
                                      ),
                                      Flexible(
                                        child: Text(model.myTotalAssetValue,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3),
                                      ),
                                    ],
                                  ),
                                ),
                        ),

                        // Level and referral count Row

                        Container(
                          color: globals.primaryColor.withAlpha(155),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context).level,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  UIHelper.horizontalSpaceSmall,
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
                                      : Text(model.memberLevel.toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(model
                                                      .memberLevelTextColor)))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(
                                    Icons.device_hub,
                                    size: 20,
                                    color: globals.exgLogoColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Text(
                                      AppLocalizations.of(context)
                                              .referralCount +
                                          ' ',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                  model.busy
                                      ? Shimmer.fromColors(
                                          baseColor: globals.primaryColor,
                                          highlightColor: globals.grey,
                                          child: Text(
                                            ('0.000'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ))
                                      : Text(model.myTotalReferrals.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
/*-------------------------------------------------------------------------------------
                            My investment and tokens container with list tiles
-------------------------------------------------------------------------------------*/
                  Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            onTap: () {
                              model.getCampaignOrdeList();
                            },
                            dense: false,
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Icon(
                                Icons.confirmation_number,
                                color: globals.exgLogoColor,
                                size: 22,
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(AppLocalizations.of(context).myInvestment,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(color: globals.buyPrice)),
                                Text(
                                  AppLocalizations.of(context).myTokens,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ],
                            ),
                            subtitle: model.busy
                                ? Shimmer.fromColors(
                                    baseColor: globals.primaryColor,
                                    highlightColor: globals.grey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          ('0.000'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                        Text(
                                          ('0.000'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        )
                                      ],
                                    ))
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          '\$${model.myInvestmentValueWithoutRewards}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      model.memberProfile == null
                                          ? Text('')
                                          : Text(
                                              '${model.memberProfile.totalQuantities.toString()}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(model
                                                          .memberLevelTextColor)))
                                    ],
                                  ),
                            trailing: Icon(
                              Icons.navigate_next,
                              color: globals.white54,
                            ))
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
                              model.navigateByRouteName(
                                  '/MyRewardDetails', model.campaignRewardList);
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
                            title: Text(
                                AppLocalizations.of(context).myReferralReward),
                            subtitle: model.busy
                                ? Shimmer.fromColors(
                                    baseColor: globals.primaryColor,
                                    highlightColor: globals.grey,
                                    child: Text(
                                      model.errorMessage,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ))
                                : Text(
                                    model.myReferralReward.toStringAsFixed(2),
                                    style:
                                        Theme.of(context).textTheme.headline5),
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
                            onTap: () {
                              if (!model.busy)
                                model.navigateByRouteName(
                                    '/teamRewardDetails', model.team);
                            },
                            dense: false,
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Icon(
                                Icons.people_outline,
                                color: globals.primaryColor,
                                size: 22,
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(AppLocalizations.of(context)
                                    .teamsTotalValue),
                                Text(
                                  AppLocalizations.of(context).teamReward,
                                  style: Theme.of(context).textTheme.headline5,
                                )
                              ],
                            ),
                            subtitle: model.busy
                                ? Shimmer.fromColors(
                                    baseColor: globals.primaryColor,
                                    highlightColor: globals.grey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          ('0.000'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                        Text(
                                          ('0.000'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        )
                                      ],
                                    ))
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          model.myTeamsTotalValue
                                              .toStringAsFixed(2),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      Text(
                                          model.myTeamsTotalRewards
                                              .toStringAsFixed(2),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(model
                                                      .memberLevelTextColor)))
                                    ],
                                  ),
                            trailing:
                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: <Widget>[
                                //     Padding(
                                //       padding: const EdgeInsets.only(bottom: 3.0),
                                //       child: Text(
                                //         AppLocalizations.of(context).teamReward,
                                //         style: Theme.of(context).textTheme.headline5,
                                //       ),
                                //     ),
                                //     model.busy
                                //         ? Shimmer.fromColors(
                                //             baseColor: globals.primaryColor,
                                //             highlightColor: globals.grey,
                                //             child: Text(
                                //               ('00.00'),
                                //               style:
                                //                   Theme.of(context).textTheme.headline5,
                                //             ))
                                //         : Text(
                                //             model.myTeamsTotalRewards
                                //                 .toStringAsFixed(2),
                                //             style: Theme.of(context)
                                //                 .textTheme
                                //                 .headline5
                                //                 .copyWith(
                                //                     fontWeight: FontWeight.w600,
                                //                     color: Color(
                                //                         model.memberLevelTextColor))),
                                //   ],
                                // ),
                                Icon(
                              Icons.navigate_next,
                              color: globals.white54,
                            )),
                      ],
                    ),
                  ),
                  //   UIHelper.divider,

/*-------------------------------------------------------------------------------------
                                  My Investment container with list tiles
-------------------------------------------------------------------------------------*/
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 5.0),
                  //   child: Column(
                  //     children: <Widget>[
                  //       ListTile(
                  //         onTap: () {},
                  //         dense: false,
                  //         leading: Padding(
                  //           padding: const EdgeInsets.only(top: 5.0),
                  //           child: Icon(
                  //             Icons.verified_user,
                  //             color: globals.primaryColor,
                  //             size: 22,
                  //           ),
                  //         ),
                  //         title: Text(AppLocalizations.of(context)
                  //             .myInvestmentWithoutRewards),
                  //         subtitle: model.busy
                  //             ? Shimmer.fromColors(
                  //                 baseColor: globals.primaryColor,
                  //                 highlightColor: globals.grey,
                  //                 child: Text(
                  //                   ('0.000'),
                  //                   style: Theme.of(context).textTheme.headline5,
                  //                 ))
                  //             : Text(model.myInvestmentWithoutRewards.toString(),
                  //                 style: Theme.of(context).textTheme.headline5),
                  //         // trailing: Icon(
                  //         //   Icons.navigate_next,
                  //         //   color: globals.white54,
                  //         // ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // UIHelper.divider,
/*-------------------------------------------------------------------------------------
                                  My referrals container with list tiles
-------------------------------------------------------------------------------------*/
                  // Container(
                  //   child: Column(
                  //     children: <Widget>[
                  //       ListTile(
                  //         onTap: () {},
                  //         dense: false,
                  //         leading: Padding(
                  //           padding: const EdgeInsets.only(top: 5.0),
                  //           child: Icon(
                  //             Icons.share,
                  //             color: globals.primaryColor,
                  //             size: 22,
                  //           ),
                  //         ),
                  //         title: Text(AppLocalizations.of(context).myReferrals),
                  //         subtitle: model.busy
                  //             ? Shimmer.fromColors(
                  //                 baseColor: globals.primaryColor,
                  //                 highlightColor: globals.grey,
                  //                 child: Text(
                  //                   ('0.000'),
                  //                   style: Theme.of(context).textTheme.headline5,
                  //                 ))
                  //             : Text(model.myTotalReferrals.toString(),
                  //                 style: Theme.of(context).textTheme.headline5),
                  //         // trailing: Icon(
                  //         //   Icons.navigate_next,
                  //         //   color: globals.white54,
                  //         // ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // UIHelper.verticalSpaceLarge,
/*-------------------------------------------------------------------------------------
                          Button Container
-------------------------------------------------------------------------------------*/
                  // Container(
                  //     child: SizedBox(
                  //   width: 150,
                  //   child: RaisedButton(
                  //       padding: EdgeInsets.all(0),
                  //       onPressed: () {
                  //         Navigator.pushNamed(context, '/campaignPayment');
                  //       },
                  //       child: Text(AppLocalizations.of(context).buy,
                  //           style: Theme.of(context).textTheme.headline4)),
                  // ))
                ],
              ),
            ),
            floatingActionButton: Container(
                margin: EdgeInsets.only(right: 10.0),
                width: MediaQuery.of(context).size.width - 50,
                child: RaisedButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pushNamed(context, '/campaignPayment');
                    },
                    child: Text(AppLocalizations.of(context).buy,
                        style: Theme.of(context).textTheme.headline4))),
            bottomNavigationBar: BottomNavBar(count: 2)),
      ),
    );
  }
}
