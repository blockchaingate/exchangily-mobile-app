import 'package:stacked/stacked.dart';
import '../../localizations.dart';
import '../../logger.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/pdf_viewer_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';

class ShopHomeState extends BaseState {
  final log = getLogger('ShopHomeScreenState');
  LocalStorageService localStorageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();
  PdfViewerService pdfViewerService = locator<PdfViewerService>();
  BuildContext context;

  ApiService apiService = locator<ApiService>();

  bool hasError = false;
  List collections = [];
  List category = [];
  String lang = '';

  // Init state
  initState() async {
    // circular indicator is still not working when page first loads
    setBusy(true);
    log.e(busy);
    sharedService.context = context;

    if (localStorageService.language == "en")
      lang = 'en';
    else if (localStorageService.language == "zh")
      lang = "sc";
    else if (lang == '')
      lang = 'en';
    else
      lang = 'en';

    print('lang $lang');

    await apiService.getCategory().then((res) async {
      if (res != null) {
        category = res["_body"];
      } else if (res == null) {
        hasError = true;
      }

      setBusy(false);
    }).catchError((err) {
      log.e('getMemberProfile catch');

      setBusy(false);
    });

    await apiService.getShopCollection().then((res) async {
      if (res != null) {
        collections = res["_body"];
      } else if (res == null) {
        hasError = true;
      }

      setBusy(false);
    }).catchError((err) {
      log.e('getMemberProfile catch');

      setBusy(false);
    });
  }
}
