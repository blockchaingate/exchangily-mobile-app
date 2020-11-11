import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingChartViewModel extends ReactiveViewModel {
  TradeService _tradeService = locator<TradeService>();
  ConfigService configService = locator<ConfigService>();
  final log = getLogger('TradingChartViewModel');
  WebViewController webViewController;
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_tradeService];

  String get tradingChartInterval => _tradeService.interval;
  //String tradingChartInterval = '4h';
  bool get isTradingChartModelBusy => _tradeService.isTradingChartModelBusy;

  /*----------------------------------------------------------------------
                    Change chart interval
----------------------------------------------------------------------*/
  updateChartInterval(String value) async {
    setBusy(true);
  
   _tradeService.setTradingChartInterval(value,true);
//tradingChartInterval = _tradeService.interval;
    log.i('tradingChartInterval ${tradingChartInterval} --');
    //  await Future.delayed(new Duration(seconds:2), () =>  isIntervalUpdated = false);
    //      log.i('Interval $interval --- isIntervalUpdatedAfter reversing $isIntervalUpdated');
    Future.delayed(Duration(seconds: 2),(){

    _tradeService.setTradingChartInterval(value,false);
    });
    setBusy(false);
  }
}
