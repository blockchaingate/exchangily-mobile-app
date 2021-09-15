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

import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/services/local_auth_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../localizations.dart';
import '../../../service_locator.dart';

class WalletSetupViewmodel extends BaseViewModel {
  final log = getLogger('WalletSetupScreenState');
  SharedService sharedService = locator<SharedService>();
  WalletDataBaseService dataBaseService = locator<WalletDataBaseService>();
  WalletService walletService = locator<WalletService>();
  final NavigationService navigationService = locator<NavigationService>();
  final localAuthService = locator<LocalAuthService>();
  BuildContext context;
  bool isWallet = false;
  String errorMessage = '';
  bool _hasAuthenticated = false;
  get hasAuthenticated => localAuthService.isAuthenticated;
  Future checkExistingWallet() async {
    setBusy(true);
    await dataBaseService.getAll().then((res) async {
      if (res == null || res == []) {
        log.w('Database is null or empty');

        isWallet = false;
      } else if (res.isNotEmpty) {
        isWallet = true;
// add here the biometric check
        await localAuthService.authenticate();

        if (localAuthService.isAuthenticated)
          await navigationService
              .navigateUsingpopAndPushedNamed(DashboardViewRoute);
        else {
          _hasAuthenticated = localAuthService.isAuthenticated;
          isWallet = false;
          setBusy(false);
        }
      }
    }).timeout(Duration(seconds: 20), onTimeout: () {
      log.e('In time out');
      isWallet = false;
      setBusy(false);
      errorMessage =
          AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater;
    }).catchError((error) {
      setBusy(false);
      isWallet = false;
      log.e(error);
    });
    setBusy(false);
  }
}
