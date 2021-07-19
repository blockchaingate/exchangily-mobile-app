import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/environments/coins.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/abi_util.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';

import 'package:exchangilymobileapp/utils/kanban.util.dart';
import 'package:exchangilymobileapp/utils/keypair_util.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:hex/hex.dart';

class RedepositViewModel extends FutureViewModel {
  final log = getLogger('RedepositVM');
  DialogService dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  SharedService sharedService = locator<SharedService>();
  final tokenListDatabaseService = locator<TokenListDatabaseService>();

  final kanbanGasPriceTextController = TextEditingController();
  final kanbanGasLimitTextController = TextEditingController();
  double kanbanTransFee = 0.0;
  bool transFeeAdvance = false;

  String errDepositTransactionID;
  List errDepositList = [];
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();

  WalletInfo walletInfo;
  BuildContext context;
  String errorMessage = '';
  @override
  Future futureToRun() => getErrDeposit();
  bool isConfirmButtonPressed = false;
  void init() {}

/*----------------------------------------------------------------------
                      Get Error Deposit
----------------------------------------------------------------------*/
  click(bigInt) {
    var b = Decimal.parse(bigInt) / Decimal.parse('1e18');
    print('b $b');
    print(NumberUtil().roundDownLastDigit(b.toDouble()));
  }

  Future getErrDeposit() async {
    setBusy(true);
    var address = await this.sharedService.getExgAddressFromWalletDatabase();
    await walletService.getErrDeposit(address).then((errDepositData) async {
      debugPrint(
          'redeposit res length ${errDepositData.length} ---data $errDepositData');
      for (var i = 0; i < errDepositData.length; i++) {
        var item = errDepositData[i];
        log.w('errDepositData count $i $item');
        var coinType = item['coinType'];

        String tickerNameByCointype = newCoinTypeMap[coinType];
        print('tickerNameByCointype $tickerNameByCointype');
        if (tickerNameByCointype == null)
          await tokenListDatabaseService.getAll().then((tokenList) {
            if (tokenList != null) {
              tickerNameByCointype = tokenList
                  .firstWhere((element) => element.tokenType == coinType)
                  .tickerName;
              if (tickerNameByCointype == walletInfo.tickerName)
                errDepositList.add(item);
            }
          });
        else if (tickerNameByCointype == walletInfo.tickerName) {
          errDepositList.add(item);
          log.e(
              'in else if -- coin type $coinType --  tickerNameByCointype $tickerNameByCointype');
          //click(item['amount']);
        }
      }
    });
    log.i(' errDepositList ${errDepositList.length}');
    var gasPrice = environment["chains"]["KANBAN"]["gasPrice"];
    var gasLimit = environment["chains"]["KANBAN"]["gasLimit"];
    kanbanGasPriceTextController.text = gasPrice.toString();
    kanbanGasLimitTextController.text = gasLimit.toString();

    var kanbanTransFee = bigNum2Double(gasPrice * gasLimit);

    log.w('errDepositList=== $errDepositList');
    // if there is only one redeposit entry
    if (errDepositList != null && errDepositList.length > 0) {
      this.errDepositList = errDepositList;
      this.errDepositTransactionID = errDepositList[0]["transactionID"];
      this.kanbanTransFee = kanbanTransFee;
    }

    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Check pass
----------------------------------------------------------------------*/

  checkPass() async {
    //TransactionHistory transactionByTxId = new TransactionHistory();
    setBusy(true);
    isConfirmButtonPressed = true;
    errorMessage = '';
    var errDepositItem;
    for (var i = 0; i < errDepositList.length; i++) {
      if (errDepositList[i]["transactionID"] == errDepositTransactionID) {
        errDepositItem = errDepositList[i];
        break;
      }
    }

    if (errDepositItem == null) {
      sharedService.showInfoFlushbar(
          '${AppLocalizations.of(context).redepositError}',
          '${AppLocalizations.of(context).redepositItemNotSelected}',
          Icons.cancel,
          red,
          context);
    }
    log.w('errDepositItem $errDepositItem');
    // var errDepositAmount = double.parse(errDepositItem['amount']);
    // log.i('errDepositAmount $errDepositAmount');
    // await walletService
    //     .checkCoinWalletBalance(errDepositAmount, walletInfo.tickerName)
    //     .then((value) {
    //   if (errDepositItem == null) {
    //     sharedService.showInfoFlushbar(
    //         '${AppLocalizations.of(context).redepositError}',
    //         '${AppLocalizations.of(context).invalidAmount}',
    //         Icons.cancel,
    //         red,
    //         context);
    //   }
    // });
    var res = await dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);
      var keyPairKanban = getExgKeyPair(seed);
      var exgAddress = keyPairKanban['address'];
      var nonce = await getNonce(exgAddress);

      var amountInBigInt = BigInt.parse(errDepositItem['amount']);
      // errDepositAmount.toString().contains('e')
      //     ? BigInt.parse(errDepositItem['amount'])
      //     : BigInt.from(errDepositAmount);
      print('amountInBigInt $amountInBigInt');
      var coinType = errDepositItem['coinType'];

      var transactionID = errDepositItem['transactionID'];

      var addressInKanban = keyPairKanban["address"];
      var originalMessage = walletService.getOriginalMessage(
          coinType,
          trimHexPrefix(transactionID),
          amountInBigInt,
          trimHexPrefix(addressInKanban));

      var signedMess = await signedMessage(
          originalMessage, seed, walletInfo.tickerName, walletInfo.tokenType);

      var resRedeposit = await this.submitredeposit(amountInBigInt,
          keyPairKanban, nonce, coinType, transactionID, signedMess,
          chainType: walletInfo.tokenType);

      if ((resRedeposit != null) && (resRedeposit['success'])) {
        log.w('resRedeposit $resRedeposit');
        var newTransactionId = resRedeposit['data']['transactionID'];

        sharedService.alertDialog(
            AppLocalizations.of(context).redepositCompleted,
            AppLocalizations.of(context).transactionId +
                ': ' +
                newTransactionId,
            path: errDepositList.length == 1 ? WalletFeaturesViewRoute : '',
            arguments: errDepositList.length == 1 ? walletInfo : null);
        if (errDepositList.length > 1) {
          setBusy(true);
          errDepositList = [];
          await getErrDeposit();
          setBusy(false);
        }
      } else if (resRedeposit['message'] != '') {
        errorMessage = resRedeposit['message'];
      } else {
        sharedService.showInfoFlushbar(
            AppLocalizations.of(context).redepositFailedError,
            AppLocalizations.of(context).networkIssue,
            Icons.cancel,
            red,
            context);
      }
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
    isConfirmButtonPressed = false;
    setBusy(false);
  }

