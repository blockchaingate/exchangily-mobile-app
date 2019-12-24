import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/view_state/base_state.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../shared/globals.dart' as globals;

class CreatePasswordScreenState extends BaseState {
  final WalletService _walletService = locator<WalletService>();
  final VaultService _vaultService = locator<VaultService>();

  List<WalletInfo> _walletInfo;
  final log = getLogger('CreatePasswordScreenState');
  String errorMessage = '';

/* ---------------------------------------------------
                    Get All Coins Future
    -------------------------------------------------- */
  Future<List<WalletInfo>> getAllCoins() async {
    log.w('Future get all coins started');
    setState(ViewState.Busy);
    _walletInfo = await _walletService
        .getAllCoins()
        .timeout(Duration(seconds: 15), onTimeout: () {
      log.e('TIMEOUT');
      setState(ViewState.Idle);
      _walletInfo = [];

      return _walletInfo;
    });
    if (_walletInfo == null) {
      errorMessage = 'No Coin Data';
      setState(ViewState.Idle);
    } else {
      errorMessage = 'Something wrong happened while creating the list';
      log.w('wallet info length ${_walletInfo.length}');
      setState(ViewState.Idle);
    }
    return _walletInfo;
  }

  getCoinAddresses() async {
    //   String addr = await _walletService.getCoinAddresses();
    // log.w(addr);
  }

  showNotification(context, title, message) {
    _walletService.showInfoFlushbar(
        title, message, Icons.cancel, Colors.red, context);
  }
/* ---------------------------------------------------
                      Validate Pass
    -------------------------------------------------- */

  bool validatePassword(pass, confirmPass, context) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
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
        _vaultService.secureSeed(context, pass);
        log.w('In else');
        return true;
      }
    }
  }
}
