import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingChartViewModel extends ReactiveViewModel {
  TradeService _tradeService = locator<TradeService>();
  ConfigService configService = locator<ConfigService>();
  WebViewController webViewController;
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_tradeService];

  String get interval => _tradeService.interval;
}
