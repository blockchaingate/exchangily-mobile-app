import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_endpoints.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class OrderService with ReactiveServiceMixin {
  final log = getLogger('OrderService');
  ApiService _api = locator<ApiService>();

  final client = new http.Client();

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  // Get Orders by address
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

  Future getMyOrdersByTickerName(
      String exgAddress, String tickerName) async {
    OrderList orderList;
    try {
      var data = await _api.getMyOrdersPagedByFabHexAddressAndTickerName(
          exgAddress, tickerName);
      print(data);
      if (data != null) {
        orderList = OrderList.fromJson(data);
        _orders = orderList.orders;
      } else {
        return null;
      }
    } catch (err) {
      log.e('getMyOrdersByTickerName Catch $err');
      throw Exception;
    }
  }
}
