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

import 'dart:typed_data';

import 'package:barcode_scan/barcode_scan.dart';
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
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';

class SendScreenState extends BaseState {
  final log = getLogger('SendScreenState');
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  BuildContext context;
  var options = {};
  String txHash = '';
  String errorMessage = '';
  var updatedBal;
  String toAddress;
  double amount;
  int gasPrice = 0;
  int gasLimit = 0;
  int satoshisPerBytes = 0;
  WalletInfo walletInfo;
  bool checkSendAmount = false;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final receiverWalletAddressTextController = TextEditingController();
  final sendAmountTextController = TextEditingController();
  final gasPriceTextController = TextEditingController();
  final gasLimitTextController = TextEditingController();
  final satoshisPerByteTextController = TextEditingController();
  double transFee = 0.0;
  bool transFeeAdvance = false;

  // Init State
  initState() {
    setState(ViewState.Busy);
    String coinName = walletInfo.tickerName;
    String tokenType = walletInfo.tokenType;
    if (coinName == 'BTC') {
      satoshisPerByteTextController.text =
          environment["chains"]["BTC"]["satoshisPerBytes"].toString();
    } else if (coinName == 'ETH' || tokenType == 'ETH') {
      gasPriceTextController.text =
          environment["chains"]["ETH"]["gasPrice"].toString();
      gasLimitTextController.text =
          environment["chains"]["ETH"]["gasLimit"].toString();
    } else if (coinName == 'FAB') {
      satoshisPerByteTextController.text =
          environment["chains"]["FAB"]["satoshisPerBytes"].toString();
    } else if (tokenType == 'FAB') {
      satoshisPerByteTextController.text =
          environment["chains"]["FAB"]["satoshisPerBytes"].toString();
      gasPriceTextController.text =
          environment["chains"]["FAB"]["gasPrice"].toString();
      gasLimitTextController.text =
          environment["chains"]["FAB"]["gasLimit"].toString();
    }
    setState(ViewState.Idle);
  }

  pasteClipBoardData() async {
    setState(ViewState.Busy);
    log.w('in clipboard');
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    log.w('Clipboard data = ${data.text}');
    receiverWalletAddressTextController.text = data.text;
    setState(ViewState.Idle);
  }

  // Verify Password
  Future verifyPassword(
      tickerName, tokenType, toWalletAddress, amount, context) async {
    log.w('dialog called');
    setState(ViewState.Busy);
    var dialogResponse = await _dialogService.showDialog(
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
      if (tokenType != null && tokenType != '') {
        if ((tickerName != null) &&
            (tickerName != '') &&
            (tokenType != null) &&
            (tokenType != '')) {
          options = {
            'tokenType': tokenType,
            'contractAddress': environment["addresses"]["smartContract"]
                [tickerName],
            'gasPrice': gasPrice,
            'gasLimit': gasLimit,
            'satoshisPerBytes': satoshisPerBytes
          };
        }
      } else {
        options = {
          'gasPrice': gasPrice,
          'gasLimit': gasLimit,
          'satoshisPerBytes': satoshisPerBytes
        };
      }

      await walletService
          .sendTransaction(
              tickerName, seed, [0], [], toWalletAddress, amount, options, true)
          .then((res) {
        log.w('Result $res');
        txHash = res["txHash"];
        errorMessage = res["errMsg"];
        if (txHash.isNotEmpty) {
          log.w('TXhash $txHash');
          walletService.showInfoFlushbar(
              AppLocalizations.of(context).sendTransactionComplete,
              '$tickerName ${AppLocalizations.of(context).isOnItsWay}',
              Icons.check_circle_outline,
              globals.green,
              context);
          setState(ViewState.Idle);
        } else if (errorMessage.isNotEmpty) {
          log.e('Error Message: $errorMessage');
          walletService.showInfoFlushbar(
              AppLocalizations.of(context).genericError,
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}',
              Icons.cancel,
              globals.red,
              context);
          setState(ViewState.Idle);
        } else if (txHash == '' && errorMessage == '') {
          log.w('Both TxHash and Error Message are empty $errorMessage');
          walletService.showInfoFlushbar(
              AppLocalizations.of(context).genericError,
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}',
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
    } else if (dialogResponse.returnedText != 'Closed') {
      setState(ViewState.Idle);
      return errorMessage =
          AppLocalizations.of(context).pleaseProvideTheCorrectPassword;
    } else {
      setState(ViewState.Idle);
    }
  }

  // Check transaction status not working yet

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
      await verifyPassword(walletInfo.tickerName.toUpperCase(),
          walletInfo.tokenType.toUpperCase(), toAddress, amount, context);
      // await updateBalance(widget.walletInfo.address);
      // widget.walletInfo.availableBalance = model.updatedBal['balance'];
    }
  }

  bool checkAmount(amount) {
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

  // Update Trans Fee
  updateTransFee() async {
    setState(ViewState.Busy);
    var to = receiverWalletAddressTextController.text;
    var amount = double.tryParse(sendAmountTextController.text);
    var gasPrice = int.tryParse(gasPriceTextController.text);
    var gasLimit = int.tryParse(gasLimitTextController.text);
    var satoshisPerBytes = int.tryParse(satoshisPerByteTextController.text);
    var options = {
      "gasPrice": gasPrice,
      "gasLimit": gasLimit,
      "satoshisPerBytes": satoshisPerBytes,
      "tokenType": walletInfo.tokenType,
      "getTransFeeOnly": true
    };
    print('widget.walletInfo.address=' + walletInfo.address);
    var address = walletInfo.address;

    var ret = await walletService.sendTransaction(
        walletInfo.tickerName,
        Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
        [0],
        [address],
        to,
        amount,
        options,
        false);

    print('ret===');
    print(ret);

    if (ret != null && ret['transFee'] != null) {
      setState(ViewState.Busy);
      transFee = ret['transFee'];
      setState(ViewState.Idle);
    }
    setState(ViewState.Idle);
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Barcode Scan

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Future scan() async {
    setState(ViewState.Busy);
    try {
      String barcode = await BarcodeScanner.scan();
      receiverWalletAddressTextController.text = barcode;
      setState(ViewState.Idle);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(ViewState.Idle);
        receiverWalletAddressTextController.text =
            AppLocalizations.of(context).userAccessDenied;
      } else {
        setState(ViewState.Idle);
        receiverWalletAddressTextController.text =
            '${AppLocalizations.of(context).unknownError}: $e';
      }
    } on FormatException {
      setState(ViewState.Idle);
      walletService.showInfoFlushbar(
          AppLocalizations.of(context).scanCancelled,
          AppLocalizations.of(context).userReturnedByPressingBackButton,
          Icons.cancel,
          globals.red,
          context);
    } catch (e) {
      setState(ViewState.Idle);
      receiverWalletAddressTextController.text =
          '${AppLocalizations.of(context).unknownError}: $e';
    }
  }
}