  submitredeposit(
      amountInLink, keyPairKanban, nonce, coinType, txHash, signedMess,
      {String chainType: ''}) async {
    var abiHex;
    String addressInKanban = keyPairKanban['address'];
    log.w('transactionID for submitredeposit:' + txHash);
    var coinPoolAddress = await getCoinPoolAddress();
    //var signedMess = {'r': r, 's': s, 'v': v};
    String coinName = '';
    bool isSpecial = false;
    int specialCoinType;
    coinName = newCoinTypeMap[coinType];
    if (coinName == null)
      await tokenListDatabaseService
          .getTickerNameByCoinType(coinType)
          .then((ticker) {
        coinName = ticker;
        log.w('submit redeposit ticker $ticker');
      });
    Constants.specialTokens.forEach((specialTokenTicker) {
      if (coinName == specialTokenTicker) isSpecial = true;
    });
    if (isSpecial) {
      specialCoinType =
          await getCoinTypeIdByName(coinName.substring(0, coinName.length - 1));
    }
    abiHex = getDepositFuncABI(isSpecial ? specialCoinType : coinType, txHash,
        amountInLink, addressInKanban, signedMess,
        chain: chainType, isSpecialDeposit: isSpecial);

    var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);

    var txKanbanHex = await signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        coinPoolAddress,
        nonce,
        kanbanPrice,
        kanbanGasLimit);

    var res = await submitReDeposit(txKanbanHex);
    return res;
  }

  showNotification(context) {
    sharedService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        red,
        context);
  }

  updateTransFee() async {
    var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);
    var kanbanTransFeeDouble = bigNum2Double(kanbanPrice * kanbanGasLimit);

    kanbanTransFee = kanbanTransFeeDouble;
  }
}
