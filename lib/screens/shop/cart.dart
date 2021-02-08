import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'checkout.dart';
import 'package:exchangilymobileapp/screen_state/shop/cart_state.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen<CartState>(
        onModelReady: (model) async {
          model.context = context;
          await model.initState();
        },
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text('My Cart'),
              ),
              body: ListView(
                children: [
                  model.emptyCart
                      ? Container(
                          child: Center(child: Text("No Item In Cart")),
                        )
                      : Container(
                          padding: EdgeInsets.all(10),
                          child: model.ready
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: model.products.length,
                                  itemBuilder: (context, index) {
                                    var product = model.products[index];
                                    return Card(
                                        child: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: CacheImage(
                                              product.thumbnailUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Container(
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.title,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Color(
                                                        0xffffffff,
                                                      ),
                                                      fontSize: 18),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '\$' + product.price.toString(),
                                                  style: TextStyle(
                                                      color: Colors.pinkAccent,
                                                      fontSize: 18),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: <Widget>[
                                                        InkWell(
                                                          onTap: () {
                                                            model.reduce(index);
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40),
                                                                color:
                                                                    Colors.white),
                                                            child: Icon(
                                                                Icons.remove),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 30,
                                                          child: Center(
                                                            child: Text(
                                                              product.quantity
                                                                  .toString(),
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
                                                            model.add(index);
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40),
                                                                color:
                                                                    Colors.white),
                                                            child:
                                                                Icon(Icons.add),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        model.removeFromCart(index);
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors
                                                                .pinkAccent),
                                                        height: 22,
                                                        width: 110,
                                                        // width: MediaQuery.of(context).size.width - 120,
                                                        child: Center(
                                                          child: Text(
                                                            "Remove",
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                color: Color(
                                                                  0xffffffff,
                                                                ),
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ));
                                  },
                                )
                              : Container()),
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
                        // Navigator.push(context, MaterialPageRoute(builder: (_) {
                        //   return Checkout();
                        // }));
                        model.checkout();
                      },
                      color: Colors.pinkAccent,
                      child: Text("CHECK OUT"),
                    ),
                  )
                ],
              ),
            ));
  }
}

Iterable<E> mapIndexed<E, T>(
    Iterable<T> items, E Function(int index, T item) f) sync* {
  var index = 0;

  for (final item in items) {
    yield f(index, item);
    index = index + 1;
  }
}
