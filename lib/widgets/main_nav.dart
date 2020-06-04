import 'package:exchangilymobileapp/screens/market/main.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/instructions_screen.dart';
import 'package:exchangilymobileapp/screens/settings/settings.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/globals.dart' as globals;

class MainNav extends StatefulWidget {
  @override
  _MainNavState createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  PageController _pageController;
  int _page = 0;
  final double paddingValue = 4; // change space between icon and title text
  final double iconSize = 25; // change icon size

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          WalletDashboardScreen(walletInfo: null),
          Market(),
          CampaignInstructionScreen(),
          SettingsScreen()
        ],
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: _selectedIndex,
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
          // BottomNavigationBarItem(
          //     icon: Icon(FontAwesomeIcons.chartBar, size: iconSize),
          //     title: Padding(
          //         padding: EdgeInsets.only(top: paddingValue),
          //         child: Text(AppLocalizations.of(context).market))),
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
        ],
        onTap: navigateToPage,
        currentIndex: _page,
      ),
    );
  }

  void navigateToPage(int page) {
    _pageController.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
