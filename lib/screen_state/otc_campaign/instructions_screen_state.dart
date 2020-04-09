import 'dart:async';

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignInstructionsScreenState extends BaseState {
  final log = getLogger('CampaignInstructionsScreenState');
  final String reffer1AssetName = 'assets/images/otc-campaign/reffer.svg';
  final List<String> campaignAssetNames = <String>[
    'assets/images/otc-campaign/reffer.svg',
    'assets/images/otc-campaign/reffer3.svg',
    'assets/images/otc-campaign/reffer5.svg'
  ];
  final List<Widget> _tierListSvg = <Widget>[];
  List<Widget> get tierListSvg => _tierListSvg;
  LocalStorageService localStorageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();

  CampaignUserData userData;
  BuildContext context;
  // Init state
  initState() async {
    log.w('init');
    // circular indicator is still not working when page first loads
    setBusy(true);
    log.w('1');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    log.w('3');
    var loginToken = prefs.getString('loginToken');
    log.w('4');
    if (loginToken != '' && loginToken != null) {
      log.w('5');
      await campaignUserDatabaseService
          .getUserDataByToken(loginToken)
          .then((res) {
        log.w('6');
        log.w('database response $res');
        if (res != null) {
          log.w('7');
          userData = res;

          navigationService.navigateTo('/campaignDashboard',
              arguments: userData);
        } else {
          log.w('9');
          setErrorMessage('Entry does not found in database');
        }
      }).catchError((err) {
        log.w('10');
        log.w('Fetch user from database failed');
      });
    } else {
      log.w('12');
      for (String assetName in campaignAssetNames) {
        log.w('13');
        _tierListSvg.add(SvgPicture.asset(
          assetName,
          fit: BoxFit.contain,
          semanticsLabel: 'Tier 1,2,3 instruction',
        ));
      }
    }
    setBusy(false);

    log.w('15');
  }
}
