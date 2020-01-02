import 'dart:typed_data';

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../shared/globals.dart' as globals;

class SendScreenState extends BaseState {
  final log = getLogger('SendState');
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  var options = {};
  String txHash = '';
  String errorMessage;
  var updatedBal;
  String toAddress;
  double amount;
  WalletInfo walletInfo;

  Future verifyPassword(tickerName, toWalletAddress, amount, context) async {
    log.w('dialog called');
    setState(ViewState.Busy);
    var res = await _dialogService.showDialog(
        title: 'Enter Password',
        description:
            'Type the same password which you entered while creating the wallet');
    if (res.confirmed) {
      String mnemonic = res.fieldOne;
      Uint8List seed = walletService.generateSeed(mnemonic);
      var ret = await walletService.sendTransaction(
          tickerName, seed, [0], toWalletAddress, amount, options, true);
      txHash = ret["txHash"];
      errorMessage = ret["errMsg"];
      if (txHash.isNotEmpty) {
        log.w('Tx Hash $txHash - ${ret["txHash"]}');
        walletService.showInfoFlushbar(
            'Send Completed',
            '$tickerName Transanction has been sent',
            Icons.check_circle_outline,
            globals.green,
            context);
        //   await checkTxStatus(txHash, tickerName);
        Future.delayed(Duration(seconds: 5));
        setState(ViewState.Idle);
        return txHash;
      }
      if (errorMessage.isNotEmpty) {
        log.e('Error Message $errorMessage');
        setState(ViewState.Idle);
        return errorMessage;
      }

      setState(ViewState.Idle);
    } else {
      if (res.fieldOne != 'Closed') {
        setState(ViewState.Idle);
        log.w('Wrong password');
        showNotification(context);
      }
    }
  }

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
    if (toAddress == '') {
      log.w('Address $toAddress');
      walletService.showInfoFlushbar('Empty Address', 'Please enter an address',
          Icons.cancel, globals.red, context);
    } else if (amount == null || amount > walletInfo.availableBalance) {
      walletService.showInfoFlushbar(
          'Invalid Amount',
          'Please enter a valid send amount',
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

  showNotification(context) {
    walletService.showInfoFlushbar('Password Mismatch',
        'Please enter the correct pasword', Icons.cancel, globals.red, context);
  }

  copyAddress(context) {
    Clipboard.setData(new ClipboardData(text: txHash));
    walletService.showInfoFlushbar('Transaction Id', 'Copied Successfully',
        Icons.check, globals.green, context);
  }
}
