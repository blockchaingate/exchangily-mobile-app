import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
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
  CampaignService campaignService = locator<CampaignService>();
  PdfViewerService pdfViewerService = locator<PdfViewerService>();

  CampaignUserData userData;
  BuildContext context;
  bool isGuideReady = false;

  // Init state

  initState() async {
    // circular indicator is still not working when page first loads
    setBusy(true);
    log.e(busy);

    var loginToken = await campaignService.getSavedLoginTokenFromLocalStorage();
    log.w(loginToken);
    if (loginToken != '' && loginToken != null) {
      await campaignService.getMemberProfile(loginToken).then((res) async {
        if (res != null) {
          await campaignService.getUserDataFromDatabase().then((res) {
            if (res != null) {
              userData = res;
              navigateTo('/campaignDashboard');
            }
          });
        } else if (res == null) {
          navigateTo('/campaignLogin', errorMessage: 'Session Expired');
        }
      }).catchError((err) {
        log.e('getMemberProfile catch');
        setErrorMessage(AppLocalizations.of(context).serverError);
        setBusy(false);
      });

      /// if login token is null then
      /// show the svg images
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

  navigateTo(String route, {String errorMessage = ''}) {
    navigationService.navigateUsingpopAndPushedNamed(route,
        arguments: userData);
    setErrorMessage(errorMessage);
    setBusy(false);
  }

  onBackButtonPressed() async {
    navigationService.navigateUsingpopAndPushedNamed('/dashboard');
  }
}
