import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:exchangilymobileapp/models/campaign/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignLoginScreenState extends BaseState {
  final log = getLogger('RegisterScreenState');
  BuildContext context;
  String errorMessage;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  CampaignService campaignService = locator<CampaignService>();
  NavigationService navigationService = locator<NavigationService>();

  // To check if user already logged in
  init() async {
    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString('loginToken');
    var referralCode = prefs.getString('referralCode');
    var email = prefs.getString('email');
    if (loginToken != '' && loginToken != null) {
      var passDataUsingRoute = {
        "token": loginToken,
        "referralCode": referralCode,
        "email": email
      };
      setBusy(false);
      navigationService.navigateTo('/campaignDashboard',
          arguments: passDataUsingRoute);
    } else {
      log.w('already in the login');
      // navigationService.navigateTo('/campaignLogin');
      setBusy(false);
    }
    setBusy(false);
  }

  Future getLogin() async {
    setBusy(true);
    // setState(ViewState.Busy);
    User user = new User(
        email: emailTextController.text, password: passwordTextController.text);
    log.w('User ${user.toJson()}');
    await campaignService.login(user).then((response) {
      // json deconde in campaign api let us see the response then its properties
      // log.w(response["token"]);
      String loginToken = response['token'];
      String email = response['email'];
      String referralCode = response['appUser']['referralCode'];
      saveUserDataLocally(loginToken, referralCode, email);
      var passDataUsingRoute = {
        "token": loginToken,
        "referralCode": referralCode,
        "email": email
      };
      log.w(passDataUsingRoute);
      navigationService.navigateTo('/campaignDashboard',
          arguments: passDataUsingRoute);
      setBusy(false);
    }).catchError((err) {
      setBusy(false);
    });
  }

  saveUserDataLocally(
      String loginToken, String referralCode, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginToken', loginToken);
    prefs.setString('referralCode', referralCode);
    prefs.setString('email', email);
  }
}
