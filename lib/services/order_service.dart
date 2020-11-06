import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_endpoints.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_model.dart';
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

/*----------------------------------------------------------------------
                  Order aggregation
----------------------------------------------------------------------*/

  List<OrderModel> orderAggregation(List<OrderModel> passedOrders) {
    List<OrderModel> result = [];
    print('passed orders length ${passedOrders.length}');
    double prevQuantity = 0.0;
    List<int> indexArray = [];
    double prevPrice = 0;

    // for each
    passedOrders.forEach((currentOrder) {
      log.i('single order in agrregation ${currentOrder.toJson()}');
      //  int index = 0;
      //   double aggrQty = 0;
      // index = passedOrders.indexOf(currentOrder);
      if (currentOrder.price == prevPrice) {
        log.i(
            'price matched with prev price ${currentOrder.price} -- $prevPrice');
        log.w(
            ' currentOrder qty ${currentOrder.orderQuantity} -- prevQuantity $prevQuantity');
        currentOrder.orderQuantity += prevQuantity;
        //  aggrQty = currentOrder.orderQuantity + prevQuantity;
        prevPrice = currentOrder.price;
        log.e(' currentOrder.orderQuantity  ${currentOrder.orderQuantity}');
        indexArray.add(passedOrders.indexOf(currentOrder));
        result.removeWhere((order) => order.price == prevPrice);
        result.add(currentOrder);
      } else {
        prevPrice = currentOrder.price;
        prevQuantity = currentOrder.orderQuantity;
        log.w('price NOT matched so prevprice: $prevPrice');
        result.add(currentOrder);
      }
    });
    return result;
  }
/*-------------------------------------------------------------------------------------
                      Swap Source 
-------------------------------------------------------------------------------------*/

  void swapSources() {
    log.e('3 swap sources show all pairs ${_isShowAllOrders.value}');
    _isShowAllOrders.value = !_isShowAllOrders.value;
    log.w('4 swap sources show all pairs ${_isShowAllOrders.value}');
  }

/*-------------------------------------------------------------------------------------
                      Get All Orders
            /ordersbyaddresspaged/:address/:start?/:count?/:status?
-------------------------------------------------------------------------------------*/
  Future<List<OrderModel>> getMyOrders(String exgAddress) async {
    try {
      String url = getOrdersPagedByFabHexAddressURL + exgAddress;
      log.w('get my orders url $url');
      var res = await client.get(url);
      log.e('res ${res.body}');
      var jsonList = jsonDecode(res.body) as List;
      log.i('jsonList $jsonList');
      OrderList orderList = OrderList.fromJson(jsonList);
      log.w('getMyOrders order list length ${orderList.orders.length}');
      //  throw Exception('Catch Exception');
      //return jsonList;

      //  _orders = orderAggregation(orderList.orders);
      _orders = orderList.orders;

      return _orders;
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
      log.w('getMyOrdersByTickerName $data');
      if (data != null) {
        orderList = OrderList.fromJson(data);

        //   _singlePairOrders.value = orderAggregation(orderList.orders);3
        _singlePairOrders.value = orderList.orders;
        //  .map((e) => e).toList();
      } else {
        return null;
      }
    } catch (err) {
      log.e('getMyOrdersByTickerName Catch $err');
      throw Exception;
    }
  }
}
