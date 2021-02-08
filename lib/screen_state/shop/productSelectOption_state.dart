import 'package:exchangilymobileapp/services/shop/cart_store_service.dart';
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
import 'dart:convert';
import 'package:exchangilymobileapp/models/shop/cart_product.dart';

class ProductSelectOptionState extends BaseState {
  final log = getLogger('ProductDetailState');
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
  int quantity = 1;
  final jsonEncoder = JsonEncoder();
  dynamic productInfo;

  CartProduct cartProduct = new CartProduct();

  // Init state
  initState(product) async {
    setBusy(true);

    productInfo = product;
    log.e(busy);
    sharedService.context = context;

    //get current lang
    if (localStorageService.language == "en")
      lang = 'en';
    else if (localStorageService.language == "zh")
      lang = "sc";
    else if (lang == '')
      lang = 'en';
    else
      lang = 'en';

    print('lang $lang');

    // print product name
    print('product: ');
    print(jsonEncoder.convert(product['title']));

    //get total price
    getTotalPrice();

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

  getTotalPrice() {
    print('quantity $quantity');

    subTotal = (productInfo["price"] + .0) * quantity;

    print('subTotal $subTotal');

    totalPrice = subTotal + (tax + .0);
    print('totalPrice $totalPrice');
  }

  //add quantity
  add() {
    quantity++;
    print("quantity: $quantity");

    getTotalPrice();
    (context as Element).markNeedsBuild();
  }

  //reduce quantity
  reduce() {
    if (quantity > 1) {
      quantity--;
      getTotalPrice();
    }

    print("quantity: $quantity");
    (context as Element).markNeedsBuild();
  }

  addToCart() {
    if (quantity < 1) {
      return;
    }

    cartProduct = CartProduct(
        productId: productInfo["_id"],
        title: productInfo['title'][lang],
        price: (productInfo['price'] + .0),
        merchantId: productInfo['merchantId'],
        currency: productInfo['currency'],
        thumbnailUrl:
            productInfo["images"].isNotEmpty ? productInfo["images"][0] : "",
        quantity: quantity);

    print("cartProduct title : ");
    log.w(cartProduct.title);
    // print("cartProduct: ");
    var w = CartProduct.toMap(cartProduct);
    log.w(w.toString());

    cartStoreService.addCartItem(cartProduct);
    showDialog();
  }

  showDialog(){
    sharedService.shopAlertDialog("Cart Message","Successfully added to cart!");
  }
}
