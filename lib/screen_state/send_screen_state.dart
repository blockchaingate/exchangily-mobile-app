import 'dart:typed_data';

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../shared/globals.dart' as globals;

import 'package:exchangilymobileapp/localizations.dart';

class SendScreenState extends BaseState {
  final log = getLogger('SendState');
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  var options = {};
  String txHash = '';
  String errorMessage = '';
  var updatedBal;
  String toAddress;
  double amount;
  WalletInfo walletInfo;
  bool checkSendAmount = false;

  Future verifyPassword(tickerName, toWalletAddress, amount, context) async {
    log.w('dialog called');
    setState(ViewState.Busy);
    var dialogResponse = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (dialogResponse.confirmed) {
      String mnemonic = dialogResponse.fieldOne;
      Uint8List seed = walletService.generateSeed(mnemonic);
      log.e(seed);
      log.w(mnemonic);
      await walletService
          .sendTransaction(
              tickerName, seed, [0], toWalletAddress, amount, options, true)
          .then((res) {
        log.w('Result $res');
        txHash = res["txHash"];
        errorMessage = res["errMsg"];
        if (txHash.isNotEmpty) {
          log.w('TXhash $txHash');
          walletService.showInfoFlushbar(
              'Send Completed',
              '$tickerName Transanction has been sent',
              Icons.check_circle_outline,
              globals.green,
              context);
          setState(ViewState.Idle);
        } else if (errorMessage.isNotEmpty) {
          setState(ViewState.Idle);
          log.e('errorMessage.isNotEmpty $errorMessage');
          return errorMessage = 'Transaction Failed';
        } else if (txHash == '' && errorMessage == '') {
          log.w('Both TxHash and Error Message are empty $errorMessage');
          walletService.showInfoFlushbar(
              AppLocalizations.of(context).sendError,
              '$tickerName + ${AppLocalizations.of(context).transanctionFailed}',
              Icons.cancel,
              globals.red,
              context);
          setState(ViewState.Idle);
        }
        return txHash;
      }).timeout(Duration(seconds: 25), onTimeout: () {
        log.e('In time out');
        setState(ViewState.Idle);
        return errorMessage =
            AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater;
      }).catchError((error) {
        log.e('In Catch error - $error');
        errorMessage = AppLocalizations.of(context).transanctionFailed;
        setState(ViewState.Idle);
      });
    } else if (dialogResponse.fieldOne != 'Closed') {
      setState(ViewState.Idle);
      return errorMessage =
          AppLocalizations.of(context).pleaseProvideTheCorrectPassword;
    } else {
      // This is when user closes the dialog box by pressing cross icon
      setState(ViewState.Idle);
    }
  }

  // Check Transaction Status

  checkTxStatus(String txHash, String tickerName) async {
    if (tickerName == 'FAB') {
      var res = await walletService.getFabTxStatus(txHash);
      log.w('$tickerName TX Status response $res');
      //  Navigator.pushNamed(context, '/walletFeatures');
    } else if (tickerName == 'ETH') {
      var res = await walletService.getEthTxStatus(txHash);
      log.w('$tickerName TX Status response $res');
      //  Navigator.pushNamed(context, '/walletFeatures');
    } else {
      log.e('No Check TX Status found');
    }
  }

// Check Fields to see if user has filled both address and amount fields correctly

  checkFields(context) async {
    log.w(walletInfo.address);
    log.w(walletInfo.availableBalance);
    if (toAddress == '') {
      log.w('Address $toAddress');
      walletService.showInfoFlushbar(
          AppLocalizations.of(context).emptyAddress,
          AppLocalizations.of(context).pleaseEnterAnAddress,
          Icons.cancel,
          globals.red,
          context);
    } else if (amount == null ||
        !checkSendAmount ||
        amount > walletInfo.availableBalance) {
      walletService.showInfoFlushbar(
          AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).pleaseEnterValidNumber,
          Icons.cancel,
          globals.red,
          context);
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      await verifyPassword(
          walletInfo.tickerName.toUpperCase(), toAddress, amount, context);
      // await updateBalance(widget.walletInfo.address);
      // widget.walletInfo.availableBalance = model.updatedBal['balance'];
    }
  }

  bool checkAmount(amount) {
    // Pattern pattern = r'^\$|^(0|([1-9][0-9]{0,})|\.)(\\.[0-9]{0,})?\$';
    Pattern pattern = r'^(0|(\d+)|\.(\d+))(\.(\d+))?$';
    log.w(amount);
    var res = RegexValidator(pattern).isValid(amount);
    checkSendAmount = res;
    log.w('check send amount $checkSendAmount');
    return checkSendAmount;
  }

  updateBalance(String address) async {
    var bal = await walletService.getFabBalance(address);
    log.w(bal['balance']);
    // if (bal != null) {
    //   updatedBal = bal;
    //   log.w('in if Updated Bal ${updatedBal}');
    // }
    // updatedBal = 0;
    // log.w('Not in if Updated Bal ${updatedBal}');
  }

  copyAddress(context) {
    Clipboard.setData(new ClipboardData(text: txHash));
    walletService.showInfoFlushbar(
        AppLocalizations.of(context).transactionId,
        AppLocalizations.of(context).copiedSuccessfully,
        Icons.check,
        globals.green,
        context);
  }
}
