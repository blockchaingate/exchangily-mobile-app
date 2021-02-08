import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screen_state/shop/checkout_state.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'address.dart';
import 'package:flutter/material.dart';
import './independent/title.dart';
import './afterOrder.dart';

class Checkout extends StatelessWidget {
  Checkout({this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return BaseScreen<CheckoutState>(
        onModelReady: (model) async {
          model.context = context;
          await model.initState(id);
        },
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text('Checkout'),
            ),
            body: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    TitleWidget("Shipping Address"),
                    SizedBox(
                      height: 20,
                    ),

                    //address area
                    model.addressReady
                        ? Container(
                            padding: EdgeInsets.all(5),
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          model.address["name"],
                                          style: TextStyle(
                                              color: Color(
                                                0xffcccccc,
                                              ),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return Address(
                                                  address: model.address);
                                            }));
                                          },
                                          child: Text(
                                            "Change",
                                            style: TextStyle(
                                                color: Colors.pinkAccent,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Text(
                                    //   "123 Street Ave, Toronto Ca. m1m1m1",
                                    //   style: TextStyle(
                                    //       color: Color(
                                    //         0xffcccccc,
                                    //       ),
                                    //       fontSize: 15),
                                    // ),
                                    Column(
                                        children:
                                            model.address.entries.map((a) {
                                      if (a.key == "_id" ||
                                          a.key == "name" ||
                                          a.key == "__v") return Container();
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            a.key + ": ",
                                            style: TextStyle(
                                                color: Color(
                                                  0xffcccccc,
                                                ),
                                                fontSize: 15),
                                          ),
                                          Text(
                                            a.value.toString(),
                                            style: TextStyle(
                                                color: Color(
                                                  0xffcccccc,
                                                ),
                                                fontSize: 15),
                                          )
                                        ],
                                      );
                                    }).toList())
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 30,
                    ),
                    TitleWidget("Shipping Method"),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 58,
                        padding: EdgeInsets.all(5),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: model.shippingMethod.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  model.selectShippingMethod(index);
                                },
                                child: Card(
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                        child: Text(
                                          model.shippingMethod[index]["name"],
                                          style: TextStyle(
                                              color: model.shippingMethod[index]
                                                      ["select"]
                                                  ? Colors.pinkAccent
                                                  : Color(
                                                      0xffcccccc,
                                                    ),
                                              fontSize: 15),
                                        ),
                                      )),
                                ),
                              );
                            })),
                    SizedBox(
                      height: 20,
                    ),
                    TitleWidget("Payment"),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 58,
                        padding: EdgeInsets.all(5),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: model.paymentOption.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  model.selectPaymentMethod(index);
                                },
                                child: Card(
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                        child: Text(
                                          model.paymentOption[index]["name"],
                                          style: TextStyle(
                                              color: model.paymentOption[index]
                                                      ["select"]
                                                  ? Colors.pinkAccent
                                                  : Color(
                                                      0xffcccccc,
                                                    ),
                                              fontSize: 15),
                                        ),
                                      )),
                                ),
                              );
                            })),
                    SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   padding: EdgeInsets.all(5),
                    //   child: Card(
                    //     child: Container(
                    //       padding: EdgeInsets.all(10),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Text(
                    //                 "Visa: 1234 **** 1234",
                    //                 style: TextStyle(
                    //                     color: Color(
                    //                       0xffcccccc,
                    //                     ),
                    //                     fontSize: 15),
                    //               ),
                    //               Text(
                    //                 "Change",
                    //                 style: TextStyle(
                    //                     color: Colors.pinkAccent, fontSize: 15),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    TitleWidget("Your Order"),
                    SizedBox(
                      height: 20,
                    ),
                    model.orderReady
                        ? Container(
                            // margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              // color: Color(0xff111122),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SizedBox(
                                  //   height: 30,
                                  // ),
                                  // Container(
                                  //   padding: EdgeInsets.all(10),
                                  //   child: Text(
                                  //     model.f.format(DateTime.parse(
                                  //         model.orderDetail["dateCreated"])),
                                  //     style: TextStyle(
                                  //         color: Colors.pinkAccent,
                                  //         fontSize: 14),
                                  //   ),
                                  // ),
                                  // TitleWidget(
                                  //     "Order#: " + model.orderDetail["_id"]),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  for (var products
                                      in model.orderDetail["items"])
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
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: CacheImage(
                                                  products["thumbnailUrl"],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                // height: 100,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      products["title"],
                                                      style: TextStyle(
                                                          color: Color(
                                                            0xffffffff,
                                                          ),
                                                          fontSize: 18),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          products["currency"] +
                                                              ": \$ " +
                                                              products["price"]
                                                                  .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .pinkAccent,
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Qty: " +
                                                          products["quantity"]
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  // SizedBox(
                                  //   height: 30,
                                  // ),
                                ]),
                          )
                        : Container(),

                    //price area
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
                              "\$" + model.subTotal.toString(),
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
                              "\$ " + model.tax.toString(),
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
                              "\$ " + model.totalPrice.toString(),
                              style: TextStyle(
                                  color: Color(
                                    0xffffffff,
                                  ),
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return AfterOrder();
                              }));
                            },
                            color: Colors.pinkAccent,
                            child: Text("Place Order"),
                          ),
                        )
                      ]),
                    ),
                  ],
                )
              ],
            )));
  }
}
