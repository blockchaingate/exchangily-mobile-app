import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations();

  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations? of(BuildContext context) {
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

  String get moveAndTrade {
    return Intl.message('Move to exchange',
        name: 'moveAndTrade', desc: 'move_and_trade');
  }

  String get withdrawToWallet {
    return Intl.message('Move to wallet',
        name: 'withdrawToWallet', desc: 'withdraw_to_wallet');
  }

  String get saveAndShareQrCode {
    return Intl.message('Save and Share QR Code',
        name: 'saveAndShareQrCode', desc: 'save_and_share_qr_code');
  }

  String get hideSmallAmountAssets {
    return Intl.message('Hide Small Amount Assets',
        name: 'hideSmallAmountAssets', desc: 'hide_small_amount_assets');
  }

  String get inExchange {
    return Intl.message('In Exchange',
        name: 'inExchange', desc: 'assets_in_exchange');
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
        'Please accurately record and securely store the following twelve word mnemonic, do not disclose the mnemonic anybody else. Disclosure of your mnemonic will result in your account being compromised and you will lose all of your funds.',
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
    return Intl.message('Tap here to copy txId',
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

  String get placeOrderTransactionFailed {
    return Intl.message('Place order transaction failed',
        name: 'placeOrderTransactionFailed',
        desc: 'place_order_transaction_failed');
  }

  String get notice {
    return Intl.message('Notice', name: 'notice', desc: 'notice');
  }

  String get testVersion {
    return Intl.message('You are using the test version',
        name: 'testVersion', desc: 'test_version');
  }

  String get campaignInstructions {
    return Intl.message('Campaign Instructions',
        name: 'campaignInstructions', desc: 'campaign_instructions');
  }

  String get tapHereToEnterInCampaign {
    return Intl.message('Tap here to enter in campaign',
        name: 'tapHereToEnterInCampaign', desc: 'campaign_enter');
  }

  String get login {
    return Intl.message('Login', name: 'login', desc: 'campaign_login');
  }

  String get email {
    return Intl.message('Email', name: 'email', desc: 'campaign_email');
  }

  String get password {
    return Intl.message('Password',
        name: 'password', desc: 'campaign_password');
  }

  String get register {
    return Intl.message('Register',
        name: 'register', desc: 'campaign_register');
  }

  String get clickToSeeThePassword {
    return Intl.message('Click to see the password',
        name: 'clickToSeeThePassword',
        desc: 'campaign_click_to_see_the_password');
  }

  String get enterYourEmail {
    return Intl.message('Enter your email',
        name: 'enterYourEmail', desc: 'campaign_register_email');
  }

  String get pasteExgAddress {
    return Intl.message('Tap on wallet icon to paste Exg Wallet Address',
        name: 'pasteExgAddress', desc: 'campaign_register_paste_exg_address');
  }

  String get referralCode {
    return Intl.message('Referral Code',
        name: 'referralCode', desc: 'campaign_register_referral_code');
  }

  String get alreadyHaveAnAccount {
    return Intl.message('Already have an account',
        name: 'alreadyHaveAnAccount',
        desc: 'campaign_register_already_have_an_account');
  }

  String get signUp {
    return Intl.message('Sign Up',
        name: 'signUp', desc: 'campaign_register_sign_up');
  }

  String get showPassword {
    return Intl.message('Show password',
        name: 'showPassword', desc: 'campaign_register_show_password');
  }

  String get registrationSuccessful {
    return Intl.message('Registration Successful',
        name: 'registrationSuccessful',
        desc: 'campaign_register_registration_successful');
  }

  String get pleaseCheckYourEmailToActivateYourAccount {
    return Intl.message('Please check your email to activate your account',
        name: 'pleaseCheckYourEmailToActivateYourAccount',
        desc: 'campaign_register_check_email_to_activate_account');
  }

  String get pleaseEnterYourEmailAddress {
    return Intl.message('Please enter your email address',
        name: 'pleaseEnterYourEmailAddress',
        desc: 'campaign_register_please_enter_your_email_address');
  }

  String get pleaseFillYourPassword {
    return Intl.message('Please fill your password',
        name: 'pleaseFillYourPassword',
        desc: 'campaign_register_please_enter_your_password');
  }

  String get confirmPasswordFieldIsEmpty {
    return Intl.message('Confirm password field is empty',
        name: 'confirmPasswordFieldIsEmpty',
        desc: 'campaign_register_Confirm_password_field_is_empty');
  }

  String get exgWalletAddressIsRequired {
    return Intl.message('Exg wallet address is required',
        name: 'exgWalletAddressIsRequired',
        desc: 'campaign_register_exg_wallet_address_is_required');
  }

  String get bothPasswordFieldsShouldMatch {
    return Intl.message('Both password fields should match',
        name: 'bothPasswordFieldsShouldMatch',
        desc: 'campaign_register_both_password_fields_should_match');
  }

  String get checkingAccountDetails {
    return Intl.message('Checking account details',
        name: 'checkingAccountDetails',
        desc: 'campaign_login_checking_login_details');
  }

  String get welcome {
    return Intl.message('Welcome',
        name: 'welcome', desc: 'campaign_dashboard_welcome');
  }

  String get logout {
    return Intl.message('Logout',
        name: 'logout', desc: 'campaign_dashboard_logout');
  }

  String get event {
    return Intl.message('Event', name: 'event', desc: 'campaign_event');
  }

  String get readCampaignInstructions {
    return Intl.message('Read Campaign Instructions',
        name: 'readCampaignInstructions',
        desc: 'campaign_read_campaign_instructions');
  }

  String get myReferralCode {
    return Intl.message('My Referral Code',
        name: 'myReferralCode', desc: 'campaign_my_referral_code');
  }

  String get level {
    return Intl.message('Level',
        name: 'level', desc: 'campaign_dashboard_level');
  }

  String get teamsTotalValue {
    return Intl.message('Teams Total Value',
        name: 'teamsTotalValue', desc: 'campaign_dashboard_teams_total_value');
  }

  String get myReferrals {
    return Intl.message('My Referrals',
        name: 'myReferrals', desc: 'campaign_dashboard_my_referrals');
  }

  String get payment {
    return Intl.message('Payment', name: 'payment', desc: 'campaign_payment');
  }

  String get paymentType {
    return Intl.message('Payment Type',
        name: 'paymentType', desc: 'campaign_payment_type');
  }

  String get bankName {
    return Intl.message('Bank Name',
        name: 'bankName', desc: 'campaign_bank_name');
  }

  String get routingNumber {
    return Intl.message('Routing Number',
        name: 'routingNumber', desc: 'campaign_routing_number');
  }

  String get bankAccount {
    return Intl.message('Bank Account',
        name: 'bankAccount', desc: 'campaign_bank_account');
  }

  String get receiveAddress {
    return Intl.message('Receive Address',
        name: 'receiveAddress', desc: 'campaign_recieve_address');
  }

  String get balance {
    return Intl.message('Balance', name: 'balance', desc: 'campaign_balance');
  }

  String get orderInformation {
    return Intl.message('Order Information',
        name: 'orderInformation', desc: 'campaign_order_information');
  }

  String get status {
    return Intl.message('Status', name: 'status', desc: 'campaign_status');
  }

  String get waiting {
    return Intl.message('Waiting', name: 'waiting', desc: 'campaign_waiting');
  }

  String get paid {
    return Intl.message('Paid', name: 'paid', desc: 'campaign_paid');
  }

  String get paymentReceived {
    return Intl.message('Payment Received',
        name: 'paymentReceived', desc: 'campaign_payment_received');
  }

  String get failed {
    return Intl.message('Failed', name: 'failed', desc: 'campaign_failed');
  }

  String get orderCancelled {
    return Intl.message('Order Cancelled',
        name: 'orderCancelled', desc: 'campaign_order_cancelled');
  }

  String get createOrderFailed {
    return Intl.message('Create order failed',
        name: 'createOrderFailed', desc: 'campaign_create_order_failed');
  }

  String get success {
    return Intl.message('Success', name: 'success', desc: 'campaign_success');
  }

  String get yourOrderHasBeenCreated {
    return Intl.message('Your order has been created',
        name: 'yourOrderHasBeenCreated',
        desc: 'campaign_your_order_has_been_created');
  }

  String get loadOrdersFailed {
    return Intl.message('Could not load orders, Please try again later',
        name: 'loadOrdersFailed', desc: 'campaign_load_orders_failed');
  }

  String get pleaseFillAllTheFields {
    return Intl.message('Please fill all the fields',
        name: 'pleaseFillAllTheFields',
        desc: 'campaign_please_fill_all_the_fields');
  }

  String get pleaseEnterAmountLessThanYourWallet {
    return Intl.message(
        'Please enter the amount equals or less than your available wallet balance',
        name: 'pleaseEnterAmountLessThanYourWallet',
        desc: 'campaign_please_enter_amount_less_than_your_wallet_bal');
  }

  String get myRewardDetails {
    return Intl.message('My Reward Details',
        name: 'myRewardDetails', desc: 'campaign_my_reward_details');
  }

  String get referrals {
    return Intl.message('Referrals',
        name: 'referrals', desc: 'campaign_referrals');
  }

  String get bankWireDetails {
    return Intl.message('Bank Wire Details',
        name: 'bankWireDetails', desc: 'campaign_bank__wire_details');
  }

  String get myTotalAssets {
    return Intl.message('My Total Assets',
        name: 'myTotalAssets', desc: 'campaign_dashboard_my_total_assets');
  }

  String get totalTokenHolding {
    return Intl.message('Total Token Holding',
        name: 'totalTokenHolding',
        desc: 'campaign_dashboard_total_token__holding');
  }

  String get tokenDetails {
    return Intl.message('Token Details',
        name: 'tokenDetails', desc: 'campaign_dashboard_token_details');
  }

  String get totalTokenAmount {
    return Intl.message('Total Token Amount',
        name: 'totalTokenAmount', desc: 'campaign_total__token_amount');
  }

  String get rewardsToken {
    return Intl.message('Rewards Token',
        name: 'rewardsToken', desc: 'campaign_rewards_token');
  }

  String get myInvestment {
    return Intl.message('My Investment',
        name: 'myInvestment',
        desc: 'campaign_dashboard_my_investment_without_rewards');
  }

  String get teamReward {
    return Intl.message('Team Reward',
        name: 'teamReward', desc: 'campaign_dashboard_team_reward');
  }

  String get myTokens {
    return Intl.message('My Tokens',
        name: 'myTokens', desc: 'campaign_dashboard_my_tokens');
  }

  String get tokenQuantity {
    return Intl.message('Token Quantity',
        name: 'tokenQuantity',
        desc: 'campaign_dashboard_payment_token_quantity');
  }

  String get referralCount {
    return Intl.message('Referral Count',
        name: 'referralCount', desc: 'campaign_dashboard_referral_count');
  }

  String get myReferralReward {
    return Intl.message('My Referral Reward',
        name: 'myReferralReward',
        desc: 'campaign_dashboard_my_referral_reward');
  }

  String get descriptionIsRequired {
    return Intl.message('Please fill the description field',
        name: 'descriptionIsRequired',
        desc: 'campaign_payment_update_description');
  }

  String get diamond {
    return Intl.message('Diamond',
        name: 'diamond', desc: 'campaign_dashboard_level_diamond');
  }

  String get gold {
    return Intl.message('Gold',
        name: 'gold', desc: 'campaign_dashboard_level_gold');
  }

  String get silver {
    return Intl.message('silver',
        name: 'silver', desc: 'campaign_dashboard_level_silver');
  }

  String get paymentDescription {
    return Intl.message('Payment Description',
        name: 'paymentDescription',
        desc: 'campaign_payment_payment_description');
  }

  String get paymentDescriptionNote {
    return Intl.message('Please fill this field to confirm the order',
        name: 'paymentDescriptionNote',
        desc: 'campaign_payment_payment_description_note');
  }

  String get orderId {
    return Intl.message('Order Id',
        name: 'orderId', desc: 'campaign_payment_order_id');
  }

  String get confirmPayment {
    return Intl.message('Confirm Payment',
        name: 'confirmPayment', desc: 'campaign_payment_order_id');
  }

  String get checkingCredentials {
    return Intl.message('Checking Credentials',
        name: 'checkingCredentials',
        desc: 'campaign_login_checking_credentials');
  }

  String get cancelOrder {
    return Intl.message('Cancel Order',
        name: 'cancelOrder', desc: 'campaign_payment_cancel_order');
  }

  String get orderCreatedSuccessfully {
    return Intl.message('Order Created Successfully',
        name: 'orderCreatedSuccessfully',
        desc: 'campaign_payment_order_created_successfully');
  }

  String get pleaseincludeYourOrderNumber {
    return Intl.message('Please include your order number',
        name: 'pleaseincludeYourOrderNumber',
        desc: 'campaign_payment_include_your_order_number');
  }

  String get afterHyphenWhenYouMakePayment {
    return Intl.message('after hyphen when you make payment',
        name: 'afterHyphenWhenYouMakePayment',
        desc: 'campaign_payment_after_hyphen_when_you_make_payment');
  }

  String get updateYourOrderStatus {
    return Intl.message('Update your order status',
        name: 'updateYourOrderStatus',
        desc: 'campaign_payment_update_your_order_status');
  }

  String get team {
    return Intl.message('Team',
        name: 'team', desc: 'campaign_dashboard_team_details');
  }

  String get members {
    return Intl.message('Members',
        name: 'members', desc: 'campaign_dashboard_team_details_members');
  }

  String get totalValue {
    return Intl.message('Total Value',
        name: 'totalValue',
        desc: 'campaign_dashboard_team_details_total_value');
  }

  String get totalQuantity {
    return Intl.message('Total Quantity',
        name: 'totalQuantity',
        desc: 'campaign_dashboard_team_details_total_quantity');
  }

  String get teamDetails {
    return Intl.message('Team Details',
        name: 'teamDetails', desc: 'campaign_dashboard_team_details_heading');
  }

  String get orderDetails {
    return Intl.message('Order Details',
        name: 'orderDetails', desc: 'campaign_dashboard_order_details_heading');
  }

  String get forgotPassword {
    return Intl.message('Forgot Password',
        name: 'forgotPassword', desc: 'campaign_login_forgot_assword');
  }

  String get passwordResetError {
    return Intl.message('Password Reset Error',
        name: 'passwordResetError', desc: 'campaign_password_reset_error');
  }

  String get pleaseEnterTheCorrectEmail {
    return Intl.message('Please enter the correct email',
        name: 'pleaseEnterTheCorrectEmail',
        desc: 'campaign_enter_correct_email');
  }

  String get passwordReset {
    return Intl.message('Password Reset',
        name: 'passwordReset', desc: 'campaign_password_reset');
  }

  String get resetPasswordEmailInstruction {
    return Intl.message(
        'Please check your email and follow instructions to reset your account password',
        name: 'resetPasswordEmailInstruction',
        desc: 'campaign_reset_password_email_instruction');
  }

  String get updateStatus {
    return Intl.message('Update status',
        name: 'updateStatus', desc: 'campaign_payment_update_status');
  }

  String get orderCancelledNotification {
    return Intl.message('Your order has been cancelled successfully',
        name: 'orderCancelledNotification',
        desc: 'campaign_payment_order_cancelled_notification');
  }

  String get orderUpdateNotification {
    return Intl.message('Your order status has been updated successfully',
        name: 'orderUpdateNotification',
        desc: 'campaign_payment_order_updated_notification');
  }

  String get redepositFailedError {
    return Intl.message('Redeposit failed',
        name: 'redepositFailedError', desc: 'redeposit_failed_error');
  }

  String get pendingConfirmDeposit {
    return Intl.message('Pending confirm deposit',
        name: 'pendingConfirmDeposit', desc: 'pending_confirm_deposit');
  }

  String get pleaseConfirmYour {
    return Intl.message('Please confirm your',
        name: 'pleaseConfirmYour', desc: 'please_confirm_your');
  }

  String get deposit {
    return Intl.message('Deposit', name: 'deposit', desc: 'deposit');
  }

  String get insufficientGasAmount {
    return Intl.message('Insufficient gas amount',
        name: 'insufficientGasAmount', desc: 'Insufficient gas amount');
  }

  String get pleaseAddGasToTrade {
    return Intl.message('Please add gas to trade',
        name: 'pleaseAddGasToTrade', desc: 'please_add_gas_to_trade');
  }

  String get hideDialogWarnings {
    return Intl.message('Hide dialog warnings',
        name: 'hideDialogWarnings', desc: 'hide_dialog_warnings');
  }

  String get showDialogWarnings {
    return Intl.message('Show dialog warnings',
        name: 'showDialogWarnings', desc: 'show_dialog_warnings');
  }

  String get doNotShowTheseWarnings {
    return Intl.message('Do not show these warnings',
        name: 'doNotShowTheseWarnings', desc: 'do_not_show_these_warnings');
  }

  String get withdraw {
    return Intl.message('Withdraw',
        name: 'withdraw', desc: 'transaction_history_withdraw');
  }

  String get marketPriceFetchFailed {
    return Intl.message(
        'Could not fetch the market price at the moment, please try again later',
        name: 'marketPriceFetchFailed',
        desc: 'wallet_dashboard_market_price_fetch_failed');
  }

  String get completed {
    return Intl.message('Completed',
        name: 'completed', desc: 'transaction_history_completed');
  }

  String get requireRedeposit {
    return Intl.message('Require redeposit',
        name: 'requireRedeposit',
        desc: 'transaction_history_require_redeposit');
  }

  String get error {
    return Intl.message('Error',
        name: 'error', desc: 'transaction_history_error');
  }

  String get pending {
    return Intl.message('Pending',
        name: 'pending', desc: 'transaction_history_pending');
  }

  String get allOrders {
    return Intl.message('All Orders',
        name: 'allOrders', desc: 'exchange_all_orders');
  }

  String get myOrders {
    return Intl.message('My Orders',
        name: 'myOrders', desc: 'exchange_my_orders');
  }

  String get change {
    return Intl.message('Change', name: 'change', desc: 'change_text');
  }

  String get reload {
    return Intl.message('reload', name: 'reload', desc: 'reload_text');
  }

  String get noRouteDefined {
    return Intl.message('No route defined for',
        name: 'noRouteDefined', desc: 'NoRouteDefined_text');
  }

  String get myRewardTokens {
    return Intl.message('My Reward Tokens',
        name: 'myRewardTokens', desc: 'myRewardTokens_text');
  }

  String get inputValidation {
    return Intl.message('input validation',
        name: 'inputValidation', desc: 'inputValidation_text');
  }

  String get showOnlyCurrentPairOrders {
    return Intl.message('Show only current pair orders',
        name: 'showOnlyCurrentPairOrders',
        desc: 'exchange_my_orders_show_current_pair_orders');
  }

  String get showAllPairOrders {
    return Intl.message('Show all pair\'s orders',
        name: 'showAllPairOrders',
        desc: 'exchange_my_orders_show_current_pair_orders');
  }

  String get symbol {
    return Intl.message('Symbol',
        name: 'symbol', desc: 'exchange_my_exchange_assets');
  }

  String get backupMnemonicNoticeTitle {
    return Intl.message(
        'What is mnemonic? Why it is so important to backup mnemonic phrases?',
        name: 'backupMnemonicNoticeTitle',
        desc: 'backup_mnemonic_notice_title');
  }

  String get backupMnemonicNoticeContent {
    return Intl.message(
        "A mnemonic phrase is a list of words which store all the information needed to recover virtual coin funds on-chain. Wallet software will typically generate a mnemonic phrase and instruct the user to write it down on paper. If the user's computer breaks or their hard drive becomes corrupted, they can download the same wallet software again and use the paper backup to get their virtual coins back. Anybody else who discovers the phrase can steal the virtual coins, so it must be kept safe like jewels or cash. For example, it must not be typed into any website. A mnemonic phrase are an excellent way of backing up and storing bitcoins and so they are used by almost all well-regarded wallets.",
        name: 'backupMnemonicNoticeContent',
        desc: 'backup_mnemonic_notice_content');
  }

  String get ticker {
    return Intl.message("Ticker", name: 'ticker', desc: 'ticker_text');
  }

  String get vol {
    return Intl.message("Vol", name: 'vol', desc: 'vol_text');
  }

  String get percentage {
    return Intl.message("Percentage",
        name: 'percentage', desc: 'percentage_text_team_rewards_view');
  }

  String get teamLeader {
    return Intl.message("Team Leader",
        name: 'teamLeader', desc: 'teamLeader_team_rewards_details_view');
  }

  String get pleaseUpdateYourAppFrom {
    return Intl.message("Please update your app from",
        name: 'pleaseUpdateYourAppFrom',
        desc: 'wallet_dashboard_text_please_update_your_app_from');
  }

  String get appUpdateNotice {
    return Intl.message("App Update Notice",
        name: 'appUpdateNotice',
        desc: 'wallet_dashboard_text_app_update_notice');
  }

  String get toLatestBuild {
    return Intl.message("to latest build",
        name: 'toLatestBuild', desc: 'wallet_dashboard_text_to_latest_build');
  }

  // Just translate the word "in" from English to Chinese
  String get inText {
    return Intl.message("in",
        name: 'inText', desc: 'wallet_dashboard_text_in_text');
  }

  String get submitYourAnswer {
    return Intl.message("Submit your answer",
        name: 'submitYourAnswer',
        desc: 'wallet_dashboard_text_submit_your_answer');
  }

  String get question {
    return Intl.message("Question",
        name: 'question', desc: 'wallet_dashboard_text_question');
  }

  String get freeFabUpdate {
    return Intl.message("Free Fab Update",
        name: 'freeFabUpdate', desc: 'wallet_dashboard_text_free_fab_update');
  }

  String get freeFabSuccess {
    return Intl.message("Your will get your FAB shortly, Thank you",
        name: 'freeFabSuccess', desc: 'wallet_dashboard_text_free_fab_success');
  }

  String get getFree {
    return Intl.message("Get free",
        name: 'getFree', desc: 'wallet_dashboard_text_get_free');
  }

  String get incorrectAnswer {
    return Intl.message("Incorrect Answer",
        name: 'incorrectAnswer',
        desc: 'wallet_dashboard_text_free_fab_incorrect_answer');
  }

  String get freeFabUsedAlready {
    return Intl.message("Free FAB feature has been used already",
        name: 'freeFabUsedAlready',
        desc: 'wallet_dashboard_text_free_fab_used_already');
  }

  String get updateNow {
    return Intl.message("Update now",
        name: 'updateNow', desc: 'wallet_dashboard_text_go_to_app_store');
  }

  String get later {
    return Intl.message("Later",
        name: 'later', desc: 'app_update_popup_button_text_later');
  }

  String get sessionExpired {
    return Intl.message("Session Expired",
        name: 'sessionExpired', desc: 'camapign_login_session_expired');
  }

  String get memberDetails {
    return Intl.message("Member Details",
        name: 'memberDetails', desc: 'camapign_team_reward_member_details');
  }

  String get website {
    return Intl.message("Website",
        name: 'website', desc: 'wallet_dashboard_app_update_popup');
  }

  String get clickOnWebsiteButton {
    return Intl.message(
        "or click on website button to download the latest version from the official Exchangily site",
        name: 'clickOnWebsiteButton',
        desc: 'wallet_dashboard_app_update_popup');
  }

  String get serverBusy {
    return Intl.message("Server Busy",
        name: 'serverBusy', desc: 'campaign_list_serverBusy');
  }

  String get bindpay {
    return Intl.message("Bindpay", name: 'bindpay', desc: 'bindpay');
  }

  String get tranfser {
    return Intl.message("Transfer",
        name: 'tranfser', desc: 'flash_pay_tranfser');
  }

  String get share {
    return Intl.message("Share",
        name: 'share', desc: 'flash_pay_tranfser_share_address');
  }

  String get validationError {
    return Intl.message("Validation Error",
        name: 'validationError', desc: 'flash_pay_tranfser_validationError');
  }

  String get pleaseTryAgainLater {
    return Intl.message("Please try again later",
        name: 'pleaseTryAgainLater',
        desc: 'flash_pay_tranfser_please_try_again_later');
  }

  String get pleaseCorrectTheFormatOfReceiveAddress {
    return Intl.message("Please correct the format of receive address",
        name: 'pleaseCorrectTheFormatOfReceiveAddress',
        desc: 'flash_pay_tranfser_correct_format_of_receive_address');
  }

  String get deletingWallet {
    return Intl.message("Deleting wallet",
        name: 'deletingWallet', desc: 'settings_view_deleting_wallet');
  }

  String get pleaseTransferFundsToExchangeWalletToUseBindpay {
    return Intl.message(
        "Please transfer funds to exchange wallet to use bindpay",
        name: 'pleaseTransferFundsToExchangeWalletToUseBindpay',
        desc:
            'bindpay_please_transfer_funds_to_exchange_wallet_to_use_bindpay');
  }

  String get pleaseTransferFundsToExchangeWalletToUseLightningRemit {
    return Intl.message(
        "Please transfer funds to exchange wallet to use Lightning Remit",
        name: 'pleaseTransferFundsToExchangeWalletToUseLightningRemit',
        desc: 'please_transfer_funds_to_exchange_wallet_to_use_LightningRemit');
  }

  String get important {
    return Intl.message("Important",
        name: 'important', desc: 'backup_mnemonic_important');
  }

  String get noInternetWarning {
    return Intl.message(
        "Cannot load the content as your device is not to the internet",
        name: 'noInternetWarning',
        desc: 'no_internet_warning');
  }

  String get buySellInstruction1 {
    return Intl.message("Make sure you have coin balance to trade",
        name: 'buySellInstruction1', desc: 'buy_Sell_instruction_1');
  }

  String get settingsShowcaseInstructions {
    return Intl.message("Show instructions for how to use certain app features",
        name: 'settingsShowcaseInstructions',
        desc: 'settings_showcase_instructions');
  }

  String get note {
    return Intl.message("Note", name: 'note', desc: 'note_text');
  }

  String get walletDashboardInstruction1 {
    return Intl.message(
        "Please add gas by using FAB coin to use wallet and exchange features",
        name: 'walletDashboardInstruction1',
        desc: 'wallet_dashboard_instruction_1');
  }

  String get walletDashboardInstruction2 {
    return Intl.message(
        'Transfer funds from wallet to exchange to trade and use lightning remit',
        name: 'walletDashboardInstruction2',
        desc: 'wallet_dashboard_instruction_2');
  }

  String get noCoinBalance {
    return Intl.message('No coin balance in exchange',
        name: 'noCoinBalance', desc: 'no_coin_balance');
  }

  String get transferFundsToExchangeUsingDepositButton {
    return Intl.message(
        'Please transfer funds to exchange using deposit button in wallet dashboard',
        name: 'transferFundsToExchangeUsingDepositButton',
        desc: 'transfer_funds_to_exchange_using_deposit_button');
  }

  String get pleaseChooseTheLanguage {
    return Intl.message('Please choose the language',
        name: 'pleaseChooseTheLanguage', desc: 'Please choose the language');
  }

  String get selectCoin {
    return Intl.message('Select Coin', name: 'selectCoin', desc: 'select_coin');
  }

  String get cancelledOrders {
    return Intl.message('Cancelled Orders',
        name: 'cancelledOrders', desc: 'cancelled_orders');
  }

  String get details {
    return Intl.message('Details', name: 'details', desc: 'etails');
  }

  String get closedOrders {
    return Intl.message('Closed Orders',
        name: 'closedOrders', desc: 'close_orders_text');
  }

  String get releaseToLoadMore {
    return Intl.message(' Release to load more',
        name: 'releaseToLoadMore', desc: ' release_to_load_more');
  }

  String get useAsiaNode {
    return Intl.message('Use Asia Node',
        name: 'useAsiaNode', desc: ' use_asia_node_settings_view');
  }

  String get useNorthAmericanNode {
    return Intl.message('Use North American Node',
        name: 'useNorthAmericanNode',
        desc: 'use_north_american_node_settings_view');
  }

  String get inProgress {
    return Intl.message('In Progress',
        name: 'inProgress', desc: 'progress_transaction_history');
  }

  String get kanban {
    return Intl.message('Kanban',
        name: 'kanban', desc: 'kanban_progress_transaction_history');
  }

  String get transactionDetails {
    return Intl.message('Transaction Details',
        name: 'transactionDetails',
        desc: 'transaction_details_transactiion_history');
  }

  String get action {
    return Intl.message('Action',
        name: 'action', desc: 'action_transaction_history');
  }

  String get chain {
    return Intl.message('Chain',
        name: 'chain', desc: 'chain_transaction_history');
  }

  String get tsWalletNote {
    return Intl.message(
        'The TS (Threshold) wallet holds deposited funds for withdrawal, and is controlled collectively by the miners of the kanban blockchain.',
        name: 'tsWalletNote',
        desc: 'withdraw_ts_wallet');
  }

  String get specialWithdrawNote {
    return Intl.message(
        'For some coins, the exchange allows users to select which blockchain they would like to withdraw. If many users withdraw to the same blockchain, there may be an imbalance of available funds to withdraw between the two chains.',
        name: 'specialWithdrawNote',
        desc: 'withdraw_special_withdraw_note');
  }

  String get specialWithdrawFailNote {
    return Intl.message(
        'In this case, withdraws on one chain may be temporarily unavailable, and you may withdraw a smaller amount, withdraw to another chain.',
        name: 'specialWithdrawFailNote',
        desc: 'special_withdraw_fail_note');
  }

  String get specialExchangeBalanceNote {
    return Intl.message(
        'The displayed exchange balance is shared for coins that exist on multiple blockchains. Withdraws may be made to the chain of your choice.',
        name: 'specialExchangeBalanceNote',
        desc: 'special_exchange_balance_note');
  }

  String get fee {
    return Intl.message('Fee', name: 'fee', desc: 'fee');
  }

  String get updateWallet {
    return Intl.message('Update wallet',
        name: 'updateWallet', desc: 'update_wallet_dashboard');
  }

  String get sameBalanceNote {
    return Intl.message('Same balance as',
        name: 'sameBalanceNote', desc: 'sameBalanceNote');
  }

  String get noEvent {
    return Intl.message('No Event', name: 'noEvent', desc: 'noEvent');
  }

  String get maxAmount {
    return Intl.message('Max Amount', name: 'maxAmount', desc: 'max_amount');
  }

  String get networkIssue {
    return Intl.message('Network issue',
        name: 'networkIssue', desc: 'networkIssue');
  }

  String get lowTsWalletBalanceErrorFirstPart {
    return Intl.message('Current maximum available balance for withdraw is',
        name: 'lowTsWalletBalanceErrorFirstPart',
        desc: 'lowTsWalletBalanceErrorText');
  }

  String get lowTsWalletBalanceErrorSecondPart {
    return Intl.message(
        'You may reduce your withdraw amount or you may withdraw by using other chain',
        name: 'lowTsWalletBalanceErrorSecondPart',
        desc: 'lowTsWalletBalanceErrorText');
  }

  String get allAssets {
    return Intl.message('All Assets', name: 'allAssets', desc: 'all_assets');
  }

  String get favAssets {
    return Intl.message('Favorite Assets',
        name: 'favAssets', desc: 'fav_assets');
  }

  String get importingWallet {
    return Intl.message('Importing Wallet',
        name: 'importingWallet', desc: 'importing_wallet_create_password');
  }

  String get incorrectDepositAmountOfTwoTx {
    return Intl.message('Incorrect amount for two transactions',
        name: 'incorrectDepositAmountOfTwoTx',
        desc: 'incorrect_deposit_amount_of_two_tx');
  }

  String get decimalLimit {
    return Intl.message('Decimal limit',
        name: 'decimalLimit', desc: 'decimal_limit');
  }

  String get unConfirmedBalance {
    return Intl.message('Unconfirmed Balance',
        name: 'unConfirmedBalance', desc: 'unConfirmed_balance');
  }

  String get availableBalanceInfoTitle {
    return Intl.message('Available Balance Info',
        name: 'availableBalanceInfoTitle',
        desc: 'available_balance_info_title');
  }

  String get availableBalanceInfoContent {
    return Intl.message(
        'The available balance reflects the total value of your unspent transactions outputs (utxos) for transactions that have already been confirmed on the blockchain so user can only use current available balance for the new transactions until the previous transactions complete',
        name: 'availableBalanceInfoContent',
        desc: 'available_balance_info_content');
  }

  String get unConfirmedBalanceInfoTitle {
    return Intl.message('Unconfirmed Balance Info',
        name: 'unConfirmedBalanceInfoTitle',
        desc: 'unConfirmed_balance_info_title');
  }

  String get unConfirmedBalanceInfoContent {
    return Intl.message(
        'The unconfirmed balance reflects the total value of your unspent transactions outputs (utxos) for transactions that are still pending (not yet confirmed on the blockchain)',
        name: 'unConfirmedBalanceInfoContent',
        desc: 'unConfirmed_balance_info_content');
  }

  String get unConfirmedBalanceInfoExample {
    return Intl.message(
        'This is the normal transaction process where unconfirmed funds may be more than the amount user sends. For example, when you purchase 50 dollars worth of groceries in a cash transaction and you give the shopkeeper a 100 dollar bill, then you get your change(50 dollars) back by the shopkeeper',
        name: 'unConfirmedBalanceInfoExample',
        desc: 'unConfirmed_balance_info_example');
  }

  String get insufficientGasBalance {
    return Intl.message('Insufficient gas balance',
        name: 'insufficientGasBalance', desc: 'Insufficient_gas_balance');
  }

  String get unlock {
    return Intl.message('Unlock', name: 'unlock', desc: 'unlock');
  }

  String get enableBiometricAuthentication {
    return Intl.message('Enable Biometric Authentication',
        name: 'enableBiometricAuthentication',
        desc: 'settings_enable_biometric_authentication');
  }

  String get pleaseSetupDeviceSecurity {
    return Intl.message('Please setup device security in the settings',
        name: 'pleaseSetupDeviceSecurity',
        desc: 'walletsetup_please_setup_device_security');
  }

  String get remit {
    return Intl.message('Remit', name: 'remit', desc: 'bottom_nav_remit');
  }

  String get withdrawPopupNote {
    return Intl.message('Please confirm the coin you want to withdraw',
        name: 'withdrawPopupNote', desc: 'withdraw_popup_note');
  }

  String get lockedOutTemp {
    return Intl.message('Too many failed attempts, please try after sometime.',
        name: 'lockedOutTemp', desc: 'locked_out_temp');
  }

  String get lockedOutPerm {
    return Intl.message(
        'Too many failed attempts, please try to unlock using Pin orPassword',
        name: 'lockedOutPerm',
        desc: 'locked_out_perm');
  }

  String get lockAppNow {
    return Intl.message('Lock App Now',
        name: 'lockAppNow', desc: 'lock_app_now');
  }

  String get time {
    return Intl.message('Time', name: 'time', desc: 'time_market_orders');
  }

  String get totalExchangeBalance {
    return Intl.message('Exchange Balance',
        name: 'totalExchangeBalance', desc: 'totalExchangeBalance');
  }

  String get totalLockedBalance {
    return Intl.message('Locked Balance',
        name: 'totalLockedBalance', desc: 'totalLockedBalance');
  }

  String get totalWalletBalance {
    return Intl.message('Total Wallet Balance',
        name: 'totalWalletBalance', desc: 'totalWalletBalance');
  }

  String get importantWalletUpdateNotice {
    return Intl.message(
        'Invalid password: If you fill the valid password then please delete the current wallet in Settings and then re-import, to use the latest wallet',
        name: 'importantWalletUpdateNotice',
        desc: 'importantWalletUpdateNotice');
  }

  String get verifyingWallet {
    return Intl.message('Verifying Wallet',
        name: 'verifyingWallet', desc: 'verifyingWallet');
  }

  String get deleteWalletConfirmationPopup {
    return Intl.message('Delete wallet confirmation',
        name: 'deleteWalletConfirmationPopup',
        desc: 'deleteWalletConfirmationPopup');
  }

  String get logo {
    return Intl.message('Logo',
        name: 'logo', desc: 'wallet_dashboard_custom_token_logo');
  }

  String get addToken {
    return Intl.message('Add Token', name: 'addToken', desc: 'addToken');
  }

  String get editTokenList {
    return Intl.message('Edit Token List',
        name: 'editTokenList', desc: 'editTokenList');
  }

  String get customTokens {
    return Intl.message('Custom Tokens',
        name: 'customTokens', desc: 'customTokens');
  }

  String get totalSupply {
    return Intl.message('Total Supply',
        name: 'totalSupply', desc: 'totalSupply');
  }

  String get add {
    return Intl.message('Add', name: 'add', desc: 'add');
  }

  String get remove {
    return Intl.message('Remove', name: 'remove', desc: 'remove');
  }

  String get restore {
    return Intl.message('Restore', name: 'restore', desc: 'restore');
  }

  String get existingWalletFound {
    return Intl.message('Existing wallet found',
        name: 'existingWalletFound', desc: 'existingWalletFound');
  }

  String get askWalletRestore {
    return Intl.message('Do you want to restore existing wallet',
        name: 'askWalletRestore', desc: 'askWalletRestore');
  }

  String get walletVerificationFailed {
    return Intl.message(
        'Current wallet is not compatible with the update, please delete the wallet and re-import again.',
        name: 'walletVerificationFailed',
        desc: 'walletVerificationFailed');
  }

  String get walletUpdateNoticeTitle {
    return Intl.message('Important Notice: Wallet Update',
        name: 'walletUpdateNoticeTitle', desc: 'walletUpdateNoticeTitle');
  }

  String get walletUpdateNoticeDecription {
    return Intl.message(
        'Please provide the wallet password to verify and install the latest update',
        name: 'walletUpdateNoticeDecription',
        desc: 'walletUpdateNoticeDecription');
  }

  String get favoriteTokens {
    return Intl.message('Favorite Tokens',
        name: 'favoriteTokens', desc: 'favoriteTokens');
  }

  String get showSmallAmountAssets {
    return Intl.message('Show Small Amount Assets',
        name: 'showSmallAmountAssets', desc: 'show_small_amount_assets');
  }

  String get currentVersion {
    return Intl.message('Current version',
        name: 'currentVersion', desc: 'currentVersion');
  }

  String get latestVersion {
    return Intl.message('Latest version',
        name: 'latestVersion', desc: 'latestVersion');
  }

  String get downloadLatestApkFromServer {
    return Intl.message('Download latest apk from server',
        name: 'downloadLatestApkFromServer',
        desc: 'downloadLatestApkFromServer');
  }

  String get googlePlay {
    return Intl.message('Google Play', //谷歌播放
        name: 'googlePlay',
        desc: 'googlePlay');
  }

  String get noEventNote {
    return Intl.message(
        'Currently there are no events but you can check our blog and announcement page to get the latest news and updates',
        name: 'noEventNote',
        desc: 'noEventNote');
  }

  String get blog {
    return Intl.message('Blog', name: 'blog', desc: 'blog');
  }

  String get announcements {
    return Intl.message('Announcements',
        name: 'announcements', desc: 'announcements');
  }

  String get updatedAmountTranslation {
    return Intl.message('Amount',
        name: 'updatedAmountTranslation', desc: 'updatedAmountTranslation');
  }

  String get unavailable {
    return Intl.message('Unavailable',
        name: 'unavailable', desc: 'unavailable');
  }

  String get visitWebsite {
    return Intl.message('Visit Website',
        name: 'visitWebsite', desc: 'visitWebsite');
  }

  String get domain {
    return Intl.message('Domain', name: 'domain', desc: 'send_domain');
  }

  String get invalidDomain {
    return Intl.message('Invalid Domain',
        name: 'invalidDomain', desc: 'send_invalidDomain');
  }

  String get addressNotSet {
    return Intl.message('Address not set',
        name: 'addressNotSet', desc: 'send_addressNotSet');
  }

  String get others {
    return Intl.message('Others', name: 'others', desc: 'exchange_otherpairs');
  }

  String get askPrivacyConsent {
    return Intl.message(
        'Please read our privacy policy and accept to use the app',
        name: 'askPrivacyConsent',
        desc: 'askPrivacyConsent');
  }

  String get decline {
    return Intl.message('Decline', name: 'decline', desc: 'decline');
  }

  String get accept {
    return Intl.message('Accept', name: 'accept', desc: 'accept');
  }

  String get userDataUsage {
    return Intl.message('We do not store or share user data',
        name: 'userDataUsage', desc: 'userDataUsage');
  }

  String get privacyPolicy {
    return Intl.message('Privacy Policy',
        name: 'privacyPolicy', desc: 'privacyPolicy');
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
