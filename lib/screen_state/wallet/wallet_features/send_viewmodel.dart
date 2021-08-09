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
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/string_validator.dart';
import 'package:exchangilymobileapp/utils/tron_util/trx_generate_address_util.dart'
    as TronAddressUtil;
import 'package:exchangilymobileapp/utils/tron_util/trx_transaction_util.dart'
    as TronTransactionUtil;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';

class SendViewModel extends BaseViewModel {
  final log = getLogger('SendViewModel');

  DialogService _dialogService = locator<DialogService>();
  final apiService = locator<ApiService>();
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  WalletDataBaseService walletDatabaseService =
      locator<WalletDataBaseService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();

  BuildContext context;
  var options = {};
  String txHash = '';
  String errorMessage = '';

  String toAddress;
  double amount = 0;
  int gasPrice = 0;
  int gasLimit = 0;
  int satoshisPerBytes = 0;
  WalletInfo walletInfo;
  bool checkSendAmount = false;
  bool isShowErrorDetailsButton = false;
  bool isShowDetailsMessage = false;
  String serverError = '';
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final receiverWalletAddressTextController = TextEditingController();
  final sendAmountTextController = TextEditingController();
  final gasPriceTextController = TextEditingController();
  final gasLimitTextController = TextEditingController();
  final satoshisPerByteTextController = TextEditingController();
  double transFee = 0.0;
  bool transFeeAdvance = false;
  PairDecimalConfig singlePairDecimalConfig = new PairDecimalConfig();
  String feeUnit = '';
  String tickerName = '';

  String tokenType = '';
  final coinUtils = CoinUtils();
  final fabUtils = FabUtils();
  int decimalLimit = 8;

  // Init State
  initState() async {
    setBusy(true);
    sharedService.context = context;
    walletInfo.tickerName == 'USDTX'
        ? tickerName = 'USDT(TRC20)'
        : tickerName = walletInfo.tickerName;
    tokenType = walletInfo.tokenType;
    String coinName = walletInfo.tickerName;
    await setFee(coinName);

    await getDecimalData();
    await refreshBalance();
    decimalLimit = await walletService.getWalletDecimalLimit(coinName);
    if (decimalLimit == null) decimalLimit = 8;
    setBusy(false);
  }

  setFee(String coinName) async {
    if (coinName == 'BTC') {
      satoshisPerByteTextController.text =
          environment["chains"]["BTC"]["satoshisPerBytes"].toString();
      feeUnit = 'BTC';
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
      feeUnit = 'ETH';
    } else if (coinName == 'FAB') {
      satoshisPerByteTextController.text =
          environment["chains"]["FAB"]["satoshisPerBytes"].toString();
      feeUnit = 'FAB';
    } else if (tokenType == 'FAB') {
      satoshisPerByteTextController.text =
          environment["chains"]["FAB"]["satoshisPerBytes"].toString();
      gasPriceTextController.text =
          environment["chains"]["FAB"]["gasPrice"].toString();
      gasLimitTextController.text =
          environment["chains"]["FAB"]["gasLimit"].toString();
      feeUnit = 'FAB';
    }
  }

  bool isTrx() {
    log.i(
        'isTrx ${walletInfo.tickerName == 'TRX' || walletInfo.tickerName == 'USDTX'}');
    return walletInfo.tickerName == 'TRX' || walletInfo.tickerName == 'USDTX'
        ? true
        : false;
  }

  fillMaxAmount() {
    setBusy(true);
    sendAmountTextController.text = NumberUtil()
        .truncateDoubleWithoutRouding(walletInfo.availableBalance,
            precision: singlePairDecimalConfig.qtyDecimal)
        .toString();
    log.i(sendAmountTextController.text);
    setBusy(false);
    amount = double.parse(sendAmountTextController.text);
    checkAmount();
  }

