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

class CheckoutState extends BaseState {
  final log = getLogger('CheckoutState');
  LocalStorageService localStorageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();
  PdfViewerService pdfViewerService = locator<PdfViewerService>();
  BuildContext context;

  ApiService apiService = locator<ApiService>();

  bool hasError = false;
  Map address = {};
  String addressId = "";
  String lang = '';

  bool isLogin = false;
  bool addressReady = false;
  bool orderReady = false;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');

  String orderId = "";

  Map orderDetail = {};

  double subTotal = 0;
  double totalPrice = 0;
  double tax = 0;

  List shippingMethod = [
    {
      "name": "Express delivery",
      "Price": "10",
      "select": true,
    },
    {
      "name": "Standard delivery",
      "Price": "0",
      "select": false,
    },
    {
      "name": "Pickup from store",
      "Price": "0",
      "select": false,
    }
  ];

  List paymentOption = [
    {
      "name": "Credit card",
      "select": true,
    },
    {
      "name": "Paypal",
      "select": false,
    },
    {
      "name": "USDT",
      "select": false,
    }
  ];

  // Init state
  initState(id) async {
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

    orderId = id;

    log.w("orderId: " + orderId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString('loginToken');

    //check if user login or not
    if (loginToken != '' && loginToken != null) {
      log.w('login token $loginToken');
      isLogin = true;

      // get address id
      await apiService.getShopMe(loginToken).then((res) async {
        if (res != null && res["_body"] != null) {
          addressId = res["_body"]["homeAddressId"];

          //get address info
          await apiService
              .getShopAddress(addressId, loginToken)
              .then((res) async {
            if (res != null && res["_body"] != null) {
              address = res["_body"];
              addressReady = true;
            } else if (res == null) {
              hasError = true;
              addressReady = true;
            }
          }).catchError((err) {
            log.e('getShopAddress catch');
            addressReady = true;
          });
          //get address info end

        } else if (res == null) {
          hasError = true;
        }
        // get address id end
      }).catchError((err) {
        log.e('getShopMe catch');
      });

      //get order detail info
      await apiService.getSingleOrder(orderId, loginToken).then((res) async {
        if (res != null && res["_body"] != null) {
          orderDetail = res["_body"];
          getTotalPrice();
        } else if (res == null) {
          hasError = true;
        }
        orderReady = true;
      }).catchError((err) {
        log.e('getSingleOrder catch'+ err.toString());
        orderReady = true;
      });
      //get order detail info end

    } else {
      log.w('login token missing!!!!');
      isLogin = false;
    }

    setBusy(false);
  }

  getTotalPrice() {
    subTotal = 0.0;

    orderDetail["items"].forEach((product) {
      subTotal = subTotal + (product['price'] + .0) * product['quantity'];
    });

    print('subTotal $subTotal');

    totalPrice = subTotal + (tax + .0);
    print('totalPrice $totalPrice');
    (context as Element).markNeedsBuild();
  }

  selectShippingMethod(index) {
    shippingMethod.asMap().forEach((i, value) =>
        i == index ? value["select"] = true : value["select"] = false);

    (context as Element).markNeedsBuild();
  }

  selectPaymentMethod(index) {
    paymentOption.asMap().forEach((i, value) =>
        i == index ? value["select"] = true : value["select"] = false);

    (context as Element).markNeedsBuild();
  }
}
