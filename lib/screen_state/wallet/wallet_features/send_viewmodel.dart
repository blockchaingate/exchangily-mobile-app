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
import 'dart:convert';
import 'dart:typed_data';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/custom_token_model.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
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

  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  final storageService = locator<LocalStorageService>();
  final navigationService = locator<NavigationService>();

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
  final amountController = TextEditingController();
  final gasPriceTextController = TextEditingController();
  final gasLimitTextController = TextEditingController();
  final satoshisPerByteTextController = TextEditingController();
  double transFee = 0.0;
  bool transFeeAdvance = false;
  String feeUnit = '';
  String tickerName = '';

  String tokenType = '';
  final coinUtils = CoinUtils();
  final fabUtils = FabUtils();
  int decimalLimit = 8;
  // double gasAmount = 0.0;
  String fabAddress = '';
  String transFeeErrMsg = '';
  double unconfirmedBalance = 0.0;
  bool isValidAmount = true;
  double chainBalance = 0.0;

  // Init State
  initState() async {
    setBusy(true);
    sharedService.context = context;
    walletInfo.tickerName == 'USDTX'
        ? tickerName = 'USDT(TRC20)'
        : tickerName = walletInfo.tickerName;
    if (walletInfo.tokenType == 'TRON') walletInfo.tokenType = "TRX";
    tokenType = walletInfo.tokenType;
    String coinName = walletInfo.tickerName;
    await setFee(coinName);
    fabAddress = await sharedService.getFabAddressFromCoreWalletDatabase();
    if (storageService.customTokenData.isEmpty) await refreshBalance();
    decimalLimit =
        await walletService.getSingleCoinWalletDecimalLimit(coinName);
    if (decimalLimit == null) decimalLimit = 8;
    if (tokenType.isNotEmpty) await getNativeChainTickerBalance();
    setBusy(false);
  }

  // get native chain ticker balance
  getNativeChainTickerBalance() async {
    if (fabAddress.isEmpty)
      fabAddress = await sharedService.getFabAddressFromCoreWalletDatabase();

    await apiService
        .getSingleWalletBalance(fabAddress, tokenType, walletInfo.address)
        .then((walletBalance) => chainBalance = walletBalance[0].balance);
  }

  /*---------------------------------------------------
                      Get gas
--------------------------------------------------- */

  // getGasBalance() async {
  //   String address = await sharedService.getExgAddressFromWalletDatabase();
  //   await walletService.gasBalance(address).then((data) {
  //     gasAmount = data;
  //     if (gasAmount == 0) {
  //       sharedService.alertDialog(
  //         AppLocalizations.of(context).notice,
  //         AppLocalizations.of(context).insufficientGasAmount,
  //       );
  //     }
  //   }).catchError((onError) => log.e(onError));
  //   log.w('gas amount $gasAmount');
  //   return gasAmount;
  // }

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

  test() {
    // CustomTokenModel customTokenModel =
    //     (jsonDecode(storageService.customTokenData) as dynamic)
    //         .cast<CustomTokenModel>();
    CustomTokenModel customTokenModel =
        CustomTokenModel.fromJson(jsonDecode(storageService.customTokenData));
    print(customTokenModel.toJson());
  }

  bool isTrx() {
    log.i(
        'isTrx ${walletInfo.tickerName == 'TRX' || walletInfo.tickerName == 'USDTX'}');
    return walletInfo.tickerName == 'TRX' || walletInfo.tickerName == 'USDTX'
        ? true
        : false;
  }

