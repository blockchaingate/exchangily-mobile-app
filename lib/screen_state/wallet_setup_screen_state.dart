import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_database_service.dart';
import 'package:flutter/material.dart';

import '../localizations.dart';
import '../service_locator.dart';

class WalletSetupScreenState extends BaseState {
  final log = getLogger('WalletSetupScreenState');
  SharedService sharedService = locator<SharedService>();
  WalletDataBaseService dataBaseService = locator<WalletDataBaseService>();
  BuildContext context;
  bool isWallet = false;
  String errorMessage = '';

  Future checkExistingWallet() async {
    setState(ViewState.Busy);
    await dataBaseService.getAll().then((res) {
      if (res == null || res == []) {
        log.w('Database is null or empty');
        setState(ViewState.Idle);
        isWallet = false;
      } else if (res.isNotEmpty) {
        setState(ViewState.Idle);
        isWallet = true;
        Navigator.of(context).pushNamed('/dashboard');
      }
    }).timeout(Duration(seconds: 20), onTimeout: () {
      log.e('In time out');
      isWallet = false;
      setState(ViewState.Idle);
      errorMessage =
          AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater;
    }).catchError((error) {
      setState(ViewState.Idle);
      isWallet = false;
      log.e(error);
    });
    setState(ViewState.Idle);
  }
}
