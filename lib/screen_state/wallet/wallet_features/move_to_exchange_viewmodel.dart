import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import '../../../logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import '../../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:web3dart/crypto.dart' as CryptoWeb3;
import 'dart:convert';

class MoveToExchangeViewModel extends BaseViewModel {
  final log = getLogger('MoveToExchangeViewModel');

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  ApiService apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
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
  PairDecimalConfig singlePairDecimalConfig = new PairDecimalConfig();
  bool isShowErrorDetailsButton = false;
  bool isShowDetailsMessage = false;
  String serverError = '';
  String specialTicker = '';
  var res;

  void initState() async {
    setBusy(true);
    coinName = walletInfo.tickerName;
    if(coinName == 'FAB') walletInfo.tokenType = '';
    tokenType = walletInfo.tokenType;
    if (coinName != 'TRX' && coinName != 'USDTX') {
      setFee();
      await getGas();
    }
    specialTicker = walletService.updateSpecialTokensTickerNameForTxHistory(
        walletInfo.tickerName)['tickerName'];
    refreshBalance();
    await getDecimalData();
    setBusy(false);
  }

  showDetailsMessageToggle() {
    setBusy(true);
    isShowDetailsMessage = !isShowDetailsMessage;
    setBusy(false);
  }

  getDecimalData() async {
    setBusy(true);
    singlePairDecimalConfig =
        await sharedService.getSinglePairDecimalConfig(coinName);
    log.i('singlePairDecimalConfig ${singlePairDecimalConfig.toJson()}');
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
    if ((gasAmount == 0.0 || gasAmount < 0.5) &&
        walletInfo.tickerName != 'TRX' &&
        walletInfo.tickerName != 'USDTX') {
      sharedService.alertDialog(
        AppLocalizations.of(context).notice,
        AppLocalizations.of(context).insufficientGasAmount,
      );
      setBusy(false);
      return;
    }
    var amount = double.tryParse(amountController.text);

    await refreshBalance();

    if (amount == null ||
        amount > walletInfo.availableBalance ||
        amount == 0 ||
        amount.isNegative) {
      log.e('amount $amount --- wallet bal: ${walletInfo.availableBalance}');
      sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).insufficientBalance,
          isWarning: false);
      setBusy(false);
      return;
    }

    if (walletInfo.tickerName == 'USDTX' &&
        walletInfo.availableBalance < 15.0) {
      log.e('amount $amount --- wallet bal: ${walletInfo.availableBalance}');
      sharedService.alertDialog(
          '${AppLocalizations.of(context).fee} ${AppLocalizations.of(context).notice}',
          AppLocalizations.of(context).insufficientBalance,
          isWarning: false);
      setBusy(false);
      return;
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
      log.i(
          '3 - -$seed, -- ${walletInfo.tickerName}, --   $amount, - - $option');

      // TRON Transaction
      if (walletInfo.tickerName == 'TRX' || walletInfo.tickerName == 'USDTX') {
        log.i('depositing tron ${walletInfo.tickerName}');

        await walletService
            .depositTron(
                mnemonic: mnemonic,
                walletInfo: walletInfo,
                amount: amount,
                isTrxUsdt: walletInfo.tickerName == 'USDTX' ? true : false,
                isBroadcast: false)
            .then((res) {
          bool success = res["success"];
          if (success) {
            amountController.text = '';
            String txId = res['data']['transactionID'];

            isShowErrorDetailsButton = false;
            isShowDetailsMessage = false;
            message = txId.toString();

            sharedService.alertDialog(
              AppLocalizations.of(context).sendTransactionComplete,
              '$tickerName ${AppLocalizations.of(context).isOnItsWay}',
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
          sharedService.alertDialog(AppLocalizations.of(context).serverError,
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}',
              isWarning: false);

          setBusy(false);
        });
      }

      // Normal DEPOSIT

      else {
        await walletService
            .depositDo(seed, walletInfo.tickerName, walletInfo.tokenType,
                amount, option)
            .then((ret) {
          log.w(ret);

          bool success = ret["success"];
          if (success) {
            amountController.text = '';
            String txId = ret['data']['transactionID'];

            var allTxids = ret["txids"];
            walletService.addTxids(allTxids);
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
                            ? Text(ret["data"])
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
          serverError = onError.toString();
        });
      }
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Refresh Balance
----------------------------------------------------------------------*/
  refreshBalance() async {
    setBusy(true);

    String fabAddress = await sharedService.getFABAddressFromWalletDatabase();
    await apiService
        .getSingleWalletBalance(
            fabAddress, walletInfo.tickerName, walletInfo.address)
        .then((walletBalance) {
      if (walletBalance != null) {
        log.w(walletBalance[0].balance);
        walletInfo.availableBalance = walletBalance[0].balance;
      }
    }).catchError((err) {
      log.e(err);
      setBusy(false);
      throw Exception(err);
    });
    setBusy(false);
  }
/*----------------------------------------------------------------------
                    ShowNotification
----------------------------------------------------------------------*/

  showNotification(context) {
    setBusy(true);
    sharedService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        globals.red,
        context);
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Update Transaction Fee
----------------------------------------------------------------------*/
  updateTransFee() async {
    setBusy(true);
    var to = getOfficalAddress(coinName, tokenType: tokenType);
    var amount = double.tryParse(amountController.text);
    if (to == null || amount == null || amount <= 0) {
      setBusy(false);
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
      log.w('updateTransFee $ret');
      if (ret != null && ret['transFee'] != null) {
        transFee = ret['transFee'];
        kanbanTransFee = kanbanTransFeeDouble;
        setBusy(false);
      }
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
