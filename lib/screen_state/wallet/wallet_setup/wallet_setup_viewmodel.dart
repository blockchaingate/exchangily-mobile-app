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

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_auth_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/version_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/wallet/wallet_util.dart';
import 'package:exchangilymobileapp/widgets/web_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';
import '../../../service_locator.dart';
import '../../../shared/ui_helpers.dart';

class WalletSetupViewmodel extends BaseViewModel {
  final log = getLogger('WalletSetupViewmodel');
  SharedService? sharedService = locator<SharedService>();
  final WalletDatabaseService? walletDatabaseService =
      locator<WalletDatabaseService>();
  WalletService? walletService = locator<WalletService>();
  final NavigationService? navigationService = locator<NavigationService>();
  final LocalAuthService? authService = locator<LocalAuthService>();
  final LocalStorageService? storageService = locator<LocalStorageService>();
  final CoreWalletDatabaseService? coreWalletDatabaseService =
      locator<CoreWalletDatabaseService>();
  TransactionHistoryDatabaseService? transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  TokenInfoDatabaseService? tokenListDatabaseService =
      locator<TokenInfoDatabaseService>();

  UserSettingsDatabaseService? userSettingsDatabaseService =
      locator<UserSettingsDatabaseService>();

  VersionService? versionService = locator<VersionService>();
  final DialogService? dialogService = locator<DialogService>();

  BuildContext? context;
  bool isWallet = false;
  String errorMessage = '';
  get hasAuthenticated => authService!.hasAuthorized;

  bool isWalletVerifySuccess = false;
  bool isDeleting = false;

  bool isVerifying = false;
  bool hasVerificationStarted = false;
  bool isHideIcon = true;
  var walletUtil = WalletUtil();
  bool hasData = false;
  // init
  init() async {
    sharedService!.context = context;

    checkLanguageFromStorage();

    if (storageService!.hasPrivacyConsent) {
      await checkExistingWallet();
    } else {
      Future.delayed(const Duration(milliseconds: 500), () async {
        showPrivacyConsentWidget();
      });
      return;
    }
  }

  checkLanguageFromStorage() {
    String? lang = '';
    lang = storageService!.language;
    if (lang == null || lang.isEmpty) {
      log.e('language empty - setting to english');

      lang = 'en';
    }
    storageService!.language = lang;
    FlutterI18n.refresh(context!, (Locale(lang, lang.toUpperCase())));
  }