/*---------------------------------------------------
                  Amount After fee
--------------------------------------------------- */
  Future<double> amountAfterFee({bool isMaxAmount = false}) async {
    setBusy(true);

    if (amountController.text.isEmpty) {
      transFee = 0.0;
      setBusy(false);
      return 0.0;
    }
    amount = NumberUtil().truncateDoubleWithoutRouding(
        double.parse(amountController.text),
        precision: decimalLimit);

    double finalAmount = 0.0;
    // update if transfee is 0
    if (!walletService.isTrx(walletInfo.tickerName)) await updateTransFee();
    // if tron coins then assign fee accordingly
    if (walletService.isTrx(walletInfo.tickerName)) {
      if (walletInfo.tickerName == 'USDTX') {
        transFee = 15;
        finalAmount = amount;
      } else if (walletInfo.tickerName == 'TRX') {
        transFee = 1.0;
        finalAmount = isMaxAmount ? amount - transFee : amount + transFee;
      }
      finalAmount <= walletInfo.availableBalance
          ? isValidAmount = true
          : isValidAmount = false;
    } else {
      // in any token transfer, gas fee is paid in native tokens so
      // in case of non-native tokens, need to check the balance of native tokens
      // so that there is fee to pay when transffering non-native tokens
      if (tokenType.isEmpty) {
        if (isMaxAmount)
          finalAmount = amount - transFee;
        else
          finalAmount = amount + transFee;
      } else
        finalAmount = amount;

      finalAmount <= walletInfo.availableBalance
          ? isValidAmount = true
          : isValidAmount = false;
    }
    log.i(
        'Func:amountAfterFee --  entered amount $amount + transaction fee $transFee = finalAmount $finalAmount after fee --  wallet bal ${walletInfo.availableBalance} -- isValidAmount $isValidAmount');
    setBusy(false);
    return finalAmount;
  }

