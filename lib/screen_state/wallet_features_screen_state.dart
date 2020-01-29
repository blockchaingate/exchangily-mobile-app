import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/services/db_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/material.dart';

class WalletFeaturesScreenState extends BaseState {
  final log = getLogger('WalletFeaturesScreenState');

  WalletInfo walletInfo;
  WalletService walletService = locator<WalletService>();
  DataBaseService databaseService  = locator<DataBaseService>();
  final double elevation = 5;
  double containerWidth = 150;
  double containerHeight = 115;
  double walletBalance;
  BuildContext context;

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

      WalletFeatureName(AppLocalizations.of(context).reDeposit,
          Icons.vertical_align_bottom, '', Colors.redAccent),
      WalletFeatureName(AppLocalizations.of(context).smartContract, Icons.layers,
          'smartContract', Colors.lightBlue),
    ];
  }

  refreshErrDeposit() async {

  }

  Future getExgAddress() async{
    String address = '';
    var res = await databaseService.getAll();
    for(var i=0;i < res.length; i++) {
      WalletInfo item = res[i];
      if(item.tickerName == 'EXG') {
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
}
