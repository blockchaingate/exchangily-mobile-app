import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import '../../../logger.dart';
import 'package:exchangilymobileapp/services/api_service.dart';

class MoveToExchangeViewModel extends BaseViewModel {
  final log = getLogger('MoveToExchangeViewModel');

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  ApiService apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  CoreWalletDatabaseService coreWalletDatabaseService =
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
  //bool isValid = false;
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
  double chainBalance = 0.0;
  String fabAddress = '';
  bool isValidAmount = true;

  // Init
  void initState() async {
    setBusy(true);
    coinName = walletInfo.tickerName;
    if (coinName == 'FAB') walletInfo.tokenType = '';
    if (coinName == 'USDTX') walletInfo.tokenType = 'TRX';
    tokenType = walletInfo.tokenType;
    setFee();
    await getGas();
    //  }
    specialTicker = walletService.updateSpecialTokensTickerNameForTxHistory(
        walletInfo.tickerName)['tickerName'];
    await refreshBalance();

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
    fabAddress =
        await coreWalletDatabaseService.getWalletAddressByTickerName('FAB');
    if (tokenType.isNotEmpty) await getNativeChainTickerBalance();
    setBusy(false);
  }

  // get native chain ticker balance
  getNativeChainTickerBalance() async {
    if (fabAddress.isEmpty)
      fabAddress =
          await coreWalletDatabaseService.getWalletAddressByTickerName('FAB');

    await apiService
        .getSingleWalletBalance(fabAddress, tokenType, walletInfo.address)
        .then((walletBalance) => chainBalance = walletBalance.first.balance);
  }

  showDetailsMessageToggle() {
    setBusy(true);
    isShowDetailsMessage = !isShowDetailsMessage;
    setBusy(false);
  }

/*---------------------------------------------------
                  Amount After fee
--------------------------------------------------- */
  Future<double> amountAfterFee({bool isMaxAmount = false}) async {
    setBusy(true);

    if (amountController.text.isEmpty) {
      transFee = 0.0;
      kanbanTransFee = 0.0;
      setBusy(false);
      return 0.0;
    }
    amount = NumberUtil().truncateDoubleWithoutRouding(
        double.parse(amountController.text),
        precision: decimalLimit);
    log.w('amountAfterFee func: amount $amount');

    double finalAmount = 0.0;
    // update if transfee is 0
    if (!walletService.isTrx(walletInfo.tickerName)) await updateTransFee();
    // if tron coins then assign fee accordingly
    if (walletService.isTrx(walletInfo.tickerName)) {
      if (walletInfo.tickerName == 'USDTX') {
        transFee = 15;
        finalAmount = amount;
        finalAmount <= walletInfo.availableBalance
            ? isValidAmount = true
            : isValidAmount = false;
      }

      if (walletInfo.tickerName == 'TRX') {
        transFee = 1.0;
        finalAmount = isMaxAmount ? amount - transFee : amount + transFee;
      }
    } else {
      // in any token transfer, gas fee is paid in native tokens so
      // in case of non-native tokens, need to check the balance of native tokens
      // so that there is fee to pay when transffering non-native tokens
      if (tokenType.isEmpty) {
        if (isMaxAmount)
          finalAmount = amount - transFee;
        else {
          log.e(
              'finalAmount ${amount + transFee} = amount $amount  + transFee $transFee');
          finalAmount = amount + transFee;
        }
      } else
        finalAmount = amount;
    }
    finalAmount <= walletInfo.availableBalance
        ? isValidAmount = true
        : isValidAmount = false;
    log.i(
        'Func:amountAfterFee --trans fee $transFee  -- entered amount $amount = finalAmount $finalAmount -- decimal limit final amount ${NumberUtil().truncateDoubleWithoutRouding(finalAmount, precision: decimalLimit)} -- isValidAmount $isValidAmount');
    setBusy(false);
    return NumberUtil()
        .truncateDoubleWithoutRouding(finalAmount, precision: decimalLimit);
  }

/*---------------------------------------------------
                  Fill Max Amount
--------------------------------------------------- */
  fillMaxAmount() async {
    setBusy(true);

    amount = walletInfo.availableBalance;
    amountController.text = amount.toString();

    if (!walletService.isTrx(walletInfo.tickerName)) await updateTransFee();
    double finalAmount = 0.0;
    if (walletService.isTrx(walletInfo.tickerName)) {
      transFee = 1;
    }
    if (transFee != 0.0) {
      finalAmount = await amountAfterFee(isMaxAmount: true);
      amountController.text = NumberUtil()
          .truncateDoubleWithoutRouding(finalAmount, precision: decimalLimit)
          .toString();
    } else
      sharedService.sharedSimpleNotification(
          FlutterI18n.translate(context, "insufficientGasAmount"));
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
          FlutterI18n.translate(context, "notice"),
          FlutterI18n.translate(context, "insufficientGasAmount"),
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
      sharedService.sharedSimpleNotification(
          FlutterI18n.translate(context, "amountMissing"),
          subtitle: FlutterI18n.translate(context, "pleaseEnterValidNumber"));

      setBusy(false);
      return;
    }
    if (gasAmount == 0.0 || gasAmount < kanbanTransFee || transFee == 0.0) {
      sharedService.sharedSimpleNotification(
          FlutterI18n.translate(context, "notice"),
          subtitle: FlutterI18n.translate(context, "insufficientGasAmount"));

      setBusy(false);
      return;
    }

