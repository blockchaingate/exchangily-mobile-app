import 'dart:convert';

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TotalBalancesScreenState extends BaseState {
  final log = getLogger('DahsboardScreenState');
  List<WalletInfo> walletInfo;
  WalletService walletService = locator<WalletService>();
  final double elevation = 5;
  double totalUsdBalance = 0;
  double coinUsdBalance;
  double gasAmount = 0;
  String addr = '';
  List<double> assetsInExchange = [];

  getGas() async {
    setState(ViewState.Busy);
    for (var i = 0; i < walletInfo.length; i++) {
      String tName = walletInfo[i].tickerName;
      if (tName == 'EXG') {
        addr = walletInfo[i].address;
        gasAmount = await walletService.gasBalance(addr);
        log.w(gasAmount);
        setState(ViewState.Idle);
        return gasAmount;
      }
    }
    setState(ViewState.Idle);
  }

  // Save Route

  void saveWalletObject() async {
    final storage = new FlutterSecureStorage();

    var test = await storage.read(key: 'seed');

    log.e(test);
  }

  /* Get Exchange Assets */

  getExchangeAssets() async {
    setState(ViewState.Busy);
    assetsInExchange.clear();
    var res = await walletService.assetsBalance(addr);
    for (var i = 0; i < res.length; i++) {
      String coin = res[i]['coin'];
      for (var j = 0; j < walletInfo.length; j++) {
        if (coin == walletInfo[j].tickerName)
          walletInfo[j].assetsInExchange = res[i]['amount'];
      }
    }
    setState(ViewState.Idle);
  }

  Future refreshBalance() async {
    setState(ViewState.Busy);
    walletService.totalUsdBalance.clear();
    //  log.w(walletInfo.length);
    int length = walletInfo.length;
    List<String> tokenType = ['', '', '', 'ETH', 'FAB'];
    if (walletInfo.isNotEmpty) {
      double bal = 0;
      double lockedBal = 0;
      for (var i = 0; i < length; i++) {
        String tName = walletInfo[i].tickerName;
        String address = walletInfo[i].address;
        String name = walletInfo[i].name;
        if (tName == 'EXG') {
          addr = walletInfo[i].address;
          log.d(addr);
        }
        await walletService
            .coinBalanceByAddress(tName, address, tokenType[i])
            .then((balance) async {
          bal = balance['balance'];
          double marketPrice = await walletService.getCoinMarketPrice(name);
          walletService.calculateCoinUsdBalance(marketPrice, bal);
          coinUsdBalance = walletService.coinUsdBalance;
          walletInfo[i].availableBalance = bal;
          // PENDING: Something went wrong  - type 'int' is not a subtype of type 'double'
          lockedBal = balance['lockbalance'];
          log.e('$tName - $lockedBal');
          //   log.i(lockedBal);
          if (lockedBal == null || lockedBal == 0) {
            walletInfo[i].lockedBalance = 1.0;
          } else {
            walletInfo[i].lockedBalance = lockedBal;
          }
          if (coinUsdBalance == null) {
            walletInfo[i].usdValue = 0.0;
          } else {
            walletInfo[i].usdValue = coinUsdBalance;
          }
        }).catchError((error) {
          log.e('Something went wrong  - $error');
        });
      }
      totalUsdBal();
      await walletService.gasBalance(addr);
      setState(ViewState.Idle);
      return walletInfo;
    } else {
      setState(ViewState.Idle);
      log.e('In else wallet list - 0');
    }
  }

  totalUsdBal() {
    totalUsdBalance = walletService.calculateTotalUsdBalance();
    return totalUsdBalance;
  }
}
