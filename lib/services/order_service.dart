import 'dart:convert';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'package:flutter/widgets.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';

class OrderService with ReactiveServiceMixin {
  final log = getLogger('OrderService');

  final client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  ConfigService? configService = locator<ConfigService>();

  List<OrderModel>? _orders = [];
  List<OrderModel>? get orders => _orders;

  final RxValue<List<OrderModel>?> _singlePairOrders =
      RxValue<List<OrderModel>?>([]);
  List<OrderModel>? get singlePairOrders => _singlePairOrders.value;

  final RxValue<bool> _isShowAllOrders = RxValue<bool>(false);
  bool get isShowAllOrders => _isShowAllOrders.value;

  OrderService() {
    listenToReactiveValues([_singlePairOrders, _isShowAllOrders]);
  }

/*----------------------------------------------------------------------
                  Order aggregation
----------------------------------------------------------------------*/

  List<OrderModel> orderAggregation(List<OrderModel> passedOrders) {
    List<OrderModel> result = [];
    debugPrint('passed orders length ${passedOrders.length}');
    double? prevQuantity = 0.0;
    List<int> indexArray = [];
    double? prevPrice = 0;

    // for each
    for (var currentOrder in passedOrders) {
      log.i('single order in agrregation ${currentOrder.toJson()}');
      //  int index = 0;
      //   double aggrQty = 0;
      // index = passedOrders.indexOf(currentOrder);
      if (currentOrder.price == prevPrice) {
        log.i(
            'price matched with prev price ${currentOrder.price} -- $prevPrice');
        log.w(
            ' currentOrder qty ${currentOrder.orderQuantity} -- prevQuantity $prevQuantity');
        currentOrder.orderQuantity =
            currentOrder.orderQuantity! + prevQuantity!;
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
    }
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
          defaults are skip 0, page size 10, any type of order
            /ordersbyaddresspaged/:address/:start?/:count?/:status?
https://kanbanprod.fabcoinapi.com/ordersbyaddresspaged/0x3b7b00ee5a7f7d57dff7b54cec39c1a21886fe0f/10/5
                                                                                          skip 10/ grab 5
-------------------------------------------------------------------------------------*/
  Future<List<OrderModel>?> getMyOrders(String exgAddress,
      {int skip = 0, int count = 10, String status = ''}) async {
    log.w('getMyOrders $exgAddress  -- skip $skip -- count $count');
    try {
      String url =
          '${configService!.getKanbanBaseUrl()!}ordersbyaddresspaged/$exgAddress/$skip/$count/$status';
      log.w('get my orders url $url');
      var res = await client.get(Uri.parse(url));
      var jsonList = jsonDecode(res.body) as List;
      log.e(jsonList);
      OrderList orderList = OrderList.fromJson(jsonList);
      log.w('getMyOrders order list length ${orderList.orders!.length}');
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
            /ordersbyaddresspaged/:address/:start?/:count?/:status?
                                                          'open', 'closed', 'canceled'
-------------------------------------------------------------------------------------*/

  Future getMyOrdersByTickerName(String? exgAddress, String? tickerName,
      {int skip = 0, int count = 10, String status = ''}) async {
    log.w(
        'getMyOrdersByTickerName $exgAddress -- $tickerName -- skip $skip -- count $count');

    try {
      String url =
          '${configService!.getKanbanBaseUrl()}getordersbytickernamepaged/$exgAddress/$tickerName/$skip/$count/$status';

      log.i('getMyOrdersByTickerName url $url');
      var res = await client.get(Uri.parse(url));

      var jsonList = jsonDecode(res.body) as List;

      OrderList orderList = OrderList.fromJson(jsonList);
      //   _singlePairOrders.value = orderAggregation(orderList.orders);3
      _singlePairOrders.value = orderList.orders;
      //  .map((e) => e).toList();
    } catch (err) {
      log.e('getMyOrdersByTickerName Catch $err');
      throw Exception;
    }
  }
}
