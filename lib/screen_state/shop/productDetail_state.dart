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

class ProductDetailState extends BaseState {
  final log = getLogger('ProductDetailState');
  LocalStorageService localStorageService = locator<LocalStorageService>();
  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();
  PdfViewerService pdfViewerService = locator<PdfViewerService>();
  BuildContext context;

  ApiService apiService = locator<ApiService>();
  CartStoreService cartStoreService = locator<CartStoreService>();

  bool hasError = false;
  List collections = [];
  String lang = '';
  bool saved = false;

  var productDetail;

  // Init state
  initState(product) async {
    setBusy(true);
    log.e(busy);
    sharedService.context = context;

    productDetail = product;

    if (localStorageService.language == "en")
      lang = 'en';
    else if (localStorageService.language == "zh")
      lang = "sc";
    else if (lang == '')
      lang = 'en';
    else
      lang = 'en';

    print('lang $lang');

    //check if this product saved in wishlist
    checkSaveStatus();

    setBusy(false);
    // await apiService.getShopCollection().then((res) async {
    //   if (res != null) {
    //     collections = res["_body"];
    //   } else if (res == null) {
    //     hasError = true;
    //   }

    //   setBusy(false);
    // }).catchError((err) {
    //   log.e('getMemberProfile catch');

    //   setBusy(false);
    // });
  }

  //check if this product saved in wishlist
  checkSaveStatus() async {
    CartProduct productTemp = CartProduct(
        productId: productDetail["_id"],
        title: productDetail['title'][lang],
        price: (productDetail['price'] + .0),
        merchantId: productDetail['merchantId'],
        currency: productDetail['currency'],
        thumbnailUrl: productDetail["images"].isNotEmpty
            ? productDetail["images"][0]
            : "",
        quantity: 1);
    saved = await cartStoreService.checkIsItemSaved(productTemp);

    print("Saved: $saved");

    (context as Element).markNeedsBuild();
  }

  //reverse product save status in wishlist
  updateSaveStatus() {
    if (!saved) {
      addToWishList();
    } else {
      removeFromWishList();
    }

    saved = !saved;

    (context as Element).markNeedsBuild();
  }

  //add product to wishlist
  addToWishList() async {
    CartProduct productTemp = CartProduct(
        productId: productDetail["_id"],
        title: productDetail['title'][lang],
        price: (productDetail['price'] + .0),
        merchantId: productDetail['merchantId'],
        currency: productDetail['currency'],
        thumbnailUrl: productDetail["images"].isNotEmpty
            ? productDetail["images"][0]
            : "",
        quantity: 1);

    cartStoreService.addSavedItem(productTemp);

    (context as Element).markNeedsBuild();
  }

  //remove product from wishlist
  removeFromWishList() {
    CartProduct productTemp = CartProduct(
        productId: productDetail["_id"],
        title: productDetail['title'][lang],
        price: (productDetail['price'] + .0),
        merchantId: productDetail['merchantId'],
        currency: productDetail['currency'],
        thumbnailUrl: productDetail["images"].isNotEmpty
            ? productDetail["images"][0]
            : "",
        quantity: 1);

    cartStoreService.removeSavedItem(productTemp);

    (context as Element).markNeedsBuild();
  }
}
