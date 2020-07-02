import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../logger.dart';
import '../../../shared/globals.dart' as globals;

class MoveToWalletScreenState extends BaseState {
  final log = getLogger('MoveToWalletScreenState');

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();

  WalletInfo walletInfo;
  BuildContext context;

  String gasFeeUnit = '';
  String feeMeasurement = '';
  final kanbanGasPriceTextController = TextEditingController();
  final kanbanGasLimitTextController = TextEditingController();
  final amountController = TextEditingController();
  var kanbanTransFee;
  var minimumAmount;
  bool transFeeAdvance = false;

  void initState() {
    setBusy(true);
    var gasPrice = environment["chains"]["KANBAN"]["gasPrice"];
    var gasLimit = environment["chains"]["KANBAN"]["gasLimit"];
    minimumAmount = environment['minimumWithdraw'][walletInfo.tickerName];
    kanbanGasPriceTextController.text = gasPrice.toString();
    kanbanGasLimitTextController.text = gasLimit.toString();

    kanbanTransFee = bigNum2Double(gasPrice * gasLimit);

    if (walletInfo.tickerName == 'ETH' || walletInfo.tickerName == 'USDT') {
      gasFeeUnit = 'WEI';
    } else if (walletInfo.tickerName == 'FAB') {
      gasFeeUnit = 'LIU';
      feeMeasurement = '10^(-8)';
    }
    setBusy(false);
  }

// Check Pass
  checkPass() async {
    setBusy(true);
    var amount = double.tryParse(amountController.text);
    // if (amount == null ||
    //     // amount > walletInfo.availableBalance ||
    //     // amount == 0 ||
    //     amount.isNegative) {
    //   sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
    //       AppLocalizations.of(context).pleaseEnterValidNumber,
    //       isWarning: false);
    //   setBusy(false);
    //   return;
    // }

    // if (amount < environment["minimumWithdraw"][walletInfo.tickerName]) {
    //   sharedService.showInfoFlushbar(
    //       AppLocalizations.of(context).minimumAmountError,
    //       AppLocalizations.of(context).yourWithdrawMinimumAmountaIsNotSatisfied,
    //       Icons.cancel,
    //       globals.red,
    //       context);
    //   return;
    // }
    setMessage('');
    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);
      var tokenType = walletInfo.tokenType;
      var coinName = walletInfo.tickerName;
      var coinAddress = walletInfo.address;
      if (coinName == 'USDT') {
        tokenType = 'ETH';
      }
      if (coinName == 'EXG') {
        tokenType = 'FAB';
      }
      print('coin address 1 $coinAddress');
      if (coinName == 'BCH') {
        await walletService.getBchAddressDetails(coinAddress).then(
            (addressDetails) => coinAddress = addressDetails['legacyAddress']);
      }
      print('coin address 2 $coinAddress');
      var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
      var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);

      await walletService
          .withdrawDo(seed, coinName, coinAddress, tokenType, amount,
              kanbanPrice, kanbanGasLimit)
          .then((ret) {
        log.w(ret);
        bool success = ret["success"];
        if (success) {
          String txId = ret['transactionHash'];
          log.e('txid $txId');
          amountController.text = '';
          setMessage(txId);
          String date = DateTime.now().toString();
          TransactionHistory transactionHistory = new TransactionHistory(
              id: null,
              tickerName: coinName,
              address: '',
              amount: 0.0,
              date: date.toString(),
              txId: txId != null ? txId : '',
              status: 'pending',
              quantity: amount,
              tag: 'withdraw');
          walletService.insertTransactionInDatabase(transactionHistory);
        } else {
          var errMsg = ret['data'];
          if (errMsg == null || errMsg == '') {
            errMsg = AppLocalizations.of(context).serverError;
            setErrorMessage(errMsg);
          }
        }
        sharedService.alertDialog(
            success
                ? AppLocalizations.of(context).depositTransactionSuccess
                : AppLocalizations.of(context).depositTransactionFailed,
            success ? "" : AppLocalizations.of(context).serverError,
            isWarning: false);
      }).catchError((err) {
        print('Withdraw catch $err');
      });
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
    setBusy(false);
  }

  showNotification(context) {
    setState(ViewState.Busy);
    sharedService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        globals.red,
        context);
    setState(ViewState.Idle);
  }

  // update Transaction Fee

  updateTransFee() async {
    var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);

    var kanbanPriceBig = BigInt.from(kanbanPrice);
    var kanbanGasLimitBig = BigInt.from(kanbanGasLimit);
    var kanbanTransFeeDouble =
        bigNum2Double(kanbanPriceBig * kanbanGasLimitBig);
    print('Update trans fee $kanbanTransFeeDouble');

    kanbanTransFee = kanbanTransFeeDouble;
  }

// Copy txid and display flushbar
  copyAndShowNotificatio(String message) {
    sharedService.copyAddress(context, message);
  }
}
