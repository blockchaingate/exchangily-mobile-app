import 'dart:io';

import 'package:exchangilymobileapp/models/wallet/user_settings_model.dart';
import 'package:exchangilymobileapp/routes.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LaguageService {
  final Map<String, String> languages = {'en': 'English', 'zh': '简体中文'};
  String selectedLanguage;
  Locale currentLang;
  final storageService = locator<LocalStorageService>();
  WalletService walletService = locator<WalletService>();
  UserSettings userSettings = new UserSettings();
  bool isUserSettingsEmpty = false;
  UserSettingsDatabaseService userSettingsDatabaseService =
      locator<UserSettingsDatabaseService>();

  setLanguageFromDb() async {
    await userSettingsDatabaseService.getById(1).then((res) {
      if (res != null) {
        userSettings.language = res.language;
        log.i('user settings db not null');
      } else {
        userSettings.language = Platform.localeName.substring(0, 2);
        isUserSettingsEmpty = true;
        log.i(
            'user settings db null-- isUserSettingsEmpty $isUserSettingsEmpty');
      }
    }).catchError((err) => log.e('user settings db empty $err'));
  }

  Future<void> setLanguage(String updatedLanguageValue, context) async {
    // Get the Map key using value
    // String key = languages.keys.firstWhere((k) => languages[k] == lang);
    String key = '';
    log.e('KEY or Value $updatedLanguageValue');
    if (languages.containsValue(updatedLanguageValue)) {
      key = languages.keys
          .firstWhere((k) => languages[k] == updatedLanguageValue);
      log.i('key in changeWalletLanguage $key');
    } else
      key = updatedLanguageValue;
// selected language should be English,Chinese or other language selected not its lang code
    selectedLanguage = key.isEmpty ? updatedLanguageValue : languages[key];
    log.w('selectedLanguage $selectedLanguage');
    if (updatedLanguageValue == 'Chinese' ||
        updatedLanguageValue == 'zh' ||
        key == 'zh') {
      log.e('in zh');
      // AppLocalizations.load(Locale('zh', 'ZH'));
      currentLang = Locale('zh');
      await FlutterI18n.refresh(context, currentLang);
      storageService.language = 'zh';
      UserSettings us = new UserSettings(id: 1, language: 'zh', theme: '');
      await walletService.updateUserSettingsDb(us, isUserSettingsEmpty);
    } else if (updatedLanguageValue == 'English' ||
        updatedLanguageValue == 'en' ||
        key == 'en') {
      log.e('in en');
      // AppLocalizations.load(Locale('en', 'EN'));
      currentLang = Locale('en');
      await FlutterI18n.refresh(context, currentLang);
      storageService.language = 'en';
      UserSettings us = new UserSettings(id: 1, language: 'en', theme: '');
      await walletService.updateUserSettingsDb(us, isUserSettingsEmpty);
    }
  }

  String getCurrentLanguage() {
    return selectedLanguage;
  }
}
