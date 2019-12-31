import 'package:flutter/material.dart';

class Styles {
  static TextStyle textStyleParaGraph(BuildContext context) {
    return TextStyle(
        fontFamily: '',
        fontSize: FontSizes.medium,
        fontWeight: FontWeight.w200,
        color: Colors.black);
  }
}

const headerStyle = TextStyle(fontSize: 35, fontWeight: FontWeight.w900);
const subHeaderStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);

class FontSizes {
  static const small = 14.0;
  static const medium = 16.0;
  static const large = 18.0;
  static const larger = 20.0;
  static const extraLarge = 24.0;
}
