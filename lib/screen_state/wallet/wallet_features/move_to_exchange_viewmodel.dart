import 'dart:convert';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/core_wallet_model.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import '../../../logger.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';

class MoveToExchangeViewModel extends BaseViewModel {
  final log = getLogger('MoveToExchangeViewModel');

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  ApiService apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  CoreWalletDatabaseService walletDatabaseService =
      locator<CoreWalletDatabaseService>();
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
  String message = '';
  final amountController = TextEditingController();
  bool isValid = false;
  double gasAmount = 0.0;
  bool isShowErrorDetailsButton = false;
  bool isShowDetailsMessage = false;
  String serverError = '';
  String specialTicker = '';
  var res;
  double amount = 0.0;
  String feeUnit = '';
  final coinUtils = CoinUtils();
  int decimalLimit = 8;

  // Init
  void initState() async {
    setBusy(true);
    coinName = walletInfo.tickerName;
    if (coinName == 'FAB') walletInfo.tokenType = '';
    tokenType = walletInfo.tokenType;
    //   if (coinName != 'TRX' && coinName != 'USDTX') {
    setFee();
    await getGas();
    //  }
    specialTicker = walletService.updateSpecialTokensTickerNameForTxHistory(
        walletInfo.tickerName)['tickerName'];
    refreshBalance();

    if (coinName == 'BTC') {
      feeUnit = 'BTC';
    } else if (coinName == 'ETH' || tokenType == 'ETH') {
      feeUnit = 'ETH';
    } else if (coinName == 'FAB') {
      feeUnit = 'FAB';
    } else if (tokenType == 'FAB') {
      feeUnit = 'FAB';
    }
    decimalLimit =
        await walletService.getSingleCoinWalletDecimalLimit(coinName);
    if (decimalLimit == null || decimalLimit == 0) decimalLimit = 8;
    setBusy(false);
  }

  showDetailsMessageToggle() {
    setBusy(true);
    isShowDetailsMessage = !isShowDetailsMessage;
    setBusy(false);
  }

/*---------------------------------------------------
                  Amount After fee
--------------------------------------------------- */
  Future<double> amountAfterFee(double amount,
      {bool isMaxAmount = false}) async {
    double finalAmount = 0.0;
    // update transfee is 0
    if (transFee == 0.0 && !walletService.isTrx(walletInfo.tickerName))
      await updateTransFee();
    // if tron coins then assign fee accordingly
    if (walletService.isTrx(walletInfo.tickerName)) {
      if (walletInfo.tickerName == 'USDTX') {
        transFee = 15;
        finalAmount = amount;
      }

      if (walletInfo.tickerName == 'TRX') {
        transFee = 1.0;
        finalAmount = isMaxAmount ? amount - transFee : amount + transFee;
      }
    } else {
      walletInfo.tokenType.isEmpty &&
              (amount == walletInfo.availableBalance || isMaxAmount)
          ? finalAmount = amount - transFee
          : finalAmount = amount;
    }
    return finalAmount;
  }

/*---------------------------------------------------
                  Fill Max Amount
--------------------------------------------------- */
  fillMaxAmount() async {
    setBusy(true);
    amount = walletInfo.availableBalance;
    double finalAmount = 0.0;
    await amountAfterFee(amount, isMaxAmount: true)
        .then((resAmount) => finalAmount = resAmount);
    //  finalAmount = amount = finalAmount;
    amountController.text = NumberUtil()
        .truncateDoubleWithoutRouding(finalAmount, precision: decimalLimit)
        .toString();

    setBusy(false);
  }

/*---------------------------------------------------
                      Set fee
--------------------------------------------------- */

  setFee() async {
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
  }

/*---------------------------------------------------
                      Get gas
--------------------------------------------------- */

