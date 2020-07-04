/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Class Name: AlertRequest
*
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

class DecimalConfig {
  int _priceDecimal;
  int _quantityDecimal;

  DecimalConfig({
    int priceDecimal,
    int quantityDecimal,
  }) {
    this._priceDecimal = priceDecimal ?? 6;
    this._quantityDecimal = quantityDecimal ?? 6;
  }

  int get priceDecimal => _priceDecimal;
  set priceDecimal(int priceDecimal) {
    this._priceDecimal = priceDecimal;
  }

  int get quantityDecimal => _quantityDecimal;

  set quantityDecimal(int quantityDecimal) {
    this._quantityDecimal = quantityDecimal;
  }
}
