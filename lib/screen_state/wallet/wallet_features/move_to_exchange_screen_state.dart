import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../../logger.dart';
import '../../../shared/globals.dart' as globals;

class MoveToExchangeViewModel extends BaseState {
  final log = getLogger('MoveToExchangeScreenState');

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();

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
  bool isValid = false;
  double gasAmount = 0.0;

  void initState() async {
    setState(ViewState.Busy);
    coinName = walletInfo.tickerName;
    tokenType = walletInfo.tokenType;
    print('coinName==' + coinName);
    if (coinName == 'BTC') {
      satoshisPerByteTextController.text =
          environment["chains"]["BTC"]["satoshisPerBytes"].toString();
    } else if (coinName == 'LTC') {
      satoshisPerByteTextController.text =
          environment["chains"]["LTC"]["satoshisPerBytes"].toString();
    } else if (coinName == 'DOGE') {
      satoshisPerByteTextController.text =
          environment["chains"]["DOGE"]["satoshisPerBytes"].toString();
    } else if (coinName == 'ETH' || tokenType == 'ETH') {
      //gasPriceTextController.text =
      //    environment["chains"]["ETH"]["gasPrice"].toString();
      var gasPriceReal = await walletService.getEthGasPrice();
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
    kanbanGasPriceTextController.text =
        environment["chains"]["KANBAN"]["gasPrice"].toString();
    kanbanGasLimitTextController.text =
        environment["chains"]["KANBAN"]["gasLimit"].toString();

    await getGas();
    setState(ViewState.Idle);
  }

/*---------------------------------------------------
                      Get gas
--------------------------------------------------- */

  getGas() async {
    String address = await sharedService.getExgAddressFromWalletDatabase();
    await walletService.gasBalance(address).then((data) {
      gasAmount = data;
      if (gasAmount < 0.5) {
        sharedService.alertDialog(
          AppLocalizations.of(context).notice,
          AppLocalizations.of(context).insufficientGasAmount,
        );
      }
    }).catchError((onError) => log.e(onError));
    log.w('gas amount $gasAmount');
    return gasAmount;
  }

/*---------------------------------------------------
                      Check Pass
--------------------------------------------------- */

  checkPass() async {
    setState(ViewState.Busy);
    if (gasAmount == 0.0 || gasAmount < 0.5) {
      sharedService.alertDialog(
        AppLocalizations.of(context).notice,
        AppLocalizations.of(context).insufficientGasAmount,
      );
      setState(ViewState.Idle);
      return;
    }
    var amount = double.tryParse(myController.text);

    if (amount == null ||
        amount > walletInfo.availableBalance ||
        amount == 0 ||
        amount.isNegative) {
      sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).pleaseEnterValidNumber,
          isWarning: false);
      setState(ViewState.Idle);
      return;
    }
    // if (amount < environment["minimumWithdraw"][walletInfo.tickerName]) {
    //   sharedService.showInfoFlushbar(
    //       AppLocalizations.of(context).minimumAmountError,
    //       AppLocalizations.of(context).yourWithdrawMinimumAmountaIsNotSatisfied,
    //       Icons.cancel,
    //       globals.red,
    //       context);
    //   setState(ViewState.Idle);
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
      log.i('wallet info  ${walletInfo.toJson()}');
      // if (coinName == 'USDT' || coinName == 'HOT') {
      //   tokenType = 'ETH';
      // }
      // if (coinName == 'EXG') {
      //   tokenType = 'FAB';
      // }

      var gasPrice = int.tryParse(gasPriceTextController.text);
      var gasLimit = int.tryParse(gasLimitTextController.text);
      var satoshisPerBytes = int.tryParse(satoshisPerByteTextController.text);
      var kanbanGasPrice = int.tryParse(kanbanGasPriceTextController.text);
      var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);

      var option = {
        "gasPrice": gasPrice ?? 0,
        "gasLimit": gasLimit ?? 0,
        "satoshisPerBytes": satoshisPerBytes ?? 0,
        'kanbanGasPrice': kanbanGasPrice,
        'kanbanGasLimit': kanbanGasLimit,
        'tokenType': walletInfo.tokenType,
        'contractAddress': environment["addresses"]["smartContract"]
            [walletInfo.tickerName]
      };
      log.i(
          '3 - -$seed, -- ${walletInfo.tickerName}, -- ${walletInfo.tokenType}, --   $amount, - - $option');
      await walletService
          .depositDo(
              seed, walletInfo.tickerName, walletInfo.tokenType, amount, option)
          .then((ret) {
        log.w(ret);

        bool success = ret["success"];
        if (success) {
          myController.text = '';
          String txId = ret['data']['transactionID'];

          var allTxids = ret["txids"];
          walletService.addTxids(allTxids);
          setMessage(txId);
          String date = DateTime.now().toString();
          TransactionHistory transactionHistory = new TransactionHistory(
              id: null,
              tickerName: walletInfo.tickerName,
              address: '',
              amount: 0.0,
              date: date.toString(),
              txId: txId,
              status: 'pending',
              quantity: amount,
              tag: 'deposit');

          walletService.checkDepositTransactionStatus(transactionHistory);
          walletService.insertTransactionInDatabase(transactionHistory);
        }
        showSimpleNotification(
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  success
                      ? Text(AppLocalizations.of(context)
                          .depositTransactionSuccess)
                      : Text(AppLocalizations.of(context)
                          .depositTransactionFailed),
                  success
                      ? Text("")
                      : ret.containsKey("error") && ret["error"] != null
                          ? Text(ret["error"])
                          : Text(AppLocalizations.of(context).serverError),
                ]),
            position: NotificationPosition.bottom,
            background: primaryColor);
        // sharedService.alertDialog(
        //     success
        //         ? AppLocalizations.of(context).depositTransactionSuccess
        //         : AppLocalizations.of(context).depositTransactionFailed,
        //     success
        //         ? ""
        //         : ret.containsKey("error") && ret["error"] != null
        //             ? ret["error"]
        //             : AppLocalizations.of(context).serverError,
        //     isWarning: false);
      }).catchError((onError) {
        log.e('Deposit Catch $onError');
        sharedService.alertDialog(
            AppLocalizations.of(context).depositTransactionFailed,
            AppLocalizations.of(context).serverError,
            isWarning: false);
      });
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
    setState(ViewState.Idle);
  }

/*----------------------------------------------------------------------
                    ShowNotification
----------------------------------------------------------------------*/

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

/*----------------------------------------------------------------------
                    Update Transaction Fee
----------------------------------------------------------------------*/
  updateTransFee() async {
    setState(ViewState.Busy);
    var to = getOfficalAddress(coinName);
    var amount = double.tryParse(myController.text);
    if (to == null || amount == null || amount <= 0) {
      setState(ViewState.Idle);
      return;
    }
    isValid = true;
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
      log.w(ret);
      if (ret != null && ret['transFee'] != null) {
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

// Copy txid and display flushbar
  copyAndShowNotification(String message) {
    sharedService.copyAddress(context, message);
  }
}