    if (transFee > walletInfo.availableBalance &&
        walletInfo.tickerName != 'TRX' &&
        walletInfo.tickerName != 'USDTX') {
      sharedService.sharedSimpleNotification(
          FlutterI18n.translate(context, "insufficientBalance"),
          subtitle:
              '${FlutterI18n.translate(context, "gasFee")} $transFee > ${FlutterI18n.translate(context, "walletbalance")} ${walletInfo.availableBalance}');

      setBusy(false);
      return;
    }

    await refreshBalance();

    double finalAmount = 0.0;
    if (!walletService.isTrx(walletInfo.tickerName))
      finalAmount = await amountAfterFee();

    if (amount == null ||
        finalAmount > walletInfo.availableBalance ||
        amount == 0 ||
        amount.isNegative) {
      log.e(
          'amount $amount --- final amount with fee: $finalAmount -- wallet bal: ${walletInfo.availableBalance}');
      sharedService.alertDialog(FlutterI18n.translate(context, "invalidAmount"),
          FlutterI18n.translate(context, "insufficientBalance"),
          isWarning: false);
      setBusy(false);
      return;
    }

    /// check chain balance to check
    /// whether native token has enough balance to cover transaction fee
    if (tokenType.isNotEmpty) {
      bool hasSufficientChainBalance = await walletService
          .hasSufficientWalletBalance(transFee, walletInfo.tokenType);
      if (!hasSufficientChainBalance) {
        log.e('Chain $tokenType -- insufficient balance');
        sharedService.sharedSimpleNotification(walletInfo.tokenType,
            subtitle: FlutterI18n.translate(context, "insufficientBalance"));
        setBusy(false);
        return;
      }
    }

// * checking trx balance required
    if (walletInfo.tickerName == 'USDTX') {
      log.e('amount $amount --- wallet bal: ${walletInfo.availableBalance}');
      bool isCorrectAmount = true;
      await walletService
          .hasSufficientWalletBalance(15, 'TRX')
          .then((res) => isCorrectAmount = res);
      log.w('isCorrectAmount $isCorrectAmount');
      if (!isCorrectAmount) {
        sharedService.alertDialog(
            '${FlutterI18n.translate(context, "fee")} ${FlutterI18n.translate(context, "notice")}',
            'TRX ${FlutterI18n.translate(context, "insufficientBalance")}',
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
            '${FlutterI18n.translate(context, "fee")} ${FlutterI18n.translate(context, "notice")}',
            'TRX ${FlutterI18n.translate(context, "insufficientBalance")}',
            isWarning: false);
        setBusy(false);
        return;
      }
    }

