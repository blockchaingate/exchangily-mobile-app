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

class TradeModel {
  String orderHash1;
  String orderHash2;
  double price;
  double amount;
  int blockNumber;
  int time;
  bool bidOrAsk;
  TradeModel(this.orderHash1, this.orderHash2, this.price, this.amount,
      this.blockNumber, this.time, this.bidOrAsk);
}
