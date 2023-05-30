import 'package:exchangilymobileapp/screen_state/otc/otc_details_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import '../../shared/globals.dart' as globals;

class OtcDetailsScreen extends StatelessWidget {
  const OtcDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<OtcDetailsScreenState>(
      onModelReady: (model) {},
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            title: Text('OTC ${FlutterI18n.translate(context, "details")}'),
            backgroundColor: Theme.of(context).canvasColor),
        body: Container(
            padding: const EdgeInsets.all(5.0),
            // Main column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 5.0),
                    color: Theme.of(context).cardColor,
                    // height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Merchant Info',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        // Name
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Name: ',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                'Paul Liu',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ])),
                        // Volume
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Volume/30d: ',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                '100 30d completed',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ])),
                        // Completed Rate
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Completed Rate: ',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                '84%',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ])),
                        // Average coin deliver time
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Average Coin Deliver Time: ',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                '2.002 min',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ])),
                        // Registration time
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Registration Time: ',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                '19-02-19 01:43:15',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 5.0),
                    color: Theme.of(context).cardColor,
                    // height: 110,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Order Info',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          // Coin and Quantity row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Coin container
                              Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      'Coin: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Text(
                                      'USDT',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ])),
                              // Quantity
                              Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      'Quantity: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Text(
                                      '44457843.1124',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
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
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      'Limits: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Text(
                                      '70000.0--48434.111',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ])),
                              // Price
                              Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      'Price: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Text(
                                      '70.1421',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
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
                  color: Theme.of(context).cardColor,
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 5.0),
                    child: Column(
                      children: <Widget>[
                        // Quantity container row
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(FlutterI18n.translate(context, "quantity"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              SizedBox(
                                width: 150,
                                child: TextField(
                                    controller: model.quantityTextController,
                                    onChanged: (String quantity) {
                                      model.quantity = double.parse(quantity);
                                    },
                                    keyboardType: TextInputType
                                        .number, // numnber keyboard
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10.0),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.elliptical(2, 2))),
                                        filled: true,
                                        fillColor: globals.grey.withAlpha(75),
                                        isDense: true,
                                        focusedBorder: UnderlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.elliptical(2, 2)),
                                            borderSide: BorderSide(
                                                color: globals.primaryColor,
                                                width: 2)),
                                        hintText: '0.00',
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .headlineSmall),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                              ),
                            ]),

                        UIHelper.horizontalSpaceSmall,
                        // Amount container row
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(FlutterI18n.translate(context, "amount"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              SizedBox(
                                width: 150,
                                child: TextField(
                                    controller: model.amountTextController,
                                    onChanged: (String amount) {
                                      model.amount = double.parse(amount);
                                    },
                                    keyboardType: TextInputType
                                        .number, // numnber keyboard
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10.0),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.elliptical(2, 2))),
                                        filled: true,
                                        fillColor: globals.grey.withAlpha(105),
                                        isDense: true,
                                        focusedBorder: UnderlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.elliptical(2, 2)),
                                            borderSide: BorderSide(
                                                color: globals.primaryColor,
                                                width: 2)),
                                        hintText: '0.00',
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .headlineSmall),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                              ),
                            ]),
                        UIHelper.horizontalSpaceSmall,
                        // Cancel and confirm button container row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 100, // Providing width to button
                                margin: const EdgeInsets.only(right: 5.0),
                                child: Theme.of(context).platform ==
                                        TargetPlatform.iOS
                                    ? Center(
                                        child: CupertinoButton(
                                            padding: const EdgeInsets.all(5.0),
                                            color: globals.grey.withAlpha(105),
                                            child: Text(
                                                FlutterI18n.translate(
                                                    context, "cancel"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall),
                                            onPressed: () {}),
                                      )
                                    : Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(5.0),
                                            backgroundColor:
                                                globals.grey.withAlpha(105),
                                          ),
                                          child: Text(
                                            FlutterI18n.translate(
                                                context, "cancel"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                          onPressed: () {},
                                        ),
                                      )),
                            SizedBox(
                                width: 100, // Providing width to button
                                child: Theme.of(context).platform ==
                                        TargetPlatform.iOS
                                    ? Center(
                                        child: CupertinoButton(
                                            color: globals.primaryColor,
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                                FlutterI18n.translate(
                                                    context, "confirm"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall),
                                            onPressed: () {}),
                                      )
                                    : Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(5.0),
                                            backgroundColor:
                                                globals.primaryColor,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            FlutterI18n.translate(
                                                context, "confirm"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ),
                                      )),
                          ],
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
