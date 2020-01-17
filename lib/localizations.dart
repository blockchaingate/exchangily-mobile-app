import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations();

  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Generic Items
  String get title {
    return Intl.message('Exchangily',
        name: 'title', desc: 'title_exchangily_app');
  }

  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: 'confirm_button');
  }

  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: 'cancel');
  }

  String get close {
    return Intl.message('Close', name: 'close', desc: 'close');
  }

  String get backupMnemonic {
    return Intl.message('Backup Mnemonic',
        name: 'backupMnemonic', desc: 'backup_mnemonic');
  }

  String get send {
    return Intl.message('Send', name: 'send', desc: 'send');
  }

  String get receive {
    return Intl.message('Receive', name: 'receive', desc: 'receive');
  }

  String get sent {
    return Intl.message('Sent', name: 'sent', desc: 'sent');
  }

  String get received {
    return Intl.message('Received', name: 'received', desc: 'received');
  }

  String get transactions {
    return Intl.message('Transactions',
        name: 'transactions', desc: 'transactions');
  }

  String get addressCopied {
    return Intl.message('Address Copied',
        name: 'addressCopied', desc: 'address_copied');
  }

  String get address {
    return Intl.message('Address', name: 'address', desc: 'receive_address');
  }

  String get receiverWalletAddress {
    return Intl.message('Receiver Wallet Address',
        name: 'receiverWalletAddress',
        desc: 'send_screen_receiver_awallet_ddress');
  }

  String get copyAddress {
    return Intl.message('Copy Address',
        name: 'copyAddress', desc: 'copy_Address');
  }

  String get addressShare {
    return Intl.message('Address Share',
        name: 'addressShare', desc: 'address_share');
  }

  String get mnemonic {
    return Intl.message('Mnemonic', name: 'mnemonic', desc: 'mnemonic');
  }

  String get seed {
    return Intl.message('Seed', name: 'seed', desc: 'seed');
  }

  String get scanBarCode {
    return Intl.message('Scan Bar Code',
        name: 'scanBarCode', desc: 'scan_bar_code');
  }

  String get backupYourMnemonic {
    return Intl.message('Backup Your Mnemonic',
        name: 'backupYourMnemonic', desc: 'backup_your_mnemonic');
  }

  String get importMnemonic {
    return Intl.message('Import Mnemonic',
        name: 'importMnemonic', desc: 'import_mnemonic');
  }

  String get importMnemonicHint {
    return Intl.message('Import Mnemonic Hint',
        name: 'importMnemonicHint', desc: 'import_mnemonic_hint');
  }

  String get welcomeText {
    return Intl.message(
        'Welcome to Exchangily. To begin you may create a new wallet or import an existing one.',
        name: 'welcomeText',
        desc: 'welcomeText');
  }

  String get createWallet {
    return Intl.message('Create Wallet',
        name: 'createWallet', desc: 'create_wallet');
  }

  String get importWallet {
    return Intl.message('Import Wallet',
        name: 'importWallet', desc: 'import_wallet');
  }

  String get sendError {
    return Intl.message('Send Error', name: 'sendError', desc: 'send_error');
  }

  String get enterAmount {
    return Intl.message('Enter Amount',
        name: 'enterAmount', desc: 'enter_amount');
  }

  String get gasFee {
    return Intl.message('Gas Fee', name: 'gasFee', desc: 'gas_fee');
  }

  String get enterAddress {
    return Intl.message('Enter Address',
        name: 'enterAddress', desc: 'enter_address');
  }

  String get invalidAddress {
    return Intl.message('Invalid Address',
        name: 'invalidAddress', desc: 'invalid_address');
  }

  String get advance {
    return Intl.message('Advance', name: 'advance', desc: 'advance');
  }

  String get addressMising {
    return Intl.message('Address Mising',
        name: 'addressMising', desc: 'address_mising');
  }

  String get amountMissing {
    return Intl.message('Amount Missing',
        name: 'amountMissing', desc: 'amount_missing');
  }

  String get insufficientBalance {
    return Intl.message('Insufficient Balance',
        name: 'insufficientBalance', desc: 'insufficient_balance');
  }

  String get wallet {
    return Intl.message(' Wallet', name: 'wallet', desc: 'wallet');
  }

  String get market {
    return Intl.message('Market', name: 'market', desc: 'market');
  }

  String get trade {
    return Intl.message('trade', name: 'trade', desc: 'trade');
  }

  String get settings {
    return Intl.message('Settings',
        name: 'settings', desc: 'bottom_nav_settings');
  }

  String get totalBalance {
    return Intl.message('Total Balance',
        name: 'totalBalance', desc: 'total_balance');
  }

  String get assetInExchange {
    return Intl.message('Asset In Exchange',
        name: 'assetInExchange', desc: 'asset_in_exchange');
  }

  String get moveAndTrade {
    return Intl.message('Move And Trade',
        name: 'moveAndTrade', desc: 'move_and_trade');
  }

  String get withdrawToWallet {
    return Intl.message('Withdraw To Wallet',
        name: 'withdrawToWallet', desc: 'withdraw_to_wallet');
  }

  String get saveAndShareQrCode {
    return Intl.message('Save and Share Qr Code',
        name: 'saveAndShareQrCode', desc: 'save_and_share_qr_code');
  }

  String get hideSmallAmountAssets {
    return Intl.message('Hide Small Amount Assets',
        name: 'hideSmallAmountAssets', desc: 'hide_small_amount_assets');
  }

  String get assetsInExchange {
    return Intl.message('Assets In Exchange',
        name: 'assetsInExchange', desc: 'assets_in_exchange');
  }

  String get secureYourWallet {
    return Intl.message('Secure Your Wallet',
        name: 'secureYourWallet', desc: 'secure_your_wallet');
  }

  String get somethingWentWrong {
    return Intl.message('Something Went Wrong',
        name: 'Something Went Wrong', desc: 'something_went_Wrong');
  }

  String get setPasswordConditions {
    return Intl.message(
        'Enter password which is minimum 8 characters long and contains at least 1 uppercase, lowercase, number and a special character using !@#\$&*~',
        name: 'setPasswordConditions',
        desc: 'setPasswordConditions');
  }

  String get setPasswordNote {
    return Intl.message(
        'Note: For Password reset you have to keep the mnemonic safe as that is the only way to recover the wallet',
        name: 'setPasswordNote',
        desc: 'set_password_note');
  }

  String get warningBackupMnemonic {
    return Intl.message(
        'Below are the 12 words mnemonic to help you recover your wallet. Please make sure that your password is safely stored and write down this mnemonics on the paper, as this is the only way to recover your phone wallet',
        name: 'warningBackupMnemonic',
        desc: 'warning_backup_mnemonic');
  }

  String get warningImportOrConfirmMnemonic {
    return Intl.message(
        'Please type in your 12 word mnemonic phrase in the correct sequence to confirm',
        name: 'warningImportOrConfirmMnemonic',
        desc: 'warning_import_or_confirm_mnemonic');
  }

  String get enterPassword {
    return Intl.message('Enter Password',
        name: 'enterPassword', desc: 'create_enter_password');
  }

  String get confirmPassword {
    return Intl.message('Confirm Password',
        name: 'confirmPassword', desc: 'create_confirm_password');
  }

  String get available {
    return Intl.message('Available',
        name: 'available', desc: 'total_balance_available');
  }

  String get locked {
    return Intl.message('Locked', name: 'locked', desc: 'total_balance_locked');
  }

  String get value {
    return Intl.message('Value', name: 'value', desc: 'total_balance_value');
  }

  String get walletbalance {
    return Intl.message('Wallet Balance',
        name: 'walletbalance', desc: 'total_balance_wallet_balance');
  }

  String get taphereToCopyTxId {
    return Intl.message('Tap here to copy TxId',
        name: 'taphereToCopyTxId', desc: 'taphereToCopyTxId');
  }

  String get creatingWallet {
    return Intl.message('Creating Wallet',
        name: 'creatingWallet', desc: 'create_password_creatingWallet');
  }

  String get displayMnemonic {
    return Intl.message('Display Mnemonic',
        name: 'displayMnemonic', desc: 'settings_displayMnemonic');
  }

  String get hideMnemonic {
    return Intl.message('Hide Mnemonic',
        name: 'hideMnemonic', desc: 'settings_hideMnemonic');
  }

  String get deleteWallet {
    return Intl.message('Delete Wallet',
        name: 'deleteWallet', desc: 'settings_deleteWallet');
  }

  String get finishWalletBackup {
    return Intl.message('Finish Wallet Backup',
        name: 'finishWalletBackup',
        desc: 'confirm_mnemonic_finishWalletBackup');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) {
    return false;
  }
}
