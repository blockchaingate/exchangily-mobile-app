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

import 'dart:io';

import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/models/dialog/dialog_response.dart';
import 'package:exchangilymobileapp/models/wallet/user_settings_model.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_auth_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stacked/stacked.dart';

import '../../localizations.dart';
import '../../logger.dart';
import '../../service_locator.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import "package:hex/hex.dart";
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';

class SettingsViewmodel extends BaseViewModel {
  bool isVisible = false;
  String mnemonic = '';
  final log = getLogger('SettingsState');
  DialogService dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();

  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
  SharedService sharedService = locator<SharedService>();
  final storageService = locator<LocalStorageService>();
  final NavigationService navigationService = locator<NavigationService>();
  UserSettingsDatabaseService userSettingsDatabaseService =
      locator<UserSettingsDatabaseService>();

  final Map<String, String> languages = {'en': 'English', 'zh': '简体中文'};
  String selectedLanguage;
  // bool result = false;
  String errorMessage = '';
  DialogResponse dialogResponse;
  BuildContext context;
  String versionName = '';
  String buildNumber = '';
  static int initialLanguageValue = 0;
  final FixedExtentScrollController fixedScrollController =
      FixedExtentScrollController(initialItem: initialLanguageValue);
  bool isDialogDisplay = false;
  ScrollController scrollController;
  bool isDeleting = false;
  GlobalKey one;
  GlobalKey two;
  bool isShowCaseOnce;
  String baseServerUrl;
  ConfigService configService = locator<ConfigService>();
  final authService = locator<LocalAuthService>();
  bool isHKServer;
  Map<String, String> versionInfo;
  UserSettings userSettings = new UserSettings();
  bool isUserSettingsEmpty = false;
  final coinUtils = CoinUtils();
  bool _isBiometricAuth = false;
  get isBiometricAuth => _isBiometricAuth;

  bool _lockAppNow = false;
  get lockAppNow => _lockAppNow;

  init() async {
    setBusy(true);

    storageService.isShowCaseView == null
        ? isShowCaseOnce = false
        : isShowCaseOnce = storageService.isShowCaseView;

    getAppVersion();
    baseServerUrl = configService.getKanbanBaseUrl();
    await setLanguageFromDb();
    await selectDefaultWalletLanguage();
    setBusy(false);
  }

  setLockAppNowValue() {
    setBusyForObject(lockAppNow, true);
    _lockAppNow = !_lockAppNow;
    navigationService.navigateUsingPushReplacementNamed(WalletSetupViewRoute);
    setBusyForObject(lockAppNow, false);
  }

// Set biometric auth

  setBiometricAuth() async {
    setBusyForObject(isBiometricAuth, true);
    await authService
        .routeAfterAuthCheck(routeName: SettingViewRoute)
        .then((hasAuthenticated) {
      if (hasAuthenticated) {
        storageService.hasInAppBiometricAuthEnabled =
            !storageService.hasInAppBiometricAuthEnabled;
      }
    });
    if (!storageService.hasPhoneProtectionEnabled) {
      sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).pleaseSetupDeviceSecurity);
    }
    _isBiometricAuth = storageService.hasInAppBiometricAuthEnabled;
    setBusyForObject(isBiometricAuth, false);
  }

