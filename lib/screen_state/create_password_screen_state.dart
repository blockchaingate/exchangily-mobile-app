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
  String password = '';
  String confirmPassword = '';
  String errorMessage = '';
  Pattern pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

/* ---------------------------------------------------
                    Get All Coins Future
    -------------------------------------------------- */
  getAllCoins(context) async {
    log.w('Future get all coins started');
    setState(ViewState.Busy);
    _walletInfo = await _walletService.getAllCoins().then((data) {
      if (data == null || data == []) {
        errorMessage = AppLocalizations.of(context).serverError;
        setState(ViewState.Idle);
      } else {
        _walletInfo = data;
        Navigator.pushNamed(context, '/dashboard', arguments: _walletInfo);
      }
      return _walletInfo;
    }).timeout(Duration(seconds: 25), onTimeout: () {
      log.e('TIMEOUT');
      errorMessage =
          AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater;
      setState(ViewState.Idle);
    }).catchError((onError) {
      errorMessage = AppLocalizations.of(context).somethingWentWrong;
      log.e(onError);
      setState(ViewState.Idle);
    });
    setState(ViewState.Idle);
  }

  showNotification(context, title, message) {
    _walletService.showInfoFlushbar(
        title, message, Icons.cancel, Colors.red, context);
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

  bool validatePassword(pass, confirmPass, context, mnemonic) {
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
        return false;
      } else {
        password = '';
        confirmPassword = '';
        _vaultService.secureMnemonic(context, pass, mnemonic);
        log.w('In else');
        return true;
      }
    }
  }
}
