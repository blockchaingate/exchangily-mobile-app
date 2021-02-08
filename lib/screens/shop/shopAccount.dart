import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screen_state/shop/shopAccount_state.dart';
import 'independent/title.dart';

class ShopAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen<ShopAccountState>(
        onModelReady: (model) async {
          model.context = context;
          await model.initState();
        },
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text('Orders'),
            ),
            body: model.isLogin
                ? ListView(
                    padding: EdgeInsets.all(10),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xff111122),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              TitleWidget("Order#: AAA123456"),
                              SizedBox(
                                height: 20,
                              ),
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
                                            "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Product 001",
                                                  style: TextStyle(
                                                      color: Color(
                                                        0xffffffff,
                                                      ),
                                                      fontSize: 18),
                                                ),
                                                SizedBox(width: 100),
                                                Text(
                                                  '\$99.99',
                                                  style: TextStyle(
                                                      color: Colors.pinkAccent,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
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
                                height: 30,
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xff111122),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  TitleWidget("Order#: BBB222222"),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                            "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Product 001",
                                                  style: TextStyle(
                                                      color: Color(
                                                        0xffffffff,
                                                      ),
                                                      fontSize: 18),
                                                ),
                                                SizedBox(width: 100),
                                                Text(
                                                  '\$99.99',
                                                  style: TextStyle(
                                                      color: Colors.pinkAccent,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
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
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                            "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Product 001",
                                                  style: TextStyle(
                                                      color: Color(
                                                        0xffffffff,
                                                      ),
                                                      fontSize: 18),
                                                ),
                                                SizedBox(width: 100),
                                                Text(
                                                  '\$99.99',
                                                  style: TextStyle(
                                                      color: Colors.pinkAccent,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
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
                            ]),
                      )
                    ],
                  )
                : Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            child: Text(
                                // add here cupertino widget to check in these small widgets first then the entire app
                                "You haven't login!",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.headline3),
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              // Navigator.of(context).pop();
                              // Navigator.push(context, MaterialPageRoute(builder: (_) {
                              //   return ShopNav( pagenum:2);
                              // }));
                              Navigator.pushNamed(context, '/shopLogin');
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                height: 30,
                                width: 200,
                                color: Colors.pinkAccent,
                                child: Center(
                                    child: Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
  }
}
