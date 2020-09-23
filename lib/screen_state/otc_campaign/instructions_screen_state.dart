import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/pdf_viewer_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignInstructionsScreenState extends BaseState {
  final log = getLogger('CampaignInstructionsScreenState');
  LocalStorageService localStorageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  CampaignService campaignService = locator<CampaignService>();
  SharedService sharedService = locator<SharedService>();
  PdfViewerService pdfViewerService = locator<PdfViewerService>();

  CampaignUserData userData;
  BuildContext context;
  bool isGuideReady = false;

  //Campaign data
  List campaignInfoList;
  ApiService apiService = locator<ApiService>();
  String lang = '';
  bool hasApiError = false;
  // Init state
  initState() async {
    // circular indicator is still not working when page first loads
    setBusy(true);
    log.e(busy);

    var loginToken = await campaignService.getSavedLoginTokenFromLocalStorage();
    log.w('token $loginToken');
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
          navigateTo('/campaignLogin',
              errorMessage: AppLocalizations.of(context).sessionExpired);
        }
      }).catchError((err) {
        log.e('getMemberProfile catch');
        setErrorMessage(AppLocalizations.of(context).serverError);
        setBusy(false);
      });

      /// if login token is null then
      /// show the svg images
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      lang = prefs.getString('lang');

      var eventContent;

      eventContent = await apiService.getEvents();

      if (eventContent == "error") {
        hasApiError = true;
      } else {
        print(eventContent.toString());
        campaignInfoList = eventContent;
      }
    }
    //get campaign info in selected language

    setBusy(false);
  }

  navigateTo(String route, {String errorMessage = ''}) {
    navigationService.navigateUsingpopAndPushedNamed(route,
        arguments: errorMessage);
  }

  onBackButtonPressed() async {
    navigationService.navigateUsingpopAndPushedNamed('/dashboard');
  }
}
