import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import '../shared/globals.dart' as globals;

class LoadingGif extends StatelessWidget {
  final double size;
  const LoadingGif({this.size = 60});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/img/exLoading.gif",
          width: size,
          height: size,
        ),
        const SizedBox(height: 3),
        Text(
          FlutterI18n.translate(context, "loading"),
          style: TextStyle(color: globals.primaryColor),
        )
      ],
    ));
  }
}
