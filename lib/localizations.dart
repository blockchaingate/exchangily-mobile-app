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
    return Intl.message('Exchangily Wallet',
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
    return Intl.message('Trade', name: 'trade', desc: 'trade');
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
        name: 'somethingWentWrong', desc: 'something_went_Wrong');
  }

  String get setPasswordConditions {
    return Intl.message(
        'Enter password which is minimum 8 characters long and contains at least 1 uppercase, lowercase, number and a special character using !@#\$&*~`%^()-_',
        name: 'setPasswordConditions',
        desc: 'create_password_set_password_conditions');
  }

  String get setPasswordNote {
    return Intl.message(
        'Note: For Password reset you have to keep the mnemonic safe as that is the only way to recover the wallet',
        name: 'setPasswordNote',
        desc: 'create_password_set_password_note');
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
        name: 'enterPassword', desc: 'create_password_enter_password');
  }

  String get confirmPassword {
    return Intl.message('Confirm Password',
        name: 'confirmPassword', desc: 'create_password_confirm_password');
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
        desc: 'confirm_mnemonic_finishWallet_backup');
  }

  String get serverTimeoutPleaseTryAgainLater {
    return Intl.message('Server Timeout, Please try again later',
        name: 'serverTimeoutPleaseTryAgainLater',
        desc: 'create_password_server_timeout_please_try_again_later');
  }

  String get serverError {
    return Intl.message('Server Error',
        name: 'serverError', desc: 'create_password_serverError');
  }

  String get emptyPassword {
    return Intl.message('Empty Password',
        name: 'emptyPassword', desc: 'create_password_empty_password');
  }

  String get pleaseFillBothPasswordFields {
    return Intl.message('Please fill both password fields',
        name: 'pleaseFillBothPasswordFields',
        desc: 'create_password_please_fill_both_password_fields');
  }

  String get passwordConditionsMismatch {
    return Intl.message('Password Conditions Mismatch',
        name: 'passwordConditionsMismatch',
        desc: 'create_password_password_conditions_mismatch');
  }

  String get passwordConditions {
    return Intl.message(
        'Please enter the password that satisfy above conditions',
        name: 'passwordConditions',
        desc: 'create_password_conditions');
  }

  String get passwordMismatch {
    return Intl.message('Password Mismatch',
        name: 'passwordMismatch', desc: 'create_password_password_mismatch');
  }

  String get passwordRetype {
    return Intl.message('Please retype the same password in both fields',
        name: 'passwordRetype', desc: 'create_password_password_retype');
  }

  String get typeYourWalletPassword {
    return Intl.message('Type your wallet password',
        name: 'typeYourWalletPassword',
        desc: 'dialog_manager_type_your_wallet_password');
  }

  String get dialogManagerTypeSamePasswordNote {
    return Intl.message(
        'Type the same password which you have entered while creating the wallet',
        name: 'dialogManagerTypeSamePasswordNote',
        desc: 'dialog_manager_type_same_password_note');
  }

  String get transanctionFailed {
    return Intl.message('Transanction Failed',
        name: 'transanctionFailed', desc: 'send_state_transanction_failed');
  }

  String get pleaseProvideTheCorrectPassword {
    return Intl.message('Please provide the correct Password',
        name: 'pleaseProvideTheCorrectPassword',
        desc: 'dialog_please_provide_the_correct_password');
  }

  String get emptyAddress {
    return Intl.message('Empty Address',
        name: 'emptyAddress', desc: 'send_state_error_empty_address');
  }

  String get pleaseEnterAnAddress {
    return Intl.message('Please enter an address',
        name: 'pleaseEnterAnAddress',
        desc: 'send_state_error_please_enter_an_address');
  }

  String get invalidAmount {
    return Intl.message('Invalid Amount',
        name: 'invalidAmount', desc: 'send_state_error_invalid_amount');
  }

  String get pleaseEnterValidNumber {
    return Intl.message('Please enter a valid number',
        name: 'pleaseEnterValidNumber',
        desc: 'send_state_error_please_enter_valid_number');
  }

  String get transactionId {
    return Intl.message('Transaction Id',
        name: 'transactionId', desc: 'send_state_transaction_id');
  }

  String get copiedSuccessfully {
    return Intl.message('Copied Successfully',
        name: 'copiedSuccessfully', desc: 'send_state_copied_successfully');
  }

  String get changeWalletLanguage {
    return Intl.message('Change Wallet Language',
        name: 'changeWalletLanguage', desc: 'settings_change_wallet_language');
  }

  String get volume {
    return Intl.message('Volume', name: 'volume', desc: 'volume_text');
  }

  String get price {
    return Intl.message('Price', name: 'price', desc: 'price_text');
  }

  String get high {
    return Intl.message('High', name: 'high', desc: 'high_text');
  }

  String get low {
    return Intl.message('Low', name: 'low', desc: 'low_text');
  }

  String get orderBook {
    return Intl.message('Order Book',
        name: 'orderBook', desc: 'order_book_text');
  }

  String get marketTrades {
    return Intl.message('Market Trades',
        name: 'marketTrades', desc: 'market_trades_text');
  }

  String get coin {
    return Intl.message('Coin', name: 'coin', desc: 'price_text');
  }

  String get amount {
    return Intl.message('Amount', name: 'amount', desc: 'amount_text');
  }

  String get lockedAmount {
    return Intl.message('Locked Amount',
        name: 'lockedAmount', desc: 'locked_amount_text');
  }

  String get buy {
    return Intl.message('Buy', name: 'buy', desc: 'buy_text');
  }

  String get sell {
    return Intl.message('Sell', name: 'sell', desc: 'sell_text');
  }

  String get transactionAmount {
    return Intl.message('Transaction Amount',
        name: 'transactionAmount', desc: 'transaction_amount_text');
  }

  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: 'quantity_text');
  }

  String get openOrders {
    return Intl.message('Open Orders',
        name: 'openOrders', desc: 'open_orders_text');
  }

  String get closeOrders {
    return Intl.message('Close Orders',
        name: 'closeOrders', desc: 'close_orders_text');
  }

  String get assets {
    return Intl.message('Assets', name: 'assets', desc: 'assets_text');
  }

  String get type {
    return Intl.message('Type', name: 'type', desc: 'type_text');
  }

  String get pair {
    return Intl.message('Pair', name: 'pair', desc: 'pair_text');
  }

  String get filledAmount {
    return Intl.message('Filled Amount',
        name: 'filledAmount', desc: 'filled_amount_text');
  }

  String get invalidMnemonic {
    return Intl.message('Invalid Mnemonic',
        name: 'invalidMnemonic',
        desc: 'confirm_mnemonic_error_invalid_mnemonic');
  }

  String get pleaseFillAllTheTextFieldsCorrectly {
    return Intl.message('Please fill all the text fields correctly',
        name: 'pleaseFillAllTheTextFieldsCorrectly',
        desc:
            'confirm_mnemonic_error_please_fill_all_the_text_fields_correctly');
  }

  String get addGas {
    return Intl.message('Add Gas', name: 'addGas', desc: 'add_gas');
  }

  String get depositTransactionSuccess {
    return Intl.message('Deposit transaction was made successfully',
        name: 'depositTransactionSuccess', desc: 'deposit_transaction_success');
  }

  String get depositTransactionFailed {
    return Intl.message('Deposit transaction failed',
        name: 'depositTransactionFailed', desc: 'deposit_transaction_failed');
  }

  String get move {
    return Intl.message('Move',
        name: 'move', desc: 'deposit_withdraw_move_header');
  }

  String get redeposit {
    return Intl.message('Redeposit',
        name: 'redeposit', desc: 'deposit_withdraw_redeposit_header');
  }

  String get toWallet {
    return Intl.message('to wallet',
        name: 'toWallet', desc: 'withdraw_to_wallet');
  }

  String get toExchange {
    return Intl.message('to exchange',
        name: 'toExchange', desc: 'deposit_to_exchange');
  }

  String get gasPrice {
    return Intl.message('Gas Price', name: 'gasPrice', desc: 'gas_price');
  }

  String get gasLimit {
    return Intl.message('Gas Limit', name: 'gasLimit', desc: 'gas_limit');
  }

  String get addGasTransactionSuccess {
    return Intl.message('Add gas transaction was made successfully',
        name: 'addGasTransactionSuccess', desc: 'add_gas_transaction_success');
  }

  String get addGasTransactionFailed {
    return Intl.message('Add gas transaction failed',
        name: 'addGasTransactionFailed', desc: 'add_gas_transaction_failed');
  }

  String get sellOrders {
    return Intl.message('Sell Orders',
        name: 'sellOrders', desc: 'trade_widget_market_sell_orders');
  }

  String get buyOrders {
    return Intl.message('Buy Orders',
        name: 'buyOrders', desc: 'trade_widget_market_buy_orders');
  }

  String get reDeposit {
    return Intl.message('Re-Deposit',
        name: 'reDeposit', desc: 'wallet_feature_redeposit');
  }

  String get smartContract {
    return Intl.message('Smart Contract',
        name: 'smartContract', desc: 'wallet_feature_smart_contract');
  }

  String get gas {
    return Intl.message('Gas', name: 'gas', desc: 'gas_balance_dashboard');
  }

  String get confirmDeposit {
    return Intl.message('Confirm Deposit',
        name: 'confirmDeposit', desc: 'confirm_deposit_dashboard');
  }

  String get genericError {
    return Intl.message('An error occured. Try again later.',
        name: 'genericError', desc: 'error_generic');
  }

  String get sendTransactionComplete {
    return Intl.message('Send Transaction Complete',
        name: 'sendTransactionComplete',
        desc: 'flushbar_title_send_transaction_complete');
  }

  String get isOnItsWay {
    return Intl.message('is on its way',
        name: 'isOnItsWay', desc: 'flushbar_message_send_transaction_complete');
  }

  String get smartContractAddress {
    return Intl.message('Smart Contract Address',
        name: 'smartContractAddress', desc: 'smart_contract_address');
  }

  String get smartContractName {
    return Intl.message('Smart Contract Name',
        name: 'smartContractName', desc: 'smart_contract_name');
  }

  String get payableValue {
    return Intl.message('Payable Value',
        name: 'payableValue', desc: 'smart_contract_payable_value');
  }

  String get function {
    return Intl.message('Function',
        name: 'function', desc: 'smart_contract_function');
  }

  String get loading {
    return Intl.message('Loading', name: 'loading', desc: 'generic_loading');
  }

  String get checkingExistingWallet {
    return Intl.message('Checking existing wallet',
        name: 'checkingExistingWallet',
        desc: 'wallet_setup_checking_existing_wallet');
  }

  String get restoringWallet {
    return Intl.message('Restoring wallet',
        name: 'restoringWallet',
        desc: 'wallet_setup_checking_restoring_wallet');
  }

  String get closeTheApp {
    return Intl.message('Do you want to close the app',
        name: 'closeTheApp', desc: 'dialog_popup_close_the_app');
  }

  String get yes {
    return Intl.message('Yes', name: 'yes', desc: 'generic_yes');
  }

  String get no {
    return Intl.message('No', name: 'no', desc: 'generic_no');
  }

  String get fabLockForExgAirdrop {
    return Intl.message('Fab Lock For Exg Airdrop',
        name: 'fabLockForExgAirdrop', desc: 'fabLock_for_exg_airdrop');
  }

  String get passwordMatched {
    return Intl.message('Password Matched',
        name: 'passwordMatched', desc: 'create_password_password_matched');
  }

  String get passwordDoesNotMatched {
    return Intl.message('Password does not matched',
        name: 'passwordDoesNotMatched',
        desc: 'create_password_password_does_not_matched');
  }

  String get userAccessDenied {
    return Intl.message('User Access Denied',
        name: 'userAccessDenied', desc: 'send_screen_user_access_denied');
  }

  String get unknownError {
    return Intl.message('Unknown Error',
        name: 'unknownError', desc: 'send_screen_unknown_error');
  }

  String get scanCancelled {
    return Intl.message('Scan Cancelled',
        name: 'scanCancelled', desc: 'send_screen_scan_cancelled');
  }

  String get userReturnedByPressingBackButton {
    return Intl.message('User returned by pressing the back button',
        name: 'userReturnedByPressingBackButton',
        desc: 'send_screen_user_returned_by_pressing_back_button');
  }

  String get date {
    return Intl.message('Date', name: 'date', desc: 'generic_Date');
  }

  String get minimumAmount {
    return Intl.message('Minimum amount',
        name: 'minimumAmount', desc: 'minimum_amount');
  }

  String get kanbanGasFee {
    return Intl.message('Kanban Gas Fee',
        name: 'kanbanGasFee', desc: 'kanban_gas_fee');
  }

  String get kanbanGasPrice {
    return Intl.message('Kanban Gas Price',
        name: 'kanbanGasPrice', desc: 'kanban_gas_price');
  }

  String get kanbanGasLimit {
    return Intl.message('Kanban Gas Limit',
        name: 'kanbanGasLimit', desc: 'kanban_gas_limit');
  }

  String get satoshisPerByte {
    return Intl.message('Satoshis/byte',
        name: 'satoshisPerByte', desc: 'satoshis_per_byte');
  }

  String get priceChange {
    return Intl.message('Price Change',
        name: 'priceChange', desc: 'trade_price_change');
  }

  String get redepositCompleted {
    return Intl.message('Redeposit Completed',
        name: 'redepositCompleted', desc: 'redeposit_redeposit_ompleted');
  }

  String get redepositError {
    return Intl.message('Redeposit error',
        name: 'redepositError', desc: 'redeposit_error');
  }

  String get redepositItemNotSelected {
    return Intl.message('Redeposit item not selected',
        name: 'redepositItemNotSelected', desc: 'redeposit_item_not_selected');
  }

  String get minimumAmountError {
    return Intl.message('Minimum amount error',
        name: 'minimumAmountError', desc: 'withdraw_Minimum amount error');
  }

  String get yourWithdrawMinimumAmountaIsNotSatisfied {
    return Intl.message('Your withdraw minimum amount is not satisfied',
        name: 'yourWithdrawMinimumAmountaIsNotSatisfied',
        desc: 'withdraw_your_withdraw_minimum_amount_is_not_satisfied');
  }

  String get withdrawTransactionSuccessful {
    return Intl.message('Withdraw transaction was made successfully',
        name: 'withdrawTransactionSuccessful',
        desc: 'withdraw_transaction_was_successfully');
  }

  String get withdrawTransactionFailed {
    return Intl.message('Withdraw transaction failed',
        name: 'withdrawTransactionFailed', desc: 'withdraw_transaction_failed');
  }

  String get placeOrderTransactionSuccessful {
    return Intl.message('Place order transaction was made successfully',
        name: 'placeOrderTransactionSuccessful',
        desc: 'place_order_transaction_was_successfully');
  }

  String get transactionHistory {
    return Intl.message('Transaction History',
        name: 'transactionHistory',
        desc: 'wallet_features_transaction_history');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh', 'hi'].contains(locale.languageCode);
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
