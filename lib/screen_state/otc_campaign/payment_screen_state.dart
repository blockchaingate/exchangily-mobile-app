import 'dart:typed_data';

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:flutter/cupertino.dart';

class CampaignPaymentScreenState extends BaseState {
  final log = getLogger('PaymentScreenState');
  NavigationService _navigationService = locator<NavigationService>();
  DialogService dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  final sendAmountTextController = TextEditingController();
  String _groupValue;
  get groupValue => _groupValue;
  String usdtToWalletAddress = '0xae397cfc8f67c46d533b844bfff25ad5ae89e63a';
  BuildContext context;
  String tickerName = '';
  String tokenType = '';
  var options = {};
  int gasPrice = 8000000000;
  int gasLimit = 100000;
  int satoshisPerBytes = 50;
  bool checkSendAmount = false;
  WalletInfo walletInfo;

  // Initial logic
  initState() {
    print('in payment screen');
  }

  // Radio button selection

  radioButtonSelection(value) {
    setState(ViewState.Busy);
    print(value);
    _groupValue = value;
    setErrorMessage('');
    setState((ViewState.Idle));
  }

  navigateToDashboard() {
    _navigationService.navigateTo('/campaignDashboard');
  }

// Verify wallet password in pop up dialog
  verifyWalletPassword(double amount) async {
    setBusy(true);
    log.w(('Sending payment amount $amount'));
    var dialogResponse = await dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (dialogResponse.confirmed) {
      String mnemonic = dialogResponse.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);

      if (tickerName == 'USDT') {
        tokenType = 'ETH';
      } else if (tickerName == 'EXG') {
        tokenType = 'FAB';
      }
      // if (tokenType != null && tokenType != '') {
      //   if ((tickerName != null) &&
      //       (tickerName != '') &&
      //       (tokenType != null) &&
      //       (tokenType != '')) {
      //     options = {
      //       'tokenType': tokenType,
      //       'contractAddress': environment["addresses"]["smartContract"]
      //           [tickerName],
      //       'gasPrice': gasPrice,
      //       'gasLimit': gasLimit,
      //       'satoshisPerBytes': satoshisPerBytes
      //     };
      //   }
      // } else {
      options = {
        'tokenType': tokenType,
        'contractAddress': environment["addresses"]["smartContract"]
            [tickerName],
        'gasPrice': gasPrice,
        'gasLimit': gasLimit,
        'satoshisPerBytes': satoshisPerBytes
      };
      // }
      log.e('$tickerName, $seed, $usdtToWalletAddress,$amount, $options');
      await walletService
          .sendTransaction(tickerName, seed, [0], [], usdtToWalletAddress,
              amount, options, true)
          .then((res) async {
        log.w('Result $res');
        String txHash = res["txHash"];
        setErrorMessage(res["errMsg"]);
        if (txHash.isNotEmpty) {
          log.w('TXhash $txHash');
          sendAmountTextController.text = '';
          // String date = DateTime.now().toString();
          // Build transaction history object
          // TransactionHistory transactionHistory = new TransactionHistory(

          //     amount: amount,
          //     date: date);
          // Add transaction history object in database
          // await transactionHistoryDatabaseService
          //     .insert(transactionHistory)
          //     .then((data) => log.w('Saved in transaction history database'))
          //     .catchError(
          //         (onError) => log.e('Could not save in database $onError'));
          // timer = Timer.periodic(Duration(seconds: 55), (Timer t) {
          //   checkTxStatus(tickerName, txHash);
          // });
          sharedService.alertResponse(
              AppLocalizations.of(context).sendTransactionComplete,
              '$tickerName ${AppLocalizations.of(context).isOnItsWay}');

          setBusy(false);
        } else if (errorMessage.isNotEmpty) {
          log.e('Error Message: $errorMessage');
          sharedService.alertResponse(AppLocalizations.of(context).genericError,
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}');
          setState(ViewState.Idle);
        } else if (txHash == '' && errorMessage == '') {
          log.w('Both TxHash and Error Message are empty $errorMessage');
          sharedService.alertResponse(AppLocalizations.of(context).genericError,
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}');
          setBusy(false);
        }
        return txHash;
      }).timeout(Duration(seconds: 25), onTimeout: () {
        log.e('In time out');
        setState(ViewState.Idle);

        setErrorMessage(
            AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater);
        return '';
      }).catchError((error) {
        log.e('In Catch error - $error');
        sharedService.alertResponse(AppLocalizations.of(context).genericError,
            '$tickerName ${AppLocalizations.of(context).transanctionFailed}');
        //errorMessage = AppLocalizations.of(context).transanctionFailed;
        setState(ViewState.Idle);
      });
    } else if (dialogResponse.returnedText != 'Closed') {
      setState(ViewState.Idle);
      setErrorMessage(
          AppLocalizations.of(context).pleaseProvideTheCorrectPassword);
    } else {
      setState(ViewState.Idle);
    }
  }

  // Check input fields
  checkFields(context) async {
    setBusy(true);
    if (sendAmountTextController.text == '' || _groupValue == null) {
      setErrorMessage('Please fill all the fields');
      setBusy(false);
      return;
    }
    // Get coin details which we are making transaction through like USDT
    await walletDataBaseService.getBytickerName(_groupValue).then((res) {
      log.e('res $res');
      tickerName = _groupValue;
      walletInfo = res;
      log.w('wallet info ${walletInfo.availableBalance}');
    });
    double amount = double.parse(sendAmountTextController.text);
    if (amount == null ||
        !checkSendAmount ||
        amount > walletInfo.availableBalance) {
      setErrorMessage(AppLocalizations.of(context).pleaseEnterValidNumber);
      sharedService.alertResponse(AppLocalizations.of(context).invalidAmount,
          'Please enter the amount equals or less than your available wallet balance');
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      await verifyWalletPassword(amount);
    }
    setBusy(false);
  }

  // Check Send Amount
  checkAmount(amount) {
    setState(ViewState.Busy);
    Pattern pattern = r'^(0|(\d+)|\.(\d+))(\.(\d+))?$';
    log.e(amount);
    var res = RegexValidator(pattern).isValid(amount);
    checkSendAmount = res;
    log.w('check send amount $checkSendAmount');
    !checkSendAmount
        ? setErrorMessage('Please enter the valid amount')
        : setErrorMessage('');
    setState(ViewState.Idle);
  }
}
