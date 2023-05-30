import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/environments/coins.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/coin_service.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
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
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';
import 'package:hex/hex.dart';

class RedepositViewModel extends FutureViewModel {
  final log = getLogger('RedepositVM');
  DialogService? dialogService = locator<DialogService>();
  WalletService? walletService = locator<WalletService>();
  SharedService? sharedService = locator<SharedService>();
  final TokenInfoDatabaseService? tokenListDatabaseService =
      locator<TokenInfoDatabaseService>();
  final CoinService? coinService = locator<CoinService>();
  final ApiService? apiService = locator<ApiService>();

  final kanbanGasPriceTextController = TextEditingController();
  final kanbanGasLimitTextController = TextEditingController();
  double kanbanTransFee = 0.0;
  bool transFeeAdvance = false;

  String? errDepositTransactionID;
  List errDepositList = [];
  TransactionHistoryDatabaseService? transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();

  WalletInfo? walletInfo;
  late BuildContext context;
  String? errorMessage = '';
  bool isConfirmButtonPressed = false;
  final abiUtils = AbiUtil();
  final kanbanUtils = KanbanUtils();

  @override
  Future futureToRun() => getErrDeposit();

  void init() {}

  Future getErrDeposit() async {
    setBusy(true);
    var address = (await sharedService!.getExgAddressFromWalletDatabase())!;
    await walletService!.getErrDeposit(address).then((errDepositData) async {
      debugPrint(
          'redeposit res length ${errDepositData.length} ---data $errDepositData');
      for (var i = 0; i < errDepositData.length; i++) {
        var item = errDepositData[i];
        log.w('errDepositData count $i $item');
        var coinType = item['coinType'];

        String? tickerNameByCointype = newCoinTypeMap[coinType];
        debugPrint('tickerNameByCointype $tickerNameByCointype');
        if (tickerNameByCointype == null) {
          await tokenListDatabaseService!.getAll().then((tokenList) {
            tickerNameByCointype = tokenList
                .firstWhere((element) => element.coinType == coinType)
                .tickerName;
            if (tickerNameByCointype == walletInfo!.tickerName) {
              errDepositList.add(item);
            }
          });
        } else if (tickerNameByCointype == walletInfo!.tickerName) {
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

    var kanbanTransFee =
        NumberUtil.rawStringToDecimal((gasPrice * gasLimit).toString())
            .toDouble();

    log.w('errDepositList=== $errDepositList');
    // if there is only one redeposit entry
    if (errDepositList.isNotEmpty) {
      errDepositList = errDepositList;
      errDepositTransactionID = errDepositList[0]["transactionID"];
      this.kanbanTransFee = kanbanTransFee;
    }
    await getSingleWalletBalance();
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Get Single wallet balance
----------------------------------------------------------------------*/

  getSingleWalletBalance() async {
    String? fabAddress =
        await sharedService!.getFabAddressFromCoreWalletDatabase();
    await apiService!
        .getSingleWalletBalance(
            fabAddress, walletInfo!.tickerName, walletInfo!.address)
        .then((res) {
      if (res != null) {
        walletInfo!.availableBalance = res[0].balance!;
      }
    });
  }

// Check Pass func

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
      sharedService!.sharedSimpleNotification(
        FlutterI18n.translate(context, "redepositError"),
        subtitle: FlutterI18n.translate(context, "redepositItemNotSelected"),
      );
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
    var res = await dialogService!.showDialog(
      title: FlutterI18n.translate(context, "enterPassword"),
      description:
          FlutterI18n.translate(context, "dialogManagerTypeSamePasswordNote"),
      buttonTitle: FlutterI18n.translate(context, "confirm"),
    );
    if (res.confirmed!) {
      String? mnemonic = res.returnedText;
      Uint8List seed = walletService!.generateSeed(mnemonic);
      var keyPairKanban = getExgKeyPair(seed);
      var exgAddress = keyPairKanban['address'];
      var nonce = await kanbanUtils.getNonce(exgAddress);

      var amountInBigIntByApi = BigInt.parse(errDepositItem['amount']);
      // errDepositAmount.toString().contains('e')
      //     ? BigInt.parse(errDepositItem['amount'])
      //     : BigInt.from(errDepositAmount);
      log.i('checkPass errDepositItem amount $amountInBigIntByApi');

      var coinType = errDepositItem['coinType'];
      var transactionID = errDepositItem['transactionID'];
      var addressInKanban = keyPairKanban["address"];

      // TRX coins deposit
      // if (walletInfo.tickerName == 'TRX' || walletInfo.tickerName == 'USDTX') {

      // }
      // // Other coins deposit
      // else {
      var originalMessage = walletService!.getOriginalMessage(
          coinType,
          trimHexPrefix(transactionID),
          amountInBigIntByApi,
          trimHexPrefix(addressInKanban));

      var signedMess = await CoinUtil().signedMessage(
          originalMessage, seed, walletInfo!.tickerName, walletInfo!.tokenType);

      var txKanbanHex = await getTxKanbanHex(amountInBigIntByApi, keyPairKanban,
          nonce, coinType, transactionID, signedMess,
          chainType: walletInfo!.tokenType);

      var resRedeposit = await kanbanUtils.submitReDeposit(txKanbanHex);

      log.w('resRedeposit $resRedeposit');
      if ((resRedeposit != null) && (resRedeposit['success'])) {
        var newTransactionId = resRedeposit['data']['transactionID'];

        sharedService!.alertDialog(
            FlutterI18n.translate(context, "redepositCompleted"),
            '${FlutterI18n.translate(context, "transactionId")}: ' +
                newTransactionId,
            path: errDepositList.length == 1 ? WalletFeaturesViewRoute : '',
            arguments: errDepositList.length == 1 ? walletInfo : null);
        if (errDepositList.length > 1) {
          setBusy(true);
          errDepositList = [];
          await getErrDeposit();
          setBusy(false);
        }
      } else if (resRedeposit!['message'] != null ||
          resRedeposit['message'] != '') {
        errorMessage = resRedeposit['message'];
      } else {
        sharedService!.sharedSimpleNotification(
          FlutterI18n.translate(context, "redepositFailedError"),
          subtitle: FlutterI18n.translate(context, "networkIssue"),
        );
      }
      //  } // other coins redeposit else ends
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
    isConfirmButtonPressed = false;
    setBusy(false);
  }

  getTxKanbanHex(
      amountInLink, keyPairKanban, nonce, coinType, txHash, signedMess,
      {String? chainType = ''}) async {
    var abiHex;
    String? addressInKanban = keyPairKanban['address'];
    log.w('transactionID for submitredeposit:' + txHash);
    var coinPoolAddress = await kanbanUtils.getCoinPoolAddress();
    //var signedMess = {'r': r, 's': s, 'v': v};
    String? coinName = '';
    bool isSpecial = false;
    int? specialCoinType;
    coinName = newCoinTypeMap[coinType];
    if (coinName == null) {
      await tokenListDatabaseService!
          .getTickerNameByCoinType(coinType)
          .then((ticker) {
        coinName = ticker;
        log.w('submit redeposit ticker $ticker');
      });
    }
    for (var i = 0; i < Constants.specialTokens.length; i++) {
      if (coinName == Constants.specialTokens[i]) {
        isSpecial = true;
        break;
      }
    }

    if (isSpecial) {
      specialCoinType = await coinService!.getCoinTypeByTickerName(
          coinName!.substring(0, coinName!.length - 1));
    }
    abiHex = abiUtils.getDepositFuncABI(isSpecial ? specialCoinType : coinType,
        txHash, amountInLink, addressInKanban!, signedMess,
        chain: chainType, isSpecialDeposit: isSpecial);
    // abiUtils.getAmountFromDepositAbiHex(abiHex);
    int kanbanPrice = int.parse(kanbanGasPriceTextController.text);
    int kanbanGasLimit = int.parse(kanbanGasLimitTextController.text);

    var txKanbanHex = await abiUtils.signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        coinPoolAddress,
        nonce,
        kanbanPrice,
        kanbanGasLimit);

    return txKanbanHex;
  }

  showNotification(context) {
    sharedService!.sharedSimpleNotification(
      FlutterI18n.translate(context, "passwordMismatch"),
      subtitle:
          FlutterI18n.translate(context, "pleaseProvideTheCorrectPassword"),
    );
  }

  updateTransFee() async {
    var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text)!;
    var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text)!;
    var kanbanTransFeeDouble =
        NumberUtil.rawStringToDecimal((kanbanGasLimit * kanbanPrice).toString())
            .toDouble();

    kanbanTransFee = kanbanTransFeeDouble;
  }
}
