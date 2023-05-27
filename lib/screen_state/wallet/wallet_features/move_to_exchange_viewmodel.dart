import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/coin_service.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/utils/coin_utils/erc20_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/wallet/wallet_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import '../../../logger.dart';
import 'package:exchangilymobileapp/services/api_service.dart';

class MoveToExchangeViewModel extends BaseViewModel {
  final log = getLogger('MoveToExchangeViewModel');

  final DialogService _dialogService = locator<DialogService>();
  WalletService? walletService = locator<WalletService>();
  ApiService? apiService = locator<ApiService>();
  SharedService? sharedService = locator<SharedService>();
  TokenInfoDatabaseService? tokenListDatabaseService =
      locator<TokenInfoDatabaseService>();
  CoreWalletDatabaseService? coreWalletDatabaseService =
      locator<CoreWalletDatabaseService>();
  WalletInfo? walletInfo;
  late BuildContext context;
  final gasPriceTextController = TextEditingController();
  final gasLimitTextController = TextEditingController();
  final satoshisPerByteTextController = TextEditingController();
  final kanbanGasPriceTextController = TextEditingController();
  final kanbanGasLimitTextController = TextEditingController();
  final trxGasValueTextController = TextEditingController();
  Decimal transFee = Constants.decimalZero;
  Decimal kanbanTransFee = Constants.decimalZero;
  bool transFeeAdvance = false;
  String? coinName = '';
  String? tokenType = '';
  String message = '';
  final amountController = TextEditingController();
  //bool isValid = false;
  Decimal gasAmount = Constants.decimalZero;
  bool isShowErrorDetailsButton = false;
  bool isShowDetailsMessage = false;
  String serverError = '';
  String? specialTicker = '';
  var res;
  Decimal amount = Constants.decimalZero;
  String feeUnit = '';
  final coinUtils = CoinUtil();
  int? decimalLimit = 8;
  Decimal chainBalance = Constants.decimalZero;
  String? fabAddress = '';
  bool isValidAmount = true;
  var walletUtil = WalletUtil();
  var erc20Util = Erc20Util();

  // Init
  void initState() async {
    setBusy(true);
    coinName = walletInfo!.tickerName;
    if (coinName == 'FAB') walletInfo!.tokenType = '';
    if (coinName == 'USDTX') walletInfo!.tokenType = 'TRX';
    tokenType = walletInfo!.tokenType;
    await setFee();

    await getGasBalance();

    specialTicker = walletUtil
        .updateSpecialTokensTickerName(walletInfo!.tickerName!)['tickerName'];
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
    } else if (coinName == 'BNB' || tokenType == 'BNB') {
      feeUnit = 'BNB';
    }
    await CoinService()
        .getSingleTokenData(coinName)
        .then((token) => decimalLimit = token!.decimal);
    if (decimalLimit == null || decimalLimit == 0) decimalLimit = 8;
    fabAddress =
        await coreWalletDatabaseService!.getWalletAddressByTickerName('FAB');
    if (tokenType!.isNotEmpty) await getNativeChainTickerBalance();
    setBusy(false);
  }

  // get native chain ticker balance
  getNativeChainTickerBalance() async {
    if (fabAddress!.isEmpty) {
      fabAddress =
          await coreWalletDatabaseService!.getWalletAddressByTickerName('FAB');
    }
    var tt = tokenType == 'POLYGON' ? 'MATICM' : tokenType;
    await apiService!
        .getSingleWalletBalance(fabAddress, tt, walletInfo!.address)
        .then((walletBalance) => chainBalance = NumberUtil.roundDecimal(
            Decimal.parse(walletBalance!.first.balance.toString()),
            decimalLimit!));
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

    if (amountController.text == '.' || amountController.text.isEmpty) {
      setBusy(false);
      transFee = Constants.decimalZero;
      kanbanTransFee = Constants.decimalZero;
      return Constants.decimalZero;
    }

    log.w('amountAfterFee func: amount $amount');
    isValidAmount = true;
    Decimal finalAmount = Constants.decimalZero;

    // Update transaction fee if it is not a TRX transfer
    if (!isTrx()) {
      await updateTransFee();
    } else {
      transFee = Decimal.parse(trxGasValueTextController.text);
    }

    // Calculate the final amount based on whether it is a max amount transfer or not
    finalAmount = isMaxAmount ? amount - transFee : amount;
    finalAmount =
        NumberUtil.decimalLimiter(finalAmount, decimalPlaces: decimalLimit);

    // For native tokens
    if (tokenType!.isEmpty) {
      // Check if the user has enough balance for the fee and the amount they want to send
      if (NumberUtil.parseDoubleToDecimal(walletInfo!.availableBalance) <
          amount + transFee) {
        log.e(
            'Insufficient balance for the transaction. Required balance: ${amount + transFee}');
        isValidAmount = false;
        return Constants.decimalZero;
      }
    } else {
      // For non-native tokens
      // Check if the user has enough native token balance to pay for the gas fee
      if (NumberUtil.parseDoubleToDecimal(walletInfo!.availableBalance) <
          transFee) {
        isValidAmount = false;
        log.e(
            'Insufficient native token balance for the transaction. Required balance for gas fee: $transFee');
        return Constants.decimalZero;
      }
    }

    log.i(
        'Func:amountAfterFee --trans fee $transFee -- entered amount $amount = finalAmount $finalAmount -- isValidAmount $isValidAmount');
    setBusy(false);
    return finalAmount;
  }

  //0.025105000000000002

