import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screen_state/shop/order_state.dart';
import 'independent/title.dart';

class Orders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen<OrderState>(
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
                      for (var order in model.orders)
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
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
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    model.f.format(
                                        DateTime.parse(order["dateCreated"])),
                                    style: TextStyle(
                                        color: Colors.pinkAccent,
                                        fontSize: 14),
                                  ),
                                ),
                                TitleWidget("Order#: " + order["_id"]),
                                SizedBox(
                                  height: 20,
                                ),
                                for (var products in order["items"])
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
                                              padding: EdgeInsets.symmetric(horizontal: 10),
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
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                       products["currency"]+ ": \$ " + products["price"].toString(),
                                                        style: TextStyle(
                                                            color: Colors.pinkAccent,
                                                            fontSize: 14),
                                                      ),

                                                      
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                        "Qty: " + products["quantity"].toString(),
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
                                SizedBox(
                                  height: 30,
                                ),
                              ]),
                        ),
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
