import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class NetworkStausView extends StatelessWidget {
  // final Widget child;

  @override
  Widget build(BuildContext context) {
    final navigationService = locator<NavigationService>();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context).noInternetWarning,
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
            UIHelper.verticalSpaceSmall,
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(white)),
                onPressed: () => navigationService
                    .navigateUsingPushReplacementNamed(DashboardViewRoute),
                child: Text(
                  AppLocalizations.of(context).reload,
                  style: const TextStyle(color: primaryColor),
                ))
          ],
        ),
      ),
    );
  }
}
