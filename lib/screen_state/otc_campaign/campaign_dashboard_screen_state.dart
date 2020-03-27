import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignDashboardScreenState extends BaseState {
  final log = getLogger('CampaignDashboardScreenState');
  NavigationService navigationService = locator<NavigationService>();
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();
  CampaignUserData userData;

  // To check if user already logged in
  initState() async {
    log.w(' In init');
    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString('loginToken');
    if (loginToken != '' && loginToken != null) {
      await campaignUserDatabaseService
          .getUserDataByToken(loginToken)
          .then((res) {
        userData = res;
      });
    } else {
      log.e('Token not found');
    }
    setBusy(false);
  }

  Future logout() async {
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
}
