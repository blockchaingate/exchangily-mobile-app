import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screen_state/shop/productDetail_state.dart';
import 'package:exchangilymobileapp/screens/shop/productSelectOption.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({Key key, this.product}) : super(key: key);
  final product;
  @override
  Widget build(BuildContext context) {
    return BaseScreen<ProductDetailState>(
        onModelReady: (model) async {
          model.context = context;
          await model.initState(product);
        },
        builder: (context, model, child) => Scaffold(
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(10),
              color: Color(0xff333355),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Row(
                children: [
                  // Flexible(
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(5),
                  //       child: Container(
                  //   color: Colors.blueAccent,
                  //   height: double.infinity,
                  //   width: double.infinity,
                  //   child: Center(child: Text("Add To Cart",style: TextStyle(color: Color(0xffffffff)),)),
                  // ),
                  //     )),
                  Center(
                      child: IconButton(
                    icon: model.saved
                        ? Icon(
                            Icons.favorite,
                            color: Colors.pinkAccent,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                    onPressed: () {
                      model.updateSaveStatus();
                    },
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ProductSelectOption(product: product);
                      }));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Colors.deepPurple,
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                            child: Text(
                          "Add To Cart",
                          style: TextStyle(color: Color(0xffffffff)),
                        )),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            appBar: AppBar(
              title: Text('ECONBAR'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  /*Image.network(
              widget.productDetails.data.productVariants[0].productImages[0]),*/
                  Image.network(
                    product["images"][0],
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 20),
                    color: Color(0xFFFFFFFF),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(product["title"][model.lang].toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF565656))),
                        // Icon(
                        //   Icons.arrow_forward_ios,
                        //   color: Color(0xFF999999),
                        // )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 20),
                    color: Color(0xFFFFFFFF),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("SKU".toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF565656))),
                        Text("AAA123456",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFfd0100))),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF999999),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 20),
                    color: Color(0xFFFFFFFF),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Price".toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF565656))),
                        Text("\$ " + product["price"].toString(),
                            style: TextStyle(
                                color:
                                    //  Color(0xFFf67426)
                                    Color(0xFF0dc2cd),
                                // fontFamily: 'Roboto-Light.ttf',
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 20),
                    color: Color(0xFFFFFFFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Description",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF565656))),
                        SizedBox(
                          height: 15,
                        ),
                        Text(product["description"][model.lang],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF4c4c4c))),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 20),
                    color: Color(0xFFFFFFFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Specification",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF565656))),
                        SizedBox(
                          height: 15,
                        ),
                        Column(children: [
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Type',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF444444))),
                                Text("IPAD",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF212121))),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Brand',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF444444))),
                                Text("APPLE",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF212121))),
                              ],
                            ),
                          ),
                        ]

                            // generateProductSpecification(context),
                            )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  // List<Widget> generateProductSpecification(BuildContext context) {
  //   List<Widget> list = [];

  //   List info =[
  //     {"Type":"IPAD"},
  //     {"Brand":"APPLE"},
  //   ];
  //   int count = 0;
  //   info.forEach((specification) {
  //     Widget element = Container(
  //       height: 30,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Text(specification[0].key,
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w400,
  //                   color: Color(0xFF444444))),
  //           Text(specification[0].value,
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w400,
  //                   color: Color(0xFF212121))),
  //         ],
  //       ),
  //     );
  //     list.add(element);
  //     count++;
  //   });
  //   return list;
  // }
}
