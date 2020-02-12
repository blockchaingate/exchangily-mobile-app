/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com, barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/buy_sell_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import "package:flutter/material.dart";
import "./textfield_text.dart";
import "./order_detail.dart";
import "./my_orders.dart";
import 'package:flutter/foundation.dart';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;
import 'package:exchangilymobileapp/localizations.dart';

class BuySell extends StatelessWidget {
  BuySell({Key key, this.bidOrAsk, this.baseCoinName, this.targetCoinName})
      : super(key: key);
  final bool bidOrAsk;
  final String baseCoinName;
  final String targetCoinName;

  @override
  Widget build(BuildContext context) {
    final log = getLogger('BuySellScreen');
    return BaseScreen<BuySellScreenState>(
      onModelReady: (model) async {
        log.w('=0');
        model.context = context;
        model.baseCoinName = baseCoinName;
        model.targetCoinName = targetCoinName;
        model.sell = [];
        model.buy = [];
        model.bidOrAsk = bidOrAsk;
        model.orderListFromTradeService();
        model.tradeListFromTradeService();
        await model.retrieveWallets();
        await model.orderList();
        await model.tradeList();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          // Close Web Socket on back click of hardware button
          model.closeChannles();
          // Let the back button push the route to the previous one
          return new Future(() => true);
        },
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: bidOrAsk
                            ? BorderSide(width: 2.0, color: Color(0XFF871fff))
                            : BorderSide.none),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: GestureDetector(
                      onTap: () {
                        //setState(() {
                        model.bidOrAsk = true;
                        //   });
                      },
                      child: Text(
                        AppLocalizations.of(context).buy,
                        style: TextStyle(
                            color: bidOrAsk ? Color(0XFF871fff) : Colors.white,
                            fontSize: 18.0),
                      ))),
              Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: bidOrAsk
                            ? BorderSide.none
                            : BorderSide(width: 2.0, color: Color(0XFF871fff))),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: GestureDetector(
                      onTap: () {
                        //   setState(() {
                        model.bidOrAsk = false;
                        //    });
                      },
                      child: Text(
                        AppLocalizations.of(context).sell,
                        style: new TextStyle(
                            color: bidOrAsk ? Colors.white : Color(0XFF871fff),
                            fontSize: 18.0),
                      )))
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2c2c4c),
              border: Border(
                  top: BorderSide(width: 1.0, color: Colors.white10),
                  bottom: BorderSide(width: 1.0, color: Colors.white10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: TextfieldText(
                              "price",
                              AppLocalizations.of(context).price,
                              baseCoinName,
                              model.handleTextChanged),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                          child: TextfieldText(
                              "quantity",
                              AppLocalizations.of(context).quantity,
                              "",
                              model.handleTextChanged),
                        ),
                        Slider(
                          activeColor: Colors.indigoAccent,
                          min: 0.0,
                          max: 15.0,
                          onChanged: (newRating) {
                            //setState(() =>
                            model.sliderValue = newRating;
                            //);
                          },
                          value: model.sliderValue,
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .transactionAmount,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.0),
                                ),
                                Text("1000" + " " + baseCoinName,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14.0))
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(AppLocalizations.of(context).totalBalance,
                                    style: TextStyle(
                                        color: globals.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0)),
                                Text("0.0000" + " " + baseCoinName,
                                    style: TextStyle(
                                        color: globals.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0))
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).kanbanGasFee,
                                style: new TextStyle(
                                    color: Colors.grey, fontSize: 14.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        5), // padding left to keep some space from the text
                                child: Text(
                                  '${model.kanbanTransFee}',
                                  style: new TextStyle(
                                      color: Colors.grey, fontSize: 14.0),
                                ),
                              )
                            ],
                          ),
                        ),

                        Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).advance,
                                  style: new TextStyle(
                                      color: Colors.grey, fontSize: 14.0),
                                ),
                                Switch(
                                  value: model.transFeeAdvance,
                                  inactiveTrackColor: globals.grey,
                                  // dragStartBehavior: DragStartBehavior.start,
                                  activeColor: globals.primaryColor,
                                  onChanged: (bool isOn) {
                                    //  setState(ViewState.Busy);
                                    model.transFeeAdvance = isOn;
                                    //  });
                                  },
                                )
                              ],
                            )),
                        Visibility(
                            visible: model.transFeeAdvance,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)
                                              .kanbanGasPrice,
                                          style: new TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0),
                                        ),
                                        Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 0, 0, 0),
                                                child: TextField(
                                                  controller: model
                                                      .kanbanGasPriceTextController,
                                                  onChanged: (String amount) {
                                                    model.updateTransFee();
                                                  },
                                                  keyboardType: TextInputType
                                                      .number, // numnber keyboard
                                                  decoration: InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: globals
                                                                      .primaryColor)),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: globals
                                                                      .grey)),
                                                      hintText: '0.00000',
                                                      hintStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .display2
                                                              .copyWith(
                                                                  fontSize:
                                                                      20)),
                                                  style: TextStyle(
                                                      color: globals.grey,
                                                      fontSize: 14),
                                                )))
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)
                                              .kanbanGasLimit,
                                          style: new TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0),
                                        ),
                                        Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 0, 0, 0),
                                                child: TextField(
                                                  controller: model
                                                      .kanbanGasLimitTextController,
                                                  onChanged: (String amount) {
                                                    model.updateTransFee();
                                                  },
                                                  keyboardType: TextInputType
                                                      .number, // numnber keyboard
                                                  decoration: InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: globals
                                                                      .primaryColor)),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: globals
                                                                      .grey)),
                                                      hintText: '0.00000',
                                                      hintStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .display2
                                                              .copyWith(
                                                                  fontSize:
                                                                      20)),
                                                  style: TextStyle(
                                                      color: globals.grey,
                                                      fontSize: 14),
                                                )))
                                      ],
                                    )
                                  ],
                                ))),
                        // Buy Sell Button
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  padding: const EdgeInsets.all(8.0),
                                  textColor: Colors.white,
                                  color: bidOrAsk
                                      ? Color(0xFF0da88b)
                                      : Color(0xFFe2103c),
                                  onPressed: () => {model.placeOrder()},
                                  child: Text(
                                      bidOrAsk
                                          ? AppLocalizations.of(context).buy
                                          : AppLocalizations.of(context).sell,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0)),
                                )))
                      ],
                    )),
                Expanded(
                    flex: 4,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.0, color: Colors.grey),
                                      ),
                                    ),
                                    child: Text(
                                        AppLocalizations.of(context).price,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0))),
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.0, color: Colors.grey),
                                      ),
                                    ),
                                    child: Text(
                                        AppLocalizations.of(context).quantity,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0)))
                              ],
                            ),
                            OrderDetail(model.sell, false),
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 5),
                                        child: Text(
                                            model.currentPrice.toString(),
                                            style: TextStyle(
                                                color: Color(0xFF17a2b8),
                                                fontSize: 18.0)))
                                  ],
                                )),
                            OrderDetail(model.buy, true)
                          ],
                        )))
              ],
            ),
          ),
          MyOrders(key: model.myordersState)
        ]),
      ),
    );
  }
}
