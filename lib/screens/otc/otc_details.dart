import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc/otc_details_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/trade/place_order/textfield_text.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class OtcDetailsScreen extends StatelessWidget {
  const OtcDetailsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<OtcDetailsScreenState>(
      onModelReady: (model) {},
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            title: Text('OTC ${AppLocalizations.of(context).details}'),
            backgroundColor: globals.secondaryColor),
        body: Container(
            padding: EdgeInsets.all(5.0),
            // Main column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 4,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    color: globals.walletCardColor,
                    // height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Merchant Info',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        // Name
                        Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Name: ',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Text(
                                'Paul Liu',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ])),
                        // Volume
                        Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Volume/30d: ',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Text(
                                '100 30d completed',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ])),
                        // Completed Rate
                        Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Completed Rate: ',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Text(
                                '84%',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ])),
                        // Average coin deliver time
                        Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Average Coin Deliver Time: ',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Text(
                                '2.002 min',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ])),
                        // Registration time
                        Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Registration Time: ',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Text(
                                '19-02-19 01:43:15',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ])),
                      ],
                    ),
                  ),
                ),
                UIHelper.horizontalSpaceSmall,
                Card(
                  elevation: 4,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    color: globals.walletCardColor,
                    // height: 110,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Order Info',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          // Coin and Quantity row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Coin container
                              Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      'Coin: ',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Text(
                                      'USDT',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ])),
                              // Quantity
                              Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      'Quantity: ',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Text(
                                      '44457843.1124',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ])),
                            ],
                          ),
                          // Limits and Price Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Limits
                              Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      'Limits: ',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Text(
                                      '70000.0--48434.111',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ])),
                              // Price
                              Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      'Price: ',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Text(
                                      '70.1421',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ])),
                            ],
                          ),
                        ]),
                  ),
                ),
                UIHelper.horizontalSpaceSmall,
                // Last input quantity amount and confirm button container
                Card(
                  color: globals.walletCardColor,
                  elevation: 4,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    child: Column(
                      children: <Widget>[
                        // Quantity container row
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    //  width: 50,
                                    child: Text(AppLocalizations.of(context).quantity,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5)),
                                Container(
                                  width: 150,
                                  child: TextField(
                                      controller: model.quantityTextController,
                                      onChanged: (String quantity) {
                                        model.quantity = double.parse(quantity);
                                      },
                                      keyboardType: TextInputType
                                          .number, // numnber keyboard
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.elliptical(2, 2))),
                                          filled: true,
                                          fillColor: globals.grey.withAlpha(75),
                                          isDense: true,
                                          focusedBorder: UnderlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.elliptical(2, 2)),
                                              borderSide: BorderSide(
                                                  color: globals.primaryColor,
                                                  width: 2)),
                                          hintText: '0.00',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                ),
                              ]),
                        ),

                        UIHelper.horizontalSpaceSmall,
                        // Amount container row
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    //  width: 50,
                                    child: Text(AppLocalizations.of(context).amount,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5)),
                                Container(
                                  width: 150,
                                  child: TextField(
                                      controller: model.amountTextController,
                                      onChanged: (String amount) {
                                        model.amount = double.parse(amount);
                                      },
                                      keyboardType: TextInputType
                                          .number, // numnber keyboard
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.elliptical(2, 2))),
                                          filled: true,
                                          fillColor:
                                              globals.grey.withAlpha(105),
                                          isDense: true,
                                          focusedBorder: UnderlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.elliptical(2, 2)),
                                              borderSide: BorderSide(
                                                  color: globals.primaryColor,
                                                  width: 2)),
                                          hintText: '0.00',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                ),
                              ]),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        // Cancel and confirm button container row
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 100, // Providing width to button
                                  margin: EdgeInsets.only(right: 5.0),
                                  child: Theme.of(context).platform ==
                                          TargetPlatform.iOS
                                      ? Center(
                                          child: CupertinoButton(
                                              padding: EdgeInsets.all(5.0),
                                              color:
                                                  globals.grey.withAlpha(105),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .cancel,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5),
                                              onPressed: () {}),
                                        )
                                      : Center(
                                          child: RaisedButton(
                                            padding: EdgeInsets.all(5.0),
                                            color: globals.grey.withAlpha(105),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .cancel,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                            onPressed: () {},
                                          ),
                                        )),
                              Container(
                                  width: 100, // Providing width to button
                                  child: Theme.of(context).platform ==
                                          TargetPlatform.iOS
                                      ? Center(
                                          child: CupertinoButton(
                                              color: globals.primaryColor,
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .confirm,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5),
                                              onPressed: () {}),
                                        )
                                      : Center(
                                          child: RaisedButton(
                                            padding: EdgeInsets.all(5.0),
                                            color: globals.primaryColor,
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .confirm,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                            onPressed: () {},
                                          ),
                                        )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
