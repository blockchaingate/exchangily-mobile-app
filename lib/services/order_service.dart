import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_endpoints.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class OrderService with ReactiveServiceMixin {
  final log = getLogger('OrderService');
  ApiService _api = locator<ApiService>();

  final client = new http.Client();

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  RxValue<List<OrderModel>> _singlePairOrders =
      RxValue<List<OrderModel>>(initial: []);
  List<OrderModel> get singlePairOrders => _singlePairOrders.value;

  RxValue<bool> _isShowAllOrders = RxValue<bool>(initial: false);
  bool get isShowAllOrders => _isShowAllOrders.value;

  OrderService() {
    listenToReactiveValues([_singlePairOrders]);
  }

  void swapSources() {
    log.e('swap sources show all pairs ${_isShowAllOrders.value}');
    _isShowAllOrders.value = !_isShowAllOrders.value;
    log.w('swap sources show all pairs ${_isShowAllOrders.value}');
  }

/*-------------------------------------------------------------------------------------
                      Get All Orders
-------------------------------------------------------------------------------------*/
  void getMyOrders(String exgAddress) async {
    try {
      String url = getOrdersPagedByFabHexAddressURL + exgAddress;
      log.w('get my orders url $url');
      var res = await client.get(url);
      log.e('res ${res.body}');
      var jsonList = jsonDecode(res.body) as List;
      log.i('jsonList $jsonList');
      OrderList orderList = OrderList.fromJson(jsonList);
      print('after order list ${orderList.orders.length}');
      //  throw Exception('Catch Exception');
      //return jsonList;
      _orders = orderList.orders;
    } catch (err) {
      log.e('getOrders Failed to load the data from the API， $err');
      throw Exception('Catch Exception $err');
    }
  }

/*-------------------------------------------------------------------------------------
                      Get my orders by tickername
-------------------------------------------------------------------------------------*/

  Future getMyOrdersByTickerName(String exgAddress, String tickerName) async {
    log.w('getMyOrdersByTickerName $exgAddress -- $tickerName');

    OrderList orderList;
    try {
      var data = await _api.getMyOrdersPagedByFabHexAddressAndTickerName(
          exgAddress, tickerName);
      print('getMyOrdersByTickerName $data');
      if (data != null) {
        orderList = OrderList.fromJson(data);
        print('getMyOrdersByTickerName ${orderList.orders.length}');
        _singlePairOrders.value = orderList.orders.map((e) => e).toList();
      } else {
        return null;
      }
    } catch (err) {
      log.e('getMyOrdersByTickerName Catch $err');
      throw Exception;
    }
  }
}