  getDecimalData() async {
    setBusy(true);
    singlePairDecimalConfig =
        await sharedService.getSinglePairDecimalConfig(walletInfo.tickerName);
    log.i('singlePairDecimalConfig ${singlePairDecimalConfig.toJson()}');
    setBusy(false);
  }

  showDetailsMessageToggle() {
    setBusy(true);
    isShowDetailsMessage = !isShowDetailsMessage;
    setBusy(false);
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
    setBusy(true);
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      log.i('paste data ${data.text}');
      receiverWalletAddressTextController.text = data.text;
      toAddress = receiverWalletAddressTextController.text;
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                      Verify Password
----------------------------------------------------------------------*/

  Future sendTransaction() async {
    setBusy(true);
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
            log.i('send token address ${token.toJson()}');
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
      } else {
        options = {
          'gasPrice': gasPrice,
          'gasLimit': gasLimit,
          'satoshisPerBytes': satoshisPerBytes
        };
      }

      // Convert FAB to EXG format
      if (walletInfo.tokenType == 'FAB') {
        if (!toAddress.startsWith('0x'))
          toAddress = fabUtils.fabToExgAddress(toAddress);
      }
      log.i('OPTIONS before send $options');

      // TRON Transaction
      if (walletInfo.tickerName == 'TRX' || walletInfo.tickerName == 'USDTX') {
        log.i('sending tron ${walletInfo.tickerName}');
        var privateKey = TronAddressUtil.generateTrxPrivKey(mnemonic);
        await TronTransactionUtil.generateTrxTransactionContract(
                privateKey: privateKey,
                fromAddr: walletInfo.address,
                toAddr: toAddress,
                amount: amount,
                isTrxUsdt: walletInfo.tickerName == 'USDTX' ? true : false,
                tickerName: walletInfo.tickerName,
                isBroadcast: true)
            .then((res) {
          log.i('send screen state ${walletInfo.tickerName} res: $res');
          var txRes = res['broadcastTronTransactionRes'];
          if (txRes['code'] == 'SUCCESS') {
            log.w('trx tx res $res');
            txHash = txRes['txid'];
            isShowErrorDetailsButton = false;
            isShowDetailsMessage = false;

            String t = '';
            walletInfo.tickerName == 'USDTX'
                ? t = 'USDT(TRC20)'
                : t = walletInfo.tickerName;
            sharedService.alertDialog(
              AppLocalizations.of(context).sendTransactionComplete,
              '$t ${AppLocalizations.of(context).isOnItsWay}',
            );
            // add tx to db
            addSendTransactionToDB(walletInfo, amount, txHash);
            Future.delayed(new Duration(milliseconds: 3), () {
              refreshBalance();
            });
          } else if (res['broadcastTronTransactionRes']['result'] == 'false') {
            String errMsg =
                res['broadcastTronTransactionRes']['message'].toString();
            log.e('In Catch error - $errMsg');

            isShowErrorDetailsButton = true;
            isShowDetailsMessage = true;
            serverError = errMsg;
            setBusy(false);
          }
          setBusy(false);
        }).timeout(Duration(seconds: 25), onTimeout: () {
          log.e('In time out');
          setBusy(false);
          isShowErrorDetailsButton = false;
          isShowDetailsMessage = false;
          sharedService.alertDialog(AppLocalizations.of(context).notice,
              AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater,
              isWarning: false);
        }).catchError((error) {
          log.e('In Catch error - $error');
          sharedService.alertDialog(AppLocalizations.of(context).serverError,
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}',
              isWarning: false);
          isShowErrorDetailsButton = true;
          isShowDetailsMessage = true;
          serverError = error.toString();
          setBusy(false);
        });
      } else {
        // Other coins transaction
        await walletService
            .sendTransaction(
                tickerName, seed, [0], [], toAddress, amount, options, true)
            .then((res) async {
          log.w('Result $res');
          txHash = res["txHash"];
          errorMessage = res["errMsg"] ?? '';

          if (txHash.isNotEmpty) {
            log.w('Txhash $txHash');
            receiverWalletAddressTextController.text = '';
            sendAmountTextController.text = '';
            isShowErrorDetailsButton = false;
            isShowDetailsMessage = false;
            sharedService.alertDialog(
              AppLocalizations.of(context).sendTransactionComplete,
              '$tickerName ${AppLocalizations.of(context).isOnItsWay}',
            );
            //   var allTxids = res["txids"];
            //  walletService.addTxids(allTxids);
            // add tx to db
            addSendTransactionToDB(walletInfo, amount, txHash);
            Future.delayed(new Duration(milliseconds: 30), () {
              refreshBalance();
            });
            return txHash;
          } else if (txHash == '' && errorMessage == '') {
            log.e('Both TxHash and Error Message are empty $errorMessage');
            sharedService.alertDialog(
              "",
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}',
            );
            isShowErrorDetailsButton = false;
            isShowDetailsMessage = false;
            setBusy(false);
          } else if (txHash.isEmpty && errorMessage.isNotEmpty) {
            log.e('Error Message $errorMessage');
            sharedService.alertDialog(
              "",
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}',
            );
            isShowErrorDetailsButton = true;
            isShowDetailsMessage = true;
            serverError = errorMessage;
            setBusy(false);
          }
          setBusy(false);
        }).timeout(Duration(seconds: 25), onTimeout: () {
          log.e('In time out');
          isShowErrorDetailsButton = false;
          isShowDetailsMessage = false;
          setBusy(false);
          return errorMessage =
              AppLocalizations.of(context).serverTimeoutPleaseTryAgainLater;
        }).catchError((error) {
          log.e('In Catch error - $error');
          sharedService.alertDialog(AppLocalizations.of(context).networkIssue,
              '$tickerName ${AppLocalizations.of(context).transanctionFailed}',
              isWarning: false);
          isShowErrorDetailsButton = true;
          isShowDetailsMessage = true;
          serverError = error.toString();
          setBusy(false);
        });
      }
    } else if (dialogResponse.returnedText != 'Closed') {
      setBusy(false);
      return errorMessage =
          AppLocalizations.of(context).pleaseProvideTheCorrectPassword;
    } else {
      setBusy(false);
    }
  }

