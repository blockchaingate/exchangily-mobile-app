import 'package:flutter/material.dart';

final double largeSize = 700;


//check is phone or tablet
bool isPhone() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < largeSize ;
}
