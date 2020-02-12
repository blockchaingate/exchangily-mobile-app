/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com, ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/material.dart';
import '../shared/globals.dart' as globals;

import 'dart:typed_data';
import '../utils/keypair_util.dart';
import '../utils/kanban.util.dart';
import '../utils/abi_util.dart';
import 'package:hex/hex.dart';
import '../environments/environment.dart';
class WalletFeaturesScreenState extends BaseState {
  final log = getLogger('WalletFeaturesScreenState');

  WalletInfo walletInfo;
  WalletService walletService = locator<WalletService>();
  WalletDataBaseService databaseService = locator<WalletDataBaseService>();
  DialogService dialogService = locator<DialogService>();
  final double elevation = 5;
  double containerWidth = 150;
  double containerHeight = 115;
  double walletBalance;
  BuildContext context;
  var errDepositItem;

  List<WalletFeatureName> features = new List();

  getWalletFeatures() {
    return features = [
      WalletFeatureName(AppLocalizations.of(context).receive,
          Icons.arrow_downward, 'receive', Colors.redAccent),
      WalletFeatureName(AppLocalizations.of(context).send, Icons.arrow_upward,
          'send', Colors.lightBlue),
      WalletFeatureName(AppLocalizations.of(context).moveAndTrade,
          Icons.equalizer, 'deposit', Colors.purple),
      WalletFeatureName(AppLocalizations.of(context).withdrawToWallet,
          Icons.exit_to_app, 'withdraw', Colors.cyan),
      WalletFeatureName(AppLocalizations.of(context).confirmDeposit,
          Icons.vertical_align_bottom, 'redeposit', Colors.redAccent),
      WalletFeatureName(AppLocalizations.of(context).smartContract,
          Icons.layers, 'smartContract', Colors.lightBlue),
    ];
  }

  refreshErrDeposit() async {}

  Future getExgAddress() async {
    String address = '';
    var res = await databaseService.getAll();
    for (var i = 0; i < res.length; i++) {
      WalletInfo item = res[i];
      if (item.tickerName == 'EXG') {
        address = item.address;
        break;
      }
    }
    return address;
  }

  Future getErrDeposit() async {
    var address = await this.getExgAddress();
    var result = await walletService.getErrDeposit(address);
    return result;
  }

  refreshBalance() async {
    setState(ViewState.Busy);
    await walletService
        .coinBalanceByAddress(
            walletInfo.tickerName, walletInfo.address, walletInfo.tokenType)
        .then((data) async {
      setState(ViewState.Idle);
      log.w(data);
      log.w(walletBalance);
      walletBalance = data['balance'];
      walletInfo.availableBalance = walletBalance;
      double currentUsdValue =
          await walletService.getCoinMarketPrice(walletInfo.name);
      walletService.calculateCoinUsdBalance(currentUsdValue, walletBalance);
      walletInfo.usdValue = walletService.coinUsdBalance;
    }).catchError((onError) {
      log.e(onError);
      setState(ViewState.Idle);
    });
  }

  // Check Pass
  /*
  checkPass(context) async {
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

      var amountInLink = BigInt.from(this.errDepositItem['amount']);

      var coinType = this.errDepositItem['coinType'];
      var r = this.errDepositItem['r'];
      var s = this.errDepositItem['s'];
      var v = this.errDepositItem['v'];
      var transactionID = this.errDepositItem['transactionID'];

      var resRedeposit = await this.submitredeposit(
          amountInLink, keyPairKanban, nonce, coinType, r, s, v, transactionID);

      log.w('resRedeposit=');
      log.w(resRedeposit);
      if ((resRedeposit != null) &&
          (resRedeposit['transactionHash'] != null) &&
          (resRedeposit['transactionHash'] != '')) {
        walletService.showInfoFlushbar(
            'Redeposit completed',
            'TransactionId is:' + resRedeposit['transactionHash'],
            Icons.cancel,
            globals.white,
            context);
      } else {
        walletService.showInfoFlushbar('Redeposit error', 'internal error',
            Icons.cancel, globals.red, context);
      }
    } else {
      if (res.returnedText != 'Closed') {
        showNotification(context);
      }
    }
  }

  // Submit redeposit

  submitredeposit(amountInLink, keyPairKanban, nonce, coinType, r, s, v,
      transactionID) async {
    log.w('transactionID for submitredeposit:' + transactionID);
    var coinPoolAddress = await getCoinPoolAddress();
    var signedMess = {'r': r, 's': s, 'v': v};
    var abiHex = getDepositFuncABI(coinType, transactionID, amountInLink,
        keyPairKanban['address'], signedMess);

    var txKanbanHex = await signAbiHexWithPrivateKey(abiHex,
        HEX.encode(keyPairKanban["privateKey"]), coinPoolAddress, nonce, environment["chains"]["KANBAN"]["gasPrice"], environment["chains"]["KANBAN"]["gasLimit"]);

    var res = await sendKanbanRawTransaction(txKanbanHex);
    return res;
  }

  // Show notification
  showNotification(context) {
    walletService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        globals.red,
        context);
  }

   */
}
