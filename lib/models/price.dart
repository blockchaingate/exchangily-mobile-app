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

class Price {
  String symbol;
  double price;
  double high;
  double low;
  double open;
  double close;
  double volume;
  double change;
  double changeValue;

  Price(this.symbol, this.price, this.high, this.low, this.open, this.close,
      this.volume, this.change, this.changeValue);
}