/*----------------------------------------------------------------------
              Add send tx to transaction database  
----------------------------------------------------------------------*/
  void addSendTransactionToDB(
      WalletInfo walletInfo, double amount, String txHash) {
    String date = DateTime.now().toLocal().toString();

    TransactionHistory transactionHistory = new TransactionHistory(
      id: null,
      tickerName: walletInfo.tickerName,
      address: '',
      amount: 0.0,
      date: date,
      kanbanTxId: '',
      tickerChainTxId: txHash,
      quantity: amount,
      tag: 'send',
      chainName: walletInfo.tokenType,
    );
    walletService.insertTransactionInDatabase(transactionHistory);
  }

/*----------------------------------------------------------------------
              Check transaction status not working yet  
----------------------------------------------------------------------*/
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
        log.w('refreshBalance ${walletBalance[0].toJson()}');

        walletInfo.availableBalance = walletBalance[0].balance;
        walletInfo.unconfirmedBalance =
            walletBalance[0].unconfirmedBalance ?? 0.0;
      }
    }).catchError((err) {
      log.e(err);
      setBusy(false);
      throw Exception(err);
    });
    setBusy(false);
  }

/*-----------------------------------------------------------------------------------
    Check Fields to see if user has filled both address and amount fields correctly
------------------------------------------------------------------------------------*/
  checkFields(context) async {
    print('in check fields');
    txHash = '';
    errorMessage = '';
    //walletInfo = walletInfo;
    if (sendAmountTextController.text == '') {
      print('amount empty');
      sharedService.alertDialog(AppLocalizations.of(context).amountMissing,
          AppLocalizations.of(context).invalidAmount,
          isWarning: false);
      return;
    }
    amount = double.tryParse(sendAmountTextController.text);
    toAddress = receiverWalletAddressTextController.text;
    if (!isTrx()) {
      gasPrice = int.tryParse(gasPriceTextController.text);
      gasLimit = int.tryParse(gasLimitTextController.text);
    }
    satoshisPerBytes = int.tryParse(satoshisPerByteTextController.text);
    //await refreshBalance();
    if (toAddress == '') {
      print('address empty');
      sharedService.alertDialog(AppLocalizations.of(context).emptyAddress,
          AppLocalizations.of(context).pleaseEnterAnAddress,
          isWarning: false);
      return;
    }
    if ((isTrx()) && !toAddress.startsWith('T')) {
      print('invalid tron address');
      sharedService.alertDialog(AppLocalizations.of(context).invalidAddress,
          AppLocalizations.of(context).pleaseCorrectTheFormatOfReceiveAddress,
          isWarning: false);
      return;
    }
    // double totalAmount = amount + transFee;
    if (amount == null ||
        amount == 0 ||
        amount.isNegative ||
        !checkSendAmount ||
        amount > walletInfo.availableBalance) {
      print('amount no good');
      sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
          AppLocalizations.of(context).pleaseEnterValidNumber,
          isWarning: false);
      return;
    }

    if (transFee == 0 && !isTrx()) {
      print('fee issue');
      showSimpleNotification(
          Center(
              child: Column(
            children: [
              Text(AppLocalizations.of(context).notice,
                  style: Theme.of(context).textTheme.bodyText2),
              Text('${AppLocalizations.of(context).gasFee} 0',
                  style: Theme.of(context).textTheme.headline6),
            ],
          )),
          position: NotificationPosition.top);
      await updateTransFee();
      setBusy(false);
      return;
    }
    amount = NumberUtil().roundDownLastDigit(amount);

    // if (walletInfo.tickerName == 'USDTX') {
    //   log.e('amount $amount --- wallet bal: ${walletInfo.availableBalance}');
    //   // bool isCorrectAmount = true;
    //   // await walletService
    //   //     .checkCoinWalletBalance(amount, 'TRX')
    //   //     .then((res) => isCorrectAmount = res);

    //   if (amount >= walletInfo.availableBalance) {
    //     sharedService.alertDialog(
    //         '${AppLocalizations.of(context).fee} ${AppLocalizations.of(context).notice}',
    //         'TRX ${AppLocalizations.of(context).insufficientBalance}',
    //         isWarning: false);
    //     setBusy(false);
    //     return;
    //   }
    // }

    print('else');
    FocusScope.of(context).requestFocus(FocusNode());
    if (transFee == 0 && !isTrx()) await updateTransFee();
    sendTransaction();
    // await updateBalance(widget.walletInfo.address);
    // widget.walletInfo.availableBalance = model.updatedBal['balance'];
  }

