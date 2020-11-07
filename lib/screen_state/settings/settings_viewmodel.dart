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
import 'package:exchangilymobileapp/models/alert/alert_response.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/globalLang.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:stacked/stacked.dart';

import '../../localizations.dart';
import '../../logger.dart';
import '../../service_locator.dart';
import '../base_state.dart';

class SettingsViewmodel extends BaseViewModel {
  bool isVisible = false;
  String mnemonic = '';
  final log = getLogger('SettingsState');
  DialogService dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
  SharedService sharedService = locator<SharedService>();
  var storageService = locator<LocalStorageService>();
  final NavigationService navigationService = locator<NavigationService>();
  Map<String, String> languages = {'en': 'English', 'zh': '简体中文'};
  String selectedLanguage;
  // bool result = false;
  String errorMessage = '';
  AlertResponse alertResponse;
  BuildContext context;
  String versionName = '';
  String versionCode = '';
  static int initialLanguageValue = 0;
  final FixedExtentScrollController fixedScrollController =
      FixedExtentScrollController(initialItem: initialLanguageValue);
  bool isDialogDisplay = false;
  ScrollController scrollController;
  bool isDeleting = false;
  GlobalKey one;
  GlobalKey two;
  bool isShowCaseOnce;

  init() async {
    setBusy(true);

    storageService.isShowCaseView == null
        ? isShowCaseOnce = false
        : isShowCaseOnce = storageService.isShowCaseView;

    sharedService.getDialogWarningsStatus().then((res) {
      if (res != null) isDialogDisplay = res;
    });
    getAppVersion();
    await selectDefaultWalletLanguage();
    // if (selectedLanguage == '')
    //   selectedLanguage = getSetLocalStorageDataByKey('lang');
    setBusy(false);
  }

  showcaseEvent(BuildContext test) async {
    setBusy(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(test).startShowCase([one, two]);
    });
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                      Get coin currency Usd Prices
-------------------------------------------------------------------------------------*/

  Future<String> selectDefaultWalletLanguage() async {
    setBusy(true);
    if (selectedLanguage == '' || selectedLanguage == null) {
      String key = await getSetLocalStorageDataByKey('lang');
      // log.w('key in init $key');

      // /// Created Map of languages because in dropdown if i want to show
      // /// first default value as whichever language is currently the app
      // /// is in then default value that i want to show should match with one
      // /// of the dropdownMenuItem's value

      if (languages.containsKey(key)) {
        selectedLanguage = languages[key];
      }
      // else if (languages.containsValue(key)) {
      //   String keyIsValue = key;

      //   selectedLanguage =
      //       languages.keys.firstWhere((k) => languages[k] == keyIsValue);
      // }
      print('selectedLanguage $selectedLanguage');
    }
    setBusy(false);
    return selectedLanguage;
  }

  void showMnemonic() async {
    await displayMnemonic();
    isVisible = !isVisible;
  }

  // Delete wallet and local storage

  Future deleteWallet() async {
    errorMessage = '';
    setBusy(true);
    log.i('model busy $busy');
    await dialogService
        .showDialog(
            title: AppLocalizations.of(context).enterPassword,
            description:
                AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
            buttonTitle: AppLocalizations.of(context).confirm)
        .then((res) async {
      if (res.confirmed) {
        isDeleting = true;
        log.w('deleting wallet');
        await walletDatabaseService.deleteDb();
        await transactionHistoryDatabaseService.deleteDb();
        await walletService.deleteEncryptedData();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('lang');
        prefs.clear();
        Navigator.pushNamed(context, '/');
      } else if (res.returnedText == 'Closed') {
        log.e('Dialog Closed By User');
        isDeleting = false;
        setBusy(false);
        return errorMessage = '';
      } else {
        log.e('Wrong pass');
        setBusy(false);
        isDeleting = false;
        return errorMessage =
            AppLocalizations.of(context).pleaseProvideTheCorrectPassword;
      }
    }).catchError((error) {
      log.e(error);
      isDeleting = false;
      setBusy(false);

      return false;
    });
    log.i('model busy $busy');
    isDeleting = false;
    setBusy(false);
  }

  // Show mnemonic
  displayMnemonic() async {
    errorMessage = '';
    setBusy(true);
    log.w('Is visi $isVisible');
    if (isVisible) {
      isVisible = !isVisible;
    } else {
      await dialogService
          .showDialog(
              title: AppLocalizations.of(context).enterPassword,
              description: AppLocalizations.of(context)
                  .dialogManagerTypeSamePasswordNote,
              buttonTitle: AppLocalizations.of(context).confirm)
          .then((res) async {
        if (res.confirmed) {
          isVisible = !isVisible;
          mnemonic = res.returnedText;

          setBusy(false);
          return '';
        } else if (res.returnedText == 'Closed') {
          log.e('Dialog Closed By User');
          setBusy(false);
          return errorMessage = '';
        } else {
          log.e('Wrong pass');
          setBusy(false);
          return errorMessage =
              AppLocalizations.of(context).pleaseProvideTheCorrectPassword;
        }
      }).catchError((error) {
        log.e(error);
        setBusy(false);
        return false;
      });
    }
  }

/*-------------------------------------------------------------------------------------
                      Get stored data by keys
-------------------------------------------------------------------------------------*/
  getSetLocalStorageDataByKey(String key,
      {bool isSetData = false, dynamic value}) async {
    print('key $key -- isData $isSetData -- value $value');

    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isSetData) prefs.setBool(key, value);
    log.e('key-- $key-- value ${prefs.get(key)}');

    setBusy(false);
    return prefs.get(key);
  }

/*-------------------------------------------------------------------------------------
                      Change wallet language
-------------------------------------------------------------------------------------*/
  changeWalletLanguage(updatedLanguageValue) async {
    setBusy(true);
    // Get the Map key using value
    // String key = languages.keys.firstWhere((k) => languages[k] == lang);
    String key = '';
    log.e('KEY or Value $updatedLanguageValue');
    if (languages.containsValue(updatedLanguageValue)) {
      key = languages.keys
          .firstWhere((k) => languages[k] == updatedLanguageValue);
      log.i('key in changeWalletLanguage $key');
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedLanguage = key.isEmpty ? updatedLanguageValue : languages[key];
    log.w('selectedLanguage $selectedLanguage');
    if (updatedLanguageValue == 'Chinese' ||
        updatedLanguageValue == 'zh' ||
        key == 'zh') {
      log.e('in zh');
      AppLocalizations.load(Locale('zh', 'ZH'));
      prefs.setString('lang', key);
    } else if (updatedLanguageValue == 'English' ||
        updatedLanguageValue == 'en' ||
        key == 'en') {
      log.e('in en');
      AppLocalizations.load(Locale('en', 'EN'));
      prefs.setString('lang', key);
    }
    //  log.w('langGlobal: ' + getlangGlobal());
    setBusy(false);
  }

  // Pin code

  // Change password

  // Change theme

  // Get app version Code

  getAppVersion() async {
    setBusy(true);
    log.w('in app getappver');
    versionName = await sharedService.getLocalAppVersion();
    setBusy(false);
  }

  // Set the display warning value to local storage
  setDialogWarningValue(value) async {
    setBusy(true);
    sharedService.setDialogWarningsStatus(value);
    isDialogDisplay = value;
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    onBackButtonPressed
----------------------------------------------------------------------*/
  onBackButtonPressed() async {
    await sharedService.onBackButtonPressed('/dashboard');
  }
}
