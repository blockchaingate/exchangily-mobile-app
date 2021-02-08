import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import '../../utils/exaddr.dart';
import './independent/title.dart';
import './independent/productCard.dart';
import './productDetail.dart';
import 'package:exchangilymobileapp/screen_state/shop/shopHome_state.dart';

class ShopHome extends StatelessWidget {
  const ShopHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    final NavigationService navigationService = locator<NavigationService>();
    // var widgetWidth = width - AppSizes.sidePadding * 2;

    return BaseScreen<ShopHomeState>(
        onModelReady: (model) async {
          model.context = context;
          await model.initState();
        },
        builder: (context, model, child) => Scaffold(
                // appBar: AppBar(
                //   title: Text('Title'),
                // ),
                body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      // margin: EdgeInsets.all(10),
                      height: width * 1.43,
                      width: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                "https://images.unsplash.com/photo-1577973460439-44606b9012e4?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80")),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(30),
                            // width: width / 2,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ECOMBAR',
                                      style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30)),
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      // Navigator.pop(context);
                                      navigationService
                                          .navigateUsingPushReplacementNamed(
                                              DashboardViewRoute);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 12, bottom: 12, top: 12),
                              width: 160,
                              child: MaterialButton(
                                color: Color(0xc40000),
                                child: Text('Details'),
                                minWidth: 160,
                                height: 48,
                                onPressed: () {},
                              ))
                        ],
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  TitleWidget("Category"),
                  // SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: model.category.length ,
                      itemBuilder: (BuildContext context, int index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            model.category.length > 1
                                ? model.category[index]["category"][model.lang]
                                : 'Category Name',
                            style: TextStyle(color: Color(0xffffffff)),
                          )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  for (var collection in model.collections)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleWidget(collection["name"]["en"]),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          // margin: EdgeInsets.only(top: 20),
                          height: 300,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: collection["products"].length,
                            itemBuilder: (BuildContext context, int index) =>
                                Card(
                                    child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return ProductDetail(
                                      product: collection["products"][index]);
                                }));
                              },
                              child: ProductCard(
                                img: collection["products"][index]["images"][0],
                                title: collection["products"][index]["title"]
                                    [model.lang],
                                price: collection["products"][index]["price"]
                                    .toString(),
                              ),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                ],
              ),
            )));
  }
}
