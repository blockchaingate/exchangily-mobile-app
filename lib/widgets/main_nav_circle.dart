import 'package:exchangilymobileapp/screens/exchange/markets/markets_view.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/instructions_screen.dart';
import 'package:exchangilymobileapp/screens/settings/settings_view.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_dashboard_view.dart';
// import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

class MainNavCircle extends StatefulWidget {
  @override
  MainNavCircleState createState() => MainNavCircleState();
}

class MainNavCircleState extends State<MainNavCircle> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: _getPage(currentPage),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [],
        ),
        // FancyBottomNavigation(
        //   tabs: [
        //     TabData(
        //         iconData: FontAwesomeIcons.wallet,
        //         title: AppLocalizations.of(context).wallet),
        //     TabData(
        //         iconData: FontAwesomeIcons.coins,
        //         title: AppLocalizations.of(context).trade),
        //     TabData(
        //         iconData: Icons.event,
        //         title: AppLocalizations.of(context).event),
        //     TabData(
        //         iconData: FontAwesomeIcons.cog,
        //         title: AppLocalizations.of(context).settings)
        //   ],
        //   initialSelection: 0,
        //   key: bottomNavigationKey,
        //   onTabChangedListener: (position) {
        //     setState(() {
        //       currentPage = position;
        //     });
        //   },
        // ),
        drawer: Drawer(
          child: ListView(
            children: const <Widget>[Text("Hello"), Text("World")],
          ),
        ),
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return const WalletDashboardView();
      case 1:
        return const MarketsView();
      case 2:
        return const CampaignInstructionScreen();
      case 3:
        return const SettingsView();
      default:
        return const WalletDashboardView();
    }
  }
}
