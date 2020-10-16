import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter/material.dart';

class NetworkStaus extends StatelessWidget {
  // final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Image.asset(
            'assets/images/wallet-page/exg.png',
            width: 50,
          )),
      body: Container(
        color: sellPrice.withOpacity(.4),
        padding: EdgeInsets.all(50),
        child: Center(
          child: Text(
            AppLocalizations.of(context).noInternetWarning,
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
