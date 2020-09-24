import 'package:exchangilymobileapp/screens/exchange/markets/markets_view.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screens/market/main.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/instructions_screen.dart';
import 'package:exchangilymobileapp/screens/settings/settings.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/globals.dart' as globals;

class MainNavCircle extends StatefulWidget {
  @override
  _MainNavCircleState createState() => _MainNavCircleState();
}

class _MainNavCircleState extends State<MainNavCircle> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: _getPage(currentPage),
          ),
        ),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(
                iconData: FontAwesomeIcons.wallet,
                title: AppLocalizations.of(context).wallet),
            TabData(
                iconData: FontAwesomeIcons.coins,
                title: AppLocalizations.of(context).trade),
            TabData(
                iconData: Icons.event,
                title: AppLocalizations.of(context).event),
            TabData(
                iconData: FontAwesomeIcons.cog,
                title: AppLocalizations.of(context).settings)
          ],
          initialSelection: 0,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[Text("Hello"), Text("World")],
          ),
        ),
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return WalletDashboardScreen();
      case 1:
        return MarketsView();
      case 2:
        return CampaignInstructionScreen();
      case 3:
        return SettingsScreen();
      default:
        return WalletDashboardScreen();
    }
  }
}
