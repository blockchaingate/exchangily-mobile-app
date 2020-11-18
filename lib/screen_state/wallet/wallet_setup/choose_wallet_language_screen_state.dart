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
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

class ChooseWalletLanguageScreenState extends BaseState {
  final log = getLogger('ChooseWalletLanguageScreenState');
  BuildContext context;

  final NavigationService navigationService = locator<NavigationService>();
  String errorMessage = '';

  Future checkLanguage() async {
    String lang = '';
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('lang');
    if (lang == null || lang == '') {
      log.e('language empty');
    } else {
      setState(ViewState.Idle);
      setLangauge(lang);
      navigationService.navigateTo('/walletSetup');
    }
    setState(ViewState.Idle);
  }

  setLangauge(String languageCode) async {
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', languageCode);
    AppLocalizations.load(Locale(languageCode, languageCode.toUpperCase()));
    setState(ViewState.Idle);
  }
}
