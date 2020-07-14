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

import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/globals.dart' as globals;

class BottomNavBar extends StatelessWidget {
  final int count;
  BottomNavBar({Key key, this.count}) : super(key: key);

  final NavigationService navigationService = locator<NavigationService>();
  final SharedService sharedService = locator<SharedService>();
  @override
  Widget build(BuildContext context) {
    final double paddingValue = 4; // change space between icon and title text
    final double iconSize = 25; // change icon size
    int _selectedIndex = count;

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
          icon: Icon(FontAwesomeIcons.wallet, size: iconSize),
          title: Padding(
              padding: EdgeInsets.only(top: paddingValue),
              child: Text(AppLocalizations.of(context).wallet)),
        ),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.coins, size: iconSize),
            title: Padding(
                padding: EdgeInsets.only(top: paddingValue),
                child: Text(AppLocalizations.of(context).trade))),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.branding_watermark, size: iconSize),
        //     title: Padding(
        //         padding: EdgeInsets.only(top: paddingValue),
        //         child: Text('OTC'))),
        BottomNavigationBarItem(
            icon: Icon(Icons.event, size: iconSize),
            title: Padding(
                padding: EdgeInsets.only(top: paddingValue),
                child: Text(AppLocalizations.of(context).event))),

        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.cog, size: iconSize),
            title: Padding(
                padding: EdgeInsets.only(top: paddingValue),
                child: Text(AppLocalizations.of(context).settings))),
      ].toList(),
      onTap: (int idx) {
        String currentRouteName = sharedService.getCurrentRouteName(context);

        switch (idx) {
          case 0:
            if (currentRouteName != 'WalletDashboardScreen')
              navigationService.navigateTo('/dashboard');
            break;

          case 1:
            if (currentRouteName != 'MarketsView')
              navigationService.navigateUsingpopAndPushedNamed('/marketsView');
            break;
          // case 2:
          // if (currentRouteName != 'OtcScreen')
          //   Navigator.pushNamed(context, '/otc');
          //   break;
          case 2:
            if (currentRouteName != 'CampaignInstructionScreen')
              navigationService
                  .navigateUsingpopAndPushedNamed('/campaignInstructions');
            break;
          case 3:
            if (currentRouteName != 'SettingsScreen')
              navigationService.navigateTo('/settings');
            else if (ModalRoute.of(context).settings.name == 'SettingsScreen')
              return null;
            break;
        }
      },
    );
  }
}
