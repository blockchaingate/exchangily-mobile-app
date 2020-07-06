import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/pdf_viewer_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignInstructionsScreenState extends BaseState {
  final log = getLogger('CampaignInstructionsScreenState');
  final String reffer1AssetName = 'assets/images/otc-campaign/reffer.svg';
  final List<String> campaignGuideFilesEn = <String>[
    'assets/images/otc-campaign/guide-about-campaign-en.svg',
    'assets/images/otc-campaign/guide-reward-example-en.svg',
    'assets/images/otc-campaign/guide-team-rewards-en.svg'
  ];
  final List<String> campaignGuideFilesCh = <String>[
    'assets/images/otc-campaign/guide-about-campaign-ch.svg',
    'assets/images/otc-campaign/guide-team-reward-ch.svg'
  ];
  final List<Widget> _tierListSvg = <Widget>[];
  List<Widget> get tierListSvg => _tierListSvg;
  LocalStorageService localStorageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();
  PdfViewerService pdfViewerService = locator<PdfViewerService>();

  CampaignUserData userData;
  BuildContext context;
  bool isGuideReady = false;

  final List<Map> eventContent = [
    {
      "type": "row",
      "title": "BRIEF INTRO",
      "text":
          "The campaign is to celebrate the official launch of eXchangily and regulatory licensing approval in the United States and Canada."
    },
    {
      "type": "row",
      "title": "DATE PERIOD",
      "text":
          "From today and will run until all 5 Million EXG reward tokens are given away."
    },
    {
      "type": "row",
      "title": "ABOUT EXCHAGILY",
      "text":
          "eXchangily is the 1st fully licensed decentralized crypto exchange, offering fast, autonomous transactions, cross-chain capability and 100% profit sharing to EXG token holders."
    },
    {
      "type": "row",
      "title": "EVENT DETAIL",
      "text":
          "The campaign is open to existing and new investors, a minimum of \$100USD purchase of EXG is required during the campaign to obtain a referral code."
    },
    {
      "type": "form",
      "content": [
        {
          "icon": "assets/images/img/level-01.png",
          "title": "SILVER",
          "price": "\$100+",
          "tier1": "TIER 1",
          "reword1":"8%",
          "client1":"1-2",
          "tier2": "TIER 2",
          "reword2":"4%",
          "client2":"3-4",
          "tier3": "TIER 3",
          "reword3":"1%",
          "client3":"5+",
        },
        {
          "icon": "assets/images/img/level-02.png",
          "title": "GOLD",
          "price": "\$500+",
          "tier1": "TIER 1",
          "reword1":"9%",
          "client1":"1-2",
          "tier2": "TIER 2",
          "reword2":"5%",
          "client2":"3-4",
          "tier3": "TIER 3",
          "reword3":"2%",
          "client3":"5+",
        },
        {
          "icon": "assets/images/img/level-03.png",
          "title": "DIAMOND",
           "price": "\$1000+",
          "tier1": "TIER 1",
          "reword1":"10%",
          "client1":"1-2",
          "tier2": "TIER 2",
          "reword2":"6%",
          "client2":"3-4",
          "tier3": "TIER 3",
          "reword3":"3%",
          "client3":"5+",
        },
        
      ],
      
    },
    {
      "type": "row",
      "title": "EXTRA BONUS",
      "text":
          "Every \$100USD purchase of EXG entitles you to 1 FAB, upto a maximum of 5 FAB Purchases of EXG can be made in USDT, ETH and BTC, via the eXchangily exchange or with USD, CAD or RMB via OTC."
    },
  ];

  // Init state

  initState() async {
    // circular indicator is still not working when page first loads
    setBusy(true);
    log.e(busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString('loginToken');
    if (loginToken != '' && loginToken != null) {
      await campaignUserDatabaseService
          .getUserDataByToken(loginToken)
          .then((res) {
        log.w('database response $res');
        if (res != null) {
          userData = res;
          isGuideReady = true;
          navigationService.navigateTo('/campaignDashboard',
              arguments: userData);
        } else {
          setErrorMessage('Entry does not found in database');
        }
      }).catchError((err) {
        log.w('Fetch user from database failed');
      });
    } else {
      String lang = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      lang = prefs.getString('lang');
      if (lang == 'en' || lang == 'EN') {
        for (String assetName in campaignGuideFilesEn) {
          _tierListSvg.add(SvgPicture.asset(
            assetName,
            fit: BoxFit.contain,
            semanticsLabel: 'Tier 1,2,3 instruction',
          ));
        }
      } else {
        for (String assetName in campaignGuideFilesCh) {
          _tierListSvg.add(SvgPicture.asset(
            assetName,
            fit: BoxFit.contain,
            semanticsLabel: 'Tier 1,2,3 instruction',
          ));
        }
      }
    }
    setBusy(false);
    log.e(busy);
  }

  onBackButtonPressed() async {
    navigationService.navigateUsingpopAndPushedNamed('/dashboard');
  }
}
