import 'dart:convert';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:stacked/stacked.dart';

class OrderbookViewModel extends StreamViewModel {
  final String? tickerName;
  OrderbookViewModel({this.tickerName});

  final log = getLogger('OrderbookViewModel');

  TradeService? tradeService = locator<TradeService>();
  SharedService? sharedService = locator<SharedService>();
  Orderbook orderbook = Orderbook();
  PairDecimalConfig decimalConfig = PairDecimalConfig();

  @override
  Stream get stream => tradeService!.getOrderBookStreamByTickerName(tickerName!);

  @override
  transformData(data) {
    log.w('transformData -- data $data');
    var jsonDynamic = jsonDecode(data);
    orderbook = Orderbook.fromJson(jsonDynamic);
    log.e(
        'OrderBook result  -- ${orderbook.buyOrders!.length} ${orderbook.sellOrders!.length}');
  }

  @override
  void onData(data) {
    setBusy(true);
    // if (data == null || data == []) {
    //   streamSubscription
    //       .cancel()
    //       .then((value) => tradeService.ordersChannel(tickerName).sink.close());
    //   log.e('orderbook stream and channel closed in onData');
    //   setBusy(false);
    //   return;
    // }
    fillTextFields(orderbook.price, orderbook.quantity);
    log.w('orderbook data ready $dataReady');
    if (dataReady) tradeService!.setOrderbookLoadedStatus(true);
  }

  @override
  void onError(error) {
    log.e('Orderbook Stream Error $error');
  }

  @override
  void onCancel() {
    log.e('Orderbook Stream closed');
    tradeService!
        .orderbookChannel(tickerName!)
        .sink
        .close()
        .then((value) => log.w('Orderbook channel closed'));
  }

  void init() {
    getDecimalPairConfig();
  }

  /*----------------------------------------------------------------------
                  Get Decimal Pair Configuration
----------------------------------------------------------------------*/

  getDecimalPairConfig() async {
    await sharedService!
        .getSinglePairDecimalConfig(tickerName!)
        .then((decimalValues) {
      decimalConfig = decimalValues;
      log.i(
          'decimal values, quantity: ${decimalConfig.qtyDecimal} -- price: ${decimalConfig.priceDecimal}');
    }).catchError((err) {
      log.e('getDecimalPairConfig $err');
    });
  }

/*----------------------------------------------------------------------
                    Set price and quantity
----------------------------------------------------------------------*/
  fillTextFields(double? p, double? q) {
    tradeService!.setPriceQuantityValues(p, q);
    log.i('fillTextFields $p--$q');
  }
}
