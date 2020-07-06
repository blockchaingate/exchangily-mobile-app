import 'package:exchangilymobileapp/localizations.dart';
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
          navigationService.navigateTo('/campaignLogin');
        } else {
          setErrorMessage(AppLocalizations.of(context).genericError);
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
