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

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:flutter/material.dart';

class CreatePasswordScreenState extends BaseState {
  final WalletService _walletService = locator<WalletService>();
  final VaultService _vaultService = locator<VaultService>();

  List<WalletInfo> _walletInfo;
  final log = getLogger('CreatePasswordScreenState');
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
  TextEditingController passTextController = TextEditingController();
  TextEditingController confirmPassTextController = TextEditingController();
  WalletService walletService = locator<WalletService>();

/* ---------------------------------------------------
                    Create Offline Wallets
    -------------------------------------------------- */

  Future createOfflineWallets() async {
    setState(ViewState.Busy);
    await _vaultService.secureMnemonic(
        context, passTextController.text, randomMnemonicFromRoute);
    await _walletService
        .createOfflineWallets(randomMnemonicFromRoute)
        .then((data) {
      _walletInfo = data;
      Navigator.pushNamed(context, '/dashboard');
      randomMnemonicFromRoute = '';
    }).catchError((onError) {
      errorMessage = AppLocalizations.of(context).somethingWentWrong;
      log.e(onError);
      setState(ViewState.Idle);
    });
    setState(ViewState.Idle);
  }

/* ---------------------------------------------------
                      Validate Pass
    -------------------------------------------------- */
  bool checkPassword(String pass) {
    password = pass;
    var res = RegexValidator(pattern).isValid(password);
    checkPasswordConditions = res;
    return checkPasswordConditions;
  }

  bool checkConfirmPassword(String confirmPass) {
    confirmPassword = confirmPass;
    var res = RegexValidator(pattern).isValid(confirmPass);
    checkConfirmPasswordConditions = res;
    password == confirmPass ? passwordMatch = true : passwordMatch = false;
    return checkConfirmPasswordConditions;
  }

  Future validatePassword() async {
    setState(ViewState.Busy);
    RegExp regex = new RegExp(pattern);
    String pass = passTextController.text;
    String confirmPass = confirmPassTextController.text;
    if (pass.isEmpty) {
      password = '';
      confirmPassword = '';
      checkPasswordConditions = false;
      checkConfirmPasswordConditions = false;
      _walletService.showInfoFlushbar(
          AppLocalizations.of(context).emptyPassword,
          AppLocalizations.of(context).pleaseFillBothPasswordFields,
          Icons.cancel,
          Colors.red,
          context);
      setState(ViewState.Idle);
      return;
    } else {
      if (!regex.hasMatch(pass)) {
        password = '';
        confirmPassword = '';
        checkPasswordConditions = false;
        checkConfirmPasswordConditions = false;
        _walletService.showInfoFlushbar(
            AppLocalizations.of(context).passwordConditionsMismatch,
            AppLocalizations.of(context).passwordConditions,
            Icons.cancel,
            Colors.red,
            context);
        setState(ViewState.Idle);
        return;
      } else if (pass != confirmPass) {
        password = '';
        confirmPassword = '';
        checkPasswordConditions = false;
        checkConfirmPasswordConditions = false;
        _walletService.showInfoFlushbar(
            AppLocalizations.of(context).passwordMismatch,
            AppLocalizations.of(context).passwordRetype,
            Icons.cancel,
            Colors.red,
            context);
        setState(ViewState.Idle);
        return;
      } else {
        setState(ViewState.Busy);
        await createOfflineWallets();
        passTextController.text = '';
        confirmPassTextController.text = '';
      }
    }
    setState(ViewState.Idle);
  }
}
