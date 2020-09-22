/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import 'order-model.dart';

// Update Orders name to OrderType so that OrderModel can be updated to Order
class Orders {
  /// instead of buy and sell it should be buyOrder, sellOrder
  List<Order> buy;
  List<Order> sell;
}
