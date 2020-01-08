import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:flutter/material.dart';

class WalletFeaturesScreenState extends BaseState {
  final log = getLogger('WalletFeaturesScreenState');

  WalletInfo walletInfo;
  WalletService walletService = locator<WalletService>();
  final double elevation = 5;
  double totalUsdBalance = 0;
  double containerWidth = 150;
  double containerHeight = 115;
  String tickerName = '';
  String coinName = '';
  var walletBalance;
  var usdBalance;
  String address = '';
  List<WalletFeatureName> features = new List();

  getWalletFeatures(context) {
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

  initialSetup() {
    tickerName = walletInfo.tickerName;
    coinName = walletInfo.name;
    address = walletInfo.address;
    walletBalance = walletInfo.availableBalance;
    usdBalance = walletInfo.usdValue;
    log.w('test ${walletInfo.name}');
  }

  refreshBalance() async {
    setState(ViewState.Busy);
    await walletService
        .coinBalanceByAddress(tickerName, address, '')
        .then((data) {
      setState(ViewState.Idle);
      log.w(data);
      walletBalance = data['balance'];
    }).catchError((onError) {
      log.e(onError);
      setState(ViewState.Idle);
    });
  }
}
