import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter/material.dart';
import '../shared/globals.dart' as globals;

class Loading extends StatelessWidget {
  final double size;
  Loading({this.size: 60});

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
        SizedBox(height: 3),
        Text(
          AppLocalizations.of(context).loading,
          style: TextStyle(color: globals.primaryColor),
        )
      ],
    ));
  }
}
