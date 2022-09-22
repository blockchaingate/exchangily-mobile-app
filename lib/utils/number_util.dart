import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class NumberUtil {
  int maxDecimalDigits;
  final log = getLogger('NumberUtil');

  static int getDecimalLength(double number) {
    String stringNumber = number.toString();
    int decimalLength = 0;
    try {
      decimalLength = stringNumber.split('.')[1].length;
      return decimalLength;
    } catch (err) {
      debugPrint('getDecimalLength no decimal found: error $err');
      return decimalLength;
    }
  }

  double truncateDoubleWithoutRouding(double input, {int precision = 2}) {
    double res = 0.0;
    bool isInputContainsE = input.toString().contains('e');
    if (!input.isNaN && !isInputContainsE) {
      String decimalPart = input.toString().split('.')[1];
      // if (input.toString().contains('.')) {
      // indexOf gives 2 if balance is 54.321299421
      // as . is after 2 decimal digits
      // we add precision for example 6
      // 2+ 6 = 8
      // 54.32129
      // we add +1 as we need 6 precisions
      // 2+6+1 = 9
      // 54.321299
      if (decimalPart.length > precision) {
        res = double.parse(
            '$input'.substring(0, '$input'.indexOf('.') + precision + 1));
      } else {
        // String tail = '';
        // for (var i = 0; i < precision - decimalPart.length; i++) {
        //   tail += '0';
        // }
        // String concat = '$input' + tail;
        // res = double.parse(concat);
        // log.e('res $res');
        res = input;
      }
    }
    return res;
  }

  double roundDownLastDigit(double input) {
    log.w('roundDownLastDigit input val $input');
    double finalBalance = 0.0;
    int roundDown = 0;
    String balanceToString = input.toString();
    String beforeDecimalBalance = balanceToString.split(".")[0];
    String afterDecimalBalance = balanceToString.split(".")[1];
    String lastDecimalDigit =
        afterDecimalBalance.substring(afterDecimalBalance.length - 1);
    String secondLastDecimalDigit =
        afterDecimalBalance.substring(0, afterDecimalBalance.length - 1);
    if (lastDecimalDigit != '0') {
      roundDown = int.parse(lastDecimalDigit) - 1;
    }
    String res = beforeDecimalBalance +
        '.' +
        secondLastDecimalDigit +
        roundDown.toString();
    finalBalance = double.parse(res);

    log.w('roundDownLastDigit res $finalBalance');
    return finalBalance;
  }

  static int convertIntToHex(int coinType) {
    var x = coinType.toRadixString(16);
    debugPrint('basecoin $coinType --  Hex == $x');
    return int.parse(x);
  }

  static double weiToGwei(int value) {
    return double.parse(value.toString()) / 1e9;
  }

  intToHex(source) {
    return source.toRadixString(16);
  }

  double truncateDouble(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

// Parse double
  double parsedDouble(value) {
    double res = 0.0;

    if (value != null) res = double.parse(value.toString());
    if (res.isNegative) {
      res = 0.0;
    }
    return res;
  }

  static BigInt decimalToBigInt(Decimal value, {int decimalPrecision = 18}) {
    return (value * Decimal.fromInt(pow(10, decimalPrecision))).toBigInt();
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
          debugPrint('toBigInt func: decimalPart before: $decimalPart');
          debugPrint('toBigInt func: decimalLength: $decimalLength');
          decimalPart = decimalPart.substring(0, decimalLength);
          debugPrint('toBigInt func: decimalPart after: $decimalPart');
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

    debugPrint('toBigInt value: $val');
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
      _exp = RegExp("^((((-){0,1})|((-){0,1}[0-9]$num))){0,1}\$");
    } else {
      _exp = RegExp("^($num){0,1}\$");
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
