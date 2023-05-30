import 'package:exchangilymobileapp/screens/exchange/markets/markets_view.dart';

import 'package:exchangilymobileapp/screens/otc_campaign/instructions_screen.dart';
import 'package:exchangilymobileapp/screens/settings/settings_view.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/service_locator.dart';

import 'constants/colors.dart';

class MainNav extends StatefulWidget {
  const MainNav({this.currentPage = 0});
  final int currentPage;

  @override
  MainNavState createState() => MainNavState();
}

class MainNavState extends State<MainNav> {
  PageController? _pageController;
  int _page = 0;
  final double paddingValue = 4; // change space between icon and title text
  final double iconSize = 25; // change icon size
  SharedService? sharedService = locator<SharedService>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: () async => false,
      onWillPop: () async {
        if (_page == 0) {
          sharedService!.context = context;
          await sharedService!.closeApp();
          return Future(() => false);
        }
        onPageChanged(0);
        navigateToPage(0);
        return Future(() => false);
      },
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: const <Widget>[
            WalletDashboardView(),
            MarketsView(),
            CampaignInstructionScreen(),
            SettingsView()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          // currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          elevation: 20,
          unselectedItemColor: grey,
          backgroundColor: Theme.of(context).cardColor,
          selectedItemColor: primaryColor,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.wallet, size: iconSize),
              label: FlutterI18n.translate(context, "wallet"),
            ),
            // BottomNavigationBarItem(
            //     icon: Icon(FontAwesomeIcons.chartBar, size: iconSize),
            //     title: Padding(
            //         padding: EdgeInsets.only(top: paddingValue),
            //         child: Text(AppLocalizations.of(context).market))),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.coins, size: iconSize),
              label: FlutterI18n.translate(context, "trade"),
            ),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.branding_watermark, size: iconSize),
            //     title: Padding(
            //         padding: EdgeInsets.only(top: paddingValue),
            //         child: Text('OTC'))),
            BottomNavigationBarItem(
              icon: Icon(Icons.event, size: iconSize),
              label: FlutterI18n.translate(context, "event"),
            ),

            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.cog, size: iconSize),
              label: FlutterI18n.translate(context, "settings"),
            ),
          ],
          onTap: navigateToPage,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigateToPage(int page) {
    _pageController!.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentPage);
    setState(() {
      _page = widget.currentPage;
      // debugPrint("current page: ${widget.currentPage}");
      // debugPrint("_page: ${this._page}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }
}

class MarketView {}
