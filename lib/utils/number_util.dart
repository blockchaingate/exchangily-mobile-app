import 'dart:math';

import 'package:decimal/decimal.dart';

class NumberUtil {
  static const int DEFAULT_DECIMAL_DIGITS = 2;
  int maxDecimalDigits;

  double truncateDecimal(Decimal input, {int digits = DEFAULT_DECIMAL_DIGITS}) {
    return (input * Decimal.fromInt(pow(10, digits))).truncateToDouble() /
        pow(10, digits);
  }
}
