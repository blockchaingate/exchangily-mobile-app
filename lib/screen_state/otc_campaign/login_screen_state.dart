import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:exchangilymobileapp/models/campaign/user.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignLoginScreenState extends BaseState {
  final log = getLogger('LoginScreenState');
  BuildContext context;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  CampaignService campaignService = locator<CampaignService>();
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();
  NavigationService navigationService = locator<NavigationService>();
  bool error = false;
  User user;
  CampaignUserData userData;
  bool isPasswordTextVisible = false;

  // To check if user already logged in
  init() async {
    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString('loginToken');
    log.w('login token $loginToken');
    if (loginToken != '' && loginToken != null) {
      await campaignUserDatabaseService
          .getUserDataByToken(loginToken)
          .then((res) {
        log.w('database response $res');
        if (res != null) {
          userData = res;
          setBusy(false);
          navigationService.navigateTo('/campaignDashboard',
              arguments: userData);
        } else {
          setErrorMessage('Entry does not found in database');
        }
      });
    } else {
      log.w('already in the login');
      setBusy(false);
    }
    setBusy(false);
  }

  Future login(User user) async {
    setBusy(true);
    await campaignService.login(user).then((response) async {
      // json deconde in campaign api let us see the response then its properties
      String loginToken = response['token'];
      if (response != null) {
        userData = new CampaignUserData(
            email: response['email'],
            token: loginToken,
            referralCode: response['appUser']['referralCode'],
            dateCreated: response['appUser']['dateCreated'],
            memberId: response['appUser']['userId']);
        log.i('Test user data object ${userData.referralCode}');
        await saveUserDataLocally(loginToken);
        navigationService.navigateTo('/campaignDashboard', arguments: userData);
        setBusy(false);
        return '';
      } else {
        error = true;
        setErrorMessage(response['message']);
        log.e('In else ${response['message']}');
        setBusy(false);
        return '';
      }
    }).catchError((err) {
      setBusy(false);
    });
  }

// Check fields before calling the api
  checkCredentials() {
    setBusy(true);
    user = new User(
        email: emailTextController.text, password: passwordTextController.text);
    if (user.email.isEmpty || user.password.isEmpty) {
      error = true;
      setErrorMessage('Please fill all fields');
    } else {
      login(user);
    }
    setBusy(false);
  }

// Save user data locally
  saveUserDataLocally(String loginToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginToken', loginToken);
    await campaignUserDatabaseService.insert(userData);
    await campaignUserDatabaseService
        .getUserDataByToken(loginToken)
        .then((value) => log.w(value));
  }

  deleteDb() async {
    await campaignUserDatabaseService
        .deleteDb()
        .then((value) => log.w('delete finish $value'));
  }
}
