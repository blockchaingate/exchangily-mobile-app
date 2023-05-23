import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/models/campaign/user.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/globals.dart' as globals;

class CampaignLoginScreenState extends BaseState {
  final log = getLogger('LoginScreenState');
  late BuildContext context;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final passwordResetEmailTextController = TextEditingController();
  CampaignService? campaignService = locator<CampaignService>();
  CampaignUserDatabaseService? campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();
  NavigationService? navigationService = locator<NavigationService>();
  SharedService? sharedService = locator<SharedService>();
  late User user;
  CampaignUserData? userData;
  bool isPasswordTextVisible = false;

  bool isLogging = false;
  bool isPasswordReset = false;
  String passwordResetMessage = '';

  // To check if user already logged in

  // INIT
  init() async {
    setBusy(true);
    setErrorMessage(AppLocalizations.of(context)!.checkingAccountDetails);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString('loginToken');
    log.w('login token $loginToken');
    if (loginToken != '' && loginToken != null) {
      await campaignService!.getMemberProfile(loginToken).then((res) async {
        if (res != null) {
          await campaignUserDatabaseService!
              .getUserDataByToken(loginToken)
              .then((res) {
            if (res != null) {
              userData = res;
              navigationService!.navigateUsingpopAndPushedNamed(
                  '/campaignDashboard',
                  arguments: userData);
              setBusy(false);
              setErrorMessage('');
            }
          });
        } else if (res == null) {
          setBusy(false);
          setErrorMessage('Session Expired');
        }
      }).catchError((err) {
        log.e('getMemberRewardByToken catch');
        setErrorMessage(AppLocalizations.of(context)!.serverError);
        setBusy(false);
      });
    } else {
      setErrorMessage('');
      log.w('already in the login');
    }
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                                  Password Reset
-------------------------------------------------------------------------------------*/
  resetPassword() async {
    Alert(
        style: AlertStyle(
            animationType: AnimationType.grow,
            isOverlayTapDismiss: true,
            backgroundColor: globals.walletCardColor,
            descStyle: Theme.of(context).textTheme.bodyLarge!,
            titleStyle: Theme.of(context).textTheme.headlineSmall!),
        context: context,
        title: AppLocalizations.of(context)!.pleaseEnterYourEmailAddress,
        closeFunction: () {
          Navigator.of(context, rootNavigator: true).pop();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        content: TextField(
          decoration: InputDecoration(
            icon: Icon(
              Icons.alternate_email,
              color: globals.primaryColor,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            color: globals.white,
          ),
          controller: passwordResetEmailTextController,
          obscureText: false,
        ),
        buttons: [
          // Confirm button
          DialogButton(
            color: globals.primaryColor,
            onPressed: () async {
              await campaignService!
                  .resetPassword(passwordResetEmailTextController.text)
                  .then((res) {
                if (res != null) {
                  String? message = res['message'];
                  if (message != '' && message != null) {
                    log.e('reset pass message $message');

                    sharedService!.sharedSimpleNotification(
                      AppLocalizations.of(context)!.passwordResetError,
                      subtitle: AppLocalizations.of(context)!
                          .pleaseEnterTheCorrectEmail,
                    );
                  } else {
                    log.w('reset password success $res');

                    sharedService!.sharedSimpleNotification(
                        AppLocalizations.of(context)!.passwordReset,
                        subtitle: AppLocalizations.of(context)!
                            .resetPasswordEmailInstruction,
                        isError: false);
                  }
                }
              }).catchError((err) => log.e('reset password $err'));
              Navigator.of(context, rootNavigator: true).pop();
              passwordResetEmailTextController.text = '';

              FocusScope.of(context).requestFocus(FocusNode());
              setBusy(false);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 7),
              // model.busy is not working here and same reason that it does not show the error when desc field is empty
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          // Cancel button
          DialogButton(
            color: globals.primaryColor,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              passwordResetEmailTextController.text = '';
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ]).show();
  }

/*-------------------------------------------------------------------------------------
                                  Login
-------------------------------------------------------------------------------------*/
  login(User user) async {
    setBusy(true);
    await campaignService!.login(user).then((res) async {
      // json deconde in campaign api let us see the response then its properties
      if (res == null) {
        setErrorMessage(AppLocalizations.of(context)!.serverError);
        return false;
      }
      String? error = res['message'];
      if (res != null && (error == null || error == '')) {
        userData = CampaignUserData.fromJson(res);
        log.i('Test user data object ${userData!.toJson()}');
        // navigationService.navigateTo('/campaignDashboard', arguments: userData);
        await campaignService!.saveCampaignUserDataInLocalDatabase(userData!);
        navigationService!.navigateTo('/campaignDashboard');
      } else {
        setErrorMessage(error);
        log.e('In else ${res['message']}');
      }
    }).catchError((err) {
      setBusy(false);
      setErrorMessage('');
      log.e('In catch $err');
    });
    setBusy(false);
  }

// Check fields before calling the api
  checkCredentials() {
    setBusy(true);
    isLogging = true;
    setErrorMessage(AppLocalizations.of(context)!.checkingCredentials);
    if (emailTextController.text.isEmpty) {
      setErrorMessage(AppLocalizations.of(context)!.pleaseEnterYourEmailAddress);
    } else if (passwordTextController.text.isEmpty) {
      setErrorMessage(AppLocalizations.of(context)!.pleaseFillYourPassword);
    } else {
      user = User(
          email: emailTextController.text,
          password: passwordTextController.text);
      login(user);
    }
    setBusy(false);
    isLogging = false;
  }

// Save user data locally
  saveUserDataLocally(String loginToken, CampaignUserData userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginToken', loginToken);
    await campaignUserDatabaseService!.insert(userData);
    await campaignUserDatabaseService!
        .getUserDataByToken(loginToken)
        .then((value) => log.w(value));
  }

  deleteDb() async {
    await campaignUserDatabaseService!
        .deleteDb()
        .then((value) => log.w('delete finish $value'));
  }

/*----------------------------------------------------------------------
                    onBackButtonPressed
----------------------------------------------------------------------*/
  onBackButtonPressed() async {
    await sharedService!.onBackButtonPressed('/dashboard');
  }
}