  getGas() async {
    String address = await sharedService.getExgAddressFromWalletDatabase();
    await walletService.gasBalance(address).then((data) {
      gasAmount = data;
      if (gasAmount == 0) {
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
                Check pass and amount
--------------------------------------------------- */
  checkPass() async {
    setBusy(true);

    if (amountController.text.isEmpty) {
      sharedService.showInfoFlushbar(
          AppLocalizations.of(context).amountMissing,
          AppLocalizations.of(context).pleaseEnterValidNumber,
          Icons.cancel,
          red,
          context);
      setBusy(false);
      return;
    }
    if (gasAmount == 0.0 || gasAmount < kanbanTransFee) {
      sharedService.showInfoFlushbar(
          AppLocalizations.of(context).notice,
          AppLocalizations.of(context).insufficientGasAmount,
          Icons.cancel,
          red,
          context);

      setBusy(false);
      return;
    }
    if (!isValid &&
        walletInfo.tickerName != 'TRX' &&
        walletInfo.tickerName != 'USDTX') {
      sharedService.showInfoFlushbar(
          AppLocalizations.of(context).notice,
          AppLocalizations.of(context).insufficientBalance,
          Icons.cancel,
          red,
          context);
      setBusy(false);
      return;
    }

    amount = double.tryParse(amountController.text);

    // amount = NumberUtil().roundDownLastDigit(amount);
    await refreshBalance();

    double finalAmount = 0.0;
    if (!walletService.isTrx(walletInfo.tickerName))
      finalAmount = await amountAfterFee(amount);
    if (amount == null ||
        finalAmount > walletInfo.availableBalance ||
        amount == 0 ||
        amount.isNegative) {
      log.e('amount $amount --- wallet bal: ${walletInfo.availableBalance}');
      sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).insufficientBalance);

      setBusy(false);
      return;
    }
    // check chain balance
    if (tokenType.isNotEmpty) {
      bool hasSufficientChainBalance = await walletService
          .checkCoinWalletBalance(transFee, walletInfo.tokenType);
      if (!hasSufficientChainBalance) {
        log.e('Chain $tokenType -- insufficient balance');
        sharedService.sharedSimpleNotification(walletInfo.tokenType,
            subtitle: AppLocalizations.of(context).insufficientGasBalance);
        setBusy(false);
        return;
      }
    }

// * checking trx balance required
    if (walletInfo.tickerName == 'USDTX') {
      log.e('amount $amount --- wallet bal: ${walletInfo.availableBalance}');
      bool isCorrectAmount = true;
      await walletService
          .checkCoinWalletBalance(15, 'TRX')
          .then((res) => isCorrectAmount = res);
      log.w('isCorrectAmount $isCorrectAmount');
      if (!isCorrectAmount) {
        sharedService.alertDialog(
            '${AppLocalizations.of(context).fee} ${AppLocalizations.of(context).notice}',
            'TRX ${AppLocalizations.of(context).insufficientBalance}',
            isWarning: false);
        setBusy(false);
        return;
      }
    }

    if (walletInfo.tickerName == 'TRX') {
      log.e('amount $amount --- wallet bal: ${walletInfo.availableBalance}');
      bool isCorrectAmount = true;
      double trxFee = 1.0;
      if (amount + trxFee > walletInfo.availableBalance)
        isCorrectAmount = false;
      if (!isCorrectAmount) {
        sharedService.alertDialog(
            '${AppLocalizations.of(context).fee} ${AppLocalizations.of(context).notice}',
            'TRX ${AppLocalizations.of(context).insufficientBalance}',
            isWarning: false);
        setBusy(false);
        return;
      }
    }

    message = '';
    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      var seed;
      String mnemonic = res.returnedText;
      if (walletInfo.tickerName != 'TRX' && walletInfo.tickerName != 'USDTX')
        seed = walletService.generateSeed(mnemonic);
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
      String tickerName = walletInfo.tickerName;
      var decimal;
      //  BigInt bigIntAmount = BigInt.tryParse(amountController.text);
      // log.w('Big int amount $bigIntAmount');
      String contractAddr = '';
      if (walletInfo.tokenType.isNotEmpty)
        contractAddr = environment["addresses"]["smartContract"][tickerName];
      if (contractAddr == null && tokenType != '') {
        log.i(
            '$tickerName with token type $tokenType contract is null so fetching from token database');
        await tokenListDatabaseService
            .getByTickerName(tickerName)
            .then((token) {
          contractAddr = token.contract;
          decimal = token.decimal;
        });
      }

      var option = {
        "gasPrice": gasPrice ?? 0,
        "gasLimit": gasLimit ?? 0,
        "satoshisPerBytes": satoshisPerBytes ?? 0,
        'kanbanGasPrice': kanbanGasPrice,
        'kanbanGasLimit': kanbanGasLimit,
        'tokenType': walletInfo.tokenType,
        'contractAddress': contractAddr,
        'decimal': decimal
      };
      log.i('3 - -- ${walletInfo.tickerName}, --   $amount, - - $option');

      // TRON Transaction
      if (walletInfo.tickerName == 'TRX' || walletInfo.tickerName == 'USDTX') {
        setBusy(true);
        log.i('depositing tron ${walletInfo.tickerName}');

        await walletService
            .depositTron(
                mnemonic: mnemonic,
                walletInfo: walletInfo,
                amount: amount,
                isTrxUsdt: walletInfo.tickerName == 'USDTX' ? true : false,
                isBroadcast: false,
                options: option)
            .then((res) {
          bool success = res["success"];
          if (success) {
            amountController.text = '';
            String txId = res['data']['transactionID'];

            isShowErrorDetailsButton = false;
            isShowDetailsMessage = false;
            message = txId.toString();

            sharedService.alertDialog(
              AppLocalizations.of(context).depositTransactionSuccess,
              '$specialTicker ${AppLocalizations.of(context).isOnItsWay}',
            );
          } else {
            if (res.containsKey("error") && res["error"] != null) {
              serverError = res['error'].toString();
              isShowErrorDetailsButton = true;
            } else if (res["message"] != null) {
              serverError = res['message'].toString();
              isShowErrorDetailsButton = true;
            }
          }
        }).timeout(Duration(seconds: 25), onTimeout: () {
          log.e('In time out');
          setBusy(false);
          sharedService.alertDialog(AppLocalizations.of(context).notice,
              AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater,
              isWarning: false);
        }).catchError((error) {
          log.e('In Catch error - $error');
          sharedService.alertDialog(AppLocalizations.of(context).networkIssue,
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}',
              isWarning: false);

          setBusy(false);
        });
      }

      // Normal DEPOSIT

      else {
        await walletService
            .depositDo(seed, walletInfo.tickerName, walletInfo.tokenType,
                finalAmount, option)
            .then((ret) {
          log.w('deposit res $ret');

          bool success = ret["success"];
          if (success) {
            amountController.text = '';
            String txId = ret['data']['transactionID'];

            //  var allTxids = ret["txids"];
            // walletService.addTxids(allTxids);
            isShowErrorDetailsButton = false;
            isShowDetailsMessage = false;
            message = txId.toString();
          } else {
            if (ret.containsKey("error") && ret["error"] != null) {
              serverError = ret['error'].toString();
              isShowErrorDetailsButton = true;
            } else if (ret["message"] != null) {
              serverError = ret['message'].toString();
              isShowErrorDetailsButton = true;
            }
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
                        : ret["data"] != null
                            ? Text(ret["data"] ==
                                    'incorrect amount for two transactions'
                                ? AppLocalizations.of(context)
                                    .incorrectDepositAmountOfTwoTx
                                : ret["data"])
                            : Text(AppLocalizations.of(context).networkIssue),
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
              AppLocalizations.of(context).networkIssue,
              isWarning: false);
          serverError = onError.toString();
        });
      }
    } else if (res.returnedText == 'Closed' && !res.confirmed) {
      log.e('Dialog Closed By User');

      setBusy(false);
    } else if (res.isRequiredUpdate) {
      log.e('Wallet update required');
      setBusy(false);
      sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).importantWalletUpdateNotice);
    } else {
      log.e('Wrong pass');
      setBusy(false);
      sharedService.showNotification(context);
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Refresh Balance
----------------------------------------------------------------------*/
  refreshBalance() async {
    String fabAddress =
        await sharedService.getFabAddressFromCoreWalletDatabase();
    await apiService
        .getSingleWalletBalance(
            fabAddress, walletInfo.tickerName, walletInfo.address)
        .then((walletBalance) {
      if (walletBalance != null) {
        log.w('refreshed balance ${walletBalance[0].balance}');
        walletInfo.availableBalance = walletBalance[0].balance;
      }
    }).catchError((err) {
      log.e(err);
      setBusy(false);
      throw Exception(err);
    });
  }

/*----------------------------------------------------------------------
                    Update Transaction Fee
----------------------------------------------------------------------*/
  updateTransFee() async {
    setBusy(true);
    var to = coinUtils.getOfficalAddress(coinName, tokenType: tokenType);
    amount = double.tryParse(amountController.text);

    if (to == null || amount == null || amount <= 0) {
      transFee = 0.0;
      setBusy(false);
      return;
    }
    isValid = true;
    var gasPrice = int.tryParse(gasPriceTextController.text) ?? 0;
    var gasLimit = int.tryParse(gasLimitTextController.text) ?? 0;
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
      log.w('updateTransFee $ret');
      if (ret != null && ret['transFee'] != null) {
        transFee = ret['transFee'];
        kanbanTransFee = kanbanTransFeeDouble;
        setBusy(false);
      }
      if (walletInfo.tickerName != 'TRX' &&
          walletInfo.tickerName != 'USDTX' &&
          transFee == 0.0) isValid = false;
      //  log.e('total amount with fee ${amount + kanbanTransFee + transFee}');
      log.i('availableBalance ${walletInfo.availableBalance}');
    }).catchError((onError) {
      setBusy(false);
      log.e(onError);
    });

    setBusy(false);
  }

// Copy txid and display flushbar
  copyAndShowNotification(String message) {
    sharedService.copyAddress(context, message);
  }
}