  showPrivacyConsentWidget() {
    showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context!).size.height - 120),
        isDismissible: false,
        enableDrag: false,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(25.0),
        //   ),
        backgroundColor: const Color(0xff181439),
        context: context!,
        builder: (BuildContext context) {
          return SafeArea(
            child: ListView(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 1.33),
                  child: WebViewWidget(
                    exchangilyPrivacyUrl,
                    FlutterI18n.translate(context, "askPrivacyConsent"),
                  ),
                ),
                UIHelper.verticalSpaceSmall,
                Container(
                  // margin: const EdgeInsets.all(5),
                  color: const Color(0xff181439),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).cardColor),
                          onPressed: (() => navigationService!.goBack()),
                          child: Text(
                            FlutterI18n.translate(context, "decline"),
                            style: headText5,
                          )),
                      UIHelper.horizontalSpaceMedium,
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                          onPressed: (() => setPrivacyConsent()),
                          child: Text(
                            FlutterI18n.translate(context, "accept"),
                            style: headText5.copyWith(
                                color: black, fontWeight: FontWeight.w400),
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  setPrivacyConsent() {
    storageService!.hasPrivacyConsent = true;
    navigationService!.goBack();
    checkExistingWallet();
  }

  importCreateNav(String actionType) async {
    // check if there is any pre existing wallet data
    String? coreWalletDbData = '';
    try {
      coreWalletDbData =
          (await coreWalletDatabaseService!.getEncryptedMnemonic())!;
    } catch (err) {
      coreWalletDbData = '';
      log.e('importCreateNav importCreateNav CATCH err $err');
    }
    if (storageService!.walletBalancesBody.isNotEmpty ||
        coreWalletDbData.isNotEmpty)
    // also show the user a dialog that there is pre existing wallet
    // data, do you want to restore that wallet or not?
    {
      await dialogService!
          .showVerifyDialog(
              title: FlutterI18n.translate(context!, "existingWalletFound"),
              secondaryButton: FlutterI18n.translate(context!, "restore"),
              description:
                  '${FlutterI18n.translate(context!, "askWalletRestore")}?',
              buttonTitle: FlutterI18n.translate(context!,
                  "importWallet")) // want to ask whether i should show Delete & Import
          .then((res) async {
        if (res.confirmed!) {
          // confirmed means import wallet true
          // delete the existing wallet data
          // then import

          // otherwise ask user for wallet password to delete the existing wallet
          await deleteWallet().whenComplete(() {
            // if not then just navigate to the route
            if (actionType == 'import') {
              navigationService!
                  .navigateTo(ImportWalletViewRoute, arguments: actionType);
            } else if (actionType == 'create') {
              navigationService!.navigateTo(BackupMnemonicViewRoute);
            }
          }).catchError((err) {
            log.e('Existing wallet deletion could not be completed');
          });
        } else if (res.returnedText == 'wrong password') {
          sharedService!.sharedSimpleNotification(FlutterI18n.translate(
              context!, "pleaseProvideTheCorrectPassword"));
        } else if (!res.confirmed! && res.returnedText != 'Closed') {
          // if user wants to restore that then call check existing wallet func
          await checkExistingWallet();
        }
      });
    } else {
      await transactionHistoryDatabaseService!
          .deleteDb()
          .whenComplete(() => log.e('transaction history database deleted!!'))
          .catchError((err) => log.e('tx history database CATCH $err'));
      if (actionType == 'import') {
        navigationService!
            .navigateTo(ImportWalletViewRoute, arguments: actionType);
      } else if (actionType == 'create') {
        navigationService!.navigateTo(BackupMnemonicViewRoute);
      }
    }
  }

  // Delete wallet

  Future deleteWallet() async {
    errorMessage = '';
    setBusyForObject(isDeleting, true);
    log.w('deleting wallet');
    try {
      await walletService!.deleteWallet();

      setBusyForObject(isDeleting, false);
    } catch (err) {
      setBusyForObject(isDeleting, false);
      errorMessage = 'Wallet deletion failed';
    }
  }

  verifyWallet() async {
    var res = await dialogService!.showVerifyDialog(
        title: FlutterI18n.translate(context!, "walletUpdateNoticeTitle"),
        secondaryButton: FlutterI18n.translate(context!, "cancel"),
        description:
            FlutterI18n.translate(context!, "walletUpdateNoticeDecription"),
        buttonTitle: FlutterI18n.translate(context!, "confirm"));
    if (!res.confirmed!) {
      setBusy(false);

      return;
    } else {
      isVerifying = true;
      var res = await dialogService!.showDialog(
          title: FlutterI18n.translate(context!, "enterPassword"),
          description: FlutterI18n.translate(
              context!, "dialogManagerTypeSamePasswordNote"),
          buttonTitle: FlutterI18n.translate(context!, "confirm"));
      if (res.confirmed!) {
        var walletVerificationRes =
            await walletService!.verifyWalletAddresses(res.returnedText);
        storageService!.hasWalletVerified = true;
        isWalletVerifySuccess = walletVerificationRes['fabAddressCheck']! &&
            walletVerificationRes['trxAddressCheck']!;
        isHideIcon = false;
        // if wallet verification is true then fill encrypted mnemonic and
        // addresses in the new corewalletdatabase
        if (isWalletVerifySuccess) {
          isVerifying = false;
          goToWalletDashboard();
          Future.delayed(const Duration(seconds: 3), () {
            setBusyForObject(isHideIcon, true);
            isHideIcon = true;
            setBusyForObject(isHideIcon, false);
          });
        } else {
          Future.delayed(const Duration(seconds: 3), () {
            setBusyForObject(isHideIcon, true);
            isHideIcon = true;
            setBusyForObject(isHideIcon, false);
          });
          isWalletVerifySuccess = false;
          storageService!.hasWalletVerified = false;
          setBusy(false);
          // show popup
          // if wallet verification failed then generate warning
          // to delete and re-import the wallet
          // show the warning in the UI and underneath a delete wallet button
          // which will delete the wallet data and navigate to create/import view
          sharedService!.context = context;
          await dialogService!
              .showVerifyDialog(
                  title: FlutterI18n.translate(
                      context!, "walletVerificationFailed"),
                  description: '',
                  buttonTitle: FlutterI18n.translate(context!, "deleteWallet"),
                  secondaryButton: '')
              .then((isDelete) async {
            await deleteWallet();
          });
        }
      } else if (res.returnedText == 'Closed') {
        log.e('Dialog Closed By User');
        // setBusy(false);
        // return errorMessage = '';
      } else {
        log.e('Wrong pass');
        setBusy(false);

        sharedService!.sharedSimpleNotification(
            FlutterI18n.translate(context!, "pleaseProvideTheCorrectPassword"));
      }
    }
  }

  Future checkExistingWallet() async {
    setBusy(true);

    String? coreWalletDbData;
    try {
      coreWalletDbData =
          await coreWalletDatabaseService!.getEncryptedMnemonic();
    } catch (err) {
      coreWalletDbData = '';
      log.e('checkExistingWallet func: getEncryptedMnemonic CATCH err $err');
    }
    if (coreWalletDbData == null || coreWalletDbData.isEmpty) {
      hasData = false;
      log.w('coreWalletDbData is null or empty');
      List walletDatabase;
      try {
        await walletDatabaseService!.initDb();
        walletDatabase = await walletDatabaseService!.getAll();
      } catch (err) {
        walletDatabase = [];
      }
      // CHECK TO VERIFY IF OLD DATA IS SAVED IN STORAGE
      if (storageService!.walletBalancesBody.isNotEmpty ||
          walletDatabase.isNotEmpty) {
        // ask user's permission to verify the wallet addresses
        // show dialog to user for this reason
        if (!storageService!.hasWalletVerified) {
          await verifyWallet();
        } else {
          isVerifying = false;
          goToWalletDashboard();
        }
      } else {
        isWallet = false;
        isVerifying = false;
      }
    }
    // IF THERE IS NO OLD DATA IN STORAGE BUT NEW CORE WALLET DATA IS PRESENT IN DATABASE
    // THEN VERIFY AGAIN IF STORED DATA IS NOT PREVIOUSLY VERIFIED
    else if (coreWalletDbData != null || coreWalletDbData.isNotEmpty) {
      hasData = true;
      isVerifying = false;
      goToWalletDashboard();
    }
    hasVerificationStarted = false;
    setBusy(false);
  }

  // Go to wallet dashboard

  goToWalletDashboard() async {
    isWalletVerifySuccess = true;
    isWallet = true;
    // add here the biometric check
    if (storageService!.hasInAppBiometricAuthEnabled) {
      if (!authService!.isCancelled) await authService!.authenticateApp();
      if (hasAuthenticated) {
        navigationService!.navigateUsingpopAndPushedNamed(DashboardViewRoute);
        storageService!.hasAppGoneInTheBackgroundKey = false;
      }
      if (authService!.isCancelled || !hasAuthenticated) {
        isWallet = false;
        setBusy(false);
        authService!.setIsCancelledValueFalse();
        return;
      }
      // bool isDeviceSupported = await authService.isDeviceSupported();
      if (!storageService!.hasPhoneProtectionEnabled) {
        navigationService!.navigateUsingpopAndPushedNamed(DashboardViewRoute);
      }
    } else {
      navigationService!.navigateUsingpopAndPushedNamed(DashboardViewRoute);
    }
    setBusy(false);

    //  walletService.storeTokenListUpdatesInDB();
  }
}
