import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/pdf_viewer_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignInstructionsScreenState extends BaseState {
  final log = getLogger('CampaignInstructionsScreenState');
  LocalStorageService localStorageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();
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
    log.e(busy);
  }

  onBackButtonPressed() async {
    navigationService.navigateUsingpopAndPushedNamed('/dashboard');
  }
}
