import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'checkout.dart';
import 'package:exchangilymobileapp/screen_state/shop/productSelectOption_state.dart';

class ProductSelectOption extends StatelessWidget {
  ProductSelectOption({Key key, this.product}) : super(key: key);
  final product;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<ProductSelectOptionState>(
        onModelReady: (model) async {
          model.context = context;
          await model.initState(product);
        },
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text('Product Option'),
              ),
              body: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CacheImage(
                                product["images"][0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product["title"][model.lang].toUpperCase(),
                                  style: TextStyle(
                                      color: Color(
                                        0xffffffff,
                                      ),
                                      fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  product["price"].toString(),
                                  style: TextStyle(
                                      color: Colors.pinkAccent, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        model.reduce();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: Colors.white),
                                        child: Icon(Icons.remove),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                      child: Center(
                                        child: Text(
                                          model.quantity.toString(),
                                          style: TextStyle(
                                              color: Color(
                                                0xffffffff,
                                              ),
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        model.add();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: Colors.white),
                                        child: Icon(Icons.add),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    color: Color(0x33000000),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal: ",
                            style: TextStyle(
                                color: Color(
                                  0xffcccccc,
                                ),
                                fontSize: 15),
                          ),
                          Text(
                            "\$ " + model.subTotal.toStringAsFixed(2),
                            style: TextStyle(
                                color: Color(
                                  0xffffffff,
                                ),
                                fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tax: ",
                            style: TextStyle(
                                color: Color(
                                  0xffcccccc,
                                ),
                                fontSize: 15),
                          ),
                          Text(
                            "\$ " + model.tax.toStringAsFixed(2),
                            style: TextStyle(
                                color: Color(
                                  0xffffffff,
                                ),
                                fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total: ",
                            style: TextStyle(
                                color: Color(
                                  0xffcccccc,
                                ),
                                fontSize: 15),
                          ),
                          Text(
                            "\$ " + model.totalPrice.toStringAsFixed(2),
                            style: TextStyle(
                                color: Color(
                                  0xffffffff,
                                ),
                                fontSize: 15),
                          ),
                        ],
                      )
                    ]),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        model.addToCart();
                        // showDialog(
                        //     context: context,
                        //     barrierDismissible: false,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         title: Center(child: Text('Alert')),
                        //         content: Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: <Widget>[
                        //             Container(
                        //               child: Text(
                        //                 "Added to cart!",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                   color: Colors.red,
                        //                 ),
                        //               ),
                        //             ),
                        //             Container(
                        //               // height: 100,
                        //               child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children: <Widget>[
                        //                     Container(
                        //                       height: 50,
                        //                       width: 100,
                        //                       child: FlatButton(
                        //                           child: Text('Yes'),
                        //                           onPressed: () {
                        //                             Navigator.of(context).pop();
                        //                           }),
                        //                     ),
                        //                   ]),
                        //             )
                        //           ],
                        //         ),
                        //       );
                        //     });
                      },
                      color: Colors.pinkAccent,
                      child: Text("ADD TO CART"),
                    ),
                  )
                ],
              ),
            ));
  }
}