/*----------------------------------------------------------------------
                    Check Send Amount
----------------------------------------------------------------------*/
  checkAmount() async {
    setBusy(true);
    Pattern pattern = r'^(0|(\d+)|\.(\d+))(\.(\d+))?$';
    log.e(amount);
    var res = RegexValidator(pattern).isValid(amount.toString());

    if (res) {
      if (!isTrx()) {
        log.i('checkAmount ${walletInfo.tickerName}');

        await updateTransFee();
        double totalAmount = 0.0;
        if (walletInfo.tickerName == 'FAB')
          totalAmount = amount + transFee;
        else
          totalAmount = amount;
        log.i('total amount $totalAmount');
        log.w('wallet bal ${walletInfo.availableBalance}');
        if (totalAmount <= walletInfo.availableBalance && transFee != 0.0)
          checkSendAmount = true;
        else
          checkSendAmount = false;
      } else if (walletInfo.tickerName == 'TRX') {
        if (amount + 1 <= walletInfo.availableBalance)
          checkSendAmount = true;
        else
          checkSendAmount = false;
      } else if (walletInfo.tickerName == 'USDTX') {
        double trxBalance = 0.0;

        trxBalance = await getTrxBalance();
        log.w('checkAmount trx bal $trxBalance');
        if (amount <= walletInfo.availableBalance && trxBalance >= 15)
          checkSendAmount = true;
        else {
          checkSendAmount = false;
          if (trxBalance < 15)
            showSimpleNotification(
                Center(
                  child: Text(
                      '${AppLocalizations.of(context).low} TRX ${AppLocalizations.of(context).balance}'),
                ),
                position: NotificationPosition.top,
                background: sellPrice);
        }
      }
      log.i('check send amount $checkSendAmount');
    }
    setBusy(false);
  }

  Future<double> getTrxBalance() async {
    double balance = 0.0;
    String trxWalletAddress = '';
    await walletDatabaseService
        .getBytickerName('TRX')
        .then((wallet) => trxWalletAddress = wallet.address);
    String fabAddress = await sharedService.getFABAddressFromWalletDatabase();
    await apiService
        .getSingleWalletBalance(fabAddress, 'TRX', trxWalletAddress)
        .then((walletBalance) {
      if (walletBalance != null) {
        balance = walletBalance[0].balance;
      }
    }).catchError((err) {
      log.e(err);
      setBusy(false);
      throw Exception(err);
    });
    return balance;
  }

