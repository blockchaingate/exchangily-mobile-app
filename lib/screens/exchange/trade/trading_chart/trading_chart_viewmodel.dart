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
  TradeService _tradeService = locator<TradeService>();
  ConfigService configService = locator<ConfigService>();
  final storageService = locator<LocalStorageService>();
  final log = getLogger('TradingChartViewModel');
  WebViewController webViewController;
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_tradeService];

  String _tradingChartInterval = '24h';
  String get tradingChartInterval => _tradeService.interval;
//  String get selectedInterval => _tradingChartInterval;
  bool get isTradingChartModelBusy => _tradeService.isTradingChartModelBusy;

  double intervalTextFontSize = 12;
  var fontTheme;
  get intervalMap => Constants.intervalMap;

  init() {
    fontTheme = TextStyle(fontSize: intervalTextFontSize);
  }

  /*----------------------------------------------------------------------
                    Change chart interval
----------------------------------------------------------------------*/
  updateChartInterval(String interval) async {
    setBusy(true);
    _tradeService.setTradingChartInterval(interval, true);
    _tradingChartInterval = _tradeService.interval;
    log.i('tradingChartInterval $tradingChartInterval');
    Future.delayed(Duration(seconds: 1), () {
      _tradeService.setTradingChartInterval(_tradingChartInterval, false);
    });
    setBusy(false);
  }
}
