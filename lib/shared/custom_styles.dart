/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomStyles {
  static TextStyle textStyleParaGraph(BuildContext context) {
    return const TextStyle(
        fontFamily: '',
        fontSize: FontSizes.medium,
        fontWeight: FontWeight.w200,
        color: Colors.black);
  }

  static Decoration roundedBoxDecoration({Color color = primaryColor}) {
    return BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
    );
  }

  static ShapeBorder roundedShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0));
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
