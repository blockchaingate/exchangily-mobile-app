import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';

class MoveToWalletViewmodel extends BaseState {
  final log = getLogger('MoveToWalletViewmodel');

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  ApiService apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();

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
  double gasAmount = 0.0;
  var withdrawLimit;

/*---------------------------------------------------
                      INIT
--------------------------------------------------- */
  void initState() {
    setBusy(true);
    var gasPrice = environment["chains"]["KANBAN"]["gasPrice"];
    var gasLimit = environment["chains"]["KANBAN"]["gasLimit"];
    setWithdrawLimit();
    kanbanGasPriceTextController.text = gasPrice.toString();
    kanbanGasLimitTextController.text = gasLimit.toString();

    kanbanTransFee = bigNum2Double(gasPrice * gasLimit);

    if (walletInfo.tickerName == 'ETH' || walletInfo.tickerName == 'USDT') {
      gasFeeUnit = 'WEI';
    } else if (walletInfo.tickerName == 'FAB') {
      gasFeeUnit = 'LIU';
      feeMeasurement = '10^(-8)';
    }
    checkGasBalance();
    getSingleCoinExchangeBal();
    setBusy(false);
  }

  /*---------------------------------------------------
                      Set Withdraw Limit
--------------------------------------------------- */
  setWithdrawLimit() async {
    setBusy(true);
    withdrawLimit = environment["minimumWithdraw"][walletInfo.tickerName];
    print('wl $withdrawLimit');
    if (withdrawLimit == null) {
      await tokenListDatabaseService
          .getByTickerName(walletInfo.tickerName)
          .then((token) => withdrawLimit = double.parse(token.minWithdraw));
    }
    log.i('withdrawLimit $withdrawLimit');
    setBusy(false);
  }

/*---------------------------------------------------
                      Get gas
--------------------------------------------------- */

  checkGasBalance() async {
    String address = await sharedService.getExgAddressFromWalletDatabase();
    await walletService.gasBalance(address).then((data) {
      gasAmount = data;
      log.i('gas balance $gasAmount');
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

  // Check single coin exchange balance
  getSingleCoinExchangeBal() async {
    setBusy(true);
    await apiService
        .getSingleCoinExchangeBalance(walletInfo.tickerName)
        .then((res) {
      walletInfo.inExchange = res.unlockedAmount;
      log.w('exchange balance check ${walletInfo.inExchange}');
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                      Verify Wallet Password
----------------------------------------------------------------------*/
  checkPass() async {
    setBusy(true);
    if (amountController.text.isEmpty) {
      sharedService.showInfoFlushbar(
          AppLocalizations.of(context).minimumAmountError,
          AppLocalizations.of(context).yourWithdrawMinimumAmountaIsNotSatisfied,
          Icons.cancel,
          red,
          context);
      setBusy(false);
      return;
    }
    await checkGasBalance();
    if (gasAmount == 0.0 || gasAmount < 0.5) {
      sharedService.alertDialog(
        AppLocalizations.of(context).notice,
        AppLocalizations.of(context).insufficientGasAmount,
      );
      setBusy(false);
      return;
    }

    var amount = double.tryParse(amountController.text);
    if (amount < withdrawLimit) {
      sharedService.showInfoFlushbar(
          AppLocalizations.of(context).minimumAmountError,
          AppLocalizations.of(context).yourWithdrawMinimumAmountaIsNotSatisfied,
          Icons.cancel,
          red,
          context);
      setBusy(false);
      return;
    }
    getSingleCoinExchangeBal();
    if (amount == null ||
        amount > walletInfo.inExchange ||
        amount == 0 ||
        amount.isNegative) {
      sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).pleaseEnterValidNumber,
          isWarning: false);
      setBusy(false);
      return;
    }

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

      if (coinName == 'BCH') {
        await walletService.getBchAddressDetails(coinAddress).then(
            (addressDetails) => coinAddress = addressDetails['legacyAddress']);
      }

      var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
      var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);

      await walletService
          .withdrawDo(seed, coinName, coinAddress, tokenType, amount,
              kanbanPrice, kanbanGasLimit)
          .then((ret) {
        log.w(ret);
        bool success = ret["success"];
        if (success && ret['transactionHash'] != null) {
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
              txId: txId,
              status: 'pending',
              quantity: amount,
              tag: 'withdraw');

          walletService.checkTxStatus(transactionHistory);
          walletService.insertTransactionInDatabase(transactionHistory);
          // Future.delayed(Duration(seconds: 10), () async {
          //   await apiService
          //       .getSingleCoinExchangeBalance(walletInfo.tickerName)
          //       .then((res) {
          //         if(navigationService.)
          //     walletInfo.inExchange = res.unlockedAmount;
          //     log.w('exchange balance reload ${walletInfo.inExchange}');
          //   });
          // });
        } else {
          var errMsg = ret['data'];
          if (errMsg == null || errMsg == '') {
            errMsg = AppLocalizations.of(context).serverError;
            setErrorMessage(errMsg);
          }
        }
        sharedService.alertDialog(
            success && ret['transactionHash'] != null
                ? AppLocalizations.of(context).withdrawTransactionSuccessful
                : AppLocalizations.of(context).withdrawTransactionFailed,
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
        red,
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
