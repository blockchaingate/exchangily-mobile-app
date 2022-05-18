import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/app_wallet_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/wallet/wallet_util.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import '../../../logger.dart';
import 'package:exchangilymobileapp/services/api_service.dart';

class MoveToExchangeViewModel extends BaseViewModel {
  final log = getLogger('MoveToExchangeViewModel');

  final DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  ApiService apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  TokenInfoDatabaseService tokenListDatabaseService =
      locator<TokenInfoDatabaseService>();
  CoreWalletDatabaseService coreWalletDatabaseService =
      locator<CoreWalletDatabaseService>();
  AppWallet appWallet;
  BuildContext context;
  final gasPriceTextController = TextEditingController();
  final gasLimitTextController = TextEditingController();
  final satoshisPerByteTextController = TextEditingController();
  final kanbanGasPriceTextController = TextEditingController();
  final kanbanGasLimitTextController = TextEditingController();
  Decimal transFee = Decimal.zero;
  Decimal kanbanTransFee = Decimal.zero;
  bool transFeeAdvance = false;
  String coinName = '';
  String tokenType = '';
  String message = '';
  final amountController = TextEditingController();
  //bool isValid = false;
  Decimal gasAmount = Decimal.zero;
  bool isShowErrorDetailsButton = false;
  bool isShowDetailsMessage = false;
  String serverError = '';
  String specialTicker = '';
  var res;
  var decimalZero = Decimal.zero;
  Decimal amount = Decimal.zero;
  String feeUnit = '';
  final coinUtils = CoinUtils();
  int decimalLimit = 8;
  Decimal chainBalance = Decimal.zero;
  String fabAddress = '';
  bool isValidAmount = true;
  var walletUtil = WalletUtil();

  final tec1 = TextEditingController();
  var oldBigIntOutputInInt;
  var oldIntOutputInBigInt;

  var newdoubleOutputInBigInt;

  // Init
  void initState() async {
    setBusy(true);
    coinName = appWallet.tickerName;
    if (coinName == 'FAB') appWallet.tokenType = '';
    if (coinName == 'USDTX') appWallet.tokenType = 'TRX';
    tokenType = appWallet.tokenType;
    setFee();
    await getGas();

    specialTicker = walletUtil.updateSpecialTokensTickerNameForTxHistory(
        appWallet.tickerName)['tickerName'];
    await refreshBalance();

    if (coinName == 'BTC') {
      feeUnit = 'BTC';
    } else if (coinName == 'ETH' || tokenType == 'ETH') {
      feeUnit = 'ETH';
    } else if (coinName == 'FAB') {
      feeUnit = 'FAB';
    } else if (tokenType == 'FAB') {
      feeUnit = 'FAB';
    } else if (coinName == 'MATICM' || tokenType == 'POLYGON') {
      feeUnit = 'MATIC(POLYGON)';
    }
    decimalLimit =
        await walletService.getSingleCoinWalletDecimalLimit(coinName);
    if (decimalLimit == null || decimalLimit == 0) decimalLimit = 8;
    fabAddress =
        await coreWalletDatabaseService.getWalletAddressByTickerName('FAB');
    if (tokenType.isNotEmpty) await getNativeChainTickerBalance();
    setBusy(false);
  }

