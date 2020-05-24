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

import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/trade/order-model.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "./order_detail.dart";
import "./my_orders.dart";
import 'package:flutter/foundation.dart';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;
import 'package:exchangilymobileapp/localizations.dart';

import 'buy_sell_screen_state.dart';

class BuySell extends StatelessWidget {
  BuySell({Key key, this.bidOrAsk, this.pair}) : super(key: key);
  final bool bidOrAsk;
  final String pair;

  @override
  Widget build(BuildContext context) {
    final log = getLogger('BuySellScreen');
    return BaseScreen<BuySellScreenState>(
      onModelReady: (model) async {
        model.context = context;
        //  model.pair = pair;
        //await model.init();
        model.splitPair(pair);
        model.setDefaultGasPrice();
        model.sell = [];
        model.buy = [];
        model.bidOrAsk = bidOrAsk;
        model.orderListFromTradeService();
        model.tradeListFromTradeService();
        await model.retrieveWallets();
        await model.orderList();
        await model.tradeList();
        await model.getDecimalPairConfig();
      },
      builder: (context, model, child) => WillPopScope(
          onWillPop: () {
            // Close Web Socket on back click of hardware button
            model.closeChannles();
            // Let the back button push the route to the previous one
            return new Future(() => true);
          },
          child: Scaffold(
            appBar: CupertinoNavigationBar(
              padding: EdgeInsetsDirectional.only(start: 0),
              leading: CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    model.closeChannles();
                    Navigator.pop(context);
                  }
                },
              ),
              middle: Text(
                pair,
                style: Theme.of(context).textTheme.headline3,
              ),
              backgroundColor: Color(0XFF1f2233),
            ),
            backgroundColor: Color(0xFF1F2233),
            body: ListView(children: <Widget>[
              Column(children: <Widget>[
                // Buy and Sell Select Container Option at the Top
                Row(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: model.bidOrAsk
                                  ? BorderSide(
                                      width: 2.0, color: globals.primaryColor)
                                  : BorderSide.none),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: GestureDetector(
                            onTap: () {
                              model.selectBuySellTab(true);
                            },
                            child: Text(
                              AppLocalizations.of(context).buy,
                              style: TextStyle(
                                  color: model.bidOrAsk
                                      ? Color(0XFF871fff)
                                      : Colors.white,
                                  fontSize: 14.0),
                            ))),
                    Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: model.bidOrAsk
                                  ? BorderSide.none
                                  : BorderSide(
                                      width: 2.0, color: Color(0XFF871fff))),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: GestureDetector(
                            onTap: () {
                              model.selectBuySellTab(false);
                            },
                            child: Text(
                              AppLocalizations.of(context).sell,
                              style: TextStyle(
                                  color: model.bidOrAsk
                                      ? Colors.white
                                      : Color(0XFF871fff),
                                  fontSize: 14.0),
                            )))
                  ],
                ),
                // Price and quantity text
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
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    DecimalTextInputFormatter(
                                        decimalRange: model.priceDecimal,
                                        activatedNegativeValues: false)
                                  ],
                                  onChanged: (value) {
                                    model.handleTextChanged('price', value);
                                  },
                                  maxLines: 1,
                                  controller: model.priceTextController,
                                  decoration: InputDecoration(
                                      labelText:
                                          AppLocalizations.of(context).price,
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    DecimalTextInputFormatter(
                                        decimalRange: model.quantityDecimal,
                                        activatedNegativeValues: false)
                                  ],
                                  onChanged: (value) {
                                    model.handleTextChanged('quantity', value);
                                  },
                                  maxLines: 1,
                                  controller: model.quantityTextController,
                                  decoration: InputDecoration(
                                      labelText:
                                          AppLocalizations.of(context).quantity,
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              // Slider
                              Slider(
                                divisions: 6,
                                label:
                                    '${model.sliderValue.toStringAsFixed(2)}',
                                activeColor: globals.primaryColor,
                                min: 0.0,
                                max: 100.0,
                                onChanged: (newValue) {
                                  model.sliderOnchange(newValue);
                                },
                                value: model.sliderValue,
                              ),
                              // Transaction Amount text
                              Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .transactionAmount,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0),
                                        ),
                                      ),
                                      UIHelper.verticalSpaceSmall,
                                      // Transaction Amount
                                      Expanded(
                                        child: model.bidOrAsk == true
                                            ? Text(
                                                "${model.transactionAmount.toStringAsFixed(model.priceDecimal)}" +
                                                    " " +
                                                    model.baseCoinName,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14.0))
                                            : Text(
                                                "${model.transactionAmount.toStringAsFixed(model.priceDecimal)}" +
                                                    " " +
                                                    model.baseCoinName,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14.0)),
                                      )
                                    ],
                                  )),
                              // Total Balance
                              Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          AppLocalizations.of(context)
                                              .totalBalance,
                                          style: TextStyle(
                                              color: globals.primaryColor,
                                              fontSize: 15.0)),
                                      // First Check if Object is null
                                      model.targetCoinWalletData == null &&
                                              model.baseCoinWalletData == null
                                          // If true then to avoid error screen, assign/display 0 in both sell and buy tab
                                          ? model.bidOrAsk == true
                                              ? Text(
                                                  "0.00" +
                                                      " " +
                                                      model.baseCoinName,
                                                  style: TextStyle(
                                                      color:
                                                          globals.primaryColor,
                                                      fontSize: 15.0))
                                              : Text(
                                                  "0.00" +
                                                      " " +
                                                      model.targetCoinName,
                                                  style: TextStyle(
                                                      color:
                                                          globals.primaryColor,
                                                      fontSize: 15.0))
                                          :
                                          // If false then show the denominator coin balance by again checking buy and sell tab to display currency accordingly
                                          model.bidOrAsk == true
                                              ? Text(
                                                  "${model.baseCoinWalletData.inExchange.toStringAsFixed(model.priceDecimal)}" +
                                                      " " +
                                                      model.baseCoinName,
                                                  style: TextStyle(
                                                      color:
                                                          globals.primaryColor,
                                                      fontSize: 15.0))
                                              : Text(
                                                  "${model.targetCoinWalletData.inExchange.toStringAsFixed(model.priceDecimal)}" +
                                                      " " +
                                                      model.targetCoinName,
                                                  style: TextStyle(
                                                      color:
                                                          globals.primaryColor,
                                                      fontSize: 15.0))
                                    ],
                                  )),
                              // kanban gas fee
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
                                        '${model.kanbanTransFee.toStringAsFixed(model.priceDecimal)}',
                                        style: new TextStyle(
                                            color: Colors.grey, fontSize: 14.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // Advance
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
                                          // Kanban gas price
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                AppLocalizations.of(context)
                                                    .kanbanGasPrice,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
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
                                                        .numberWithOptions(
                                                            decimal:
                                                                true), // numnber keyboard
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
                                                                .headline5),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5),
                                              ))
                                            ],
                                          ),
                                          // Kanban gas limit
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                AppLocalizations.of(context)
                                                    .kanbanGasLimit,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: TextField(
                                                        controller: model
                                                            .kanbanGasLimitTextController,
                                                        onChanged:
                                                            (String amount) {
                                                          model
                                                              .updateTransFee();
                                                        },
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(
                                                                decimal:
                                                                    true), // numnber keyboard
                                                        decoration: InputDecoration(
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: globals
                                                                        .primaryColor)),
                                                            enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: globals
                                                                        .grey)),
                                                            hintText: '0.00000',
                                                            hintStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline5),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5,
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
                                        color: model.bidOrAsk
                                            ? Color(0xFF0da88b)
                                            : Color(0xFFe2103c),
                                        onPressed: () =>
                                            {model.checkPass(context)},
                                        child: Text(
                                            model.bidOrAsk
                                                ? AppLocalizations.of(context)
                                                    .buy
                                                : AppLocalizations.of(context)
                                                    .sell,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4)),
                                  ))
                            ],
                          )),
                      // Price and Quantity side
                      Expanded(
                          flex: 4,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      // Heading Price
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 5),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .price,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6)),
                                      // Heading Quantity
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 5),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .quantity,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6))
                                    ],
                                  ),
                                  orderDetail(model.sell, false, model),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(model.currentPrice.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4)
                                        ],
                                      )),
                                  orderDetail(model.buy, true, model)
                                ],
                              )))
                    ],
                  ),
                ),
                MyOrders(key: model.myordersState)
              ]),
            ]),
          )),
    );
  }

  // Using orderDetail here in this buy and sell screen to fill the price and quanity in text fields when user click on the order
  Widget orderDetail(
      final List<OrderModel> orderArray, final bool bidOrAsk, model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        for (var item in orderArray)
          InkWell(
            onTap: () {
              model.quantityTextController.text = item.orderQuantity.toString();
              model.priceTextController.text = item.price.toString();
            },
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(item.price.toStringAsFixed(model.priceDecimal),
                        style: TextStyle(
                            color: Color(bidOrAsk ? 0xFF0da88b : 0xFFe2103c),
                            fontSize: 13.0)),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        color: Color(bidOrAsk ? 0xFF264559 : 0xFF502649),
                        child: Text(
                            item.orderQuantity
                                .toStringAsFixed(model.quantityDecimal),
                            style:
                                TextStyle(color: Colors.white, fontSize: 13.0)))
                  ],
                )),
          )
      ],
    );
  }
}
