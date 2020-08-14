import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc/otc_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class OtcScreen extends StatelessWidget {
  const OtcScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<OtcScreenState>(
      onModelReady: (model) {},
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            title: Text('OTC'),
            backgroundColor: globals.secondaryColor),
        body: Container(
            padding: EdgeInsets.all(5.0),
            // Main column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  child: Text('KYC'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/kycView');
                  },
                ),
                // Use inkwell to make the card tap and perform something
                InkWell(
                    splashColor: globals.primaryColor,
                    child: Card(
                      elevation: 4,
                      child: Container(
                        color: globals.walletCardColor,
                        height: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Image.asset(
                                'assets/images/otc/face.png',
                                width: 70,
                                height: 70,
                                // color: globals
                                //     .iconBackgroundColor, // image background color
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Fixec Merchant data
                            Container(
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Merchant:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: globals.grey,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Divider(
                                    color: globals.primaryColor,
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Quantity:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: globals.grey,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Price:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: globals.grey,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Limits:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: globals.grey,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Payment:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: globals.grey,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            // Dynamic Merchant data
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Paul Liu',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Divider(
                                    color: globals.primaryColor,
                                    thickness: 2,
                                  ),
                                  Text(
                                    '711241.124',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Text(
                                    '14.2145',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  // Limit amount
                                  Text(
                                    '21000--3212154',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(color: globals.grey),
                                  ),
                                  // Payment icons
                                  Container(
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        IconButton(
                                            visualDensity:
                                                VisualDensity.comfortable,
                                            padding: EdgeInsets.all(0),
                                            iconSize: 16,
                                            icon: Icon(
                                              Icons.credit_card,
                                              color: globals.red,
                                            ),
                                            onPressed: () {}),
                                        IconButton(
                                            padding: EdgeInsets.all(0),
                                            icon: Icon(
                                              Icons.card_giftcard,
                                              color: globals.red,
                                              size: 16,
                                            ),
                                            onPressed: () {})
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Last stars and buy button container
                            Container(
                                // width: 125,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start, // Element stars and buy button position starting from the top

                                    children: <Widget>[
                                      // First column element is merchant rating
                                      Container(
                                        height: 25, // to align with name row
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.star,
                                                color: globals.white, size: 16),
                                            Icon(Icons.star,
                                                color: globals.white, size: 16),
                                            Icon(Icons.star,
                                                color: globals.white, size: 16),
                                            Icon(Icons.star,
                                                color: globals.white, size: 16),
                                            Icon(Icons.star_border,
                                                color: globals.white, size: 16),
                                          ],
                                        ),
                                      ),

                                      // Second column element is buy button
                                      Container(
                                          width: 84,
                                          height: 64,
                                          child: Theme.of(context).platform ==
                                                  TargetPlatform.iOS
                                              ? Center(
                                                  child: CupertinoButton(
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .buy,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline5),
                                                      onPressed: () {}),
                                                )
                                              : Center(
                                                  child: RaisedButton(
                                                    color: globals.buyPrice,
                                                    child: Text(
                                                      'Buy',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                )),
                                    ]))
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/otcDetails');
                    })
              ],
            )),
        bottomNavigationBar: BottomNavBar(count: 2),
      ),
    );
  }
}
