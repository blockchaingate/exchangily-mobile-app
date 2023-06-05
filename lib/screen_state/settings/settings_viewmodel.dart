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
import 'package:exchangilymobileapp/services/coin_service.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_auth_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/version_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/wallet/local_kyc_util.dart';
import 'package:exchangilymobileapp/utils/wallet/wallet_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:kyc/kyc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../../logger.dart';
import '../../service_locator.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import "package:hex/hex.dart";
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';

class SettingsViewModel extends BaseViewModel {
  bool isVisible = false;
  String? mnemonic = '';
  final log = getLogger('SettingsViewmodel');
  DialogService dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  TokenInfoDatabaseService tokenListDatabaseService =
      locator<TokenInfoDatabaseService>();
  SharedService sharedService = locator<SharedService>();
  final LocalStorageService storageService = locator<LocalStorageService>();
  var themeService = locator<ThemeService>();
  final NavigationService navigationService = locator<NavigationService>();

  final WalletDatabaseService walletDatabaseService =
      locator<WalletDatabaseService>();
  final CoreWalletDatabaseService coreWalletDatabaseService =
      locator<CoreWalletDatabaseService>();
  UserSettingsDatabaseService userSettingsDatabaseService =
      locator<UserSettingsDatabaseService>();
  ConfigService configService = locator<ConfigService>();
  final LocalAuthService authService = locator<LocalAuthService>();
  final CoinService coinService = locator<CoinService>();
  final VersionService vs = locator<VersionService>();
  final Map<String, String> languages = {'en': 'English', 'zh': '简体中文'};
  String? selectedLanguage;
  // bool result = false;
  String errorMessage = '';
  DialogResponse? dialogResponse;
  late BuildContext context;
  String? versionName = '';
  String? buildNumber = '';
  static int initialLanguageValue = 0;
  final FixedExtentScrollController fixedScrollController =
      FixedExtentScrollController(initialItem: initialLanguageValue);
  bool isDialogDisplay = false;
  ScrollController? scrollController;
  bool isDeleting = false;
  late GlobalKey one;
  late GlobalKey two;
  late bool isShowCaseOnce;
  String? baseServerUrl;

  bool? isHKServer;
  late Map<String, String> versionInfo;
  UserSettings userSettings = UserSettings();
  bool isUserSettingsEmpty = false;
  final coinUtils = CoinUtil();
  bool _isBiometricAuth = false;
  get isBiometricAuth => _isBiometricAuth;
  final t = TextEditingController();
  bool _lockAppNow = false;
  get lockAppNow => _lockAppNow;
  var walletUtil = WalletUtil();
  bool kycStarted = false;
  var kycCheckResult = UserDataContent();
  init() async {
    setBusy(true);
    if (storageService.isDarkMode) {
      themeService.setThemeMode(ThemeManagerMode.dark);
    }
    isShowCaseOnce = storageService.isShowCaseView;

    getAppVersion();
    baseServerUrl = configService.getKanbanBaseUrl();
    // Future.delayed(const Duration(seconds: 1), () async {
    // await setLanguageFromDb();
    selectedLanguage = storageService.language;
    if (selectedLanguage!.isEmpty) {
      selectedLanguage = 'en';
    }
    // await selectDefaultWalletLanguage();
    // });

    setBusy(false);
  }

  checkKycStatus() async {
    setBusyForObject(kycStarted, true);
    var result = await LocalKycUtil.checkKycStatus();
    kycStarted = result['success'];
    if (kycStarted) {
      var res = result['data'] ?? {};
      log.w('checkkycstatus res $res');
      kycCheckResult = UserDataContent.fromJson(res['data']);
      // kycCheckResult.kyc!.step = 6;
      log.w('checkkycstatus kycCheckResult ${kycCheckResult.toJson()}');
    }
    setBusyForObject(kycStarted, false);
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

    bool hasAuthorized = await authService.authenticateApp();

    if (hasAuthorized) {
      storageService.hasInAppBiometricAuthEnabled =
          !storageService.hasInAppBiometricAuthEnabled;
      storageService.hasPhoneProtectionEnabled = true;
    } else if (!hasAuthorized) {
      if (authService.isLockedOut) {
        sharedService.sharedSimpleNotification(
            FlutterI18n.translate(context, "lockedOutTemp"));
      } else if (authService.isLockedOutPerm) {
        sharedService.sharedSimpleNotification(
            FlutterI18n.translate(context, "lockedOutPerm"));
      }
    }

    if (!storageService.hasPhoneProtectionEnabled) {
      sharedService.sharedSimpleNotification(
          FlutterI18n.translate(context, "pleaseSetupDeviceSecurity"));
      storageService.hasCancelledBiometricAuth = false;
      storageService.hasInAppBiometricAuthEnabled = false;
    }
    _isBiometricAuth = storageService.hasInAppBiometricAuthEnabled;
    setBusyForObject(isBiometricAuth, false);
  }

