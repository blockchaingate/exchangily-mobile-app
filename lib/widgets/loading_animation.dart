import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double size;
  Loading({this.size:60});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
      "assets/images/img/exLoading.gif",
      width: size,
      height: size,
    ));
  }
}
