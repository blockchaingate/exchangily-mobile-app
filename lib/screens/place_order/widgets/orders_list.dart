/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import "package:flutter/material.dart";
import 'package:exchangilymobileapp/localizations.dart';
import '../../../utils/string_util.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'dart:typed_data';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;
import 'package:exchangilymobileapp/utils/kanban.util.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:hex/hex.dart';
import 'package:exchangilymobileapp/utils/keypair_util.dart';
import 'package:exchangilymobileapp/utils/abi_util.dart';

class OrdersList extends StatefulWidget {
  List<Map<String, dynamic>> orderArray;
  String type;
  String exgAddress;

  OrdersList(this.orderArray, this.type, this.exgAddress);

  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();

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
    var nonce = await getNonce(widget.exgAddress);

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

  @override
  Widget build(BuildContext context) {
    return Table(children: [
      TableRow(children: [
        Text(AppLocalizations.of(context).type,
            style: TextStyle(color: Colors.grey, fontSize: 14.0)),
        Text(AppLocalizations.of(context).pair,
            style: new TextStyle(color: Colors.grey, fontSize: 14.0)),
        Text(AppLocalizations.of(context).price,
            style: new TextStyle(color: Colors.grey, fontSize: 14.0)),
        Text(
            AppLocalizations.of(context).amount +
                "(" +
                AppLocalizations.of(context).filledAmount +
                ")",
            style: new TextStyle(color: Colors.grey, fontSize: 14.0)),
        if (widget.type == 'open') Text('')
      ]),
      for (var item in widget.orderArray)
        TableRow(children: [
          Text(item["type"],
              style: new TextStyle(
                  color:
                      Color((item["type"] == 'Buy') ? 0xFF0da88b : 0xFFe2103c),
                  fontSize: 16.0)),
          Text(item["pair"],
              style: new TextStyle(color: Colors.white70, fontSize: 14.0)),
          Text(item["price"].toString(),
              style: new TextStyle(color: Colors.white70, fontSize: 14.0)),
          Text(
              doubleAdd(item["amount"], item["filledAmount"]).toString() +
                  "(" +
                  (item["filledAmount"] *
                          100 /
                          doubleAdd(item["filledAmount"], item["amount"]))
                      .toStringAsFixed(2) +
                  "%)",
              style: new TextStyle(color: Colors.white70, fontSize: 14.0)),
          if (widget.type == 'open')
            GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.white70,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              onTap: () {
                checkPass(context, item["orderHash"]);
              },
            )
        ]),
    ]);
  }
}
