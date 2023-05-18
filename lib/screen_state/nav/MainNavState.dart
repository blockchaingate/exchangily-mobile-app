import 'package:exchangilymobileapp/models/dialog/dialog_response.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import '../../logger.dart';
import '../../service_locator.dart';
import '../base_state.dart';

class MainNavState extends BaseState {
  bool isVisible = false;
  String mnemonic = '';
  final log = getLogger('LanguageScreenState');
  DialogService? dialogService = locator<DialogService>();
  WalletService? walletService = locator<WalletService>();

  SharedService? sharedService = locator<SharedService>();

  final NavigationService? navigationService = locator<NavigationService>();
  List<String> languages = ['English', 'Chinese'];
  String? selectedLanguage;
  // bool result = false;
  @override
  String errorMessage = '';
  DialogResponse? dialogResponse;
  BuildContext? context;
  // String versionName = '';
  // String versionCode = '';
  // bool isDialogDisplay = false;
  // bool isDeleting = false;
  ScrollController? scrollController;

  init() {}

  // Change wallet language

  // changeWalletLanguage(newValue) async {
  //   setState(ViewState.Busy);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   selectedLanguage = newValue;
  //   log.w('Selec $selectedLanguage');
  //   if (newValue == 'Chinese') {
  //     log.e('in zh');

  //     AppLocalizations.load(Locale('zh', 'ZH'));
  //     prefs.setString('lang', 'zh');
  //   } else if (newValue == 'English') {
  //     log.e('in en');
  //     AppLocalizations.load(Locale('en', 'EN'));
  //     prefs.setString('lang', 'en');
  //   }
  //   setState(ViewState.Idle);
  // }

}
