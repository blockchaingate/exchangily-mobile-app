import 'dart:async';

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
    setErrorMessage('Checking login details');
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

          Timer(Duration(seconds: 2), () {
            navigationService.navigateTo('/campaignDashboard',
                arguments: userData);
            setBusy(false);
            setErrorMessage('');
          });
        } else {
          setBusy(false);
          setErrorMessage('');
          setErrorMessage('Entry does not found in database');
        }
      }).catchError((err) {
        setErrorMessage('');
        log.w('Fetch user from database failed');
        setBusy(false);
      });
    } else {
      setErrorMessage('');
      log.w('already in the login');
      setBusy(false);
    }
    setBusy(false);
  }

// Login

  Future login(User user) async {
    setBusy(true);
    await campaignService.login(user).then((res) async {
      // json deconde in campaign api let us see the response then its properties
      if (res == null) {
        setErrorMessage('Server error, Please try again later.');
        return false;
      }
      String error = res['message'];
      if (res != null && (error == null || error == '')) {
        userData = CampaignUserData.fromJson(res);
        log.i('Test user data object ${userData.toJson()}');
        await campaignService.saveCampaignUserDataLocally(userData);
        navigationService.navigateTo('/campaignDashboard', arguments: userData);
        setBusy(false);
        return '';
      } else {
        setErrorMessage(error);
        log.e('In else ${res['message']}');
        setBusy(false);
        return '';
      }
    }).catchError((err) {
      setBusy(false);
      setErrorMessage('');
      log.e('In catch $err');
    });
  }

// Check fields before calling the api
  checkCredentials() {
    setBusy(true);

    if (emailTextController.text.isEmpty) {
      setErrorMessage('Please enter your login email address');
    } else if (passwordTextController.text.isEmpty) {
      setErrorMessage('Please enter your password');
    } else {
      user = new User(
          email: emailTextController.text,
          password: passwordTextController.text);
      login(user);
    }
    setBusy(false);
  }

// Save user data locally
  saveUserDataLocally(String loginToken, CampaignUserData userData) async {
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
