import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:stacked/stacked.dart';

class TradeViewModal extends MultipleStreamViewModel {
  final log = getLogger('TradeViewModal');
  String tickerName;

  @override
  Map<String, StreamData<dynamic>> get streamsMap {
    Map<String, StreamData<dynamic>> res;
    print('3');
    log.w('ticker $tickerName');
    if (tickerName != null && tickerName.isNotEmpty)
      res = locator<TradeService>().getMultipleStreams(tickerName);

    print('res $res');
    return res;
  }

  @override
  transformData(String key, data) {
    if (key != null && data != null) {
      print(key);
      print(data);
    } else {
      print('data null');
    }
  }
}
