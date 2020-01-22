import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/material.dart';

class WalletFeaturesScreenState extends BaseState {
  final log = getLogger('WalletFeaturesScreenState');

  WalletInfo walletInfo;
  WalletService walletService = locator<WalletService>();
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
          Icons.equalizer, 'moveToExchange', Colors.purple),
      WalletFeatureName(AppLocalizations.of(context).withdrawToWallet,
          Icons.exit_to_app, 'withdrawToWallet', Colors.cyan),
    ];
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
