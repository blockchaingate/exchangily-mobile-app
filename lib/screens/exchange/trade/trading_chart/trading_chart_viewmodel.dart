import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingChartViewModel extends ReactiveViewModel {
  final TradeService _tradeService = locator<TradeService>();
  ConfigService? configService = locator<ConfigService>();
  final LocalStorageService? storageService = locator<LocalStorageService>();
  final log = getLogger('TradingChartViewModel');
  late WebViewController webViewController;
  @override
  List<ListenableServiceMixin> get listenableServices => [_tradeService];

  String? _tradingChartInterval = '24h';
  String? get tradingChartInterval => _tradeService.interval;
//  String get selectedInterval => _tradingChartInterval;
  bool get isTradingChartModelBusy => _tradeService.isTradingChartModelBusy;

  double intervalTextFontSize = 12;
  late var fontTheme;
  get intervalMap => Constants.intervalMap;

  init() {
    fontTheme = TextStyle(fontSize: intervalTextFontSize);
  }

  /*----------------------------------------------------------------------
                    Change chart interval
----------------------------------------------------------------------*/
  updateChartInterval(String? interval) async {
    setBusy(true);
    _tradeService.setTradingChartInterval(interval, true);
    _tradingChartInterval = _tradeService.interval;
    log.i('tradingChartInterval $tradingChartInterval');
    Future.delayed(const Duration(seconds: 1), () {
      _tradeService.setTradingChartInterval(_tradingChartInterval, false);
    });
    setBusy(false);
  }
}
