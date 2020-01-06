import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/globals.dart' as globals;

class AppBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double paddingValue = 4; // change space between icon and title text
    final double iconSize = 25; // change icon size
    return BottomNavigationBar(
      elevation: 10,
      unselectedItemColor: globals.grey,
      //  backgroundColor: Color.fromRGBO(28, 28, 45, .95),
      selectedItemColor: globals.primaryColor,
      showUnselectedLabels:
          true, // show label below the icon even when not selected
      items: [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.wallet, size: iconSize),
          title: Padding(
              padding: EdgeInsets.only(
                  top:
                      paddingValue), // use to give top padding between icon and text
              child: Text('Wallet')),
        ),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartBar, size: iconSize),
            title: Padding(
                padding: EdgeInsets.only(top: paddingValue),
                child: Text('Market'))),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.coins, size: iconSize),
            title: Padding(
                padding: EdgeInsets.only(top: paddingValue),
                child: Text('Trade'))),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.cog, size: iconSize),
            title: Padding(
                padding: EdgeInsets.only(top: paddingValue),
                child: Text('Settings'))),
      ].toList(),
      onTap: (int idx) {
        switch (idx) {
          case 0:
            // Navigator.pushNamed(context, '/wallet');
            break;
          case 1:
            Navigator.pushNamed(context, '/market');
            break;
          case 2:
            Navigator.pushNamed(context, '/trade');
            break;
          case 3:
            Navigator.pushNamed(context, '/settings');
            break;
        }
      },
    );
  }
}
