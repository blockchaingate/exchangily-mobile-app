/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreatePasswordViewModel extends BaseViewModel {
  final WalletService _walletService = locator<WalletService>();
  final NavigationService navigationService = locator<NavigationService>();
  final sharedService = locator<SharedService>();

  //List<WalletInfo> _walletInfo;
  final log = getLogger('CreatePasswordViewModel');
  bool checkPasswordConditions = false;
  bool passwordMatch = false;
  bool checkConfirmPasswordConditions = false;
  String randomMnemonicFromRoute = '';
  BuildContext context;
  String password = '';
  String confirmPassword = '';
  String errorMessage = '';
  Pattern pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[`~!@#\$%\^&*\(\)-_\+\=\{\[\}\]]).{8,}$';

  FocusNode passFocus = FocusNode();
  FocusNode confirmPassFocus = FocusNode();
  TextEditingController passTextController = TextEditingController();
  TextEditingController confirmPassTextController = TextEditingController();
  WalletService walletService = locator<WalletService>();
  final coreWalletDatabaseService = locator<CoreWalletDatabaseService>();
  bool isShowPassword = false;

  togglePassword() {
    setBusyForObject(isShowPassword, true);
    isShowPassword = !isShowPassword;
    setBusyForObject(isShowPassword, false);
  }

  Future createOfflineWallets() async {
    setBusy(true);
    isShowPassword = false;
    // await _vaultService.secureMnemonic(
    //     passTextController.text, randomMnemonicFromRoute);
    await _walletService
        .createOfflineWalletsV2(
            randomMnemonicFromRoute, passTextController.text)
        .then((data) {
      navigationService
          .navigateUsingPushNamedAndRemoveUntil(DashboardViewRoute);
      randomMnemonicFromRoute = '';
      passTextController.text = '';
      confirmPassTextController.text = '';
    }).catchError((onError) {
      passwordMatch = false;
      password = '';
      confirmPassword = '';
      errorMessage = onError.toString();
      //AppLocalizations.of(context).somethingWentWrong;
      log.e(onError);
      setBusy(false);
    });
    setBusy(false);
  }

/* ---------------------------------------------------
                      Validate Pass
    -------------------------------------------------- */
  bool checkPassword(String pass) {
    setBusy(true);
    password = pass;
    var res = RegexValidator(pattern).isValid(password);
    checkPasswordConditions = res;
    if (confirmPassTextController.text.isNotEmpty) {
      password == confirmPassword
          ? passwordMatch = true
          : passwordMatch = false;
    }
    if (passwordMatch) errorMessage = '';
    setBusy(false);
    return checkPasswordConditions;
  }

  bool checkConfirmPassword(String confirmPass) {
    setBusy(true);
    confirmPassword = confirmPass;
    var res = RegexValidator(pattern).isValid(confirmPass);
    checkConfirmPasswordConditions = res;
    password == confirmPass ? passwordMatch = true : passwordMatch = false;
    if (passwordMatch) errorMessage = '';
    setBusy(false);
    return checkConfirmPasswordConditions;
  }

  Future validatePassword() async {
    setBusy(true);
    RegExp regex = RegExp(pattern);
    String pass = passTextController.text;
    String confirmPass = confirmPassTextController.text;
    if (pass.isEmpty) {
      password = '';
      confirmPassword = '';
      checkPasswordConditions = false;
      checkConfirmPasswordConditions = false;
      sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).emptyPassword,
          subtitle: AppLocalizations.of(context).pleaseFillBothPasswordFields);

      setBusy(false);
      return;
    } else {
      if (!regex.hasMatch(pass)) {
        sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).passwordConditionsMismatch,
          subtitle: AppLocalizations.of(context).passwordConditions,
        );

        setBusy(false);
        return;
      } else if (pass != confirmPass) {
        sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).passwordMismatch,
          subtitle: AppLocalizations.of(context).passwordRetype,
        );
        setBusy(false);
        return;
      } else {
        await createOfflineWallets().catchError((err) {
          passTextController.text = '';
          confirmPassTextController.text = '';
          passwordMatch = false;
          setBusy(false);
        });
        passTextController.text = '';
        confirmPassTextController.text = '';
        setBusy(false);
      }
    }
    setBusy(false);
  }
}
