import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:flutter/material.dart';

import '../../logger.dart';
import '../../service_locator.dart';
import '../base_state.dart';

class MarketPairsTabViewState extends BaseState {
  final log = getLogger('MarketPairsTabViewState');
  List images;
  ApiService apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  LocalStorageService localStorageService = locator<LocalStorageService>();
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

    lang = localStorageService.language;
    log.w("Slider from api: $result");

    if (result == "error") {
      images = imagesLocal;
    } else {
      images = result;
    }

    setBusy(false);
  }
}
