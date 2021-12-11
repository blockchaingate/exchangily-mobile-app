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
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_auth_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/services/version_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../localizations.dart';
import '../../../service_locator.dart';

class WalletSetupViewmodel extends BaseViewModel {
  final log = getLogger('WalletSetupViewmodel');
  SharedService sharedService = locator<SharedService>();
  final coreDataBaseService = locator<CoreWalletDatabaseService>();
  final walletDatabaseService = locator<WalletDataBaseService>();
  WalletService walletService = locator<WalletService>();
  final NavigationService navigationService = locator<NavigationService>();
  final authService = locator<LocalAuthService>();
  final storageService = locator<LocalStorageService>();
  BuildContext context;
  bool isWallet = false;
  String errorMessage = '';
  get hasAuthenticated => authService.hasAuthorized;

  VersionService versionService = locator<VersionService>();
  final dialogService = locator<DialogService>();
  bool isWalletVerifySuccess = false;
  bool isDeleting = false;

  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();

  final coreWalletDatabaseService = locator<CoreWalletDatabaseService>();
  UserSettingsDatabaseService userSettingsDatabaseService =
      locator<UserSettingsDatabaseService>();

  final _vaultService = locator<VaultService>();

  init() async {
    await walletService.checkLanguage();
    context = context;
    sharedService.context = context;
    coreDataBaseService.initDb();

    await checkExistingWallet();
  }

  Future checkVersion(context) async {
    await versionService.checkVersion(context);
  }

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
        await walletDatabaseService
            .deleteDb()
            .whenComplete(() => log.e('wallet database deleted!!'))
            .catchError((err) => log.e('wallet database CATCH $err'));

        await transactionHistoryDatabaseService
            .deleteDb()
            .whenComplete(() => log.e('trnasaction history database deleted!!'))
            .catchError((err) => log.e('tx history database CATCH $err'));

        await _vaultService
            .deleteEncryptedData()
            .whenComplete(() => log.e('encrypted data deleted!!'))
            .catchError((err) => log.e('delete encrypted CATCH $err'));

        await coreWalletDatabaseService
            .deleteDb()
            .whenComplete(
                () => log.e('coreWalletDatabaseService data deleted!!'))
            .catchError(
                (err) => log.e('coreWalletDatabaseService  CATCH $err'));

        await tokenListDatabaseService
            .deleteDb()
            .whenComplete(() => log.e('Token list database deleted!!'))
            .catchError((err) => log.e('token list database CATCH $err'));

        await userSettingsDatabaseService
            .deleteDb()
            .whenComplete(() => log.e('User settings database deleted!!'))
            .catchError((err) => log.e('user setting database CATCH $err'));

        storageService.walletBalancesBody = '';

        storageService.isShowCaseView = true;

        storageService.clearStorage();

        Navigator.pushNamed(context, '/');
      } else if (res.returnedText == 'Closed' && !res.confirmed) {
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
    });
    isDeleting = false;
    setBusy(false);
  }

  Future checkExistingWallet() async {
    setBusy(true);
    var coreWalletDbData = await coreDataBaseService.getAll();

    if (coreWalletDbData == null || coreWalletDbData == []) {
      log.w('coreWalletDbData is null or empty');
      var walletDatabase = await walletDatabaseService.getAll();
      if (storageService.walletBalancesBody.isNotEmpty ||
          walletDatabase != null ||
          walletDatabase.isNotEmpty) {
        await dialogService
            .showDialog(
                title: AppLocalizations.of(context).enterPassword,
                description: AppLocalizations.of(context)
                    .dialogManagerTypeSamePasswordNote,
                buttonTitle: AppLocalizations.of(context).confirm)
            .then((res) async {
          if (res.confirmed) {
            isWalletVerifySuccess =
                await walletService.verifyWalletAddresses(res.returnedText);
            // if wallet verification is true then fill encrypted mnemonic and
            // addresses in the new corewalletdatabase
            if (isWalletVerifySuccess) {
            } else {
              // show popup
              // if wallet verification failed then generate warning
              // to delete and re-import the wallet
              // show the warning in the UI and underneath a delete wallet button
              // which will delete the wallet data and navigate to create/import view
              await deleteWallet();
              setBusy(false);
            }
          }
        });
      } else {
        isWallet = false;
      }
    } else if (coreWalletDbData.mnemonic.isNotEmpty) {
      isWalletVerifySuccess = true;
      isWallet = true;
// add here the biometric check
      if (storageService.hasInAppBiometricAuthEnabled) {
        if (!authService.isCancelled) await authService.authenticateApp();
        if (hasAuthenticated) {
          navigationService.navigateUsingpopAndPushedNamed(DashboardViewRoute);
          storageService.hasAppGoneInTheBackgroundKey = false;
        }
        if (authService.isCancelled || !hasAuthenticated) {
          isWallet = false;
          setBusy(false);
          authService.setIsCancelledValueFalse();
        }
        // bool isDeviceSupported = await authService.isDeviceSupported();
        if (!storageService.hasPhoneProtectionEnabled)
          //|| isDeviceSupported)
          navigationService.navigateUsingpopAndPushedNamed(DashboardViewRoute);
      } else
        navigationService.navigateUsingpopAndPushedNamed(DashboardViewRoute);
      setBusy(false);

      walletService.storeTokenListInDB();
    }

    setBusy(false);
  }
}
