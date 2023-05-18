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
import 'package:exchangilymobileapp/models/wallet/user_settings_model.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';

class ChooseWalletLanguageScreenState extends BaseState {
  final log = getLogger('ChooseWalletLanguageScreenState');
  BuildContext? context;

  UserSettingsDatabaseService? userSettingsDatabaseService =
      locator<UserSettingsDatabaseService>();
  final NavigationService? navigationService = locator<NavigationService>();
  final LocalStorageService? storageService = locator<LocalStorageService>();
  final WalletService? walletService = locator<WalletService>();
  @override
  String errorMessage = '';
  bool isUserSettingsEmpty = false;

  Future checkLanguage() async {
    String lang = '';
    setState(ViewState.Busy);
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = await userSettingsDatabaseService!
        .getById(1)
        .then((res) => res!.language!);
    if (lang == null || lang == '') {
      log.e('language empty');
    } else {
      setState(ViewState.Idle);
      setLangauge(lang);
      storageService!.language = lang;
      navigationService!.navigateTo('/walletSetup');
    }
    setState(ViewState.Idle);
  }

  setLangauge(String languageCode) async {
    setState(ViewState.Busy);
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    UserSettings userSettings = UserSettings(language: languageCode, theme: '');
    await userSettingsDatabaseService!.getById(1).then((res) {
      if (res != null) {
        //   userSettings.language = res.language;
        isUserSettingsEmpty = false;
        log.i('user settings db not null --$res');
      } else {
        isUserSettingsEmpty = true;
        log.i('user settings db null --$res');
      }
    }).catchError((err) => log.e('user settings db empty $err'));
    //await walletService.updateUserSettingsDb(userSettings, isUserSettingsEmpty);
    storageService!.language = languageCode;
    AppLocalizations.load(Locale(languageCode, languageCode.toUpperCase()));
    setState(ViewState.Idle);
  }
}