/*---------------------------------------------------
                  Fill Max Amount
--------------------------------------------------- */
  fillMaxAmount() async {
    setBusy(true);

    amount = walletInfo.availableBalance;
    amountController.text = amount.toString();

    await updateTransFee();
    double finalAmount = 0.0;

    finalAmount = await amountAfterFee(isMaxAmount: true);
    if (transFee != 0.0)
      amountController.text = NumberUtil()
          .truncateDoubleWithoutRouding(finalAmount, precision: decimalLimit)
          .toString();
    else
      sharedService.sharedSimpleNotification(
          AppLocalizations.of(context).insufficientGasAmount);
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
    errorMessage = '';
    isShowErrorDetailsButton = false;
    isShowDetailsMessage = false;
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
      } else if (tickerName == 'EXG') {
        tokenType = 'FAB';
      }

      if ((tickerName != null) &&
          (tickerName != '') &&
          (tokenType != null) &&
          (tokenType != '')) {
        var decimal;

        String contractAddr = '';

        if (storageService.customTokenData.isNotEmpty) {
          try {
            CustomTokenModel customTokenModel = CustomTokenModel.fromJson(
                jsonDecode(storageService.customTokenData));
            contractAddr = customTokenModel.tokenId;
            decimalLimit = customTokenModel.decimal;
          } catch (err) {
            log.e(
                'Send transaction func: custom token from storage failed conversion');
          }
        } else
          contractAddr = environment["addresses"]["smartContract"][tickerName];

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
            amountController.text = '';
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
    } else if (dialogResponse.returnedText == 'Closed') {
      setBusy(false);
    } else if (dialogResponse.isRequiredUpdate) {
      log.e('Wallet update required');
      setBusy(false);
      return errorMessage =
          AppLocalizations.of(context).importantWalletUpdateNotice;
    } else {
      setBusy(false);
      return errorMessage =
          AppLocalizations.of(context).pleaseProvideTheCorrectPassword;
    }
    transFee = 0.0;
    setBusy(false);
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

    await apiService
        .getSingleWalletBalance(
            fabAddress, walletInfo.tickerName, walletInfo.address)
        .then((walletBalance) {
      if (walletBalance != null) {
        log.w('refreshBalance ${walletBalance[0].toJson()}');

        walletInfo.availableBalance = walletBalance[0].balance;
        unconfirmedBalance = walletBalance[0].unconfirmedBalance;
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
    log.w('in check fields');
    txHash = '';
    errorMessage = '';
    if (amountController.text == '') {
      print('amount empty');
      sharedService.alertDialog(AppLocalizations.of(context).amountMissing,
          AppLocalizations.of(context).invalidAmount,
          isWarning: false);
      return;
    }
    // amount = double.tryParse(amountController.text);
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

    // ! Check if ETH is available for making USDT transaction
    // ! Same for Fab token based coins

    if (tokenType == 'ETH' || tokenType == 'FAB' || tokenType == 'TRX'
        // tickerName == 'ETH' ||
        // tickerName == 'FAB' ||
        // tickerName == 'BTC'
        ) {
      await walletService
          .hasSufficientWalletBalance(transFee, tokenType)
          .then((isValidNativeChainBal) {
        if (!isValidNativeChainBal) {
          log.e('not enough $tokenType balance to make tx');
          var coin =
              tokenType.isEmpty ? walletInfo.tickerName : walletInfo.tokenType;
          showSimpleNotification(
              Center(
                child: Text(
                    '${AppLocalizations.of(context).low} $coin ${AppLocalizations.of(context).balance}'),
              ),
              position: NotificationPosition.top,
              background: sellPrice);
        }
      });
      return;
    }

    if (transFee == 0.0 && !isTrx()) {
      log.e('transfee $transFee not enough $tokenType balance to make tx');
      var coin =
          tokenType.isEmpty ? walletInfo.tickerName : walletInfo.tokenType;
      showSimpleNotification(
          Center(
            child: Text(
                '${AppLocalizations.of(context).low} $coin ${AppLocalizations.of(context).balance}',
                style: Theme.of(context).textTheme.headline5),
          ),
          subtitle: Center(
            child: Text('${AppLocalizations.of(context).gasFee} 0',
                style: Theme.of(context).textTheme.headline6),
          ),
          position: NotificationPosition.top,
          background: sellPrice);
      await updateTransFee();

      return;
    }

    // if (!isTrx() &&
    //     walletInfo.tickerName != 'BTC' &&
    //     walletInfo.tickerName != 'ETH') {
    //   int decimalLength = NumberUtil.getDecimalLength(amount);
    //   log.w('decimalLength $decimalLength');
    //   if (decimalLength == decimalLimit)
    //     amount = NumberUtil().roundDownLastDigit(amount);
    // }

    print('else');
    FocusScope.of(context).requestFocus(FocusNode());

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
        // if token is empty then fee will use native coin so add amount and transfee
        if (tokenType.isEmpty) {
          totalAmount = amount + transFee;
          log.i('total amount $totalAmount');
        } else
          // for tokens, fee will be paid in native tokens so just need to check if transfee is not 0
          totalAmount = amount;
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
      log.i('check send amount $checkSendAmount -- trans fee $transFee');
    }
    setBusy(false);
  }

  Future<double> getTrxBalance() async {
    double balance = 0.0;

    String trxWalletAddress =
        await walletService.getAddressFromCoreWalletDatabaseByTickerName('TRX');

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
    //amount = double.tryParse(amountController.text);

    if (to == null || amount == null || amount <= 0) {
      transFee = 0.0;
      setBusy(false);
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
        log.w('trans fee res $ret');
        transFee = ret['transFee'];
        // ! check if update fee return err message
        // * if true then assign the err message to the local var and display it in the
        if (ret['errMsg'].toString().isNotEmpty) {
          if (ret['errMsg'].toString().startsWith('not enough')) {
            var coin = tokenType.isEmpty
                ? walletInfo.tickerName
                : walletInfo.tokenType;
            showSimpleNotification(
                Center(
                  child: Text(
                      '${AppLocalizations.of(context).low} $coin ${AppLocalizations.of(context).balance}'),
                ),
                position: NotificationPosition.top,
                background: sellPrice);
          }
        }
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
      barcode = result.rawContent;
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
