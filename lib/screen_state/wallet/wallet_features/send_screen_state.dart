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
import 'dart:typed_data';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:overlay_support/overlay_support.dart';

class SendScreenState extends BaseState {
  final log = getLogger('SendScreenState');

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  BuildContext context;
  var options = {};
  String txHash = '';
  String errorMessage = '';
  var updatedBal;
  String toAddress;
  double amount = 0;
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
  initState() async {
    setState(ViewState.Busy);
    sharedService.context = context;
    String coinName = walletInfo.tickerName;
    String tokenType = walletInfo.tokenType;
    if (coinName == 'BTC') {
      satoshisPerByteTextController.text =
          environment["chains"]["BTC"]["satoshisPerBytes"].toString();
    } else if (coinName == 'ETH' || tokenType == 'ETH') {
      var gasPriceReal = await walletService.getEthGasPrice();
      print('gasPriceReal======');
      print(gasPriceReal);
      gasPriceTextController.text = gasPriceReal.toString();
      gasLimitTextController.text =
          environment["chains"]["ETH"]["gasLimit"].toString();
      if (tokenType == 'ETH') {
        gasLimitTextController.text =
            environment["chains"]["ETH"]["gasLimitToken"].toString();
      }
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
    //  getGasBalance();
    setState(ViewState.Idle);
  }

  getGasBalance() async {
    // await walletService.gasBalance(addr)
  }

  // getExgWalletAddr() async {
  //   // Get coin details which we are making transaction through like USDT
  //   await walletDataBaseService.getBytickerName('EXG').then((res) {
  //     exgWalletAddress = res.address;
  //     log.w('Exg wallet address $exgWalletAddress');
  //   });
  // }

  // Paste Clipboard Data In Receiver Address

  pasteClipBoardData() async {
    setState(ViewState.Busy);
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    receiverWalletAddressTextController.text = data.text;
    toAddress = receiverWalletAddressTextController.text;
    setState(ViewState.Idle);
  }

  // Verify Password
  Future verifyPassword() async {
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
      String tickerName = walletInfo.tickerName.toUpperCase();
      String tokenType = walletInfo.tokenType.toUpperCase();
      if (tickerName == 'USDT') {
        tokenType = 'ETH';

        // Check if ETH is available for making USDT transaction
        // Same for Fab token based coins

        // WalletInfo ethWallet =
        //     await walletDatabaseService.getBytickerName('ETH');
        // if (ethWallet.availableBalance < 0.05) {
        //   sharedService.alertDialog('Send Notice',
        //       'To send ETH or USDT you need atleast .05 eth balance available in your wallet.',
        //       isWarning: false);
        // }
      } else if (tickerName == 'EXG') {
        tokenType = 'FAB';
      }
      if (tokenType != null && tokenType != '') {
        if ((tickerName != null) &&
            (tickerName != '') &&
            (tokenType != null) &&
            (tokenType != '')) {
          var decimal;
          String contractAddr =
              environment["addresses"]["smartContract"][tickerName];
          if (contractAddr == null) {
            await tokenListDatabaseService
                .getByTickerName(tickerName)
                .then((token) {
              contractAddr = token.contract;
              decimal = token.decimal;
            });
          }
          options = {
            'tokenType': tokenType,
            'contractAddress': contractAddr,
            'gasPrice': gasPrice,
            'gasLimit': gasLimit,
            'satoshisPerBytes': satoshisPerBytes,
            'decimal': decimal
          };
        }
      } else {
        options = {
          'gasPrice': gasPrice,
          'gasLimit': gasLimit,
          'satoshisPerBytes': satoshisPerBytes
        };
      }

      // Convert FAB to EXG format
      if (walletInfo.tokenType == 'FAB') {
        if (!toAddress.startsWith('0x')) toAddress = fabToExgAddress(toAddress);
      }

      await walletService
          .sendTransaction(
              tickerName, seed, [0], [], toAddress, amount, options, true)
          .then((res) async {
        log.w('Result $res');
        txHash = res["txHash"];
        errorMessage = res["errMsg"];

        if (txHash.isNotEmpty) {
          log.w('TXhash $txHash');
          receiverWalletAddressTextController.text = '';
          sendAmountTextController.text = '';

          sharedService.alertDialog(
            AppLocalizations.of(context).sendTransactionComplete,
            '$tickerName ${AppLocalizations.of(context).isOnItsWay}',
          );
          var allTxids = res["txids"];
          walletService.addTxids(allTxids);

          String date = DateTime.now().toLocal().toString();
          TransactionHistory transactionHistory = new TransactionHistory(
            id: null,
            tickerName: tickerName,
            address: '',
            amount: 0.0,
            date: date,
            kanbanTxId: '',
            tickerChainTxId: txHash,
            quantity: amount,
            tag: 'send',
            chainName: tokenType,
          );
          walletService.insertTransactionInDatabase(transactionHistory);
        } else if (txHash == '' && errorMessage == '') {
          log.e('Both TxHash and Error Message are empty $errorMessage');
          sharedService.alertDialog(
            "",
            '$tickerName ${AppLocalizations.of(context).transanctionFailed}',
          );
          setState(ViewState.Idle);
        }
        setState(ViewState.Idle);
        return txHash;
      }).timeout(Duration(seconds: 25), onTimeout: () {
        log.e('In time out');
        setState(ViewState.Idle);
        return errorMessage =
            AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater;
      }).catchError((error) {
        log.e('In Catch error - $error');
        sharedService.alertDialog(AppLocalizations.of(context).serverError,
            '$tickerName ${AppLocalizations.of(context).transanctionFailed}',
            isWarning: false);
        //errorMessage = AppLocalizations.of(context).transanctionFailed;
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

  checkTxStatus(String tickerName, String txHash) async {
    Timer timer;
    if (tickerName == 'FAB') {
      await walletService.getFabTxStatus(txHash).then((res) {
        if (res != null) {
          var confirmations = res['confirmations'];
          // timer?.cancel();
          log.w('$tickerName Not null $confirmations');
        }

        log.w('$tickerName TX Status response $res');
      }).catchError((onError) {
        timer.cancel();
        log.e(onError);
      });
      //  Navigator.pushNamed(context, '/walletFeatures');
    } else if (tickerName == 'ETH') {
      await walletService.getEthTxStatus(txHash).then((res) {
        timer.cancel();
        log.w('$tickerName TX Status response $res');
      }).catchError((onError) {
        timer.cancel();
        log.e(onError);
      });
      //  Navigator.pushNamed(context, '/walletFeatures');
    } else {
      timer.cancel();
      log.e('No Check TX Status found');
    }
  }

// Check Fields to see if user has filled both address and amount fields correctly

  checkFields(context) async {
    print('in check fields');
    txHash = '';
    errorMessage = '';
    //walletInfo = walletInfo;
    amount = double.tryParse(sendAmountTextController.text);
    toAddress = receiverWalletAddressTextController.text;
    gasPrice = int.tryParse(gasPriceTextController.text);
    gasLimit = int.tryParse(gasLimitTextController.text);
    satoshisPerBytes = int.tryParse(satoshisPerByteTextController.text);

    if (toAddress == '') {
      print('address empty');
      sharedService.alertDialog(AppLocalizations.of(context).emptyAddress,
          AppLocalizations.of(context).pleaseEnterAnAddress,
          isWarning: false);
    } else if (amount == null ||
        amount == 0 ||
        amount.isNegative ||
        !checkSendAmount ||
        amount > walletInfo.availableBalance) {
      print('amount no good');
      sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).pleaseEnterValidNumber,
          isWarning: false);
    }
    // else if (amount < environment["minimumWithdraw"][walletInfo.tickerName]) {
    //   sharedService.showInfoFlushbar(
    //       AppLocalizations.of(context).minimumAmountError,
    //       AppLocalizations.of(context).yourWithdrawMinimumAmountaIsNotSatisfied,
    //       Icons.cancel,
    //       globals.red,
    //       context);
    //   return;
    // }
    else {
      print('else');
      FocusScope.of(context).requestFocus(FocusNode());
      await verifyPassword();
      // await updateBalance(widget.walletInfo.address);
      // widget.walletInfo.availableBalance = model.updatedBal['balance'];
    }
  }

  // Check Send Amount

  checkAmount(amount) {
    setState(ViewState.Busy);
    Pattern pattern = r'^(0|(\d+)|\.(\d+))(\.(\d+))?$';
    log.e(amount);
    var res = RegexValidator(pattern).isValid(amount);
    checkSendAmount = res;
    log.w('check send amount $checkSendAmount');
    setState(ViewState.Idle);
  }

// Copy Address
  copyAddress(context) {
    Clipboard.setData(new ClipboardData(text: txHash));
    showSimpleNotification(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).transactionId + ' '),
            Text(AppLocalizations.of(context).copiedSuccessfully),
          ],
        ),
        position: NotificationPosition.bottom,
        background: primaryColor);
    // sharedService.alertDialog(AppLocalizations.of(context).transactionId,
    //     AppLocalizations.of(context).copiedSuccessfully,
    //     isWarning: false);
  }

  // Update Trans Fee
  updateTransFee() async {
    setState(ViewState.Busy);
    setBusy(true);
    var to = getOfficalAddress(walletInfo.tickerName.toUpperCase(),
        tokenType: walletInfo.tokenType.toUpperCase());
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

    var address = walletInfo.address;

    await walletService
        .sendTransaction(
            walletInfo.tickerName,
            Uint8List.fromList(
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
            [0],
            [address],
            to,
            amount,
            options,
            false)
        .then((ret) {
      if (ret != null && ret['transFee'] != null) {
        transFee = ret['transFee'];
      }
      setState(ViewState.Idle);
    }).catchError((err) {
      setState(ViewState.Idle);
      setBusy(false);
      log.e(err);
      sharedService.alertDialog(AppLocalizations.of(context).genericError,
          AppLocalizations.of(context).transanctionFailed,
          isWarning: false);
    });
    setState(ViewState.Idle);
    setBusy(false);
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    Barcode Scan
--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Future scan() async {
    log.i("Barcode: going to scan");
    setState(ViewState.Busy);
    log.i("Barcode: set busy");
    try {
      log.i("Barcode: will try");
      String barcode = '';
      log.i("Barcode: will get result");
      var result = await BarcodeScanner.scan();
      barcode = result;
      log.i("Barcode Res: ");
      log.i(result);

      receiverWalletAddressTextController.text = barcode;
      setState(ViewState.Idle);
    } on PlatformException catch (e) {
      log.i("Barcode PlatformException : ");
      log.i(e.toString());
      if (e.code == "PERMISSION_NOT_GRANTED") {
        setState(ViewState.Idle);
        sharedService.alertDialog(
            '', AppLocalizations.of(context).userAccessDenied,
            isWarning: false);
        // receiverWalletAddressTextController.text =
        //     AppLocalizations.of(context).userAccessDenied;
      } else {
        setState(ViewState.Idle);
        sharedService.alertDialog('', AppLocalizations.of(context).unknownError,
            isWarning: false);
        // receiverWalletAddressTextController.text =
        //     '${AppLocalizations.of(context).unknownError}: $e';
      }
    } on FormatException {
      log.i("Barcode FormatException : ");
      // log.i(e.toString());
      setState(ViewState.Idle);
      sharedService.alertDialog(AppLocalizations.of(context).scanCancelled,
          AppLocalizations.of(context).userReturnedByPressingBackButton,
          isWarning: false);
    } catch (e) {
      log.i("Barcode error : ");
      log.i(e.toString());
      setState(ViewState.Idle);
      sharedService.alertDialog('', AppLocalizations.of(context).unknownError,
          isWarning: false);
      // receiverWalletAddressTextController.text =
      //     '${AppLocalizations.of(context).unknownError}: $e';
    }
  }
}
