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
import 'package:exchangilymobileapp/models/dialog/dialog_response.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localizations.dart';
import '../../logger.dart';
import '../../service_locator.dart';
import '../base_state.dart';

class OtcScreenState extends BaseState {
  bool isVisible = false;
  String? mnemonic = '';
  final log = getLogger('OtcState');
  DialogService? dialogService = locator<DialogService>();
  WalletService? walletService = locator<WalletService>();

  final VaultService? _vaultService = locator<VaultService>();
  List<String> languages = ['English', 'Chinese'];
  String? selectedLanguage;
  // bool result = false;
  @override
  String errorMessage = '';
  DialogResponse? dialogResponse;
  late BuildContext context;
  String versionName = '';
  String versionCode = '';
  void showMnemonic() async {
    await displayMnemonic();
    isVisible = !isVisible;
  }

  // Delete wallet and local storage

  deleteWallet() async {
    errorMessage = '';
    setState(ViewState.Busy);

    await dialogService!
        .showDialog(
            title: AppLocalizations.of(context)!.enterPassword,
            description:
                AppLocalizations.of(context)!.dialogManagerTypeSamePasswordNote,
            buttonTitle: AppLocalizations.of(context)!.confirm)
        .then((res) async {
      if (res.confirmed!) {
        log.w('deleting wallet');
        await _vaultService!.deleteEncryptedData();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('lang');
        prefs.clear();
        Navigator.pushNamed(context, '/');
        setState(ViewState.Idle);
        return null;
      } else if (res.returnedText == 'Closed') {
        log.e('Dialog Closed By User');
        setState(ViewState.Idle);
        return errorMessage = '';
      } else {
        log.e('Wrong pass');
        setState(ViewState.Idle);
        return errorMessage =
            AppLocalizations.of(context)!.pleaseProvideTheCorrectPassword;
      }
    }).catchError((error) {
      log.e(error);
      setState(ViewState.Idle);
      return false;
    });
  }

  // Show mnemonic
  displayMnemonic() async {
    errorMessage = '';
    setState(ViewState.Busy);
    log.w('Is visi $isVisible');
    if (isVisible) {
      isVisible = !isVisible;
    } else {
      await dialogService!
          .showDialog(
              title: AppLocalizations.of(context)!.enterPassword,
              description: AppLocalizations.of(context)!
                  .dialogManagerTypeSamePasswordNote,
              buttonTitle: AppLocalizations.of(context)!.confirm)
          .then((res) async {
        if (res.confirmed!) {
          isVisible = !isVisible;
          mnemonic = res.returnedText;
          setState(ViewState.Idle);
          return '';
        } else if (res.returnedText == 'Closed') {
          log.e('Dialog Closed By User');
          setState(ViewState.Idle);
          return errorMessage = '';
        } else {
          log.e('Wrong pass');
          setState(ViewState.Idle);
          return errorMessage =
              AppLocalizations.of(context)!.pleaseProvideTheCorrectPassword;
        }
      }).catchError((error) {
        log.e(error);
        setState(ViewState.Idle);
        return false;
      });
    }
  }

  // Change wallet language

  changeWalletLanguage(newValue) async {
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedLanguage = newValue;
    log.w('Selec $selectedLanguage');
    if (newValue == 'Chinese') {
      log.e('in zh');

      AppLocalizations.load(const Locale('zh', 'ZH'));
      prefs.setString('lang', 'zh');
    } else if (newValue == 'English') {
      log.e('in en');
      AppLocalizations.load(const Locale('en', 'EN'));
      prefs.setString('lang', 'en');
    }
    setState(ViewState.Idle);
  }

  // Pin code

  // Change password

  // Change theme

  // Get app version Code

  getAppVersion() async {
    setState(ViewState.Busy);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionName = packageInfo.version;
    setState(ViewState.Idle);
  }
}