  //                    setLanguageFromDb

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

  Future<String?> selectDefaultWalletLanguage() async {
    setBusy(true);
    if (selectedLanguage == '' || selectedLanguage == null) {
      String? key;
      if (userSettings.language == null || userSettings.language!.isEmpty) {
        key = 'en';
      }
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
    int? baseCoin = 0;
    await coinService
        .getCoinTypeByTickerName('USDT')
        .then((value) => baseCoin = value);
    var x = baseCoin!.toRadixString(16);
    var t = HEX.encode([baseCoin!]);
    log.e('basecoin $baseCoin --  Hex == $t');
  }

  toggleTheme() {
    setBusy(true);
    storageService.isDarkMode = !storageService.isDarkMode;
    notifyListeners();
    getThemeManager(context).toggleDarkLightTheme();

    setBusy(false);
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
    // log.i('model busy $busy');
    await dialogService
        .showDialog(
      title: FlutterI18n.translate(context, "deleteWalletConfirmationPopup"),
      buttonTitle: FlutterI18n.translate(context, "confirm"),
      // secondaryButton: FlutterI18n.translate(context, "cancel"),
    )
        .then((res) async {
      if (res.confirmed!) {
        setBusy(true);
        isDeleting = true;
        log.w('deleting wallet');
        await walletService.deleteWallet();

        Navigator.pushNamed(context, '/');
      } else if (res.returnedText == 'Closed' && !res.confirmed!) {
        log.e('Dialog Closed By User');
        isDeleting = false;
        setBusy(false);
        return errorMessage = '';
      } else {
        log.e('Cancel Button');
        setBusy(false);
        isDeleting = false;
      }
    }).catchError((error) {
      log.e(error);
      isDeleting = false;
      setBusy(false);
      return error.toString();
    });
    isDeleting = false;
    setBusy(false);
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
        title: FlutterI18n.translate(context, "enterPassword"),
        description:
            FlutterI18n.translate(context, "dialogManagerTypeSamePasswordNote"),
        buttonTitle: FlutterI18n.translate(context, "confirm"),
      )
          .then((res) async {
        if (res.confirmed!) {
          setBusy(true);
          isVisible = !isVisible;
          mnemonic = res.returnedText;

          setBusy(false);
          return '';
        } else if (res.returnedText == 'Closed') {
          log.e('Dialog Closed By User');
          // setBusy(false);
          // return errorMessage = '';
        } else if (res.isRequiredUpdate!) {
          log.e('Wallet update required');
          setBusy(false);
          return errorMessage =
              FlutterI18n.translate(context, "importantWalletUpdateNotice");
        } else {
          log.e('Wrong pass');
          setBusy(false);
          return errorMessage =
              FlutterI18n.translate(context, "pleaseProvideTheCorrectPassword");
        }
      }).catchError((error) {
        log.e(error);
        setBusy(false);
        return error.toString();
      });
    }
    setBusy(false);
  }

/*-------------------------------------------------------------------------------------
                      Change wallet language
-------------------------------------------------------------------------------------*/
  changeWalletLanguage(String? updatedLanguageValue) async {
    setBusy(true);

    //remove cached announcement Data in different language
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("announceData");

    // Get the Map key using value
    // String key = languages.keys.firstWhere((k) => languages[k] == lang);
    String? key = '';
    log.e('KEY or Value $updatedLanguageValue');
    if (languages.containsValue(updatedLanguageValue)) {
      key = languages.keys
          .firstWhere((k) => languages[k] == updatedLanguageValue);
      log.i('key in changeWalletLanguage $key');
    } else {
      key = updatedLanguageValue;
    }
// selected language should be English,Chinese or other language selected not its lang code
    selectedLanguage = key!.isNotEmpty ? updatedLanguageValue : languages[key];
    log.w('selectedLanguage $selectedLanguage');
    if (updatedLanguageValue == 'Chinese' ||
        updatedLanguageValue == 'zh' ||
        key == 'zh') {
      log.e('in zh');
      FlutterI18n.refresh(context, Locale('zh', 'ZH'));

      //   UserSettings us = UserSettings(id: 1, language: 'zh', theme: '');
      //   await walletService.updateUserSettingsDb(us, isUserSettingsEmpty);
      storageService.language = 'zh';
    } else if (updatedLanguageValue == 'English' ||
        updatedLanguageValue == 'en' ||
        key == 'en') {
      log.e('in en');
      FlutterI18n.refresh(context, Locale('en', 'EN'));
      storageService.language = 'en';
      // UserSettings us = UserSettings(id: 1, language: 'en', theme: '');
      // await walletService.updateUserSettingsDb(us, isUserSettingsEmpty);
    }

    setBusy(false);
  }

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
