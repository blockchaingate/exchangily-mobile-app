import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseWalletLanguageScreenState extends BaseState {
  final log = getLogger('ChooseWalletLanguageScreenState');
  BuildContext context;
  String errorMessage = '';

  Future checkLanguage() async {
    String lang = '';
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('lang');
    if (lang == null || lang.isEmpty) {
      log.e('null');
    } else {
      setState(ViewState.Idle);
      Navigator.pushNamed(context, '/walletSetup');
    }
    setState(ViewState.Idle);
  }

  setLangauge(String languageCode) async {
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log.w('Lang code $languageCode');
    prefs.setString('lang', languageCode);
    setState(ViewState.Idle);
  }
}
