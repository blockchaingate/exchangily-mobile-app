import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/models/alert/alert_response.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localizations.dart';
import '../../logger.dart';
import '../../service_locator.dart';
import '../base_state.dart';

class MarketPairsTabViewState extends BaseState {
  final log = getLogger('MarketPairsTabViewState');
  List images;
  ApiService apiService = locator<ApiService>();
  BuildContext context;
  String lang = 'en';

  final List imagesLocal = [
    {
      "url": "assets/images/slider/campaign2.jpg",
      "urlzh": "assets/images/slider/adv2.jpg.jpg",
      "route": ''
    },
  ];

  init() async {
    setBusy(true);
    var result = await apiService.getSliderImages();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('lang');
    print("Slider from api:");
    print(result);
    if (result == "error") {
      images = imagesLocal;
    } else {
      images = result;
    }

    setBusy(false);
  }
}
