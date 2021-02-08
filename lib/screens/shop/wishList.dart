import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screen_state/shop/wishList_state.dart';

class WishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen<WishListState>(
        onModelReady: (model) async {
          model.context = context;
          await model.initState();
        },
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text('Wish List'),
            ),
            body: model.emptyList
                ? Container(
                    child: Center(child: Text("No Item In WishList")),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: model.products.length,
                    itemBuilder: (context, index) {
                      var product = model.products[index];
                      return model.ready
                          ? Container(
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
                                        padding: EdgeInsets.only(top: 5),
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
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
                                            Container(
                                              // color: Colors.yellow,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      model.moveToCart(index);
                                                    },
                                                    child: Container(
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
                                                          "Add To Cart",
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
                                                  InkWell(
                                                    onTap: () {
                                                      model.removeFromWishList(
                                                          index);
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
                            )
                          : Container();
                    })));
  }
}
