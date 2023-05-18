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

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/globals.dart' as globals;

class BottomNavBar extends StatelessWidget {
  final int? count;
  BottomNavBar({Key? key, this.count}) : super(key: key);

  final NavigationService? navigationService = locator<NavigationService>();
  final SharedService? sharedService = locator<SharedService>();
  @override
  Widget build(BuildContext context) {
    // final double paddingValue = 4; // change space between icon and title text
    const double iconSize = 25; // change icon size
    int _selectedIndex = count!;

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14,
      elevation: 10,
      unselectedItemColor: globals.grey,
      backgroundColor: globals.walletCardColor,
      selectedItemColor: globals.primaryColor,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/wallet.png',
              width: 40,
              height: 30,
              color: _selectedIndex == 0 ? primaryColor : grey,
            ),
            label: AppLocalizations.of(context)!.wallet),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/price-up.png',
              width: 40,
              height: 30,
              color: _selectedIndex == 1 ? primaryColor : grey,
            ),
            label: AppLocalizations.of(context)!.trade),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/lightning-remit/remit.png',
            width: 40,
            height: 30,
            color: _selectedIndex == 2 ? primaryColor : grey,
          ),
          label: AppLocalizations.of(context)!.remit,
        ),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.branding_watermark, size: iconSize),
        //     title: Padding(
        //         padding: EdgeInsets.only(top: paddingValue),
        //         child: Text('OTC'))),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/calendar.png',
              width: 40,
              height: 30,
              color: _selectedIndex == 3 ? primaryColor : grey,
            ),
            label: AppLocalizations.of(context)!.event),

        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/settings-icon.png',
              width: 40,
              height: 30,
              color: _selectedIndex == 4 ? primaryColor : grey,
            ),
            label: AppLocalizations.of(context)!.settings),
      ].toList(),
      onTap: (int idx) {
        String? currentRouteName = sharedService!.getCurrentRouteName(context);

        switch (idx) {
          case 0:
            if (currentRouteName != 'WalletDashboardScreen') {
              navigationService!
                  .navigateUsingPushReplacementNamed(DashboardViewRoute);
            }
            break;

          case 1:
            if (currentRouteName != 'MarketsView') {
              navigationService!.navigateUsingPushReplacementNamed(
                  MarketsViewRoute,
                  arguments: false);
            }
            break;
          case 2:
            if (currentRouteName != 'LightningRemitView') {
              navigationService!
                  .navigateUsingPushReplacementNamed(LightningRemitViewRoute);
            }
            break;
          // case 2:
          // if (currentRouteName != 'OtcScreen')
          //   Navigator.pushNamed(context, '/otc');
          //   break;
          case 3:
            if (currentRouteName != 'EventsView') {
              navigationService!
                  .navigateUsingPushReplacementNamed(eventsViewRoute);
            }
            break;
          case 4:
            if (currentRouteName != 'SettingsScreen') {
              navigationService!
                  .navigateUsingpopAndPushedNamed(SettingViewRoute);
            } else if (ModalRoute.of(context)!.settings.name ==
                'SettingsScreen') {
              return null;
            }
            break;
        }
      },
    );
  }
}
