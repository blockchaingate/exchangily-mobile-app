import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/campaign_service.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/pdf_viewer_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';

class CampaignInstructionsScreenState extends BaseState {
  final log = getLogger('CampaignInstructionsScreenState');
  LocalStorageService? localStorageService = locator<LocalStorageService>();
  NavigationService? navigationService = locator<NavigationService>();
  CampaignService? campaignService = locator<CampaignService>();
  SharedService? sharedService = locator<SharedService>();
  PdfViewerService? pdfViewerService = locator<PdfViewerService>();
  UserSettingsDatabaseService? userSettingsDatabaseService =
      locator<UserSettingsDatabaseService>();

  CampaignUserData? userData;
  BuildContext? context;
  bool isGuideReady = false;

  //Campaign data
  List? campaignInfoList;
  ApiService? apiService = locator<ApiService>();
  String? lang = '';
  bool hasApiError = false;
  // Init state
  initState() async {
    // circular indicator is still not working when page first loads
    setBusy(true);
    log.e(busy);
    sharedService!.context = context;
    var loginToken = await campaignService!.getSavedLoginTokenFromLocalStorage();
    log.w('token $loginToken');
    if (loginToken != '' && loginToken != null) {
      await campaignService!.getMemberProfile(loginToken).then((res) async {
        if (res != null) {
          await campaignService!.getUserDataFromDatabase().then((res) {
            if (res != null) {
              userData = res;
              navigateTo('/campaignDashboard');
            }
          });
        } else if (res == null) {
          navigateTo('/campaignLogin',
              errorMessage: AppLocalizations.of(context!)!.sessionExpired);
        }
      }).catchError((err) {
        log.e('getMemberProfile catch');
        setErrorMessage(AppLocalizations.of(context!)!.serverError);
        setBusy(false);
      });

      /// if login token is null then
      /// show the svg images
    } else {
      // lang = localStorageService.language;
      await userSettingsDatabaseService!.getLanguage().then((value) {
        debugPrint('value $value');
        lang = value;
      });
      if (lang == '' || lang == null) lang = 'en';
      log.i('lang $lang');
      var eventContent;

      eventContent = await apiService!.getEvents();

      log.i("Got Event!!! $eventContent");
      if (eventContent == "error") {
        log.wtf("Got API Error!!!");
        hasApiError = true;
      } else {
        log.i("no issue");
        debugPrint(eventContent.toString());
        campaignInfoList = eventContent;
      }

      log.i("Got Event End!!!");
      setBusy(false);
    }
    //get campaign info in selected language
    log.i("setBusy(false);!!!");
    setBusy(false);
  }

  navigateTo(String route, {String errorMessage = ''}) {
    navigationService!.navigateUsingpopAndPushedNamed(route,
        arguments: errorMessage);
  }

  onBackButtonPressed() async {
    navigationService!.navigateUsingpopAndPushedNamed('/dashboard');
  }
}
