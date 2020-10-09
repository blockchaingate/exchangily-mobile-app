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
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
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

class SettingsScreenViewmodel extends BaseViewModel {
  bool isVisible = false;
  String mnemonic = '';
  final log = getLogger('SettingsState');
  DialogService dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
  SharedService sharedService = locator<SharedService>();

  final NavigationService navigationService = locator<NavigationService>();
  List<String> languages = ['English', 'Chinese'];
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
    // await getStoredDataByKeys('isShowCaseOnce', isSetData: true, value: false);
    isShowCaseOnce = await getStoredDataByKeys('isShowCaseOnce');
    // await Future.delayed(Duration(seconds: 2), () {
    //   log.i('waited 2 seconds');
    // });
    log.i('isShow $isShowCaseOnce');
    sharedService.getDialogWarningsStatus().then((res) {
      if (res != null) isDialogDisplay = res;
    });
    getAppVersion();
    if (selectedLanguage == '')
      selectedLanguage = await getStoredDataByKeys('lang');
    setBusy(false);
  }

  showcaseEvent(BuildContext test) async {
    setBusy(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(test).startShowCase([one, two]);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // isShowCaseOnce = true;
    // prefs.setBool('isShowCaseOnce', isShowCaseOnce);
    // isShowCaseOnce = prefs.getBool('isShowCaseOnce');
    // log.e('isShow $isShowCaseOnce');
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
        await walletDatabaseService.deleteDb();
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

  Future getStoredDataByKeys(String key,
      {bool isSetData = false, dynamic value}) async {
    print('key $key -- isData $isSetData -- value $value');
    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isSetData) prefs.setBool(key, value);

    log.e('value of get key ${prefs.get(key)}');
    isShowCaseOnce = prefs.get(key);
    setBusy(false);
    if (!isSetData) return prefs.get(key);
  }

  // Change wallet language

  changeWalletLanguage(lang) async {
    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedLanguage = lang;
    log.w('Selec $selectedLanguage');

    if (lang == 'Chinese' || lang == 'zh') {
      log.e('in zh');
      AppLocalizations.load(Locale('zh', 'ZH'));
      prefs.setString('lang', 'zh');
    } else if (lang == 'English' || lang == 'en') {
      log.e('in en');
      AppLocalizations.load(Locale('en', 'EN'));
      prefs.setString('lang', 'en');
      setlangGlobal('en');
    }

    log.w('langGlobal: ' + getlangGlobal());
    setBusy(false);
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
