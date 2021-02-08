import 'dart:convert';

class CartProduct {
  String productId;
  String title;
  double price;
  String merchantId;
  String currency;
  int quantity;
  String thumbnailUrl;

  CartProduct(
      {this.productId,
      this.title,
      this.price,
      this.merchantId,
      this.currency,
      this.quantity,
      this.thumbnailUrl});

  factory CartProduct.fromJson(Map<String, dynamic> jsonData) {
    return CartProduct(
      productId: jsonData['productId'],
      title: jsonData['title'],
      price: jsonData['price'],
      merchantId: jsonData['merchantId'],
      currency: jsonData['currency'],
      quantity: jsonData['quantity'],
      thumbnailUrl: jsonData['thumbnailUrl'],
    );
  }

  static Map<String, dynamic> toMap(CartProduct cp) => {
        'productId': cp.productId,
        'title': cp.title,
        'price': cp.price,
        'merchantId': cp.merchantId,
        'currency': cp.currency,
        'quantity': cp.quantity,
        'thumbnailUrl': cp.thumbnailUrl,
      };

  static String encode(List<CartProduct> cartProducts) => json.encode(
        cartProducts
            .map<Map<String, dynamic>>((cartProduct) => CartProduct.toMap(cartProduct))
            .toList(),
      );

  static List<CartProduct> decode(String cartProducts) =>
      (json.decode(cartProducts) as List<dynamic>)
          .map<CartProduct>((item) => CartProduct.fromJson(item))
          .toList();
  
}
