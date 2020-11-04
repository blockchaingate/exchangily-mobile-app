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

import 'package:exchangilymobileapp/models/trade/order-model.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_orders_view.dart';
import 'package:exchangilymobileapp/screens/settings/settings_portable_widget.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import 'package:flutter/foundation.dart';
import 'package:exchangilymobileapp/shared/globals.dart' as globals;
import 'package:exchangilymobileapp/localizations.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stacked/stacked.dart';

import 'buy_sell_screen_state.dart';

class BuySellView extends StatelessWidget {
  BuySellView({Key key, this.bidOrAsk, this.pair, this.orderbook})
      : super(key: key);
  final bool bidOrAsk;
  final Price pair;
  final List orderbook;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SharedService sharedService = locator<SharedService>();
    GlobalKey _one = GlobalKey();
    GlobalKey _two = GlobalKey();
    return ViewModelBuilder<BuySellScreenState>.reactive(
        viewModelBuilder: () => BuySellScreenState(),
        onModelReady: (model) async {
          model.context = context;
          model.globalKeyOne = _one;
          model.globalKeyTwo = _two;
          sharedService.context = context;
          model.splitPair(pair.symbol);
          model.setDefaultGasPrice();
          model.bidOrAsk = bidOrAsk;
          await model.retrieveWallets();
          await model.getDecimalPairConfig();
          model.passedPair = pair;
          model.init();
        },
        builder: (context, model, child) => Scaffold(
            key: _scaffoldKey,
            endDrawerEnableOpenDragGesture: true,
            endDrawer: Drawer(child: Container(child: SettingsPortableView())),
            appBar: CupertinoNavigationBar(
              trailing: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
              ),
              padding: EdgeInsetsDirectional.only(start: 0),
              leading: CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              middle: Text(
                pair.symbol ?? '',
                style: Theme.of(context).textTheme.headline3,
              ),
              backgroundColor: Color(0XFF1f2233),
            ),
            backgroundColor: Color(0xFF1F2233),
            body: ShowCaseWidget(
              onStart: (index, key) {
                print('onStart: $index, $key');
              },
              onComplete: (index, key) {
                print('onComplete: $index, $key');
              },
              builder: Builder(
                builder: (context) => Stack(
                    fit: StackFit.loose,
                    overflow: Overflow.visible,
                    alignment: Alignment.center,
                    children: [
                      ListView(children: <Widget>[
                        //    : Container(),
                        // Buy/Sell text row

                        Row(
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: model.bidOrAsk
                                          ? BorderSide(
                                              width: 2.0,
                                              color: globals.primaryColor)
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
                                              width: 2.0,
                                              color: Color(0XFF871fff))),
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
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Color(0xFF2c2c4c),
                            border: Border(
                                top: BorderSide(
                                    width: 1.0, color: Colors.white10),
                                bottom: BorderSide(
                                    width: 1.0, color: Colors.white10)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 2, left: 1),
                                    child: Column(
                                      children: <Widget>[
                                        // price text input
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: TextField(
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            inputFormatters: [
                                              DecimalTextInputFormatter(
                                                  decimalRange:
                                                      model.priceDecimal,
                                                  activatedNegativeValues:
                                                      false)
                                            ],
                                            onChanged: (value) {
                                              model.handleTextChanged(
                                                  'price', value);
                                            },
                                            maxLines: 1,
                                            controller:
                                                model.priceTextController,
                                            decoration: InputDecoration(
                                                labelText:
                                                    AppLocalizations.of(context)
                                                        .price,
                                                labelStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ),
                                        // quantity text input
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: TextField(
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            inputFormatters: [
                                              DecimalTextInputFormatter(
                                                  decimalRange:
                                                      model.quantityDecimal,
                                                  activatedNegativeValues:
                                                      false)
                                            ],
                                            onChanged: (value) {
                                              model.handleTextChanged(
                                                  'quantity', value);
                                            },
                                            maxLines: 1,
                                            controller:
                                                model.quantityTextController,
                                            decoration: InputDecoration(
                                                labelText:
                                                    AppLocalizations.of(context)
                                                        .quantity,
                                                labelStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 3.0),
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .amount,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0),
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
                                                          fontSize: 12.0))
                                                  : Text(
                                                      "${model.transactionAmount.toStringAsFixed(model.priceDecimal)}" +
                                                          " " +
                                                          model.baseCoinName,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12.0)),
                                            )
                                          ],
                                        ),
                                        UIHelper.verticalSpaceSmall,
                                        // Total Balance
                                        BalanceRowWidget(model: model),
                                        UIHelper.verticalSpaceSmall,
                                        // kanban gas fee
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .kanbanGasFee,
                                              style: new TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      5), // padding left to keep some space from the text
                                              child: Text(
                                                '${model.kanbanTransFee.toStringAsFixed(model.priceDecimal)}',
                                                style: new TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0),
                                              ),
                                            )
                                          ],
                                        ),
                                        UIHelper.verticalSpaceSmall,
                                        // Advance
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .advance,
                                              style: new TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0),
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
                                        ),
                                        Visibility(
                                            visible: model.transFeeAdvance,
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 0, 5, 0),
                                                child: Column(
                                                  children: <Widget>[
                                                    // Kanban gas price
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .kanbanGasPrice,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline5,
                                                        ),
                                                        Expanded(
                                                            child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  20, 0, 0, 0),
                                                          child: TextField(
                                                              controller: model
                                                                  .kanbanGasPriceTextController,
                                                              onChanged: (String
                                                                  amount) {
                                                                model
                                                                    .updateTransFee();
                                                              },
                                                              keyboardType:
                                                                  TextInputType.numberWithOptions(
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
                                                                  hintText:
                                                                      '0.00000',
                                                                  hintStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline5),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline5),
                                                        ))
                                                      ],
                                                    ),
                                                    // Kanban gas limit
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .kanbanGasLimit,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline5,
                                                        ),
                                                        Expanded(
                                                            child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            20,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    TextField(
                                                                  controller: model
                                                                      .kanbanGasLimitTextController,
                                                                  onChanged:
                                                                      (String
                                                                          amount) {
                                                                    model
                                                                        .updateTransFee();
                                                                  },
                                                                  keyboardType:
                                                                      TextInputType.numberWithOptions(
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
                                                                      hintText:
                                                                          '0.00000',
                                                                      hintStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline5),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline5,
                                                                )))
                                                      ],
                                                    )
                                                  ],
                                                ))),
                                        // Buy Sell Button
                                        UIHelper.verticalSpaceSmall,
                                        SizedBox(
                                          width: double.infinity,
                                          child: RaisedButton(
                                              elevation: 4,
                                              animationDuration:
                                                  Duration(milliseconds: 100),
                                              splashColor: Colors.purpleAccent,
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              textColor: Colors.white,
                                              color: model.bidOrAsk
                                                  ? Color(0xFF0da88b)
                                                  : Color(0xFFe2103c),
                                              onPressed: () {
                                                model.checkPass(context);
                                              },
                                              child: Text(
                                                  model.bidOrAsk
                                                      ? AppLocalizations.of(
                                                              context)
                                                          .buy
                                                      : AppLocalizations.of(
                                                              context)
                                                          .sell,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4)),
                                        )
                                      ],
                                    ),
                                  )),
                              //------------------------------------
                              // Price and Quantity orderbook side
                              //------------------------------------
                              Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          // Heading Price
                                          Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                      orderDetail(orderbook[1], true, model),
                                      Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text('${pair.price.toString()}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4)
                                            ],
                                          )),
                                      orderDetail(orderbook[0], false, model)
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        // My Orders view
                        MyOrdersView(tickerName: model.tickerName),
                      ]),
                      model.isBusy
                          ? model.sharedService
                              .stackFullScreenLoadingIndicator()
                          : Container(),
                    ]),
              ),
            )));
  }

  // Using orderDetail here in this buy and sell screen to fill the price and quanity in text fields when user click on the order
  Widget orderDetail(List<OrderModel> orderArray, final bool bidOrAsk, model) {
    List<OrderModel> sellOrders = [];
    print('OrderArray length before ${orderArray.length}');
    orderArray = (orderArray.length > 7)
        ? orderArray = (orderArray.sublist(0, 7))
        : orderArray;
    if (bidOrAsk) {
      sellOrders = orderArray.reversed.toList();
      orderArray = sellOrders;
    }
    print('OrderArray length after ${orderArray.length}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        for (var item in orderArray)
          InkWell(
            onTap: () {
              model.setBusy(true);
              model.quantityTextController.text = item.orderQuantity.toString();
              model.quantity = item.orderQuantity;
              model.priceTextController.text = item.price.toString();
              model.price = item.price;
              model.transactionAmount = model.quantity * model.price;
              model.updateTransFee();
              model.setBusy(false);
            },
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(item.price.toStringAsFixed(model.priceDecimal),
                        style: TextStyle(
                            color: Color(!bidOrAsk ? 0xFF0da88b : 0xFFe2103c),
                            fontSize: 13.0)),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        color: Color(!bidOrAsk ? 0xFF264559 : 0xFF502649),
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

class BalanceRowWidget extends StatelessWidget {
  const BalanceRowWidget({Key key, this.model}) : super(key: key);
  final BuySellScreenState model;
  @override
  Widget build(BuildContext context) {
    model.showcaseEvent(context);
    return Container(
        child:
            // !model.storageService.showCaseView
            //    ?
            Showcase(
      key: model.globalKeyOne,
      description: AppLocalizations.of(context).buySellInstruction1,
      child: transferRow(context, model),
    )
        //  : transferRow(context, model)
        );
  }

  Row transferRow(BuildContext context, BuySellScreenState model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppLocalizations.of(context).balance,
            style: TextStyle(color: globals.primaryColor, fontSize: 13.0)),
        // First Check if Object is null
        model.targetCoinWalletData == null && model.baseCoinWalletData == null
            // If true then to avoid error screen, assign/display 0 in both sell and buy tab
            ? model.bidOrAsk == true
                ? Text("0.00" + " " + model.baseCoinName,
                    style:
                        TextStyle(color: globals.primaryColor, fontSize: 13.0))
                : Text("0.00" + " " + model.targetCoinName,
                    style:
                        TextStyle(color: globals.primaryColor, fontSize: 13.0))
            :
            // If false then show the denominator coin balance by again checking buy and sell tab to display currency accordingly
            model.bidOrAsk
                ? Text(
                    "${model.baseCoinExchangeBalance.unlockedAmount.toStringAsFixed(model.priceDecimal)}" +
                        " " +
                        model.baseCoinName,
                    style:
                        TextStyle(color: globals.primaryColor, fontSize: 13.0))
                : Text(
                    "${model.targetCoinExchangeBalance.unlockedAmount.toStringAsFixed(model.priceDecimal)}" +
                        " " +
                        model.targetCoinName,
                    style:
                        TextStyle(color: globals.primaryColor, fontSize: 13.0))
      ],
    );
  }
}