  t1() {
    setBusy(true);
    // old
    try {
      oldBigIntOutputInInt =
          BigInt.parse(NumberUtil.toBigInt(tec1.text, 8)).toInt();
      oldIntOutputInBigInt = BigInt.from(oldBigIntOutputInInt);
      var amountNum = BigInt.parse(NumberUtil.toBigInt(tec1.text, 8)).toInt();
      debugPrint('amountNum $amountNum');
      var calc = (2 * 34 + 10) * 100;
      debugPrint('old calc $calc');
      amountNum += calc;
      //1452464262667475564
      //               7800
      //1452464262667483364
      debugPrint('amountNum + calc $amountNum');
      var amountOldDouble = amountNum / 1e8;
      log.i('amountOldDouble after calc $amountOldDouble');
      // 14524642626.67475564
    } catch (err) {
      log.e('old way broke, $err');
    }
    // new
    newdoubleOutputInBigInt = NumberUtil.decimalStringToBigInt(tec1.text);
    var amountNum2 = NumberUtil.decimalStringToBigInt(tec1.text);
    debugPrint('amountNum2 $amountNum2');
    log.w(
        'new bigint result to decimal ${NumberUtil.rawStringToDecimal(newdoubleOutputInBigInt.toString())}');
    //  BigInt feeCalc= (NumberUtil.decimalToBigInt(2.toString()) *
    //               NumberUtil.decimalToBigInt(34.toString()) +
    //           NumberUtil.decimalToBigInt(10.toString())) *
    //       NumberUtil.decimalToBigInt(100.toString());
    var two = BigInt.from(2);
    var threeFour = BigInt.from(34);
    var ten = BigInt.from(10);
    var hundred = BigInt.from(100);
    // var m = two * threeFour;
    // log.i('2*34 = $m');
    // var p = m + ten;
    // log.i('m+10 = $p');
    var newCalc = (two * threeFour + ten) * hundred;

    log.w('final new calc = $newCalc');
    // var newCalcBigInt = NumberUtil.decimalToBigInt(newCalc.toString());
    // debugPrint('new calc bigint $newCalcBigInt');
    amountNum2 += newCalc;
    log.e('amountnum2 +  finalRes = $amountNum2');
    //1452464262667475564000000000000000000000
    //           78000000000000000000000000000
    //1452464262745475564000000000000000000000
    // amountNum2 += (BigInt.parse(2.toString()) * BigInt.parse(34.toString()) +
    //         BigInt.parse(10.toString())) *
    //     BigInt.parse(100.toString());
    debugPrint('amountNum2 $amountNum2');
    log.w(
        'new bigint result to decimal ${NumberUtil.rawStringToDecimal(amountNum2.toString())}');
    // 14524642626.674755640000000000000000078
    // 14524642626.67475564(old)
    setBusy(false);
  }

