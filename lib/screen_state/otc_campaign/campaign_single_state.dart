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

class CampaignSingleScreenState extends BaseState {
  final log = getLogger('CampaignInstructionsScreenState');

  LocalStorageService localStorageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  // CampaignUserDatabaseService campaignUserDatabaseService =
  //     locator<CampaignUserDatabaseService>();

  // CampaignUserData userData;
  BuildContext context;
  bool isGuideReady = false;

  //Campaign data
  Map campaignInfoSingle;
  ApiService apiService = locator<ApiService>();
  String lang = '';
  bool hasApiError = false;

  String eventID;
  // Init state
  initState() async {
    setBusy(true);
    log.e(busy);

    print("eventID: " + eventID);

    //get campaign info in selected language
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('lang');

    var eventContent;

    eventContent = await apiService.postEventSingle(eventID);

    if (eventContent == "error") {
      hasApiError = true;
    } else {
      print(eventContent.toString());
      campaignInfoSingle = eventContent;
    }

    setBusy(false);
    log.e(busy);
  }
}
