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
  DialogService dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();

  SharedService sharedService = locator<SharedService>();

  final NavigationService navigationService = locator<NavigationService>();
  List<String> languages = ['English', 'Chinese'];
  String selectedLanguage;
  // bool result = false;
  String errorMessage = '';
  DialogResponse dialogResponse;
  BuildContext context;
  // String versionName = '';
  // String versionCode = '';
  // bool isDialogDisplay = false;
  // bool isDeleting = false;
  ScrollController scrollController;

  init() {}
}
