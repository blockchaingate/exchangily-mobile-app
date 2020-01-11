import 'package:exchangilymobileapp/enums/screen_state.dart';
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
      if (data == null) {
        errorMessage = 'Server Error';
        setState(ViewState.Idle);
      } else {
        _walletInfo = data;
        Navigator.pushNamed(context, '/totalBalance', arguments: _walletInfo);
      }
      return _walletInfo;
    }).timeout(Duration(seconds: 25), onTimeout: () {
      log.e('TIMEOUT');
      errorMessage = 'Server Timeout, Please try again later';
      setState(ViewState.Idle);
      return;
    }).catchError((onError) {
      errorMessage = 'Something went wrong';
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
      _walletService.showInfoFlushbar(
          'Empty Password',
          'Please fill both password fields',
          Icons.cancel,
          Colors.red,
          context);
      return false;
    } else {
      if (!regex.hasMatch(pass)) {
        _walletService.showInfoFlushbar(
            'Password Conditions Mismatch,',
            'Please enter the password that satisfy above conditions',
            Icons.cancel,
            Colors.red,
            context);
        return false;
      } else if (pass != confirmPass) {
        _walletService.showInfoFlushbar(
            'Password Mismatch',
            'Please retype the same password in both fields',
            Icons.cancel,
            Colors.red,
            context);
        return false;
      } else {
        password = '';
        confirmPassword = '';
        _vaultService.secureSeed(context, pass, mnemonic);
        log.w('In else');
        return true;
      }
    }
  }
}
