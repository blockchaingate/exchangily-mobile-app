import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class NetworkStausView extends StatelessWidget {
  // final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Image.asset(
            'assets/images/wallet-page/exg.png',
            width: 50,
          )),
      body: Container(
        color: primaryColor.withOpacity(.4),
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Text(
            FlutterI18n.translate(context, "noInternetWarning"),
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
