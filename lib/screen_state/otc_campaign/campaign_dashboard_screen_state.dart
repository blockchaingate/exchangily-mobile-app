import 'dart:async';

import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/order_info.dart';
import 'package:exchangilymobileapp/models/campaign/reward.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignDashboardScreenState extends BaseState {
  final log = getLogger('CampaignDashboardScreenState');

  NavigationService navigationService = locator<NavigationService>();
  CampaignService campaignService = locator<CampaignService>();
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();
  ApiService _apiService = locator<ApiService>();
  CampaignUserData userData;
  String campaignName = '';

  final List<int> memberLevelsColorList = [0xff696969, 0xffE6BE8A, 0xffffffff];
  String memberLevel = '';
  int memberLevelTextColor = 0xff696969;
  double myTotalAssetQuantity = 0.0;
  double myTotalAssetValue = 0.0;
  double myReferralReward = 0.0;
  int myTotalReferrals = 0;
  double myTeamsTotalRewards = 0.0;
  double myTeamsTotalValue = 0.0;
  BuildContext context;
  double myInvestmentValueWithoutRewards = 0.0;
  double myTokensWithoutRewards = 0.0;
  var myTokens;
  Map<String, dynamic> teamValueAndRewardWithLoginToken = {};
  List<OrderInfo> orderInfoList = [];
  List<OrderInfo> orderListFromApi = [];
  List<String> orderStatusList = [];
  List<String> uiOrderStatusList = [];
  List<CampaignReward> campaignRewardList = [];

  List team = [];

/*----------------------------------------------------------------------
                    Init
----------------------------------------------------------------------*/

  init() async {
    await campaignService.getSavedLoginToken().then((token) async {
      if (token != '' || token != null) {
        await myProfile(token);
        await myRewardsByToken();
        await getCampaignName();
      } else {
        navigationService.navigateTo('/campaignLogin');
      }
    });
  }

/*----------------------------------------------------------------------
                    Token check timer
----------------------------------------------------------------------*/

  tokenCheckTimer() {
    Timer.periodic(Duration(minutes: 5), (t) async {
      await campaignService.getSavedLoginToken().then((token) async {
        if (token != '' || token != null) {
          await campaignService
              .getTeamsRewardDetailsByToken(token)
              .then((reward) {
            log.w('get member reward $reward');
            if (reward != null) {
              log.i('timer - login token not expired');
            } else {
              navigationService.navigateTo('/campaignLogin');
              t.cancel();
              log.e('Timer cancel');
            }
          });
        }
      });
    });
  }

