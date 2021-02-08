import 'package:exchangilymobileapp/models/shop/cart_product.dart';
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

class WishListState extends BaseState {
  final log = getLogger('products[index]State');
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
  bool emptyList = true;
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

    // List<CartProduct> temp =
    //     await cartStoreService.getSavedItem() as List<CartProduct>;

    // if (temp != null && temp.isNotEmpty) {
    //   emptyList = false;
    //   products = temp;
    // }
    getSavedProduct();

    ready = true;
    setBusy(false);
  }

  //get wishlist
  getSavedProduct() async {
    List<CartProduct> temp =
        await cartStoreService.getSavedItem() as List<CartProduct>;

    if (temp != null && temp.isNotEmpty) {
      emptyList = false;
      products = temp;
    }

    (context as Element).markNeedsBuild();
  }

  //remove product from wishlist
  removeFromWishList(index) {
    if (products != null && products.length > 0) {
      cartStoreService.removeSavedItem(products[index]);
      products.removeAt(index);
      emptyList = products.length > 0 ? false : true;
      (context as Element).markNeedsBuild();
    }
  }

  //move product from wishlist to cart
  moveToCart(index) {
    if (products != null && products.length > 0) {
      cartStoreService.addCartItem(products[index]);
      cartStoreService.removeSavedItem(products[index]);
      products.removeAt(index);
      emptyList = products.length > 0 ? false : true;
      (context as Element).markNeedsBuild();
    }
  }
}
