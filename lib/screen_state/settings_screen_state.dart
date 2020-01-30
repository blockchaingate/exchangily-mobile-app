import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/models/alert/alert_response.dart';
import 'package:exchangilymobileapp/services/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../localizations.dart';
import '../logger.dart';
import '../service_locator.dart';
import 'base_state.dart';

class SettingsScreenState extends BaseState {
  bool isVisible = false;
  String mnemonic = '';
  final log = getLogger('SendState');
  DialogService dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  WalletDataBaseService databaseService = locator<WalletDataBaseService>();
  List<String> languages = ['English', 'Chinese'];
  String selectedLanguage;
  // bool result = false;
  String errorMessage = '';
  AlertResponse alertResponse;
  BuildContext context;

  void showMnemonic() async {
    await displayMnemonic();
    isVisible = !isVisible;
  }

  verify() async {
    errorMessage = '';
    setState(ViewState.Busy);

    await dialogService
        .showDialog(
            title: AppLocalizations.of(context).enterPassword,
            description:
                AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
            buttonTitle: AppLocalizations.of(context).confirm)
        .then((res) async {
      if (res.confirmed) {
        log.w('deleting wallet');
        await walletService.deleteEncryptedData();
        await databaseService.deleteDb();
        Navigator.pushNamed(context, '/walletSetup');
        setState(ViewState.Idle);
        return null;
      } else if (res.fieldOne == 'Closed') {
        log.e('Dialog Closed By User');
        setState(ViewState.Idle);
        return errorMessage = '';
      } else {
        log.e('Wrong pass');
        setState(ViewState.Idle);
        return errorMessage =
            AppLocalizations.of(context).pleaseProvideTheCorrectPassword;
      }
    }).catchError((error) {
      log.e(error);
      setState(ViewState.Idle);
      return false;
    });
  }

  displayMnemonic() async {
    errorMessage = '';
    setState(ViewState.Busy);
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
          mnemonic = res.fieldOne;
          setState(ViewState.Idle);
          return '';
        } else if (res.fieldOne == 'Closed') {
          log.e('Dialog Closed By User');
          setState(ViewState.Idle);
          return errorMessage = '';
        } else {
          log.e('Wrong pass');
          setState(ViewState.Idle);
          return errorMessage =
              AppLocalizations.of(context).pleaseProvideTheCorrectPassword;
        }
      }).catchError((error) {
        log.e(error);
        setState(ViewState.Idle);
        return false;
      });
    }
  }

  changeWalletLanguage(newValue) {
    setState(ViewState.Busy);
    selectedLanguage = newValue;
    log.w('Selec $selectedLanguage');
    if (newValue == 'Chinese') {
      log.e('in zh');
      AppLocalizations.load(Locale('zh', 'ZH'));
    } else if (newValue == 'English') {
      log.e('in en');
      AppLocalizations.load(Locale('en', 'EN'));
    }
    setState(ViewState.Idle);
  }
}
