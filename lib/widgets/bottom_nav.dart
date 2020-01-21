import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/globals.dart' as globals;

class AppBottomNav extends StatelessWidget {
  final int count;
  AppBottomNav({Key key, this.count}) : super(key: key);

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
            icon: Icon(FontAwesomeIcons.chartBar, size: iconSize),
            title: Padding(
                padding: EdgeInsets.only(top: paddingValue),
                child: Text(AppLocalizations.of(context).market))),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.coins, size: iconSize),
            title: Padding(
                padding: EdgeInsets.only(top: paddingValue),
                child: Text(AppLocalizations.of(context).trade))),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.cog, size: iconSize),
            title: Padding(
                padding: EdgeInsets.only(top: paddingValue),
                child: Text(AppLocalizations.of(context).settings))),
      ].toList(),
      onTap: (int idx) {
        switch (idx) {
          case 0:
            Navigator.pushNamed(context, '/dashboard');
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