/*----------------------------------------------------------------------
                Get campaign name
----------------------------------------------------------------------*/

  getCampaignName() async {
    setBusy(true);
    await campaignService.getCampaignName().then((res) {
      if (res != null) {
        campaignName = res['name'];
        log.w(res);
      } else {
        setBusy(false);
        log.w('In get campaign name else, res is null');
      }
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                        Logout
----------------------------------------------------------------------*/

  logout() async {
    if (userData != null) {
      await campaignUserDatabaseService.deleteUserData(userData.email);
      log.w('User data deleted successfully.');
    } else {
      log.e('Email not found, deleting user from database failed!!!');
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    log.i('Local storage clear');
    navigationService.navigateTo('/campaignLogin');
  }

/*-------------------------------------------------------------------------------------
                                  Get Member Profile By Token
-------------------------------------------------------------------------------------*/

  myProfile(String token) async {
    setBusy(true);
    await campaignService.getMemberProfile(token).then((res) {
      if (res != null) {
        String level = res.membership;
        if (level == 'gold') {
          memberLevelTextColor = 0xffE6BE8A;
          memberLevel = AppLocalizations.of(context).gold;
        } else if (level == 'diamond') {
          memberLevelTextColor = 0xffffffff;
          memberLevel = AppLocalizations.of(context).diamond;
        } else {
          memberLevelTextColor = 0xff696969;
          memberLevel = AppLocalizations.of(context).silver;
        }
        //assignColorAccordingToMemberLevel(level);
        myInvestmentValueWithoutRewards = res.totalValue.toDouble();
        myTokensWithoutRewards = res.totalQuantities.toDouble();
      } else {
        log.w(' In myProfile else');
        setBusy(false);
      }
    }).catchError((err) {
      log.e('myProfile $err');
      setBusy(false);
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                Assign Color According To Member Level
----------------------------------------------------------------------*/

  assignColorAccordingToMemberLevel(memberLevel) {
    log.w('Entry assignColorAccordingToMemberLevel $memberLevel');
    if (memberLevel == 'gold') {
      memberLevelTextColor = 0xffE6BE8A;
      memberLevel = AppLocalizations.of(context).gold;
    } else if (memberLevel == 'diamond') {
      memberLevelTextColor = 0xffffffff;
      memberLevel = AppLocalizations.of(context).diamond;
    } else {
      memberLevelTextColor = 0xff696969;
      memberLevel = AppLocalizations.of(context).silver;
    }
    log.e('Exit assignColorAccordingToMemberLevel $memberLevel');
  }

/*----------------------------------------------------------------------
                Get Campaign Order List
----------------------------------------------------------------------*/
  getCampaignOrdeList() async {
    setBusy(true);
    // await getExgWalletAddr();
    await campaignService
        .getUserDataFromDatabase()
        .then((res) => userData = res);
    if (userData == null) return false;
    await campaignService.getOrdersById(userData.id).then((orderList) {
      if (orderList != null) {
        orderInfoList = [];
        orderListFromApi = [];
        orderStatusList = [];
        orderListFromApi = orderList;

        log.w(orderListFromApi.length);
        orderStatusList = [
          "",
          AppLocalizations.of(context).waiting,
          AppLocalizations.of(context).paid,
          AppLocalizations.of(context).paymentReceived,
          AppLocalizations.of(context).failed,
          AppLocalizations.of(context).orderCancelled,
        ];

        for (int i = 0; i < orderListFromApi.length; i++) {
          var status = orderListFromApi[i].status;

          if (status == "3") {
            addOrderInTheList(i, int.parse(status));
          } else if (status == "4") {
            addOrderInTheList(i, int.parse(status));
          } else if (status == "5") {
            addOrderInTheList(i, int.parse(status));
          }
        }
        navigateByRouteName('/campaignOrderDetails', orderInfoList);
      } else {
        log.e('Api result null');
        setErrorMessage(AppLocalizations.of(context).loadOrdersFailed);
        setBusy(false);
      }
    }).catchError((err) {
      log.e('getCampaignOrdeList $err');
      setBusy(false);
    });
    setBusy(false);
  }

  // Add order in the order list
  addOrderInTheList(int i, int status) {
    String formattedDate = formatStringDate(orderListFromApi[i].dateCreated);
    // needed to declare orderListFromApi globally due to this funtion to keep the code DRY
    orderListFromApi[i].dateCreated = formattedDate;
    orderListFromApi[i].status = orderStatusList[status];
    orderInfoList.add(orderListFromApi[i]);
  }

/*-------------------------------------------------------------------------------------
                                  Get Member Referrals By MemberID
-------------------------------------------------------------------------------------*/

  myReferralsById(CampaignUserData userData) async {
    setBusy(true);
    await campaignService.getReferralsById(userData).then((res) {
      log.w(res);
      if (res != null) {
        var list = res as List;
        myTotalReferrals = list.length;
        log.e(list.length);
        // navigationService.navigateTo('/campaignRefferalDetails');
      } else {
        log.w(' In myreferral else');
        setBusy(false);
      }
    }).catchError((err) {
      log.e(err);
      setBusy(false);
    });
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                                  Get Member Reward By MemberID
-------------------------------------------------------------------------------------*/

  // myRewardsById(CampaignUserData userData) async {
  //   if (userData == null) return false;
  //   log.e(userData.id);
  //   setBusy(true);
  //   setErrorMessage('fetching your rewards');
  //   await campaignService.getRewardById(userData).then((res) {
  //     if (res != null) {
  //       // if i convert and assign the value directly to double variable then i get cast error so this is the solution
  //       var x = res['_body']['myselfValue'];
  //       myTotalAssetValue = x.toDouble();
  //       var y = res['_body']['myselfQuantity'];
  //       myTotalTokenHolding = y.toDouble();
  //       // navigationService.navigateTo('/campaignRewardDetails');
  //       //calculateMyTotalReward();
  //     } else {
  //       log.w('In myReward else, res is null from api');
  //       setBusy(false);
  //     }
  //   }).catchError((err) {
  //     log.e(err);
  //     setBusy(false);
  //   });
  //   setBusy(false);
  // }

/*-------------------------------------------------------------------------------------
                                  Get Member Reward By Token
-------------------------------------------------------------------------------------*/

  myRewardsByToken() async {
    setBusy(true);
    setErrorMessage('fetching your rewards');
    String token = await campaignService.getSavedLoginToken();
    await campaignService.getMemberRewardByToken(token).then((res) async {
      if (res != null) {
        campaignRewardList = res;
        // var res = response['personal'] as List;

        for (int i = 0; i < res.length; i++) {
          // double totalValueByLevel = campaignRewardList[i].totalValue;
          // double totalTokenQuantityByLevel =
          //     campaignRewardList[i].totalQuantities;
          int totalReferralsByLevel = campaignRewardList[i].totalAccounts;
          double totalRewardQuantityByLevel =
              campaignRewardList[i].totalRewardQuantities;
          // int level = campaignRewardList[i].level;

          // // calculating total asset quantity
          myTotalAssetQuantity =
              myTotalAssetQuantity + totalRewardQuantityByLevel;

          // // calculating total referrals
          myTotalReferrals = myTotalReferrals + totalReferralsByLevel;

          // Calling team reward
          await getTotalTeamReward(token);
          // calculating total reward
          myReferralReward = myReferralReward + totalRewardQuantityByLevel;
        }
        myTotalAssetQuantity =
            myTotalAssetQuantity + myTokensWithoutRewards + myTeamsTotalRewards;
        await calcMyTotalAsssetValue();
      } else {
        log.e('Campaign reward result in else block $res');
        log.w('In myReward else, res is null from api');
        if (res == null) {
          navigationService.navigateTo('/campaignLogin');
        }
        setBusy(false);
      }
    }).catchError((err) {
      log.e('myRewardsByToken catch $err');
      setBusy(false);
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                Get total team value and reward
----------------------------------------------------------------------*/

  getTotalTeamReward(token) async {
    await campaignService.getTotalTeamsRewardByToken(token).then((res) {
      myTeamsTotalValue = res['teamsTotalValue'].toDouble();
      myTeamsTotalRewards = res['teamsRewards'].toDouble();

      log.e(
          'personal reward view data $myTeamsTotalRewards -- $myTeamsTotalValue');
      team = res['team'];

      // double totalValue = res['team']['totalValue'].toDouble();
      // log.w('team totalValue $totalValue');
      // double totalQuantity = res['team']['totalQuantity'].toDouble();
      // log.w('team totalQuantity $totalQuantity');
      // int members = res['team']['members'].length;
      // log.w('team members $members');
      // double percentage = res['team']['percentage'].toDouble();
      // log.w('team percentage $percentage');

      // teamValueAndRewardWithLoginToken = {
      //   "totalValue": totalValue,
      //   "totalQuantity": totalQuantity,
      //   "members": members,
      //   'percentage': percentage,
      //   "token": token
      // };

      log.w('reward view data ${team[0]}');
    });
  }

/*----------------------------------------------------------------------
                Calculate my total Asset value
----------------------------------------------------------------------*/

  calcMyTotalAsssetValue() async {
    log.e('calcMyTotalAsssetValue');
    double exgPrice = await getUsdValue();
    myTotalAssetValue = myTotalAssetQuantity * exgPrice;
    log.e(
        'calcMyTotalAsssetValue $myTotalAssetQuantity, $exgPrice - $myTotalAssetValue');
    return myTotalAssetValue;
  }

  // Generic Navigate
  navigateByRouteName(String routeName, args) async {
    await navigationService.navigateTo(routeName, arguments: args);
  }

/*-------------------------------------------------------------------------------------
      Get Usd Price for token and currencies like btc, exg, rmb, cad, usdt
-------------------------------------------------------------------------------------*/

  Future<double> getUsdValue() async {
    setBusy(true);
    double usdValue = 0;
    await _apiService.getCoinCurrencyUsdPrice().then((res) {
      if (res != null) {
        log.w(res['data']['EXG']['USD']);
        usdValue = res['data']['EXG']['USD'];
      }
    });
    setBusy(false);
    return usdValue;
  }
}
