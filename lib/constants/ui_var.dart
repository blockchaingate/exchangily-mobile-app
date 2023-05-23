import 'package:flutter/material.dart';

const double largeSize = 700;


//check is phone or tablet
bool isPhone() {
    final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
    return data.size.shortestSide < largeSize ;
}
