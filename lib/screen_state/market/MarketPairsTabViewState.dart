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
  // DialogService dialogService = locator<DialogService>();
  // WalletService walletService = locator<WalletService>();
  // WalletDataBaseService walletDatabaseService =
  //     locator<WalletDataBaseService>();
  // SharedService sharedService = locator<SharedService>();

  // final NavigationService navigationService = locator<NavigationService>();
  // List<String> languages = ['English', 'Chinese'];
  // String selectedLanguage;
  // // bool result = false;
  // String errorMessage = '';
  // AlertResponse alertResponse;
  // BuildContext context;
  // String versionName = '';
  // String versionCode = '';
  // bool isDialogDisplay = false;
  // bool isDeleting = false;
  // ScrollController scrollController;
  List<Map> images;
  ApiService apiService = locator<ApiService>();
  BuildContext context;

  init() async {
    setBusy(true);
    var result = await apiService.getSliderImages();
    print("Slider from api:");
    print(result);
    // result.map((e)=>images.add(e));
    // print("image list map:");
    // print(images.toString());
    setBusy(false);
  }

 

}
