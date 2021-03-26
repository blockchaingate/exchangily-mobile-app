import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
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
  // String coinName = '';
  // String tokenType = '';
  String errDepositTransactionID;
  List errDepositList = new List();
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();

  WalletInfo walletInfo;
  BuildContext context;

  @override
  Future futureToRun() => getErrDeposit();

  void init() {}

/*----------------------------------------------------------------------
                      Get Error Deposit
----------------------------------------------------------------------*/

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
    return errDepositList;
  }

/*----------------------------------------------------------------------
                    Check pass
----------------------------------------------------------------------*/

  checkPass() async {
    //TransactionHistory transactionByTxId = new TransactionHistory();
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
      var errDepositAmount = double.parse(errDepositItem['amount']);
      log.i('errDepositAmount $errDepositAmount');
      var amountInLink = BigInt.from(errDepositAmount);
      print('amountInLink $amountInLink');
      var coinType = errDepositItem['coinType'];

      var transactionID = errDepositItem['transactionID'];

      var addressInKanban = keyPairKanban["address"];
      var originalMessage = walletService.getOriginalMessage(
          coinType,
          trimHexPrefix(transactionID),
          amountInLink,
          trimHexPrefix(addressInKanban));

      var signedMess = await signedMessage(
          originalMessage, seed, walletInfo.tickerName, walletInfo.tokenType);

      var resRedeposit = await this.submitredeposit(amountInLink, keyPairKanban,
          nonce, coinType, transactionID, signedMess);

      if ((resRedeposit != null) && (resRedeposit['success'])) {
        log.w('resRedeposit $resRedeposit');
        var newTransactionId = resRedeposit['data']['transactionID'];

        // get transaction from database

        // await transactionHistoryDatabaseService
        //     .getByKanbanTxId(transactionID)
        //     .then((transactionByTxId) async {
        //   if (transactionByTxId != null) {
        //     // update transaction history status with new txid
        //     log.i(
        //         'updating ${transactionByTxId.tickerName} in transaction history db');
        //     // String date = DateTime.now().toString();
        //     // TransactionHistory transactionHistory = new TransactionHistory(
        //     //     id: transactionByTxId.id,
        //     //     tickerName: walletInfo.tickerName,
        //     //     address: '',
        //     //     amount: 0.0,
        //     //     date: date.toString(),
        //     //     tickerChainTxId: newTransactionId,
        //     //     tickerChainTxStatus: 'pending',
        //     //     quantity: transactionByTxId.quantity,
        //     //     tag: transactionByTxId.tag);

        //     // await transactionHistoryDatabaseService.update(transactionHistory);
        //     // walletService.checkDepositTransactionStatus(transactionHistory);
        //   } else {
        //     log.e(
        //         'transactionID $transactionID not found in transaction history db');
        //     await transactionHistoryDatabaseService.getAll().then((res) {
        //       List<String> txIdList = [];
        //       if (res != null) {
        //         res.forEach((element) {
        //           txIdList.add(element.kanbanTxId);
        //         });
        //       }
        //       log.e('transaction history tx id list $txIdList');
        //     });
        //   }
        // });

        // sharedService.showInfoFlushbar(
        //     '${AppLocalizations.of(context).redepositCompleted}',
        //     '${AppLocalizations.of(context).transactionId}' +
        //         resRedeposit['data']['transactionID'],
        //     Icons.cancel,
        //     globals.white,
        //     context);
        sharedService.alertDialog(
            AppLocalizations.of(context).redepositCompleted,
            AppLocalizations.of(context).transactionId + newTransactionId,
            path: '/dashboard');
      } else {
        sharedService.showInfoFlushbar(
            AppLocalizations.of(context).redepositFailedError,
            AppLocalizations.of(context).serverError,
            Icons.cancel,
            red,
            context);
      }
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
  }

  submitredeposit(amountInLink, keyPairKanban, nonce, coinType, transactionID,
      signedMess) async {
    log.w('transactionID for submitredeposit:' + transactionID);
    var coinPoolAddress = await getCoinPoolAddress();
    //var signedMess = {'r': r, 's': s, 'v': v};
    String ticker = '';
    bool isSpecial = false;
    try {
      await tokenListDatabaseService
          .getTickerNameByCoinType(coinType)
          .then((ticker) {
        ticker = ticker;
        log.w('submit redeposit ticker $ticker');
      });
      Constants.specialTokens.forEach((specialTokenTicker) {
        if (ticker == specialTokenTicker) isSpecial = true;
      });
    } catch (err) {
      log.e('no match with special tickers');
    }
    var abiHex = getDepositFuncABI(coinType, transactionID, amountInLink,
        keyPairKanban['address'], signedMess,
        isSpecialDeposit: isSpecial);

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
