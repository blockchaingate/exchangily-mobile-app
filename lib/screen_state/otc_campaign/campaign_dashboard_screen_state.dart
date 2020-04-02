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
  String memberLevel = '';
  double myTotalInvestmentValue = 0;
  double myToalInvestmentQuantity = 0;
  double myTotalReward = 0;
  int myReferrals = 0;

  // To check if user already logged in
  initState() async {
    log.w(' In init');
    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString('loginToken');
    if (loginToken != '' && loginToken != null) {
      await campaignUserDatabaseService
          .getUserDataByToken(loginToken)
          .then((res) async {
        if (res != null) {
          userData = res;
        } else {
          log.e('User data null from database');
          navigationService.navigateTo('campaignLogin');
        }
      });
    } else {
      log.e('Token not found');
    }
    setBusy(false);
  }

  getCampaignName() async {
    setBusy(true);
    await campaignService.getCampaignName().then((res) {
      campaignName = res['name'];
      log.w(res);
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
      int level = res['_body']['myLevel'];
      memberLevel = campaignLevelsList[level];
      log.e(memberLevel);
      // if i convert and assign the value directly to double variable then i get cast error so this is the solution
      var x = res['_body']['myselfValue'];
      myTotalInvestmentValue = x.toDouble();
      var y = res['_body']['myselfQuantity'];
      myToalInvestmentQuantity = y.toDouble();
      // navigationService.navigateTo('/campaignRewardDetails');
      calculateMyTotalReward();
    }).catchError((err) {
      log.e(err);
      setBusy(false);
    });
    setBusy(false);
  }

  // Calculate my total reward
  calculateMyTotalReward() {
    var price = 2;
    myTotalReward = myToalInvestmentQuantity * price;
    return myTotalReward;
  }
}
