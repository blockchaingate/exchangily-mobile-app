import 'dart:convert';
import 'dart:typed_data';
import 'package:hex/hex.dart';

hex2Buffer(hexString) {

  var buffer = new List<int>();
  for (var i = 0; i < hexString.length; i += 2) {
    var val = (int.parse(hexString[i],radix: 16) << 4) | int.parse(hexString[i + 1], radix: 16);
    buffer.add(val);
  }
  return buffer;
}

trimHexPrefix(String str) {
  if(str.startsWith('0x')) {
    str = str.substring(2);
  }
  return str;
}

number2Buffer(num) {
  var buffer = new List<int>();
  var neg = (num < 0);
  num = num.abs();
  while (num > 0) {
    print('num=');
    print(num);
    print(buffer.length);
    print(num & 0xff);
    buffer.add (num & 0xff);
    print('buffer=');
    print(buffer);
    num = num >> 8;
  }

  var top = buffer[buffer.length - 1];
  if (top & 0x80 != 0) {
    buffer.add (neg ? 0x80 : 0x00) ;
  }
  else if (neg) {
    buffer.add(top | 0x80) ;
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

fixLength( String str, int length ) {
  var retStr = '';
  int len = str.length;
  int len2 = length - len;
  if (len2 > 0) {
    for(int i=0;i<len2; i++) {
      retStr += '0';
    }
  }
  retStr += str;
  return retStr;
}

bigNum2Double(bigNum) {

  double d = (BigInt.parse(bigNum.toString()) / BigInt.parse('1000000000000')).round() / 1000000;
  return d;
}