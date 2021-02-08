import 'package:exchangilymobileapp/models/shop/cart_product.dart';
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
import 'package:exchangilymobileapp/services/shop/cart_store_service.dart';

class CartState extends BaseState {
  final log = getLogger('CartState');
  LocalStorageService localStorageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();
  PdfViewerService pdfViewerService = locator<PdfViewerService>();
  CartStoreService cartStoreService = locator<CartStoreService>();

  BuildContext context;

  ApiService apiService = locator<ApiService>();

  bool hasError = false;
  List collections = [];
  String lang = '';

  double subTotal = 0;
  double totalPrice = 0;
  double tax = 0;

  List<CartProduct> products = List<CartProduct>();
  bool emptyCart = true;
  bool ready = false;

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

    List<CartProduct> temp =
        await cartStoreService.getCartItem() as List<CartProduct>;

    if (temp != null && temp.isNotEmpty) {
      emptyCart = false;
      products = temp;
    }

    getTotalPrice();

    ready = true;
    setBusy(false);
  }

  getTotalPrice() {
    subTotal = 0.0;

    products.forEach((product) {
      subTotal = subTotal + (product.price + .0) * product.quantity;
    });

    print('subTotal $subTotal');

    totalPrice = subTotal + (tax + .0);
    print('totalPrice $totalPrice');
  }

  add(int index) async {
    cartStoreService.addCartItemQuantity(products[index]);
    List<CartProduct> temp =
        await cartStoreService.getCartItem() as List<CartProduct>;

    if (temp != null && temp.isNotEmpty) {
      emptyCart = false;
      products = temp;
    }

    getTotalPrice();
    (context as Element).markNeedsBuild();
  }

  reduce(int index) async {
    if (products[index].quantity > 1) {
      cartStoreService.reduceCartItemQuantity(products[index]);
      List<CartProduct> temp =
          await cartStoreService.getCartItem() as List<CartProduct>;

      if (temp != null && temp.isNotEmpty) {
        emptyCart = false;
        products = temp;
      }

      getTotalPrice();
      (context as Element).markNeedsBuild();
    }
  }

  removeFromCart(index) {
    if (products != null && products.length > 0) {
      cartStoreService.removeCartItem(products[index]);
      products.removeAt(index);
      emptyCart = products.length > 0 ? false : true;
      (context as Element).markNeedsBuild();
    }
  }

  checkout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString('loginToken');

    if (loginToken != '' && loginToken != null) {
      log.w('login token $loginToken');
      // isLogin = true;
      var merchantId = '';
      var currency = '';
      double transAmount = 0.0;

      List itemJson = [];

      products.forEach((item) {
        print('item=');
        itemJson.add(CartProduct.toMap(item));
        log.w(CartProduct.toMap(item).toString());

        merchantId = item.merchantId;
        currency = item.currency;
        transAmount += item.quantity * (item.price + .0);
        // titleTran = this.translateServ.transField(item.title);
        // item.title = item.title;

        // orderItems.add(item);
      });
      var orderData = {
        "merchantId": merchantId,
        "items": itemJson,
        "currency": currency,
        "transAmount": transAmount,
        "appId": "5f80c3b09577e8dc2f8db596"
      };

      print("orderData:");
      log.w(orderData.toString());

      await apiService.postCreateOrder(orderData, loginToken).then((res) async {
        if (res != {} && res != ["error"] && res["ok"] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('cartProduct');
          Navigator.pushNamed(context, '/checkout', arguments: res["_body"]["_id"]);
        }
      }).catchError((err) {
        log.e('getMemberProfile catch');

      });
    } else {
      log.w('login token missing!!!!');
      Navigator.pushNamed(context, '/shopLogin');
    }
  }
}