/*-------------------------------------------------------------------------------------
                      setLanguageFromDb
-------------------------------------------------------------------------------------*/
  setLanguageFromDb() async {
    setBusy(true);
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
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                      selectDefaultWalletLanguage
-------------------------------------------------------------------------------------*/

  Future<String> selectDefaultWalletLanguage() async {
    setBusy(true);
    if (selectedLanguage == '' || selectedLanguage == null) {
      String key = userSettings.language ?? 'en';
      // await getSetLocalStorageDataByKey('lang');
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
      log.i('selectedLanguage $selectedLanguage');
    }
    setBusy(false);
    return selectedLanguage;
  }
/*-------------------------------------------------------------------------------------
                    convertDecimalToHex
-------------------------------------------------------------------------------------*/

// Not in use
  convertDecimalToHex() async {
    int baseCoin = 0;
    await coinUtils
        .getCoinTypeIdByName('USDT')
        .then((value) => baseCoin = value);
    var x = baseCoin.toRadixString(16);
    var t = HEX.encode([baseCoin]);
    log.e('basecoin $baseCoin --  Hex == $t');
  }

/*-------------------------------------------------------------------------------------
                      Reload app
-------------------------------------------------------------------------------------*/

  changeBaseAppUrl() {
    setBusy(true);
    //  log.i('1');
    storageService.isHKServer = !storageService.isHKServer;

    storageService.isUSServer = storageService.isHKServer ? false : true;
    // Phoenix.rebirth(context);
    //  log.i('2');
    baseServerUrl = configService.getKanbanBaseUrl();
    isHKServer = storageService.isHKServer;
    log.e('GLobal kanban url $baseServerUrl');
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                      Showcase Event Start
-------------------------------------------------------------------------------------*/

  showcaseEvent(BuildContext test) async {
    setBusy(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(test).startShowCase([one, two]);
    });
    setBusy(false);
  }

  setIsShowcase(bool v) {
    // set updated value
    log.i('setIsShowcase $v value');
    storageService.isShowCaseView = !storageService.isShowCaseView;

    // get new value and assign it to the viewmodel variable
    setBusy(true);
    isShowCaseOnce = storageService.isShowCaseView;
    setBusy(false);
    log.w('is show case once value $isShowCaseOnce');
  }

/*-------------------------------------------------------------------------------------
                      Set the display warning value to local storage
-------------------------------------------------------------------------------------*/

  setIsDialogWarningValue(value) async {
    storageService.isNoticeDialogDisplay =
        !storageService.isNoticeDialogDisplay;
    setBusy(true);
    //sharedService.setDialogWarningsStatus(value);
    isDialogDisplay = storageService.isNoticeDialogDisplay;
    setBusy(false);
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
        await walletDatabaseService
            .deleteDb()
            .whenComplete(() => log.e('wallet database deleted!!'))
            .catchError((err) => log.e('wallet database CATCH $err'));

        await transactionHistoryDatabaseService
            .deleteDb()
            .whenComplete(() => log.e('trnasaction history database deleted!!'))
            .catchError((err) => log.e('tx history database CATCH $err'));

        await walletService
            .deleteEncryptedData()
            .whenComplete(() => log.e('encrypted data deleted!!'))
            .catchError((err) => log.e('delete encrypted CATCH $err'));

        await tokenListDatabaseService
            .deleteDb()
            .whenComplete(() => log.e('Token list database deleted!!'))
            .catchError((err) => log.e('token list database CATCH $err'));

        await userSettingsDatabaseService
            .deleteDb()
            .whenComplete(() => log.e('User settings database deleted!!'))
            .catchError((err) => log.e('user setting database CATCH $err'));

        storageService.walletBalancesBody = '';

        storageService.isShowCaseView = true;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        log.e('before wallet removal, local storage has ${prefs.getKeys()}');
        prefs.clear();

        storageService.clearStorage();
        log.e('before local storage service clear ${prefs.getKeys()}');

        log.e('all keys after clearing ${prefs.getKeys()}');
        await _deleteCacheDir()
            .catchError((err) => log.e('delete cache failed $err'));
        await _deleteAppDir()
            .catchError((err) => log.e('delete app dir failed $err'));

        Navigator.pushNamed(context, '/');
      } else if (res.returnedText == 'Closed' && !res.confirmed) {
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
    });
    isDeleting = false;
    setBusy(false);
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

/*----------------------------------------------------------------------
                Display mnemonic
----------------------------------------------------------------------*/
  displayMnemonic() async {
    errorMessage = '';

    log.w('Is visible $isVisible');
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
          setBusy(true);
          isVisible = !isVisible;
          mnemonic = res.returnedText;

          setBusy(false);
          return '';
        } else if (res.returnedText == 'Closed') {
          log.e('Dialog Closed By User');
          // setBusy(false);
          // return errorMessage = '';
        } else {
          log.e('Wrong pass');
          setBusy(false);
          return errorMessage =
              AppLocalizations.of(context).pleaseProvideTheCorrectPassword;
        }
      }).catchError((error) {
        log.e(error);
        setBusy(false);
      });
    }
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                      Change wallet language
-------------------------------------------------------------------------------------*/
  changeWalletLanguage(String updatedLanguageValue) async {
    setBusy(true);

    //remove cached announcement Data in different language
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("announceData");

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
      AppLocalizations.load(Locale('zh', 'ZH'));

      UserSettings us = new UserSettings(id: 1, language: 'zh', theme: '');
      await walletService.updateUserSettingsDb(us, isUserSettingsEmpty);
      storageService.language = 'zh';
    } else if (updatedLanguageValue == 'English' ||
        updatedLanguageValue == 'en' ||
        key == 'en') {
      log.e('in en');
      AppLocalizations.load(Locale('en', 'EN'));
      storageService.language = 'en';
      UserSettings us = new UserSettings(id: 1, language: 'en', theme: '');
      await walletService.updateUserSettingsDb(us, isUserSettingsEmpty);
    }

    setBusy(false);
  }

  // Pin code

  // Change password

  // Change theme

  // Get app version Code

  getAppVersion() async {
    setBusy(true);
    log.w('in app getappver');
    versionInfo = await sharedService.getLocalAppVersion();
    log.i('getAppVersion $versionInfo');
    versionName = versionInfo['name'];
    buildNumber = versionInfo['buildNumber'];
    log.i('getAppVersion name $versionName');

    setBusy(false);
  }

/*----------------------------------------------------------------------
                    onBackButtonPressed
----------------------------------------------------------------------*/
  onBackButtonPressed() async {
    await sharedService.onBackButtonPressed('/dashboard');
  }
}
