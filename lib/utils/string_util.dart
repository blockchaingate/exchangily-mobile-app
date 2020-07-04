/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com & barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'dart:convert';
import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

hex2Buffer(hexString) {
  var buffer = new List<int>();
  for (var i = 0; i < hexString.length; i += 2) {
    var val = (int.parse(hexString[i], radix: 16) << 4) |
        int.parse(hexString[i + 1], radix: 16);
    buffer.add(val);
  }
  return buffer;
}

trimHexPrefix(String str) {
  if (str.startsWith('0x')) {
    str = str.substring(2);
  }
  return str.trim();
}

number2Buffer(num) {
  var buffer = new List<int>();
  var neg = (num < 0);
  num = num.abs();
  while (num > 0) {
    buffer.add(num & 0xff);

    num = num >> 8;
  }

  var top = buffer[buffer.length - 1];
  if (top & 0x80 != 0) {
    buffer.add(neg ? 0x80 : 0x00);
  } else if (neg) {
    buffer.add(top | 0x80);
  }
  return buffer;
}

stringToUint8List(String s) {
  List<int> list = utf8.encode(s);
  return Uint8List.fromList(list);
}

uint8ListToString(Uint8List list) {
  return HEX.encode(list);
}

/*
bigIntString2Double(bigInt) {
  return (Decimal.parse(bigInt.toString()) / Decimal.parse('1000000000000000000')).toDouble();
}
*/
fixLength(String str, int length) {
  var retStr = '';
  int len = str.length;
  int len2 = length - len;
  if (len2 > 0) {
    for (int i = 0; i < len2; i++) {
      retStr += '0';
    }
    retStr += str;
    return retStr;
  } else if (len2 < 0) {
    return str.substring(0, length - 1);
  } else {
    return str;
  }
}

doubleAdd(double d1, double d2) {
  var d = Decimal.parse(d1.toString()) + Decimal.parse(d2.toString());
  return d.toDouble();
}

bigNum2Double(bigNum) {
  var dec =
      Decimal.parse(bigNum.toString()) / Decimal.parse('1000000000000000000');
  if (dec.toDouble() > 999999) {
    return double.parse(dec.toDouble().toStringAsFixed(8));
  }
  var str = dec.toString();
  var s = str;
  // if (str.length > 6) {
  //   s = str.substring(0, 6);
  // }

  // double d = double.parse(s);
  // if (d == 0.0) {
  //   if (str.length > 7) {
  //     s = str.substring(0, 7);
  //   }
  //   d = double.parse(s);
  // }

  var d = dec.toDouble();
  if (str.length > 8) {
    s = str.substring(0, 8);

    d = double.parse(s);
  }
  return d;
  //double d = (BigInt.parse(bigNum.toString()) / BigInt.parse('1000000000000')).round() / 1000000;
  //return d;
}

/*----------------------------------------------------------------------
                Format Date and time string
----------------------------------------------------------------------*/
String formatStringDate(String date) {
  String wholeDate = date;
  var dateToFormat = DateTime.parse(wholeDate);
  String formattedDate = DateFormat('yyyy/MM/dd').format(dateToFormat);
  String formattedTime = DateFormat('kk:mm:ss').format(dateToFormat);
  formattedDate = '$formattedDate\n' '$formattedTime';
  return formattedDate;
}
