import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;

class DepositScreenState extends BaseState {
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  WalletInfo walletInfo;
  BuildContext context;
  final gasPriceTextController = TextEditingController();
  final gasLimitTextController = TextEditingController();
  final satoshisPerByteTextController = TextEditingController();
  final kanbanGasPriceTextController = TextEditingController();
  final kanbanGasLimitTextController = TextEditingController();
  double transFee = 0.0;
  double kanbanTransFee = 0.0;
  bool transFeeAdvance = false;
  String coinName = '';
  String tokenType = '';
  final myController = TextEditingController();

  void initState() {
    setState(ViewState.Busy);
    coinName = walletInfo.tickerName;
    tokenType = walletInfo.tokenType;
    print('coinName==' + coinName);
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
    kanbanGasPriceTextController.text =
        environment["chains"]["KANBAN"]["gasPrice"].toString();
    kanbanGasLimitTextController.text =
        environment["chains"]["KANBAN"]["gasLimit"].toString();
    setState(ViewState.Idle);
  }

  checkPass(double amount, context) async {
    setState(ViewState.Busy);
    if (amount == null || amount > walletInfo.availableBalance) {
      walletService.showInfoFlushbar(
          AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).pleaseEnterValidNumber,
          Icons.cancel,
          globals.red,
          context);
      setState(ViewState.Idle);
      return;
    }

    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);
      if (coinName == 'USDT') {
        tokenType = 'ETH';
      }
      if (coinName == 'EXG') {
        tokenType = 'FAB';
      }

      var gasPrice = int.tryParse(gasPriceTextController.text);
      var gasLimit = int.tryParse(gasLimitTextController.text);
      var satoshisPerBytes = int.tryParse(satoshisPerByteTextController.text);
      var kanbanGasPrice = int.tryParse(kanbanGasPriceTextController.text);
      var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);

      var option = {
        "gasPrice": gasPrice,
        "gasLimit": gasLimit,
        "satoshisPerBytes": satoshisPerBytes,
        'kanbanGasPrice': kanbanGasPrice,
        'kanbanGasLimit': kanbanGasLimit,
        'tokenType': tokenType,
        'contractAddress': environment["addresses"]["smartContract"][coinName]
      };

      await walletService
          .depositDo(seed, coinName, tokenType, amount, option)
          .then((ret) {
        if (ret["success"]) {
          myController.text = '';
        }
        var errMsg = ret['data'];
        if (errMsg == null || errMsg == '') {
          errMsg = ret['error'];
        }
        if (errMsg == null || errMsg == '') {
          errMsg = 'Unknown Error';
        }
        walletService.showInfoFlushbar(
            ret["success"]
                ? AppLocalizations.of(context).depositTransactionSuccess
                : AppLocalizations.of(context).depositTransactionFailed,
            ret["success"]
                ? 'transactionID:' + ret['data']['transactionID']
                : errMsg,
            Icons.cancel,
            globals.red,
            context);
        setState(ViewState.Idle);
      }).catchError((onError) {
        setState(ViewState.Idle);
        log.e(onError);
      });
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
        setState(ViewState.Idle);
      }
    }
    setState(ViewState.Idle);
  }

  showNotification(context) {
    setState(ViewState.Busy);
    walletService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        globals.red,
        context);
    setState(ViewState.Idle);
  }

  updateTransFee() async {
    setState(ViewState.Busy);
    var to = getOfficalAddress(coinName);
    var amount = double.tryParse(myController.text);
    if (to == null || amount == null || amount <= 0) {
      return;
    }
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

    var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);
    var kanbanTransFeeDouble = (Decimal.parse(kanbanPrice.toString()) *
            Decimal.parse(kanbanGasLimit.toString()) /
            Decimal.parse('1e18'))
        .toDouble();
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
        setState(ViewState.Busy);
        transFee = ret['transFee'];
        kanbanTransFee = kanbanTransFeeDouble;
        setState(ViewState.Idle);
      }
    }).catchError((onError) {
      setState(ViewState.Idle);
      log.e(onError);
    });

    setState(ViewState.Idle);
  }
}
