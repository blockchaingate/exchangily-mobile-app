import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:intl/intl.dart';

class OrderState extends BaseState {
  final log = getLogger('OrderState');
  LocalStorageService localStorageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();
  PdfViewerService pdfViewerService = locator<PdfViewerService>();
  BuildContext context;

  ApiService apiService = locator<ApiService>();

  bool hasError = false;
  List orders = [];
  String lang = '';

  bool isLogin = false;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');

  // Init state
  initState() async {
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString('loginToken');

    if (loginToken != '' && loginToken != null) {
      log.w('login token $loginToken');
      isLogin = true;

      await apiService.getOrders(loginToken).then((res) async {
        if (res != null && res["_body"] != null) {
          // collections = res["_body"];
          orders = res["_body"];
        } else if (res == null) {
          hasError = true;
        }
      }).catchError((err) {
        log.e('getMemberProfile catch');
      });
    } else {
      log.w('login token missing!!!!');
      isLogin = false;
    }

    setBusy(false);
  }
}
