import 'dart:typed_data';

import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/abi_util.dart';
import 'package:exchangilymobileapp/utils/kanban.util.dart';
import 'package:exchangilymobileapp/utils/keypair_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;
import 'package:hex/hex.dart';

class OrderListScreenState extends BaseState {
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  List<Map<String, dynamic>> orderArray;
  String type;
  String exgAddress;
  String baseCoinName;

  showNotification(context) {
    walletService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        globals.red,
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
            globals.green,
            context);
      }
      print(resKanban);
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
  }

  txHexforCancelOrder(seed, orderHash) async {
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