  // get native chain ticker balance
  getNativeChainTickerBalance() async {
    if (fabAddress.isEmpty) {
      fabAddress =
          await coreWalletDatabaseService.getWalletAddressByTickerName('FAB');
    }

    await apiService
        .getSingleCoinWalletBalanceV2(fabAddress, tokenType, appWallet.address)
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
  Future<Decimal> amountAfterFee({bool isMaxAmount = false}) async {
    setBusy(true);
    if (amountController.text == '.') {
      setBusy(false);
      return decimalZero;
    }
    if (amountController.text.isEmpty) {
      transFee = decimalZero;
      kanbanTransFee = decimalZero;
      setBusy(false);
      return decimalZero;
    }
    amount = NumberUtil.decimalLimiter(Decimal.parse(amountController.text),
        decimalPrecision: decimalLimit);
    log.w('amountAfterFee func: amount $amount');

    Decimal finalAmount = Decimal.zero;
    // update if transfee is 0
    if (!walletService.isTrx(appWallet.tickerName)) await updateTransFee();
    // if tron coins then assign fee accordingly
    if (walletService.isTrx(appWallet.tickerName)) {
      if (appWallet.tickerName == 'USDTX') {
        transFee = NumberUtil.parseStringToDecimal("15");
        finalAmount = amount;
        finalAmount <=
                NumberUtil.parseStringToDecimal(appWallet.balance.toString())
            ? isValidAmount = true
            : isValidAmount = false;
      }

      if (appWallet.tickerName == 'TRX') {
        transFee = Decimal.one;
        finalAmount = isMaxAmount ? amount - transFee : amount + transFee;
      }
    } else {
      // in any token transfer, gas fee is paid in native tokens so
      // in case of non-native tokens, need to check the balance of native tokens
      // so that there is fee to pay when transffering non-native tokens
      if (tokenType.isEmpty) {
        if (isMaxAmount) {
          finalAmount = amount - transFee;
        } else {
          log.e(
              'finalAmount ${amount + transFee} = amount $amount  + transFee $transFee');
          finalAmount = amount + transFee;
        }
      } else {
        finalAmount = amount;
      }
    }
    finalAmount <= NumberUtil.parseStringToDecimal(appWallet.balance.toString())
        ? isValidAmount = true
        : isValidAmount = false;
    log.i(
        'Func:amountAfterFee --trans fee $transFee  -- entered amount $amount = finalAmount $finalAmount -- decimal limit final amount ${NumberUtil.decimalLimiter(finalAmount, decimalPrecision: decimalLimit)} -- isValidAmount $isValidAmount');
    setBusy(false);
    return NumberUtil.decimalLimiter(finalAmount,
        decimalPrecision: decimalLimit);
  }

/*---------------------------------------------------
                  Fill Max Amount
--------------------------------------------------- */
  fillMaxAmount() async {
    setBusy(true);

    amount = NumberUtil.parseStringToDecimal(appWallet.balance.toString());
    amountController.text = amount.toString();

    if (!walletService.isTrx(appWallet.tickerName)) await updateTransFee();
    Decimal finalAmount = decimalZero;
    if (walletService.isTrx(appWallet.tickerName)) {
      transFee = Decimal.one;
    }
    if (transFee != decimalZero) {
      finalAmount = await amountAfterFee(isMaxAmount: true);
      amountController.text =
          NumberUtil.decimalLimiter(finalAmount, decimalPrecision: decimalLimit)
              .toString();
    } else {
      sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).insufficientGasAmount);
    }
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
      if (gasAmount == decimalZero) {
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
      sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).amountMissing,
          subtitle: AppLocalizations.of(context).pleaseEnterValidNumber);

      setBusy(false);
      return;
    }
    if (gasAmount == decimalZero ||
        gasAmount < kanbanTransFee ||
        transFee == decimalZero) {
      sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).notice,
          subtitle: AppLocalizations.of(context).insufficientGasAmount);

      setBusy(false);
      return;
    }

    if (transFee >
            NumberUtil.parseStringToDecimal(appWallet.balance.toString()) &&
        appWallet.tickerName != 'TRX' &&
        appWallet.tickerName != 'USDTX') {
      sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).insufficientBalance,
          subtitle:
              '${AppLocalizations.of(context).gasFee} $transFee > ${AppLocalizations.of(context).walletbalance} ${appWallet.balance}');

      setBusy(false);
      return;
    }

    await refreshBalance();

    Decimal finalAmount = decimalZero;
    if (!walletService.isTrx(appWallet.tickerName)) {
      finalAmount = await amountAfterFee();
    }

    if (amount == null ||
        finalAmount >
            NumberUtil.parseStringToDecimal(appWallet.balance.toString()) ||
        amount == decimalZero ||
        amount.toString() == '-$amount') {
      log.e(
          'amount $amount --- final amount with fee: $finalAmount -- wallet bal: ${appWallet.balance}');
      sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).insufficientBalance,
          isWarning: false);
      setBusy(false);
      return;
    }

    /// check chain balance to check
    /// whether native token has enough balance to cover transaction fee
    if (tokenType.isNotEmpty) {
      bool hasSufficientChainBalance = await walletService
          .hasSufficientWalletBalance(transFee, appWallet.tokenType);
      if (!hasSufficientChainBalance) {
        log.e('Chain $tokenType -- insufficient balance');
        sharedService.sharedSimpleNotification(appWallet.tokenType,
            subtitle: AppLocalizations.of(context).insufficientBalance);
        setBusy(false);
        return;
      }
    }

