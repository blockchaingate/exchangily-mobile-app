import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/trade/order-model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/abi_util.dart';
import 'package:exchangilymobileapp/utils/kanban.util.dart';
import 'package:exchangilymobileapp/utils/keypair_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:hex/hex.dart';
import 'package:exchangilymobileapp/environments/environment.dart';

class MyOrdersViewModel extends FutureViewModel<List<OrderModel>> {
  final log = getLogger('MyOrdersViewModel');

  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  TradeService tradeService = locator<TradeService>();
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();

  double filledAmount = 0;
  double filledPercentage = 0;
  String errorMessage = '';

  bool _showCurrentPairOrders = false;
  bool get showCurrentPairOrders => _showCurrentPairOrders;

  @override
  Future<List<OrderModel>> futureToRun() async {
    String exgAddress = await getExgAddress();
    return _showCurrentPairOrders
        ? await tradeService.getMyOrders(exgAddress)
        : await tradeService.getMyOrders(exgAddress);
  }

  Future<String> getExgAddress() async {
    var exgWallet = await walletDataBaseService.getBytickerName('EXG');
    return exgWallet.address;
  }

  void swapSources() {
    _showCurrentPairOrders = !_showCurrentPairOrders;
    notifySourceChanged();
  }

  @override
  void onData(List<OrderModel> data) {
    data.forEach((element) {
      filledAmount = element.orderQuantity + element.filledQuantity;
      filledPercentage = element.filledQuantity * 100 / filledAmount;
    });
  }

  @override
  void onError(error) {
    errorMessage = error.toString();
  }

  showNotification(context) {
    walletService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        red,
        context);
  }

  checkPass(context, orderHash) async {
    var res = await _dialogService.showDialog(
        title: AppLocalizations.of(context).enterPassword,
        description:
            AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context).confirm);
    if (res.confirmed) {
      String mnemonic = res.returnedText;
      Uint8List seed = walletService.generateSeed(mnemonic);

      var txHex = await txHexforCancelOrder(seed, orderHash);
      var resKanban = await sendKanbanRawTransaction(txHex);
      print('resKanban===');
      if (resKanban != null && resKanban["transactionHash"] != null) {
        walletService.showInfoFlushbar(
            'Your cancel order transaction was successfull',
            'txid:' + resKanban["transactionHash"],
            Icons.info,
            green,
            context);
      }
      print(resKanban);
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
        futureToRun();
      }
    }
  }

  txHexforCancelOrder(seed, orderHash) async {
    String exgAddress = await getExgAddress();
    var abiHex = '7489ec23' + trimHexPrefix(orderHash);
    var nonce = await getNonce(exgAddress);

    var keyPairKanban = getExgKeyPair(seed);
    var exchangilyAddress = await getExchangilyAddress();
    var txKanbanHex = await signAbiHexWithPrivateKey(
        abiHex,
        HEX.encode(keyPairKanban["privateKey"]),
        exchangilyAddress,
        nonce,
        environment["chains"]["KANBAN"]["gasPrice"],
        environment["chains"]["KANBAN"]["gasLimit"]);
    return txKanbanHex;
  }
}
