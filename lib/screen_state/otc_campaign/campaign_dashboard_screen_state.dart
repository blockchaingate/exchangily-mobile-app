import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignDashboardScreenState extends BaseState {
  final log = getLogger('CampaignDashboardScreenState');

  NavigationService navigationService = locator<NavigationService>();
  CampaignService campaignService = locator<CampaignService>();
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();
  CampaignUserData userData;
  String campaignName = '';
  final List<String> campaignLevelsList = ['Bronze', 'Gold', 'Diamond'];
  final List<int> campaignLevelsColor = [0xff696969, 0xffE6BE8A, 0xffffffff];
  String memberLevel = '';
  int levelTextColor = 0xff696969;
  double myTotalInvestmentValue = 0;
  double myTotalInvestmentQuantity = 0;
  double myTotalReward = 0;
  int myReferrals = 0;

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
                                  Get Member Referrals By MemberID
-------------------------------------------------------------------------------------*/

  myReferralsById(CampaignUserData userData) async {
    setBusy(true);
    await campaignService.getReferralsById(userData).then((res) {
      log.w(res);
      if (res != null) {
        var list = res as List;
        myReferrals = list.length;
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

  myRewardById(CampaignUserData userData) async {
    setBusy(true);
    await campaignService.getRewardById(userData).then((res) {
      if (res != null) {
        int level = res['_body']['myLevel'];
        memberLevel = campaignLevelsList[level];
        levelTextColor = campaignLevelsColor[level];
        log.e(memberLevel);
        log.e(levelTextColor.toString());
        // if i convert and assign the value directly to double variable then i get cast error so this is the solution
        var x = res['_body']['myselfValue'];
        myTotalInvestmentValue = x.toDouble();
        var y = res['_body']['myselfQuantity'];
        myTotalInvestmentQuantity = y.toDouble();
        // navigationService.navigateTo('/campaignRewardDetails');
        calculateMyTotalReward();
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

  // Calculate my total reward
  calculateMyTotalReward() {
    var price = 2;
    myTotalReward = myTotalInvestmentQuantity * price;
    return myTotalReward;
  }

  // Generic Navigate
  navigateByRouteName(String routeName) {
    navigationService.navigateTo(routeName);
  }
}