    message = '';
    var res = await _dialogService.showDialog(
        title: FlutterI18n.translate(context, "enterPassword"),
        description:
            FlutterI18n.translate(context, "dialogManagerTypeSamePasswordNote"),
        buttonTitle: FlutterI18n.translate(context, "confirm"));
    if (res.confirmed) {
      var seed;
      String mnemonic = res.returnedText;
      if (walletInfo.tickerName != 'TRX' && walletInfo.tickerName != 'USDTX')
        seed = walletService.generateSeed(mnemonic);

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
      if (decimal == null) decimal = decimalLimit;
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

            sharedService.sharedSimpleNotification(
                FlutterI18n.translate(context, "depositTransactionSuccess"),
                subtitle:
                    '$specialTicker ${FlutterI18n.translate(context, "isOnItsWay")}',
                isError: false);
            Future.delayed(new Duration(seconds: 3), () {
              refreshBalance();
            });
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
          sharedService.alertDialog(
              FlutterI18n.translate(context, "notice"),
              FlutterI18n.translate(
                  context, "serverTimeoutPleaseTryAgainLater"),
              isWarning: false);
        }).catchError((error) {
          log.e('In Catch error - $error');
          sharedService.alertDialog(
              FlutterI18n.translate(context, "networkIssue"),
              '$tickerName ${FlutterI18n.translate(context, "transanctionFailed")}',
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
                        ? Text(FlutterI18n.translate(
                            context, "depositTransactionSuccess"))
                        : Text(FlutterI18n.translate(
                            context, "depositTransactionFailed")),
                    success
                        ? Text("")
                        : ret["data"] != null
                            ? Text(ret["data"] ==
                                    'incorrect amount for two transactions'
                                ? FlutterI18n.translate(
                                    context, "incorrectDepositAmountOfTwoTx")
                                : ret["data"])
                            : Text(
                                FlutterI18n.translate(context, "networkIssue")),
                  ]),
              position: NotificationPosition.bottom,
              background: primaryColor);
          Future.delayed(new Duration(seconds: 3), () {
            refreshBalance();
          });

          // sharedService.alertDialog(
          //     success
          //         ? FlutterI18n.translate(context, "depositTransactionSuccess")
          //         : FlutterI18n.translate(context, "depositTransactionFailed"),
          //     success
          //         ? ""
          //         : ret.containsKey("error") && ret["error"] != null
          //             ? ret["error"]
          //             : FlutterI18n.translate(context, "serverError"),
          //     isWarning: false);
        }).catchError((onError) {
          log.e('Deposit Catch $onError');

          sharedService.alertDialog(
              FlutterI18n.translate(context, "depositTransactionFailed"),
              FlutterI18n.translate(context, "networkIssue"),
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
          FlutterI18n.translate(context, "importantWalletUpdateNotice"));
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
        setBusyForObject(walletInfo, true);
        walletInfo.availableBalance = walletBalance[0].balance;
        setBusyForObject(walletInfo, false);
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

    //amount = double.tryParse(amountController.text);

    if (to == null || amount == null || amount <= 0) {
      transFee = 0.0;
      kanbanTransFee = 0.0;
      setBusy(false);
      return;
    }

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
        transFee = NumberUtil()
            .truncateDoubleWithoutRouding(ret['transFee'], precision: 8);
        log.i('transfee $transFee');
        kanbanTransFee = kanbanTransFeeDouble;
        setBusy(false);
      }

      // if (walletInfo.tokenType.isEmpty)
      //   log.w(
      //       'Func: updateTransFee total amount with fee: amount $amount + kanbantransfee $kanbanTransFee + gasFee $transFee = ${amount + kanbanTransFee + transFee}');
      log.i(
          'Func: updateTransFee availableBalance ${walletInfo.availableBalance} -- amount entered $amount');
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
