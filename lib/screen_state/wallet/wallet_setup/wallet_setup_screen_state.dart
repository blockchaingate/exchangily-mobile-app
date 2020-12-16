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
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:flutter/material.dart';
import '../../../localizations.dart';
import '../../../service_locator.dart';

class WalletSetupScreenState extends BaseState {
  final log = getLogger('WalletSetupScreenState');
  SharedService sharedService = locator<SharedService>();
  final storageService = locator<LocalStorageService>();

  final NavigationService navigationService = locator<NavigationService>();
  BuildContext context;
  bool isWallet = false;
  String errorMessage = '';

  Future checkExistingWallet() async {
    setState(ViewState.Busy);
    if (storageService.walletBalancesBody == null ||
        storageService.walletBalancesBody == '') {
      isWallet = false;
      setState(ViewState.Idle);
    } else {
      isWallet = true;
      setState(ViewState.Idle);
      await sharedService.onBackButtonPressed(DashboardViewRoute);
    }
    setState(ViewState.Idle);
  }
}
