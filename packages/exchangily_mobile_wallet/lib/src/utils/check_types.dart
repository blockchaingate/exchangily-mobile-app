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

import 'dart:typed_data';
import 'dart:math';

const SATOSHI_MAX = 21 * 1e14;

bool isShatoshi(int value) {
  return isUint(value, 53) && value <= SATOSHI_MAX;
}

bool isUint(int value, int bit) {
  return (value >= 0 && value <= pow(2, bit) - 1);
}

bool isHash160bit(Uint8List value) {
  return value.length == 20;
}

bool isHash256bit(Uint8List value) {
  return value.length == 32;
}