/*---------------------------------------------------
                  Fill Max Amount
--------------------------------------------------- */
  fillMaxAmount() async {
    setBusy(true);

    amount = NumberUtil.parseDoubleToDecimal(walletInfo!.availableBalance);
    amountController.text = amount.toString();

    if (!isTrx()) await updateTransFee();
    Decimal finalAmount = Constants.decimalZero;
    if (isTrx()) {
      transFee = Decimal.parse(trxGasValueTextController.text);
    }
    if (transFee != Constants.decimalZero) {
      finalAmount = await amountAfterFee(isMaxAmount: true);
      amountController.text =
          NumberUtil.decimalLimiter(finalAmount, decimalPlaces: decimalLimit)
              .toString();
    } else {
      sharedService!.sharedSimpleNotification(
          FlutterI18n.translate(context, "insufficientGasAmount"));
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
      var gasPriceReal = await walletService!.getEthGasPrice();
      gasPriceTextController.text = gasPriceReal.toString();
      gasLimitTextController.text =
          environment["chains"]["ETH"]["gasLimit"].toString();

      if (tokenType == 'ETH') {
        gasLimitTextController.text =
            environment["chains"]["ETH"]["gasLimitToken"].toString();
      }
    } else if (coinName == 'BNB' || tokenType == 'BNB') {
      var gasPriceReal = await erc20Util.getGasPrice(bnbBaseUrl!);
      gasPriceTextController.text = gasPriceReal.toString();
      gasLimitTextController.text =
          environment["chains"]["BNB"]["gasLimit"].toString();

      if (tokenType == 'BNB') {
        gasLimitTextController.text =
            environment["chains"]["BNB"]["gasLimitToken"].toString();
      }
    } else if (coinName == 'MATICM' || tokenType == 'POLYGON') {
      var gasPriceReal = await erc20Util.getGasPrice(maticmBaseUrl!);
      gasPriceTextController.text = gasPriceReal.toString();
      gasLimitTextController.text =
          environment["chains"]["MATICM"]["gasLimit"].toString();

      if (tokenType == 'POLYGON') {
        gasLimitTextController.text =
            environment["chains"]["POLYGON"]["gasLimitToken"].toString();
      }
    } else if (coinName == 'USDTX' || tokenType == 'TRX') {
      trxGasValueTextController.text = Constants.tronUsdtFee.toString();
    } else if (coinName == 'TRX') {
      trxGasValueTextController.text = Constants.tronFee.toString();
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
    var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);
    if (kanbanGasLimit != null && kanbanPrice != null) {
      var kanbanPriceBig = BigInt.from(kanbanPrice);
      var kanbanGasLimitBig = BigInt.from(kanbanGasLimit);
      var f = NumberUtil.rawStringToDecimal(
          (kanbanPriceBig * kanbanGasLimitBig).toString());
      kanbanTransFee = f;
      //  kanbanTransFee = kanbanTransFeeDouble;
      log.w('fee $kanbanPrice $kanbanGasLimit $kanbanTransFee');
    }
  }

