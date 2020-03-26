import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignDashboardScreenState extends BaseState {
  NavigationService navigationService = locator<NavigationService>();

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.clear();
    navigationService.navigateTo('/campaignLogin');
  }
}
