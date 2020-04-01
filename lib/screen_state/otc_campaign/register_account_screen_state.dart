import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/user.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:flutter/cupertino.dart';

class CampaignRegisterAccountScreenState extends BaseState {
  final log = getLogger('RegisterScreenState');
  CampaignService campaignService = locator<CampaignService>();
  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();
  BuildContext context;
  bool passwordMatch;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final referralCodeTextController = TextEditingController();
  User user;
  bool isPasswordTextVisible = false;
  CampaignUserData userData;

  Future<CampaignUserData> register(User user) async {
    setBusy(true);
    await campaignService
        .registerAccount(user, referralCodeTextController.text)
        .then((res) async {
      // String loginToken = res['token'];
      String error = res['message'];
      if (res != null && (error == null || error == '')) {
        sharedService.alertResponseWithPath(
            'Registration Successful',
            'Please check your email to activate your account',
            '/campaignLogin');
        // await campaignService.saveCampaignUserDataLocally(loginToken, userData);
        // navigationService.navigateTo('/campaignDashboard', arguments: userData);
        setBusy(false);
      } else {
        setErrorMessage(error);
        setBusy(false);
      }
    }).catchError((err) {
      setBusy(false);
      log.e(err);
    });
    return userData;
  }

  // Check fields before calling the api
  checkInputValues() {
    setBusy(true);
    matchPassword();
    if (emailTextController.text.isEmpty) {
      setErrorMessage('Please enter your email address');
    } else if (passwordTextController.text.isEmpty) {
      setErrorMessage('Please fill your password');
    } else if (confirmPasswordTextController.text.isEmpty) {
      setErrorMessage('Confirm password field is empty');
    } else if (!passwordMatch) {
      setErrorMessage('Both passwords should match');
    } else {
      setErrorMessage('');
      user = new User(
          email: emailTextController.text,
          password: passwordTextController.text);
      register(user);
    }
    setBusy(false);
  }

  matchPassword() {
    passwordTextController.text == confirmPasswordTextController.text
        ? passwordMatch = true
        : passwordMatch = false;
  }

  showPasswordText(bool value) {
    setBusy(true);
    isPasswordTextVisible = value;
    setBusy(false);
  }
}
