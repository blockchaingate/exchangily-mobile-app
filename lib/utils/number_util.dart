import 'dart:math';
import 'package:exchangilymobileapp/logger.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberUtil {
  static const int DEFAULT_DECIMAL_DIGITS = 2;
  int maxDecimalDigits;
  final log = getLogger('NumberUtil');

  double truncateDouble(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

// Parse double
  double parsedDouble(value) {
    double res = 0.0;

    if (value != null) res = double.parse(value.toString());
    return res;
  }

// To Big Int
  static toBigInt(amount, [decimalLength]) {
    var numString = amount.toString();
    var numStringArray = numString.split('.');
    decimalLength ??= 18;
    var val = '';
    if (numStringArray != null) {
      val = numStringArray[0];
      if (numStringArray.length == 2) {
        var decimalPart = numStringArray[1];
        if (decimalPart.length > decimalLength) {
          print('decimalPart before: $decimalPart');
          print('decimalLength: $decimalLength');
          decimalPart = decimalPart.substring(0, decimalLength);
          print('decimalPart after: $decimalPart');
        }
        decimalLength -= decimalPart.length;
        val += decimalPart;
      }
    }

    var valInt = int.parse(val);
    val = valInt.toString();
    if (decimalLength > 0) {
      for (var i = 0; i < decimalLength; i++) {
        val += '0';
      }
    }

    print('toBigInt value: $val');
    return val;
  }

// pass value to format with decimal digits needed
  static String currencyFormat(double value, int decimalDigits) {
    String holder = '';
    holder =
        NumberFormat.simpleCurrency(decimalDigits: decimalDigits).format(value);
    holder = holder.substring(1);
    return holder;
  }

// Check if value is an int
  static bool checkIfInt(value) {
    bool result;

    return result;
  }

// Time Format
  timeFormatted(timeStamp) {
    var time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return addZeroInFrontForSingleDigit(time.hour.toString()) +
        ':' +
        addZeroInFrontForSingleDigit(time.minute.toString()) +
        ':' +
        addZeroInFrontForSingleDigit(time.second.toString());
  }

  String addZeroInFrontForSingleDigit(String value) {
    String holder = '';
    if (value.length == 1) {
      holder = '0$value';
    } else {
      holder = value;
    }

    return holder;
  }

  // check decimal places more than 6
  checkDecimal(double value) {
    String valueToString = value.toString();
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final log = getLogger('DecimalTextInputFormatter');
  DecimalTextInputFormatter({int decimalRange, bool activatedNegativeValues})
      : assert(decimalRange == null || decimalRange >= 0,
            'DecimalTextInputFormatter declaretion error') {
    String dp = (decimalRange != null && decimalRange > 0)
        ? "([.][0-9]{0,$decimalRange}){0,1}"
        : "";
    String num = "[0-9]*$dp";

    if (activatedNegativeValues) {
      _exp = new RegExp("^((((-){0,1})|((-){0,1}[0-9]$num))){0,1}\$");
    } else {
      _exp = new RegExp("^($num){0,1}\$");
    }
  }

  RegExp _exp;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
