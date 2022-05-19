// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'messages';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "action": MessageLookupByLibrary.simpleMessage("Action"),
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "addGas": MessageLookupByLibrary.simpleMessage("Add Gas"),
        "addGasTransactionFailed":
            MessageLookupByLibrary.simpleMessage("Add gas transaction failed"),
        "addGasTransactionSuccess": MessageLookupByLibrary.simpleMessage(
            "Add gas transaction was made successfully"),
        "addToken": MessageLookupByLibrary.simpleMessage("Add Token"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "addressCopied": MessageLookupByLibrary.simpleMessage("Address Copied"),
        "addressMising": MessageLookupByLibrary.simpleMessage("Address Mising"),
        "addressShare": MessageLookupByLibrary.simpleMessage("Address Share"),
        "advance": MessageLookupByLibrary.simpleMessage("Advance"),
        "afterHyphenWhenYouMakePayment": MessageLookupByLibrary.simpleMessage(
            "after hyphen when you make payment"),
        "allAssets": MessageLookupByLibrary.simpleMessage("All Assets"),
        "allOrders": MessageLookupByLibrary.simpleMessage("All Orders"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account"),
        "amount": MessageLookupByLibrary.simpleMessage("Amount"),
        "amountMissing": MessageLookupByLibrary.simpleMessage("Amount Missing"),
        "appUpdateNotice":
            MessageLookupByLibrary.simpleMessage("App Update Notice"),
        "askWalletRestore": MessageLookupByLibrary.simpleMessage(
            "Do you want to restore existing wallet"),
        "assets": MessageLookupByLibrary.simpleMessage("Assets"),
        "available": MessageLookupByLibrary.simpleMessage("Available"),
        "availableBalanceInfoContent": MessageLookupByLibrary.simpleMessage(
            "The available balance reflects the total value of your unspent transactions outputs (utxos) for transactions that have already been confirmed on the blockchain so user can only use current available balance for the new transactions until the previous transactions complete"),
        "availableBalanceInfoTitle":
            MessageLookupByLibrary.simpleMessage("Available Balance Info"),
        "backupMnemonic":
            MessageLookupByLibrary.simpleMessage("Backup Mnemonic"),
        "backupMnemonicNoticeContent": MessageLookupByLibrary.simpleMessage(
            "A mnemonic phrase is a list of words which store all the information needed to recover virtual coin funds on-chain. Wallet software will typically generate a mnemonic phrase and instruct the user to write it down on paper. If the user's computer breaks or their hard drive becomes corrupted, they can download the same wallet software again and use the paper backup to get their virtual coins back. Anybody else who discovers the phrase can steal the virtual coins, so it must be kept safe like jewels or cash. For example, it must not be typed into any website. A mnemonic phrase are an excellent way of backing up and storing bitcoins and so they are used by almost all well-regarded wallets."),
        "backupMnemonicNoticeTitle": MessageLookupByLibrary.simpleMessage(
            "What is mnemonic? Why it is so important to backup mnemonic phrases?"),
        "backupYourMnemonic":
            MessageLookupByLibrary.simpleMessage("Backup Your Mnemonic"),
        "balance": MessageLookupByLibrary.simpleMessage("Balance"),
        "bankAccount": MessageLookupByLibrary.simpleMessage("Bank Account"),
        "bankName": MessageLookupByLibrary.simpleMessage("Bank Name"),
        "bankWireDetails":
            MessageLookupByLibrary.simpleMessage("Bank Wire Details"),
        "bindpay": MessageLookupByLibrary.simpleMessage("Bindpay"),
        "bothPasswordFieldsShouldMatch": MessageLookupByLibrary.simpleMessage(
            "Both password fields should match"),
        "buy": MessageLookupByLibrary.simpleMessage("Buy"),
        "buyOrders": MessageLookupByLibrary.simpleMessage("Buy Orders"),
        "buySellInstruction1": MessageLookupByLibrary.simpleMessage(
            "Make sure you have coin balance to trade"),
        "campaignInstructions":
            MessageLookupByLibrary.simpleMessage("Campaign Instructions"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelOrder": MessageLookupByLibrary.simpleMessage("Cancel Order"),
        "cancelledOrders":
            MessageLookupByLibrary.simpleMessage("Cancelled Orders"),
        "chain": MessageLookupByLibrary.simpleMessage("Chain"),
        "change": MessageLookupByLibrary.simpleMessage("Change"),
        "changeWalletLanguage":
            MessageLookupByLibrary.simpleMessage("Change Wallet Language"),
        "checkingAccountDetails":
            MessageLookupByLibrary.simpleMessage("Checking account details"),
        "checkingCredentials":
            MessageLookupByLibrary.simpleMessage("Checking Credentials"),
        "checkingExistingWallet":
            MessageLookupByLibrary.simpleMessage("Checking existing wallet"),
        "clickOnWebsiteButton": MessageLookupByLibrary.simpleMessage(
            "or click on website button to download the latest version from the official Exchangily site"),
        "clickToSeeThePassword":
            MessageLookupByLibrary.simpleMessage("Click to see the password"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "closeTheApp": MessageLookupByLibrary.simpleMessage(
            "Do you want to close the app"),
        "closedOrders": MessageLookupByLibrary.simpleMessage("Closed Orders"),
        "coin": MessageLookupByLibrary.simpleMessage("Coin"),
        "completed": MessageLookupByLibrary.simpleMessage("Completed"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmDeposit":
            MessageLookupByLibrary.simpleMessage("Confirm Deposit"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "confirmPasswordFieldIsEmpty": MessageLookupByLibrary.simpleMessage(
            "Confirm password field is empty"),
        "confirmPayment":
            MessageLookupByLibrary.simpleMessage("Confirm Payment"),
        "copiedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Copied Successfully"),
        "copyAddress": MessageLookupByLibrary.simpleMessage("Copy Address"),
        "createOrderFailed":
            MessageLookupByLibrary.simpleMessage("Create order failed"),
        "createWallet": MessageLookupByLibrary.simpleMessage("Create Wallet"),
        "creatingWallet":
            MessageLookupByLibrary.simpleMessage("Creating Wallet"),
        "currentVersion":
            MessageLookupByLibrary.simpleMessage("Current version"),
        "customTokens": MessageLookupByLibrary.simpleMessage("Custom Tokens"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "decimalLimit": MessageLookupByLibrary.simpleMessage("Decimal limit"),
        "deleteWallet": MessageLookupByLibrary.simpleMessage("Delete Wallet"),
        "deleteWalletConfirmationPopup":
            MessageLookupByLibrary.simpleMessage("Delete wallet confirmation"),
        "deletingWallet":
            MessageLookupByLibrary.simpleMessage("Deleting wallet"),
        "deposit": MessageLookupByLibrary.simpleMessage("Deposit"),
        "depositTransactionFailed":
            MessageLookupByLibrary.simpleMessage("Deposit transaction failed"),
        "depositTransactionSuccess": MessageLookupByLibrary.simpleMessage(
            "Deposit transaction was made successfully"),
        "descriptionIsRequired": MessageLookupByLibrary.simpleMessage(
            "Please fill the description field"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "dialogManagerTypeSamePasswordNote": MessageLookupByLibrary.simpleMessage(
            "Type the same password which you have entered while creating the wallet"),
        "diamond": MessageLookupByLibrary.simpleMessage("Diamond"),
        "displayMnemonic":
            MessageLookupByLibrary.simpleMessage("Display Mnemonic"),
        "doNotShowTheseWarnings":
            MessageLookupByLibrary.simpleMessage("Do not show these warnings"),
        "downloadLatestApkFromServer": MessageLookupByLibrary.simpleMessage(
            "Download latest apk from server"),
        "editTokenList":
            MessageLookupByLibrary.simpleMessage("Edit Token List"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emptyAddress": MessageLookupByLibrary.simpleMessage("Empty Address"),
        "emptyPassword": MessageLookupByLibrary.simpleMessage("Empty Password"),
        "enableBiometricAuthentication": MessageLookupByLibrary.simpleMessage(
            "Enable Biometric Authentication"),
        "enterAddress": MessageLookupByLibrary.simpleMessage("Enter Address"),
        "enterAmount": MessageLookupByLibrary.simpleMessage("Enter Amount"),
        "enterPassword": MessageLookupByLibrary.simpleMessage("Enter Password"),
        "enterYourEmail":
            MessageLookupByLibrary.simpleMessage("Enter your email"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "event": MessageLookupByLibrary.simpleMessage("Event"),
        "exgWalletAddressIsRequired": MessageLookupByLibrary.simpleMessage(
            "Exg wallet address is required"),
        "existingWalletFound":
            MessageLookupByLibrary.simpleMessage("Existing wallet found"),
        "fabLockForExgAirdrop":
            MessageLookupByLibrary.simpleMessage("Fab Lock For Exg Airdrop"),
        "failed": MessageLookupByLibrary.simpleMessage("Failed"),
        "favAssets": MessageLookupByLibrary.simpleMessage("Favorite Assets"),
        "favoriteTokens":
            MessageLookupByLibrary.simpleMessage("Favorite Tokens"),
        "fee": MessageLookupByLibrary.simpleMessage("Fee"),
        "filledAmount": MessageLookupByLibrary.simpleMessage("Filled Amount"),
        "finishWalletBackup":
            MessageLookupByLibrary.simpleMessage("Finish Wallet Backup"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password"),
        "freeFabSuccess": MessageLookupByLibrary.simpleMessage(
            "Your will get your FAB shortly, Thank you"),
        "freeFabUpdate":
            MessageLookupByLibrary.simpleMessage("Free Fab Update"),
        "freeFabUsedAlready": MessageLookupByLibrary.simpleMessage(
            "Free FAB feature has been used already"),
        "function": MessageLookupByLibrary.simpleMessage("Function"),
        "gas": MessageLookupByLibrary.simpleMessage("Gas"),
        "gasFee": MessageLookupByLibrary.simpleMessage("Gas Fee"),
        "gasLimit": MessageLookupByLibrary.simpleMessage("Gas Limit"),
        "gasPrice": MessageLookupByLibrary.simpleMessage("Gas Price"),
        "genericError": MessageLookupByLibrary.simpleMessage(
            "An error occured. Try again later."),
        "getFree": MessageLookupByLibrary.simpleMessage("Get free"),
        "gold": MessageLookupByLibrary.simpleMessage("Gold"),
        "hideDialogWarnings":
            MessageLookupByLibrary.simpleMessage("Hide dialog warnings"),
        "hideMnemonic": MessageLookupByLibrary.simpleMessage("Hide Mnemonic"),
        "hideSmallAmountAssets":
            MessageLookupByLibrary.simpleMessage("Hide Small Amount Assets"),
        "high": MessageLookupByLibrary.simpleMessage("High"),
        "importMnemonic":
            MessageLookupByLibrary.simpleMessage("Import Mnemonic"),
        "importMnemonicHint":
            MessageLookupByLibrary.simpleMessage("Import Mnemonic Hint"),
        "importWallet": MessageLookupByLibrary.simpleMessage("Import Wallet"),
        "important": MessageLookupByLibrary.simpleMessage("Important"),
        "importantWalletUpdateNotice": MessageLookupByLibrary.simpleMessage(
            "Invalid password: If you fill the valid password then please delete the current wallet in Settings and then re-import, to use the latest wallet"),
        "importingWallet":
            MessageLookupByLibrary.simpleMessage("Importing Wallet"),
        "inExchange": MessageLookupByLibrary.simpleMessage("In Exchange"),
        "inProgress": MessageLookupByLibrary.simpleMessage("In Progress"),
        "inText": MessageLookupByLibrary.simpleMessage("in"),
        "incorrectAnswer":
            MessageLookupByLibrary.simpleMessage("Incorrect Answer"),
        "incorrectDepositAmountOfTwoTx": MessageLookupByLibrary.simpleMessage(
            "Incorrect amount for two transactions"),
        "inputValidation":
            MessageLookupByLibrary.simpleMessage("input validation"),
        "insufficientBalance":
            MessageLookupByLibrary.simpleMessage("Insufficient Balance"),
        "insufficientGasAmount":
            MessageLookupByLibrary.simpleMessage("Insufficient gas amount"),
        "insufficientGasBalance":
            MessageLookupByLibrary.simpleMessage("Insufficient gas balance"),
        "invalidAddress":
            MessageLookupByLibrary.simpleMessage("Invalid Address"),
        "invalidAmount": MessageLookupByLibrary.simpleMessage("Invalid Amount"),
        "invalidMnemonic":
            MessageLookupByLibrary.simpleMessage("Invalid Mnemonic"),
        "isOnItsWay": MessageLookupByLibrary.simpleMessage("is on its way"),
        "kanban": MessageLookupByLibrary.simpleMessage("Kanban"),
        "kanbanGasFee": MessageLookupByLibrary.simpleMessage("Kanban Gas Fee"),
        "kanbanGasLimit":
            MessageLookupByLibrary.simpleMessage("Kanban Gas Limit"),
        "kanbanGasPrice":
            MessageLookupByLibrary.simpleMessage("Kanban Gas Price"),
        "later": MessageLookupByLibrary.simpleMessage("Later"),
        "latestVersion": MessageLookupByLibrary.simpleMessage("Latest version"),
        "level": MessageLookupByLibrary.simpleMessage("Level"),
        "loadOrdersFailed": MessageLookupByLibrary.simpleMessage(
            "Could not load orders, Please try again later"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading"),
        "lockAppNow": MessageLookupByLibrary.simpleMessage("Lock App Now"),
        "locked": MessageLookupByLibrary.simpleMessage("Locked"),
        "lockedAmount": MessageLookupByLibrary.simpleMessage("Locked Amount"),
        "lockedOutPerm": MessageLookupByLibrary.simpleMessage(
            "Too many failed attempts, please try to unlock using Pin orPassword"),
        "lockedOutTemp": MessageLookupByLibrary.simpleMessage(
            "Too many failed attempts, please try after sometime."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logo": MessageLookupByLibrary.simpleMessage("Logo"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "low": MessageLookupByLibrary.simpleMessage("Low"),
        "lowTsWalletBalanceErrorFirstPart":
            MessageLookupByLibrary.simpleMessage(
                "Current maximum available balance for withdraw is"),
        "lowTsWalletBalanceErrorSecondPart": MessageLookupByLibrary.simpleMessage(
            "You may reduce your withdraw amount or you may withdraw by using other chain"),
        "market": MessageLookupByLibrary.simpleMessage("Market"),
        "marketPriceFetchFailed": MessageLookupByLibrary.simpleMessage(
            "Could not fetch the market price at the moment, please try again later"),
        "marketTrades": MessageLookupByLibrary.simpleMessage("Market Trades"),
        "maxAmount": MessageLookupByLibrary.simpleMessage("Max Amount"),
        "memberDetails": MessageLookupByLibrary.simpleMessage("Member Details"),
        "members": MessageLookupByLibrary.simpleMessage("Members"),
        "minimumAmount": MessageLookupByLibrary.simpleMessage("Minimum amount"),
        "minimumAmountError":
            MessageLookupByLibrary.simpleMessage("Minimum amount error"),
        "mnemonic": MessageLookupByLibrary.simpleMessage("Mnemonic"),
        "move": MessageLookupByLibrary.simpleMessage("Move"),
        "moveAndTrade":
            MessageLookupByLibrary.simpleMessage("Move to exchange"),
        "myInvestment": MessageLookupByLibrary.simpleMessage("My Investment"),
        "myOrders": MessageLookupByLibrary.simpleMessage("My Orders"),
        "myReferralCode":
            MessageLookupByLibrary.simpleMessage("My Referral Code"),
        "myReferralReward":
            MessageLookupByLibrary.simpleMessage("My Referral Reward"),
        "myReferrals": MessageLookupByLibrary.simpleMessage("My Referrals"),
        "myRewardDetails":
            MessageLookupByLibrary.simpleMessage("My Reward Details"),
        "myRewardTokens":
            MessageLookupByLibrary.simpleMessage("My Reward Tokens"),
        "myTokens": MessageLookupByLibrary.simpleMessage("My Tokens"),
        "myTotalAssets":
            MessageLookupByLibrary.simpleMessage("My Total Assets"),
        "networkIssue": MessageLookupByLibrary.simpleMessage("Network issue"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noCoinBalance":
            MessageLookupByLibrary.simpleMessage("No coin balance in exchange"),
        "noEvent": MessageLookupByLibrary.simpleMessage("No Event"),
        "noInternetWarning": MessageLookupByLibrary.simpleMessage(
            "Cannot load the content as your device is not to the internet"),
        "noRouteDefined":
            MessageLookupByLibrary.simpleMessage("No route defined for"),
        "note": MessageLookupByLibrary.simpleMessage("Note"),
        "notice": MessageLookupByLibrary.simpleMessage("Notice"),
        "openOrders": MessageLookupByLibrary.simpleMessage("Open Orders"),
        "orderBook": MessageLookupByLibrary.simpleMessage("Order Book"),
        "orderCancelled":
            MessageLookupByLibrary.simpleMessage("Order Cancelled"),
        "orderCancelledNotification": MessageLookupByLibrary.simpleMessage(
            "Your order has been cancelled successfully"),
        "orderCreatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Order Created Successfully"),
        "orderDetails": MessageLookupByLibrary.simpleMessage("Order Details"),
        "orderId": MessageLookupByLibrary.simpleMessage("Order Id"),
        "orderInformation":
            MessageLookupByLibrary.simpleMessage("Order Information"),
        "orderUpdateNotification": MessageLookupByLibrary.simpleMessage(
            "Your order status has been updated successfully"),
        "paid": MessageLookupByLibrary.simpleMessage("Paid"),
        "pair": MessageLookupByLibrary.simpleMessage("Pair"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordConditions": MessageLookupByLibrary.simpleMessage(
            "Please enter the password that satisfy above conditions"),
        "passwordConditionsMismatch": MessageLookupByLibrary.simpleMessage(
            "Password Conditions Mismatch"),
        "passwordDoesNotMatched":
            MessageLookupByLibrary.simpleMessage("Password does not matched"),
        "passwordMatched":
            MessageLookupByLibrary.simpleMessage("Password Matched"),
        "passwordMismatch":
            MessageLookupByLibrary.simpleMessage("Password Mismatch"),
        "passwordReset": MessageLookupByLibrary.simpleMessage("Password Reset"),
        "passwordResetError":
            MessageLookupByLibrary.simpleMessage("Password Reset Error"),
        "passwordRetype": MessageLookupByLibrary.simpleMessage(
            "Please retype the same password in both fields"),
        "pasteExgAddress": MessageLookupByLibrary.simpleMessage(
            "Tap on wallet icon to paste Exg Wallet Address"),
        "payableValue": MessageLookupByLibrary.simpleMessage("Payable Value"),
        "payment": MessageLookupByLibrary.simpleMessage("Payment"),
        "paymentDescription":
            MessageLookupByLibrary.simpleMessage("Payment Description"),
        "paymentDescriptionNote": MessageLookupByLibrary.simpleMessage(
            "Please fill this field to confirm the order"),
        "paymentReceived":
            MessageLookupByLibrary.simpleMessage("Payment Received"),
        "paymentType": MessageLookupByLibrary.simpleMessage("Payment Type"),
        "pending": MessageLookupByLibrary.simpleMessage("Pending"),
        "pendingConfirmDeposit":
            MessageLookupByLibrary.simpleMessage("Pending confirm deposit"),
        "percentage": MessageLookupByLibrary.simpleMessage("Percentage"),
        "placeOrderTransactionFailed": MessageLookupByLibrary.simpleMessage(
            "Place order transaction failed"),
        "placeOrderTransactionSuccessful": MessageLookupByLibrary.simpleMessage(
            "Place order transaction was made successfully"),
        "pleaseAddGasToTrade":
            MessageLookupByLibrary.simpleMessage("Please add gas to trade"),
        "pleaseCheckYourEmailToActivateYourAccount":
            MessageLookupByLibrary.simpleMessage(
                "Please check your email to activate your account"),
        "pleaseChooseTheLanguage":
            MessageLookupByLibrary.simpleMessage("Please choose the language"),
        "pleaseConfirmYour":
            MessageLookupByLibrary.simpleMessage("Please confirm your"),
        "pleaseCorrectTheFormatOfReceiveAddress":
            MessageLookupByLibrary.simpleMessage(
                "Please correct the format of receive address"),
        "pleaseEnterAmountLessThanYourWallet": MessageLookupByLibrary.simpleMessage(
            "Please enter the amount equals or less than your available wallet balance"),
        "pleaseEnterAnAddress":
            MessageLookupByLibrary.simpleMessage("Please enter an address"),
        "pleaseEnterTheCorrectEmail": MessageLookupByLibrary.simpleMessage(
            "Please enter the correct email"),
        "pleaseEnterValidNumber":
            MessageLookupByLibrary.simpleMessage("Please enter a valid number"),
        "pleaseEnterYourEmailAddress": MessageLookupByLibrary.simpleMessage(
            "Please enter your email address"),
        "pleaseFillAllTheFields":
            MessageLookupByLibrary.simpleMessage("Please fill all the fields"),
        "pleaseFillAllTheTextFieldsCorrectly":
            MessageLookupByLibrary.simpleMessage(
                "Please fill all the text fields correctly"),
        "pleaseFillBothPasswordFields": MessageLookupByLibrary.simpleMessage(
            "Please fill both password fields"),
        "pleaseFillYourPassword":
            MessageLookupByLibrary.simpleMessage("Please fill your password"),
        "pleaseProvideTheCorrectPassword": MessageLookupByLibrary.simpleMessage(
            "Please provide the correct Password"),
        "pleaseSetupDeviceSecurity": MessageLookupByLibrary.simpleMessage(
            "Please setup device security in the settings"),
        "pleaseTransferFundsToExchangeWalletToUseBindpay":
            MessageLookupByLibrary.simpleMessage(
                "Please transfer funds to exchange wallet to use bindpay"),
        "pleaseTransferFundsToExchangeWalletToUseLightningRemit":
            MessageLookupByLibrary.simpleMessage(
                "Please transfer funds to exchange wallet to use Lightning Remit"),
        "pleaseTryAgainLater":
            MessageLookupByLibrary.simpleMessage("Please try again later"),
        "pleaseUpdateYourAppFrom":
            MessageLookupByLibrary.simpleMessage("Please update your app from"),
        "pleaseincludeYourOrderNumber": MessageLookupByLibrary.simpleMessage(
            "Please include your order number"),
        "price": MessageLookupByLibrary.simpleMessage("Price"),
        "priceChange": MessageLookupByLibrary.simpleMessage("Price Change"),
        "quantity": MessageLookupByLibrary.simpleMessage("Quantity"),
        "question": MessageLookupByLibrary.simpleMessage("Question"),
        "reDeposit": MessageLookupByLibrary.simpleMessage("Re-Deposit"),
        "readCampaignInstructions":
            MessageLookupByLibrary.simpleMessage("Read Campaign Instructions"),
        "receive": MessageLookupByLibrary.simpleMessage("Receive"),
        "receiveAddress":
            MessageLookupByLibrary.simpleMessage("Receive Address"),
        "received": MessageLookupByLibrary.simpleMessage("Received"),
        "receiverWalletAddress":
            MessageLookupByLibrary.simpleMessage("Receiver Wallet Address"),
        "redeposit": MessageLookupByLibrary.simpleMessage("Redeposit"),
        "redepositCompleted":
            MessageLookupByLibrary.simpleMessage("Redeposit Completed"),
        "redepositError":
            MessageLookupByLibrary.simpleMessage("Redeposit error"),
        "redepositFailedError":
            MessageLookupByLibrary.simpleMessage("Redeposit failed"),
        "redepositItemNotSelected":
            MessageLookupByLibrary.simpleMessage("Redeposit item not selected"),
        "referralCode": MessageLookupByLibrary.simpleMessage("Referral Code"),
        "referralCount": MessageLookupByLibrary.simpleMessage("Referral Count"),
        "referrals": MessageLookupByLibrary.simpleMessage("Referrals"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "registrationSuccessful":
            MessageLookupByLibrary.simpleMessage("Registration Successful"),
        "releaseToLoadMore":
            MessageLookupByLibrary.simpleMessage(" Release to load more"),
        "reload": MessageLookupByLibrary.simpleMessage("Reload"),
        "remit": MessageLookupByLibrary.simpleMessage("Remit"),
        "remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "requireRedeposit":
            MessageLookupByLibrary.simpleMessage("Require redeposit"),
        "resetPasswordEmailInstruction": MessageLookupByLibrary.simpleMessage(
            "Please check your email and follow instructions to reset your account password"),
        "restore": MessageLookupByLibrary.simpleMessage("Restore"),
        "restoringWallet":
            MessageLookupByLibrary.simpleMessage("Restoring wallet"),
        "rewardsToken": MessageLookupByLibrary.simpleMessage("Rewards Token"),
        "routingNumber": MessageLookupByLibrary.simpleMessage("Routing Number"),
        "sameBalanceNote":
            MessageLookupByLibrary.simpleMessage("Same balance as"),
        "satoshisPerByte":
            MessageLookupByLibrary.simpleMessage("Satoshis/byte"),
        "saveAndShareQrCode":
            MessageLookupByLibrary.simpleMessage("Save and Share QR Code"),
        "scanBarCode": MessageLookupByLibrary.simpleMessage("Scan Bar Code"),
        "scanCancelled": MessageLookupByLibrary.simpleMessage("Scan Cancelled"),
        "secureYourWallet":
            MessageLookupByLibrary.simpleMessage("Secure Your Wallet"),
        "seed": MessageLookupByLibrary.simpleMessage("Seed"),
        "selectCoin": MessageLookupByLibrary.simpleMessage("Select Coin"),
        "sell": MessageLookupByLibrary.simpleMessage("Sell"),
        "sellOrders": MessageLookupByLibrary.simpleMessage("Sell Orders"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "sendTransactionComplete":
            MessageLookupByLibrary.simpleMessage("Send Transaction Complete"),
        "sent": MessageLookupByLibrary.simpleMessage("Sent"),
        "serverBusy": MessageLookupByLibrary.simpleMessage("Server Busy"),
        "serverError": MessageLookupByLibrary.simpleMessage("Server Error"),
        "serverTimeoutPleaseTryAgainLater":
            MessageLookupByLibrary.simpleMessage(
                "Server Timeout, Please try again later"),
        "sessionExpired":
            MessageLookupByLibrary.simpleMessage("Session Expired"),
        "setPasswordConditions": MessageLookupByLibrary.simpleMessage(
            "Enter password which is minimum 8 characters long and contains at least 1 uppercase, lowercase, number and a special character using !@#\$&*~`%^()-_"),
        "setPasswordNote": MessageLookupByLibrary.simpleMessage(
            "Note: For Password reset you have to keep the mnemonic safe as that is the only way to recover the wallet"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "settingsShowcaseInstructions": MessageLookupByLibrary.simpleMessage(
            "Show instructions for how to use certain app features"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "showAllPairOrders":
            MessageLookupByLibrary.simpleMessage("Show all pair's orders"),
        "showDialogWarnings":
            MessageLookupByLibrary.simpleMessage("Show dialog warnings"),
        "showOnlyCurrentPairOrders": MessageLookupByLibrary.simpleMessage(
            "Show only current pair orders"),
        "showPassword": MessageLookupByLibrary.simpleMessage("Show password"),
        "showSmallAmountAssets":
            MessageLookupByLibrary.simpleMessage("Show Small Amount Assets"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "silver": MessageLookupByLibrary.simpleMessage("silver"),
        "smartContract": MessageLookupByLibrary.simpleMessage("Smart Contract"),
        "smartContractAddress":
            MessageLookupByLibrary.simpleMessage("Smart Contract Address"),
        "smartContractName":
            MessageLookupByLibrary.simpleMessage("Smart Contract Name"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Something Went Wrong"),
        "specialExchangeBalanceNote": MessageLookupByLibrary.simpleMessage(
            "The displayed exchange balance is shared for coins that exist on multiple blockchains. Withdraws may be made to the chain of your choice."),
        "specialWithdrawFailNote": MessageLookupByLibrary.simpleMessage(
            "In this case, withdraws on one chain may be temporarily unavailable, and you may withdraw a smaller amount, withdraw to another chain."),
        "specialWithdrawNote": MessageLookupByLibrary.simpleMessage(
            "For some coins, the exchange allows users to select which blockchain they would like to withdraw. If many users withdraw to the same blockchain, there may be an imbalance of available funds to withdraw between the two chains."),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "submitYourAnswer":
            MessageLookupByLibrary.simpleMessage("Submit your answer"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "symbol": MessageLookupByLibrary.simpleMessage("Symbol"),
        "tapHereToEnterInCampaign": MessageLookupByLibrary.simpleMessage(
            "Tap here to enter in campaign"),
        "taphereToCopyTxId":
            MessageLookupByLibrary.simpleMessage("Tap here to copy txId"),
        "team": MessageLookupByLibrary.simpleMessage("Team"),
        "teamDetails": MessageLookupByLibrary.simpleMessage("Team Details"),
        "teamLeader": MessageLookupByLibrary.simpleMessage("Team Leader"),
        "teamReward": MessageLookupByLibrary.simpleMessage("Team Reward"),
        "teamsTotalValue":
            MessageLookupByLibrary.simpleMessage("Teams Total Value"),
        "testVersion": MessageLookupByLibrary.simpleMessage(
            "You are using the test version"),
        "ticker": MessageLookupByLibrary.simpleMessage("Ticker"),
        "time": MessageLookupByLibrary.simpleMessage("Time"),
        "title": MessageLookupByLibrary.simpleMessage("Exchangily Wallet"),
        "toExchange": MessageLookupByLibrary.simpleMessage("to exchange"),
        "toLatestBuild":
            MessageLookupByLibrary.simpleMessage("to latest build"),
        "toWallet": MessageLookupByLibrary.simpleMessage("to wallet"),
        "tokenDetails": MessageLookupByLibrary.simpleMessage("Token Details"),
        "tokenQuantity": MessageLookupByLibrary.simpleMessage("Token Quantity"),
        "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
        "totalExchangeBalance":
            MessageLookupByLibrary.simpleMessage("Exchange Balance"),
        "totalLockedBalance":
            MessageLookupByLibrary.simpleMessage("Locked Balance"),
        "totalQuantity": MessageLookupByLibrary.simpleMessage("Total Quantity"),
        "totalSupply": MessageLookupByLibrary.simpleMessage("Total Supply"),
        "totalTokenAmount":
            MessageLookupByLibrary.simpleMessage("Total Token Amount"),
        "totalTokenHolding":
            MessageLookupByLibrary.simpleMessage("Total Token Holding"),
        "totalValue": MessageLookupByLibrary.simpleMessage("Total Value"),
        "totalWalletBalance":
            MessageLookupByLibrary.simpleMessage("Total Wallet Balance"),
        "trade": MessageLookupByLibrary.simpleMessage("Trade"),
        "tranfser": MessageLookupByLibrary.simpleMessage("Transfer"),
        "transactionAmount":
            MessageLookupByLibrary.simpleMessage("Transaction Amount"),
        "transactionDetails":
            MessageLookupByLibrary.simpleMessage("Transaction Details"),
        "transactionHistory":
            MessageLookupByLibrary.simpleMessage("Transaction History"),
        "transactionId": MessageLookupByLibrary.simpleMessage("Transaction Id"),
        "transactions": MessageLookupByLibrary.simpleMessage("Transactions"),
        "transanctionFailed":
            MessageLookupByLibrary.simpleMessage("Transanction Failed"),
        "transferFundsToExchangeUsingDepositButton":
            MessageLookupByLibrary.simpleMessage(
                "Please transfer funds to exchange using deposit button in wallet dashboard"),
        "tsWalletNote": MessageLookupByLibrary.simpleMessage(
            "The TS (Threshold) wallet holds deposited funds for withdrawal, and is controlled collectively by the miners of the kanban blockchain."),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "typeYourWalletPassword":
            MessageLookupByLibrary.simpleMessage("Type your wallet password"),
        "unConfirmedBalance":
            MessageLookupByLibrary.simpleMessage("Unconfirmed Balance"),
        "unConfirmedBalanceInfoContent": MessageLookupByLibrary.simpleMessage(
            "The unconfirmed balance reflects the total value of your unspent transactions outputs (utxos) for transactions that are still pending (not yet confirmed on the blockchain)"),
        "unConfirmedBalanceInfoExample": MessageLookupByLibrary.simpleMessage(
            "This is the normal transaction process where unconfirmed funds may be more than the amount user sends. For example, when you purchase 50 dollars worth of groceries in a cash transaction and you give the shopkeeper a 100 dollar bill, then you get your change(50 dollars) back by the shopkeeper"),
        "unConfirmedBalanceInfoTitle":
            MessageLookupByLibrary.simpleMessage("Unconfirmed Balance Info"),
        "unknownError": MessageLookupByLibrary.simpleMessage("Unknown Error"),
        "unlock": MessageLookupByLibrary.simpleMessage("Unlock"),
        "updateNow": MessageLookupByLibrary.simpleMessage("Update now"),
        "updateStatus": MessageLookupByLibrary.simpleMessage("Update status"),
        "updateWallet": MessageLookupByLibrary.simpleMessage("Update wallet"),
        "updateYourOrderStatus":
            MessageLookupByLibrary.simpleMessage("Update your order status"),
        "useAsiaNode": MessageLookupByLibrary.simpleMessage("Use Asia Node"),
        "useNorthAmericanNode":
            MessageLookupByLibrary.simpleMessage("Use North American Node"),
        "userAccessDenied":
            MessageLookupByLibrary.simpleMessage("User Access Denied"),
        "userReturnedByPressingBackButton":
            MessageLookupByLibrary.simpleMessage(
                "User returned by pressing the back button"),
        "validationError":
            MessageLookupByLibrary.simpleMessage("Validation Error"),
        "value": MessageLookupByLibrary.simpleMessage("Value"),
        "verifyingWallet":
            MessageLookupByLibrary.simpleMessage("Verifying Wallet"),
        "vol": MessageLookupByLibrary.simpleMessage("Vol"),
        "volume": MessageLookupByLibrary.simpleMessage("Volume"),
        "waiting": MessageLookupByLibrary.simpleMessage("Waiting"),
        "wallet": MessageLookupByLibrary.simpleMessage(" Wallet"),
        "walletDashboardInstruction1": MessageLookupByLibrary.simpleMessage(
            "Please add gas by using FAB coin to use wallet and exchange features"),
        "walletDashboardInstruction2": MessageLookupByLibrary.simpleMessage(
            "Transfer funds from wallet to exchange to trade and use lightning remit"),
        "walletUpdateNoticeDecription": MessageLookupByLibrary.simpleMessage(
            "Please provide the wallet password to verify and install the latest update"),
        "walletUpdateNoticeTitle": MessageLookupByLibrary.simpleMessage(
            "Important Notice: Wallet Update"),
        "walletVerificationFailed": MessageLookupByLibrary.simpleMessage(
            "Current wallet is not compatible with the update, please delete the wallet and re-import again."),
        "walletbalance": MessageLookupByLibrary.simpleMessage("Wallet Balance"),
        "warningBackupMnemonic": MessageLookupByLibrary.simpleMessage(
            "Please accurately record and securely store the following twelve word mnemonic, do not disclose the mnemonic anybody else. Disclosure of your mnemonic will result in your account being compromised and you will lose all of your funds."),
        "warningImportOrConfirmMnemonic": MessageLookupByLibrary.simpleMessage(
            "Please type in your 12 word mnemonic phrase in the correct sequence to confirm"),
        "website": MessageLookupByLibrary.simpleMessage("Website"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Welcome to Exchangily. To begin you may create a new wallet or import an existing one."),
        "withdraw": MessageLookupByLibrary.simpleMessage("Withdraw"),
        "withdrawPopupNote": MessageLookupByLibrary.simpleMessage(
            "Please confirm the coin you want to withdraw"),
        "withdrawToWallet":
            MessageLookupByLibrary.simpleMessage("Move to wallet"),
        "withdrawTransactionFailed":
            MessageLookupByLibrary.simpleMessage("Withdraw transaction failed"),
        "withdrawTransactionSuccessful": MessageLookupByLibrary.simpleMessage(
            "Withdraw transaction was made successfully"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "yourOrderHasBeenCreated":
            MessageLookupByLibrary.simpleMessage("Your order has been created"),
        "yourWithdrawMinimumAmountaIsNotSatisfied":
            MessageLookupByLibrary.simpleMessage(
                "Your withdraw minimum amount is not satisfied")
      };
}