// * checking trx balance required
    if (appWallet.tickerName == 'USDTX') {
      log.e('amount $amount --- wallet bal: ${appWallet.balance}');
      bool isCorrectAmount = true;
      await walletService
          .hasSufficientWalletBalance(Decimal.fromInt(15), 'TRX')
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

    if (appWallet.tickerName == 'TRX') {
      log.e('amount $amount --- wallet bal: ${appWallet.balance}');
      bool isCorrectAmount = true;
      Decimal trxFee = Decimal.one;
      if (amount + trxFee >
          NumberUtil.parseStringToDecimal(appWallet.balance.toString())) {
        isCorrectAmount = false;
      }
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
      if (appWallet.tickerName != 'TRX' && appWallet.tickerName != 'USDTX') {
        seed = walletService.generateSeed(mnemonic);
      }

      var gasPrice = int.tryParse(gasPriceTextController.text);
      var gasLimit = int.tryParse(gasLimitTextController.text);
      var satoshisPerBytes = int.tryParse(satoshisPerByteTextController.text);
      var kanbanGasPrice = int.tryParse(kanbanGasPriceTextController.text);
      var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);
      String tickerName = appWallet.tickerName;
      int decimal;
      //  BigInt bigIntAmount = BigInt.tryParse(amountController.text);
      // log.w('Big int amount $bigIntAmount');
      String contractAddr = '';
      if (appWallet.tokenType.isNotEmpty) {
        contractAddr = environment["addresses"]["smartContract"][tickerName];
      }
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
      decimal ??= decimalLimit;
      var option = {
        "gasPrice": gasPrice ?? 0,
        "gasLimit": gasLimit ?? 0,
        "satoshisPerBytes": satoshisPerBytes ?? 0,
        'kanbanGasPrice': kanbanGasPrice,
        'kanbanGasLimit': kanbanGasLimit,
        'tokenType': appWallet.tokenType,
        'contractAddress': contractAddr,
        'decimal': decimal
      };
      log.i('3 - -- ${appWallet.tickerName}, --   $amount, - - $option');

      // TRON Transaction
      if (appWallet.tickerName == 'TRX' || appWallet.tickerName == 'USDTX') {
        setBusy(true);
        log.i('depositing tron ${appWallet.tickerName}');

        await walletService
            .depositTron(
                mnemonic: mnemonic,
                appWallet: appWallet,
                amount: amount,
                isTrxUsdt: appWallet.tickerName == 'USDTX' ? true : false,
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
                AppLocalizations.of(context).depositTransactionSuccess,
                subtitle:
                    '$specialTicker ${AppLocalizations.of(context).isOnItsWay}',
                isError: false);
            Future.delayed(const Duration(seconds: 3), () {
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
        }).timeout(const Duration(seconds: 25), onTimeout: () {
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
            .depositDo(seed, appWallet.tickerName, appWallet.tokenType,
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
                        ? const Text("")
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
          Future.delayed(const Duration(seconds: 3), () {
            refreshBalance();
          });

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
      sharedService.inCorrectpasswordNotification(context);
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
        .getSingleCoinWalletBalanceV2(
            fabAddress, appWallet.tickerName, appWallet.address)
        .then((walletBalance) {
      if (walletBalance != null) {
        log.w('refreshed balance ${walletBalance[0].balance}');
        setBusyForObject(appWallet, true);
        appWallet.balance = walletBalance[0].balance;
        setBusyForObject(appWallet, false);
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

    if (to == null || amount == null || amount <= decimalZero) {
      transFee = decimalZero;
      kanbanTransFee = decimalZero;
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
      "tokenType": appWallet.tokenType,
      "getTransFeeOnly": true
    };
    var address = appWallet.address;

    var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);
    var kanbanTransFeeDouble = (Decimal.parse(kanbanPrice.toString()) *
            Decimal.parse(kanbanGasLimit.toString()) /
            Decimal.parse('1e18'))
        .toDecimal();
    //  .toDouble();

    await walletService
        .sendTransactionV2(
            appWallet.tickerName,
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
        transFee = NumberUtil.decimalLimiter(
            Decimal.parse(ret['transFee'].toString()),
            decimalPrecision: 8);
        log.i('transfee $transFee');
        kanbanTransFee = kanbanTransFeeDouble;
        setBusy(false);
      }

      // if (walletInfo.tokenType.isEmpty)
      //   log.w(
      //       'Func: updateTransFee total amount with fee: amount $amount + kanbantransfee $kanbanTransFee + gasFee $transFee = ${amount + kanbanTransFee + transFee}');
      log.i(
          'Func: updateTransFee availableBalance ${appWallet.balance} -- amount entered $amount');
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
