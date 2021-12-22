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

import 'dart:async';

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
  bool isVerifying = false;
  bool hasVerificationStarted = false;
  bool isHideIcon = true;
  init() async {
    await walletService.checkLanguage();

    sharedService.context = context;

    await checkExistingWallet();
  }

  Future checkVersion(context) async {
    await versionService.checkVersion(context);
  }

  importCreateNav(String actionType) async {
    // check if there is any pre existing wallet data
    String coreWalletDbData = '';
    try {
      coreWalletDbData = await coreWalletDatabaseService.getEncryptedMnemonic();
    } catch (err) {
      coreWalletDbData = '';
      log.e('importCreateNav importCreateNav CATCH err $err');
    }
    if (storageService.walletBalancesBody.isNotEmpty ||
        coreWalletDbData.isNotEmpty)
    // also show the user a dialog that there is pre existing wallet
    // data, do you want to restore that wallet or not?
    {
      await dialogService
          .showVerifyDialog(
              title: 'Existing wallet found',
              secondaryButton: 'Restore',
              description: 'Do you want to restore existing wallet?',
              buttonTitle:
                  'Import') // want to ask whether i should show Delete & Import
          .then((res) async {
        if (res.confirmed) {
          // confirmed means import wallet true
          // delete the existing wallet data
          // then import

          // otherwise ask user for wallet password to delete the existing wallet
          await deleteWallet().whenComplete(() {
            // if not then just navigate to the route
            if (actionType == 'import')
              navigationService.navigateTo(ImportWalletViewRoute,
                  arguments: actionType);
            else if (actionType == 'create')
              navigationService.navigateTo(BackupMnemonicViewRoute);
          }).catchError((err) {
            log.e('Existing wallet deletion could not be completed');
          });
        } else if (res.returnedText == 'wrong password') {
          sharedService.sharedSimpleNotification(
              AppLocalizations.of(context).pleaseProvideTheCorrectPassword);
        } else if (!res.confirmed && res.returnedText != 'Closed') {
          // if user wants to restore that then call check existing wallet func
          await checkExistingWallet();
        }
      });
    } else {
      await transactionHistoryDatabaseService
          .deleteDb()
          .whenComplete(() => log.e('transaction history database deleted!!'))
          .catchError((err) => log.e('tx history database CATCH $err'));
      if (actionType == 'import')
        navigationService.navigateTo(ImportWalletViewRoute,
            arguments: actionType);
      else if (actionType == 'create')
        navigationService.navigateTo(BackupMnemonicViewRoute);
    }
  }

  Future deleteWallet() async {
    errorMessage = '';

    setBusyForObject(isDeleting, true);

    log.w('deleting wallet');
    try {
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
          .whenComplete(() => log.e('coreWalletDatabaseService data deleted!!'))
          .catchError((err) => log.e('coreWalletDatabaseService  CATCH $err'));

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

      setBusyForObject(isDeleting, false);
    } catch (err) {
      setBusyForObject(isDeleting, false);

      errorMessage = 'Wallet deletion failed';
    }
  }

  Future checkExistingWallet() async {
    setBusy(true);

    var coreWalletDbData;

    try {
      coreWalletDbData = await coreWalletDatabaseService.getEncryptedMnemonic();
    } catch (err) {
      coreWalletDbData = '';
      log.e('importCreateNav importCreateNav CATCH err $err');
    }
    if (coreWalletDbData == null || coreWalletDbData.isEmpty) {
      log.w('coreWalletDbData is null or empty');
      var walletDatabase;
      try {
        walletDatabase = await walletDatabaseService.getAll();
      } catch (err) {
        walletDatabase = [];
      }
      if (storageService.walletBalancesBody.isNotEmpty ||
          walletDatabase.isNotEmpty) {
        // ask user's permission to verify the wallet addresses
        // show dialog to user for this reason
        var res = await dialogService.showVerifyDialog(
            title: 'Important Notice: Wallet Update',
            secondaryButton: 'Cancel',
            description:
                'Please provide the wallet password to verify and install the latest update',
            buttonTitle: AppLocalizations.of(context).confirm);
        if (!res.confirmed) {
          setBusy(false);

          return;
        } else {
          isVerifying = true;
          var res = await dialogService.showDialog(
              title: AppLocalizations.of(context).enterPassword,
              description: AppLocalizations.of(context)
                  .dialogManagerTypeSamePasswordNote,
              buttonTitle: AppLocalizations.of(context).confirm);
          if (res.confirmed) {
            var walletVerificationRes =
                await walletService.verifyWalletAddresses(res.returnedText);
            isWalletVerifySuccess = walletVerificationRes['fabAddressCheck'] &&
                walletVerificationRes['trxAddressCheck'];
            isHideIcon = false;
            // if wallet verification is true then fill encrypted mnemonic and
            // addresses in the new corewalletdatabase
            if (isWalletVerifySuccess) {
              isVerifying = false;
              goToWalletDashboard();
              Future.delayed(new Duration(seconds: 3), () {
                setBusyForObject(isHideIcon, true);
                isHideIcon = true;
                setBusyForObject(isHideIcon, false);
              });
            } else {
              Future.delayed(new Duration(seconds: 3), () {
                setBusyForObject(isHideIcon, true);
                isHideIcon = true;
                setBusyForObject(isHideIcon, false);
              });
              isWalletVerifySuccess = false;
              setBusy(false);
              // show popup
              // if wallet verification failed then generate warning
              // to delete and re-import the wallet
              // show the warning in the UI and underneath a delete wallet button
              // which will delete the wallet data and navigate to create/import view
              sharedService.context = context;
              await sharedService
                  .dialogAcceptOrReject(
                      'Current wallet is not compatible with the update, please delete the wallet and re-import again.',
                      'Delete wallet',
                      '')
                  .then((isDelete) async {
                await deleteWallet();
              });
            }
          } else if (res.returnedText == 'wrong password') {
            sharedService.sharedSimpleNotification(
                AppLocalizations.of(context).pleaseProvideTheCorrectPassword);
          }
        }
      } else {
        isWallet = false;
        isVerifying = false;
      }
    } else if (coreWalletDbData != null || coreWalletDbData.isNotEmpty) {
      await goToWalletDashboard();
    }
    hasVerificationStarted = false;
    setBusy(false);
  }

  goToWalletDashboard() async {
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
}