/*----------------------------------------------------------------------
                      Copy Address
----------------------------------------------------------------------*/

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

/*----------------------------------------------------------------------
                Update Trans Fee
----------------------------------------------------------------------*/

  updateTransFee() async {
    setBusy(true);
    log.i('in update trans fee');
    var to = coinUtils.getOfficalAddress(walletInfo.tickerName.toUpperCase(),
        tokenType: walletInfo.tokenType.toUpperCase());
    amount = double.tryParse(sendAmountTextController.text);
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
        log.w('trans fee $ret');
      }
      setBusy(false);
    }).catchError((err) {
      setBusy(false);

      log.e(err);
      sharedService.alertDialog(AppLocalizations.of(context).genericError,
          AppLocalizations.of(context).transanctionFailed,
          isWarning: false);
    });
    setBusy(false);
  }

/*--------------------------------------------------------
                      Barcode Scan
--------------------------------------------------------*/

  Future scan() async {
    log.i("Barcode: going to scan");
    setBusy(true);

    try {
      log.i("Barcode: try");
      String barcode = '';

      var result = await BarcodeScanner.scan();
      barcode = result;
      log.i("Barcode Res: $result ");

      receiverWalletAddressTextController.text = barcode;
      setBusy(false);
    } on PlatformException catch (e) {
      log.i("Barcode PlatformException : ");
      log.i(e.toString());
      if (e.code == "PERMISSION_NOT_GRANTED") {
        setBusy(false);
        sharedService.alertDialog(
            '', AppLocalizations.of(context).userAccessDenied,
            isWarning: false);
        // receiverWalletAddressTextController.text =
        //     AppLocalizations.of(context).userAccessDenied;
      } else {
        setBusy(false);
        sharedService.alertDialog('', AppLocalizations.of(context).unknownError,
            isWarning: false);
        // receiverWalletAddressTextController.text =
        //     '${AppLocalizations.of(context).unknownError}: $e';
      }
    } on FormatException {
      log.i("Barcode FormatException : ");
      // log.i(e.toString());
      setBusy(false);
      // sharedService.alertDialog(AppLocalizations.of(context).scanCancelled,
      //     AppLocalizations.of(context).userReturnedByPressingBackButton,
      //     isWarning: false);
    } catch (e) {
      log.i("Barcode error : ");
      log.i(e.toString());
      setBusy(false);
      sharedService.alertDialog('', AppLocalizations.of(context).unknownError,
          isWarning: false);
      // receiverWalletAddressTextController.text =
      //     '${AppLocalizations.of(context).unknownError}: $e';
    }
    setBusy(false);
  }
}
