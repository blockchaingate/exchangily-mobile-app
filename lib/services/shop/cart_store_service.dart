import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;
import 'package:exchangilymobileapp/models/shop/cart_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartStoreService {
  final log = getLogger('CartStoreService');
  final client = new http.Client();

  SharedPreferences prefs;

  //getSavedItem
  getSavedItem() async {
    prefs = await SharedPreferences.getInstance();
    var tempdata = prefs.getString('savedProduct');
    List<CartProduct> items = List<CartProduct>();

    if (tempdata != "" && tempdata != null && tempdata.isNotEmpty) {
      print('has item in saved');
      items = CartProduct.decode(tempdata);

      print('items before added');
      log.w(CartProduct.encode(items).toString());
    } else {
      log.w('no item in saved');
    }

    return items;
  }

  //checkIsItemSaved
  checkIsItemSaved(CartProduct item) async {
    print("checkIsItemSaved");
    List<CartProduct> items = List<CartProduct>();

    bool existed = false;
    bool hasItems = false;

    prefs = await SharedPreferences.getInstance();
    var tempdata = prefs.getString('savedProduct');

    // item to be added
    print("checkIsItemSaved: item to be Saved");
    var w = CartProduct.toMap(item);
    log.w(w.toString());

    if (tempdata != "" && tempdata != null && tempdata.isNotEmpty) {
      print('has item in wishList');
      items = CartProduct.decode(tempdata);

      print('items before added to wishList');
      log.w(CartProduct.encode(items).toString());

      hasItems = true;
    } else {
      log.w('no item in WishList');
    }

    if (hasItems) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].productId == item.productId) {
          existed = true;
          log.w('existed=true');
        }
      }
    }

    return existed;
  }

  //addSavedItem
  addSavedItem(CartProduct item) async {
    print("addSavedItem");
    List<CartProduct> items = List<CartProduct>();

    bool existed = false;
    bool hasItems = false;

    prefs = await SharedPreferences.getInstance();
    var tempdata = prefs.getString('savedProduct');

    // item to be added
    print("cartProduct: item to be added");
    var w = CartProduct.toMap(item);
    log.w(w.toString());

    if (tempdata != "" && tempdata != null && tempdata.isNotEmpty) {
      print('has item in WishList');
      items = CartProduct.decode(tempdata);

      print('items before added to WishList');
      log.w(CartProduct.encode(items).toString());

      hasItems = true;
    } else {
      log.w('no item in WishList');
    }

    if (hasItems) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].productId == item.productId) {
          existed = true;
          log.w('existed=true');
        }
      }

      if (!existed) {
        log.w('not existed');
        items.add(item);
        log.w('after push', items);
      }
    } else {
      items.add(item);
    }

    prefs.setString('savedProduct', CartProduct.encode(items));
    log.w("savedProduct: Added product!");
  }

  removeSavedItem(CartProduct item) async {
    List<CartProduct> items = List<CartProduct>();

    bool existed = false;
    bool hasItems = false;

    prefs = await SharedPreferences.getInstance();
    var tempdata = prefs.getString('savedProduct');

    // item to be added
    print("removeSavedItem: item to be remove");
    var w = CartProduct.toMap(item);
    log.w(w.toString());

    if (tempdata != "" && tempdata != null && tempdata.isNotEmpty) {
      print('has item in wishlist');
      items = CartProduct.decode(tempdata);

      print('items before wishlist');
      log.w(CartProduct.encode(items).toString());

      hasItems = true;
    } else {
      log.w('no item in wishlist');
    }

    if (hasItems) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].productId == item.productId) {
          existed = true;
          log.w('existed=true');
          items.removeAt(i);
        }
      }
    }

    prefs.setString('savedProduct', CartProduct.encode(items));
    log.w("removeSavedItem: removed product!");
  }

  //getCartItem
  getCartItem() async {
    prefs = await SharedPreferences.getInstance();
    var tempdata = prefs.getString('cartProduct');
    List<CartProduct> items = List<CartProduct>();

    if (tempdata != "" && tempdata != null && tempdata.isNotEmpty) {
      print('has item in cart');
      items = CartProduct.decode(tempdata);

      print('items before added');
      log.w(CartProduct.encode(items).toString());
    } else {
      log.w('no item in cart');
    }

    return items;
  }

  //addCartItem
  addCartItem(CartProduct item) async {
    List<CartProduct> items = List<CartProduct>();

    bool existed = false;
    bool hasItems = false;

    // we assaign a new copy of todos by adding a new todo to it
    // with automatically assigned ID ( don't do this at home, use uuid() )
    prefs = await SharedPreferences.getInstance();
    var tempdata = prefs.getString('cartProduct');

    // item to be added
    print("cartProduct: item to be added");
    var w = CartProduct.toMap(item);
    log.w(w.toString());

    if (tempdata != "" && tempdata != null && tempdata.isNotEmpty) {
      print('has item in cart');
      items = CartProduct.decode(tempdata);

      print('items before added');
      log.w(CartProduct.encode(items).toString());

      hasItems = true;
    } else {
      log.w('no item in cart');
    }

    if (hasItems) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].productId == item.productId) {
          print('Check items info ');
          print('items[i].quantity ' + items[i].quantity.toString());
          print('item.quantity ' + item.quantity.toString());
          items[i].quantity = item.quantity + items[i].quantity;
          print('items[i].quantity2 ' + items[i].quantity.toString());
          // log.w('items in middle', items);
          existed = true;
          log.w('existed=true');
        }
      }

      if (!existed) {
        log.w('not existed');
        items.add(item);
        log.w('after push', items);
      }
    } else {
      items.add(item);
    }

    prefs.setString('cartProduct', CartProduct.encode(items));
    log.w("cartProduct: Added product!");
  }

  //reduce Cart Item Quantity
  reduceCartItemQuantity(item) async {
    List<CartProduct> items = List<CartProduct>();
    bool hasItems = false;

    prefs = await SharedPreferences.getInstance();
    var tempdata = prefs.getString('cartProduct');

    // item to be added
    print("cartProduct: item to be added");
    var w = CartProduct.toMap(item);
    log.w(w.toString());

    if (tempdata != "" && tempdata != null && tempdata.isNotEmpty) {
      print('has item in cart');
      items = CartProduct.decode(tempdata);

      print('items before added');
      log.w(CartProduct.encode(items).toString());

      hasItems = true;
    } else {
      log.w('no item in cart');
    }

    if (hasItems) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].productId == item.productId) {
          print('Check items info ');
          items[i].quantity = items[i].quantity - 1;
          print('items[i].quantity2 ' + items[i].quantity.toString());
          log.w('existed=true');
        }
      }
    }

    prefs.setString('cartProduct', CartProduct.encode(items));
    log.w("cartProduct: reduce Cart Item Quantity!");
  }

  //add Cart Item Quantity
  addCartItemQuantity(item) async {
    List<CartProduct> items = List<CartProduct>();
    bool hasItems = false;

    prefs = await SharedPreferences.getInstance();
    var tempdata = prefs.getString('cartProduct');

    // item to be added
    print("cartProduct: item to be added");
    var w = CartProduct.toMap(item);
    log.w(w.toString());

    if (tempdata != "" && tempdata != null && tempdata.isNotEmpty) {
      print('has item in cart');
      items = CartProduct.decode(tempdata);

      print('items before added');
      log.w(CartProduct.encode(items).toString());

      hasItems = true;
    } else {
      log.w('no item in cart');
    }

    if (hasItems) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].productId == item.productId) {
          print('Check items info ');
          items[i].quantity = items[i].quantity + 1;
          print('items[i].quantity2 ' + items[i].quantity.toString());
          log.w('existed=true');
        }
      }
    }

    prefs.setString('cartProduct', CartProduct.encode(items));
    log.w("cartProduct: reduce Cart Item Quantity!");
  }

  removeCartItem(item) async {
    List<CartProduct> items = List<CartProduct>();

    bool existed = false;
    bool hasItems = false;

    prefs = await SharedPreferences.getInstance();
    var tempdata = prefs.getString('cartProduct');

    // item to be added
    print("removeSavedItem: item to be remove");
    var w = CartProduct.toMap(item);
    log.w(w.toString());

    if (tempdata != "" && tempdata != null && tempdata.isNotEmpty) {
      print('has item in wishlist');
      items = CartProduct.decode(tempdata);

      print('items before wishlist');
      log.w(CartProduct.encode(items).toString());

      hasItems = true;
    } else {
      log.w('no item in wishlist');
    }

    if (hasItems) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].productId == item.productId) {
          existed = true;
          log.w('existed=true');
          items.removeAt(i);
        }
      }
    }

    prefs.setString('cartProduct', CartProduct.encode(items));
    log.w("removeSavedItem: removed product!");
  }
}
