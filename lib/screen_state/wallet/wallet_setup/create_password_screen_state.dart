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
import 'package:exchangilymobileapp/models/wallet.dart';
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

/* ---------------------------------------------------
                    Create Offline Wallets
    -------------------------------------------------- */

  Future createOfflineWallets() async {
    setState(ViewState.Busy);
    _walletInfo = await _walletService
        .createOfflineWallets(randomMnemonicFromRoute)
        .then((data) {
      _walletInfo = data;
      Navigator.pushNamed(context, '/dashboard', arguments: _walletInfo);
      randomMnemonicFromRoute = '';
      setState(ViewState.Idle);
    }).catchError((onError) {
      errorMessage = AppLocalizations.of(context).somethingWentWrong;
      log.e(onError);
      setState(ViewState.Idle);
    });
    setState(ViewState.Idle);
  }

/* ---------------------------------------------------
                    Get All Coins Future
    -------------------------------------------------- */
  Future getAllCoins() async {
    log.w(randomMnemonicFromRoute);
    setState(ViewState.Busy);
    _walletInfo = await _walletService
        .getWalletCoins(randomMnemonicFromRoute)
        .then((data) {
      if (data == null || data == []) {
        errorMessage = AppLocalizations.of(context).serverError;
        setState(ViewState.Idle);
      } else {
        _walletInfo = data;
        Navigator.pushNamed(context, '/dashboard', arguments: _walletInfo);
        randomMnemonicFromRoute = '';
      }
      //  return _walletInfo;
    }).timeout(Duration(seconds: 25), onTimeout: () {
      log.e('Timeout');
      errorMessage =
          AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater;
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

  bool validatePassword(pass, confirmPass) {
    setState(ViewState.Busy);
    RegExp regex = new RegExp(pattern);

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
      return false;
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
        return false;
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
        return false;
      } else {
        password = '';
        confirmPassword = '';
        _vaultService.secureMnemonic(context, pass, randomMnemonicFromRoute);
        log.w('In else');
        setState(ViewState.Idle);
        return true;
      }
    }
  }
}
