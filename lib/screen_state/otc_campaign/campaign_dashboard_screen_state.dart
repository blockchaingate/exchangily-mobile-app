import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/reward.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignDashboardScreenState extends BaseState {
  final log = getLogger('CampaignDashboardScreenState');

  NavigationService navigationService = locator<NavigationService>();
  CampaignService campaignService = locator<CampaignService>();
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();
  CampaignUserData userData;
  String campaignName = '';

  final List<int> memberLevelsColorList = [0xff696969, 0xffE6BE8A, 0xffffffff];
  String memberLevel = '';
  int memberLevelTextColor = 0xff696969;
  double myTotalAssetQuantity = 0;
  double myTotalAssetValue = 0;
  double myTotalTokenHolding = 0;
  double myTotalReward = 0;
  int myTotalReferrals = 0;
  double myTeamsTotalRewards = 0;
  double myTeamsTotalValue = 0;
  BuildContext context;
  double myInvestmentWithoutRewards = 0;
  double myTokensWithoutRewards = 0;
  var myTokens;

  List<CampaignReward> campaignRewardList = [];
  initState() async {
    log.w(' In init');
  }

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

  logout() async {
    await initState();
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

  myProfile(CampaignUserData userData) async {
    setBusy(true);
    await campaignService.getMemberProfile(userData).then((res) {
      if (res != null) {
        log.w(res);
        memberLevel = res['membership'];
        myInvestmentWithoutRewards = res['totalValue'];
        myTokens = res['totalQuantities'];
        //  myTokensWithoutRewards = myTokens;
        assignColorAccordingToMemberLevel(memberLevel);
        //   log.w('mytokens $myTokensWithoutRewards ${res['totalQuantities']}');
      } else {
        log.w(' In myProfile else');
        setBusy(false);
      }
    }).catchError((err) {
      log.e(err);
      setBusy(false);
    });
    setBusy(false);
  }

  assignColorAccordingToMemberLevel(memberLevel) {
    if (memberLevel == 'gold') {
      memberLevelTextColor = 0xffE6BE8A;
    } else if (memberLevel == 'diamond') {
      memberLevelTextColor = 0xffffffff;
    } else {
      memberLevelTextColor = 0xff696969;
    }
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
    await campaignService.getMemberRewardByToken(token).then((response) async {
      if (response != null) {
        myTotalAssetQuantity = 0;
        myTotalTokenHolding = 0;
        myTotalReferrals = 0;
        myTotalReward = 0;
        var res = response['personal'] as List;
        for (int i = 0; i < res.length; i++) {
          var totalRewardValueByLevel = res[i]['totalValue'];
          var totalTokenQuantityByLevel = res[i]['totalQuantities'];
          var totalReferralsByLevel = res[i]['totalAccounts'];
          var totalRewardQuantityByLevel = res[i]['totalRewardQuantities'];
          CampaignReward campaignReward = new CampaignReward(
              level: res[i]['level'],
              totalValue: totalRewardValueByLevel,
              totalQuantities: totalTokenQuantityByLevel,
              totalRewardQuantities: totalRewardQuantityByLevel,
              totalAccounts: totalReferralsByLevel,
              totalRewardNextQuantities: res[i]['totalRewardNextQuantities']);
          campaignRewardList.add(campaignReward);
          // calculating total asset value
          myTotalAssetQuantity = myTotalAssetQuantity + totalRewardValueByLevel;
          myTotalTokenHolding = myTotalTokenHolding +
              totalTokenQuantityByLevel +
              totalRewardQuantityByLevel;
          log.e(myTotalTokenHolding);
          myTotalReferrals = myTotalReferrals + totalReferralsByLevel;
          myTotalReward = myTotalReward + totalRewardQuantityByLevel;
          log.w(campaignReward.toJson());
        }
        myTotalAssetQuantity =
            myTotalAssetQuantity + myInvestmentWithoutRewards;
        await calcMyTotalAsssetValue();
        log.w('Length ${campaignRewardList.length}');
        var ttv = response['teamsTotalValue'];
        // Have to check if team value or reward is zero otherwise it throws type cast error and doesn't execute any statement after that
        if (ttv != 0) {
          myTeamsTotalValue = ttv;
        }
        var ttr = response['teamsRewards'];
        if (ttr != 0) {
          myTeamsTotalRewards = ttr;
        }
      } else {
        log.w('In myReward else, res is null from api');
        setBusy(false);
      }
    }).catchError((err) {
      log.e(err);
      setBusy(false);
    });
    setBusy(false);
  }

  // Calculate my total Asset value
  calcMyTotalAsssetValue() async {
    double exgPrice = await getUsdValue();
    myTotalAssetValue = myTotalAssetQuantity * exgPrice;
    log.e('Test $myTotalAssetQuantity, $exgPrice - $myTotalAssetValue');
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
    await campaignService.getUsdPrices().then((res) {
      if (res != null) {
        log.w(res['data']['EXG']['USD']);
        usdValue = res['data']['EXG']['USD'];
      }
    });
    setBusy(false);
    return usdValue;
  }
}