/*---------------------------------------------------
                      Get gas
--------------------------------------------------- */

  getGasBalance() async {
    String address = (await sharedService!.getExgAddressFromWalletDatabase())!;
    await walletService!.gasBalance(address).then((data) {
      gasAmount = NumberUtil.parseDoubleToDecimal(data);
      if (gasAmount == Constants.decimalZero) {
        sharedService!.alertDialog(
          FlutterI18n.translate(context, "notice"),
          FlutterI18n.translate(context, "insufficientGasAmount"),
        );
      }
    }).catchError((onError) => log.e(onError));
    log.w('gas amount $gasAmount');
    return gasAmount;
  }

  bool isTrx() {
    log.w(
        'tickername ${walletInfo!.tickerName}:  isTrx ${walletInfo!.tickerName == 'TRX' || walletInfo!.tokenType == 'TRX'}');
    return walletInfo!.tickerName == 'TRX' || walletInfo!.tokenType == 'TRX'
        ? true
        : false;
  }

  checkPass() async {
    setBusy(true);

    if (amountController.text.isEmpty) {
      sharedService!.sharedSimpleNotification(
          FlutterI18n.translate(context, "amountMissing"),
          subtitle: FlutterI18n.translate(context, "pleaseEnterValidNumber"));

      setBusy(false);
      return;
    }
    if (gasAmount == Constants.decimalZero ||
        transFee == Constants.decimalZero) {
      sharedService!.sharedSimpleNotification(
          FlutterI18n.translate(context, "notice"),
          subtitle: FlutterI18n.translate(context, "insufficientGasAmount"));

      setBusy(false);
      return;
    }
    Decimal feeBalance = Constants.decimalZero;
    if (tokenType!.isEmpty) {
      feeBalance =
          NumberUtil.parseDoubleToDecimal(walletInfo!.availableBalance);
    } else {
      feeBalance = chainBalance;
    }
    if (transFee > feeBalance && !isTrx()) {
      sharedService!.sharedSimpleNotification(
          FlutterI18n.translate(context, "insufficientBalance"),
          subtitle:
              '${FlutterI18n.translate(context, "gasFee")} $transFee > ${FlutterI18n.translate(context, "walletbalance")} ${walletInfo!.availableBalance}');

      setBusy(false);
      return;
    }

    await refreshBalance();

    Decimal finalAmount = Constants.decimalZero;
    if (!isTrx()) {
      finalAmount = await amountAfterFee();
    }
    if (amount == Constants.decimalZero || amount.isInteger) {
      log.e(
          'amount $amount --- final amount with fee: $finalAmount -- wallet bal: ${walletInfo!.availableBalance}');
      sharedService!.alertDialog(
          FlutterI18n.translate(context, "invalidAmount"),
          FlutterI18n.translate(context, "pleaseEnterValidNumber"),
          isWarning: false);
      setBusy(false);
      return;
    }

    if (finalAmount >
        NumberUtil.parseDoubleToDecimal(walletInfo!.availableBalance)) {
      log.e(
          'amount $amount --- final amount with fee: $finalAmount -- wallet bal: ${walletInfo!.availableBalance}');
      sharedService!.alertDialog(
          FlutterI18n.translate(context, "invalidAmount"),
          FlutterI18n.translate(context, "insufficientBalance"),
          isWarning: false);
      setBusy(false);
      return;
    }

    /// check chain balance to check
    /// whether native token has enough balance to cover transaction fee
    if (tokenType!.isNotEmpty) {
      var tt = tokenType == 'POLYGON' ? 'MATICM' : tokenType;
      bool hasSufficientChainBalance = await walletService!
          .hasSufficientWalletBalance(transFee.toDouble(), tt);
      if (!hasSufficientChainBalance) {
        log.e('Chain $tokenType -- insufficient balance');
        sharedService!.sharedSimpleNotification(walletInfo!.tokenType!,
            subtitle: FlutterI18n.translate(context, "insufficientBalance"));
        setBusy(false);
        return;
      }
    }

// * checking trx balance required
    if (walletInfo!.tickerName == 'USDTX') {
      log.e('amount $amount --- wallet bal: ${walletInfo!.availableBalance}');
      bool isCorrectAmount = true;
      await walletService!
          .hasSufficientWalletBalance(
              double.parse(trxGasValueTextController.text), 'TRX')
          .then((res) => isCorrectAmount = res);
      log.w('isCorrectAmount $isCorrectAmount');
      if (!isCorrectAmount) {
        sharedService!.alertDialog(
            '${FlutterI18n.translate(context, "fee")} ${FlutterI18n.translate(context, "notice")}',
            'TRX ${FlutterI18n.translate(context, "insufficientBalance")}',
            isWarning: false);
        setBusy(false);
        return;
      }
    }

    if (walletInfo!.tickerName == 'TRX') {
      log.e('amount $amount --- wallet bal: ${walletInfo!.availableBalance}');
      bool isCorrectAmount = true;
      Decimal totalAmount =
          amount + Decimal.parse(trxGasValueTextController.text);
      if (totalAmount >
          NumberUtil.parseDoubleToDecimal(walletInfo!.availableBalance)) {
        isCorrectAmount = false;
      }
      if (!isCorrectAmount) {
        sharedService!.alertDialog(
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
    if (res.confirmed!) {
      setBusy(true);
      var seed;
      String? mnemonic = res.returnedText;
      if (walletInfo!.tickerName != 'TRX' &&
          walletInfo!.tickerName != 'USDTX') {
        seed = walletService!.generateSeed(mnemonic);
      }

      var gasPrice = int.tryParse(gasPriceTextController.text);
      var gasLimit = isTrx()
          ? int.tryParse(trxGasValueTextController.text)
          : int.tryParse(gasLimitTextController.text);
      var satoshisPerBytes = int.tryParse(satoshisPerByteTextController.text);
      var kanbanGasPrice = int.tryParse(kanbanGasPriceTextController.text);
      var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);
      String? tickerName = walletInfo!.tickerName;
      int? decimal;
      //  BigInt bigIntAmount = BigInt.tryParse(amountController.text);
      // log.w('Big int amount $bigIntAmount');
      String? contractAddr = '';
      if (walletInfo!.tokenType!.isNotEmpty) {
        contractAddr = environment["addresses"]["smartContract"][tickerName];
      }
      if (contractAddr == null && tokenType != '') {
        log.i(
            '$tickerName with token type $tokenType contract is null so fetching from token database');
        await tokenListDatabaseService!
            .getByTickerName(tickerName)
            .then((token) {
          contractAddr = token!.contract;
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
        'tokenType': walletInfo!.tokenType,
        'contractAddress': contractAddr,
        'decimal': decimal
      };
      log.i('3 - -- ${walletInfo!.tickerName}, --   $amount, - - $option');

      // TRON Transaction
      if (walletInfo!.tickerName == 'TRX' ||
          walletInfo!.tickerName == 'USDTX') {
        setBusy(true);
        log.i('depositing tron ${walletInfo!.tickerName}');

        await walletService!
            .depositTron(
                mnemonic: mnemonic,
                walletInfo: walletInfo!,
                amount: amount,
                isTrxUsdt: walletInfo!.tickerName == 'USDTX' ||
                        walletInfo!.tickerName == 'USDCX'
                    ? true
                    : false,
                isBroadcast: false,
                options: option)
            .then((res) {
          bool success = res["success"];
          if (success) {
            amountController.text = '';
            String? txId = res['data']['transactionID'];

            isShowErrorDetailsButton = false;
            isShowDetailsMessage = false;
            message = txId.toString();

            sharedService!.sharedSimpleNotification(
                FlutterI18n.translate(context, "depositTransactionSuccess"),
                subtitle:
                    '$specialTicker ${FlutterI18n.translate(context, "isOnItsWay")}',
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
          sharedService!.alertDialog(
              FlutterI18n.translate(context, "notice"),
              FlutterI18n.translate(
                  context, "serverTimeoutPleaseTryAgainLater"),
              isWarning: false);
        }).catchError((error) {
          log.e('In Catch error - $error');
          sharedService!.alertDialog(
              FlutterI18n.translate(context, "networkIssue"),
              '$tickerName ${FlutterI18n.translate(context, "transanctionFailed")}',
              isWarning: false);

          setBusy(false);
        });
      }

      // Normal DEPOSIT

      else {
        await walletService!
            .depositDo(seed, walletInfo!.tickerName, walletInfo!.tokenType,
                finalAmount.toDouble(), option)
            .then((ret) {
          log.w('deposit res $ret');

          bool success = ret["success"];
          if (success) {
            amountController.text = '';
            String? txId = ret['data']['transactionID'];

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
                        ? const Text("")
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

          sharedService!.alertDialog(
              FlutterI18n.translate(context, "depositTransactionFailed"),
              FlutterI18n.translate(context, "networkIssue"),
              isWarning: false);
          serverError = onError.toString();
        });
      }
    } else if (res.returnedText == 'Closed' && !res.confirmed!) {
      log.e('Dialog Closed By User');

      setBusy(false);
    } else if (res.isRequiredUpdate!) {
      log.e('Wallet update required');
      setBusy(false);
      sharedService!.sharedSimpleNotification(
          FlutterI18n.translate(context, "importantWalletUpdateNotice"));
    } else {
      log.e('Wrong pass');
      setBusy(false);
      sharedService!.inCorrectpasswordNotification(context);
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Refresh Balance
----------------------------------------------------------------------*/
  refreshBalance() async {
    String? fabAddress =
        await sharedService!.getFabAddressFromCoreWalletDatabase();
    await apiService!
        .getSingleWalletBalance(
            fabAddress, walletInfo!.tickerName, walletInfo!.address)
        .then((walletBalance) {
      if (walletBalance != null) {
        log.w('refreshed balance ${walletBalance[0].balance}');
        setBusyForObject(walletInfo, true);
        walletInfo!.availableBalance = walletBalance[0].balance!;
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

    if (to == null || amount <= Constants.decimalZero) {
      transFee = Constants.decimalZero;
      // kanbanTransFee = Constants.decimalZero;
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
      "tokenType": walletInfo!.tokenType,
      "getTransFeeOnly": true
    };
    var address = walletInfo!.address;

    await walletService!
        .sendTransaction(
            walletInfo!.tickerName,
            Uint8List.fromList(
                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
            [0],
            [address],
            to,
            amount.toDouble(),
            options,
            false)
        .then((ret) async {
      log.w('updateTransFee $ret');
      if (ret != null && ret['transFee'] != null) {
        transFee = NumberUtil.roundStringToDecimal(ret['transFee'].toString(),
            decimalPlaces: 8);
        log.i('transfee $transFee -- kanbanTransFee $kanbanTransFee');
        //  await setFee();
        setBusy(false);
      }

      // if (walletInfo.tokenType.isEmpty)
      //   log.w(
      //       'Func: updateTransFee total amount with fee: amount $amount + kanbantransfee $kanbanTransFee + gasFee $transFee = ${amount + kanbanTransFee + transFee}');
      log.i(
          'Func: updateTransFee availableBalance ${walletInfo!.availableBalance} -- amount entered $amount');
    }).catchError((onError) {
      setBusy(false);
      log.e(onError);
    });

    setBusy(false);
  }

// Copy txid and display flushbar
  copyAndShowNotification(String message) {
    sharedService!.copyAddress(context, message);
  }
}
