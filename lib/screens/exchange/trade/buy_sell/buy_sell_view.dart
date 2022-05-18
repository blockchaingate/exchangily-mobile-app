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

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/buy_sell/buy_sell_viewmodel.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_orders_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/orderbook/orderbook_model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:exchangilymobileapp/localizations.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stacked/stacked.dart';

class BuySellView extends StatelessWidget {
  BuySellView(
      {Key key, this.bidOrAsk, this.pairSymbolWithSlash, this.tickerName})
      : super(key: key);
  final bool bidOrAsk;
  final String pairSymbolWithSlash;
  final tickerName;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    GlobalKey _one = GlobalKey();
    GlobalKey _two = GlobalKey();
    return ViewModelBuilder<BuySellViewModel>.reactive(
        disposeViewModel: false,
        viewModelBuilder: () =>
            BuySellViewModel(tickerNameFromRoute: tickerName),
        onModelReady: (model) async {
          model.context = context;
          model.globalKeyOne = _one;
          model.globalKeyTwo = _two;
          model.bidOrAsk = bidOrAsk;

          model.pairSymbolWithSlash = pairSymbolWithSlash;
          // sharedService.context = context;
          model.splitPair(pairSymbolWithSlash);
          // model.setDefaultGasPrice();
          // await model.retrieveWallets();
          // await model.getDecimalPairConfig();
          model.init();
        },
        builder: (context, model, child) => Scaffold(
            key: _scaffoldKey,
            // endDrawerEnableOpenDragGesture: true,
            // endDrawer: Drawer(child: Container(child: SettingsPortableView())),
            appBar: buildCupertinoNavigationBar(context),
            backgroundColor: const Color(0xFF1F2233),
            body: ShowCaseWidget(
              onStart: (index, key) {
                debugPrint('onStart: $index, $key');
              },
              onComplete: (index, key) {
                debugPrint('onComplete: $index, $key');
                model.storageService.isShowCaseView = false;
              },
              builder: Builder(
                builder: (context) => Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    ListView(children: <Widget>[
                      // Buy/Sell text row
                      buildBuySellTabRow(model, context),

                      // Price and quantity text
                      Container(
                        margin: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2c2c4c),
                          border: Border(
                              top:
                                  BorderSide(width: 1.0, color: Colors.white10),
                              bottom: BorderSide(
                                  width: 1.0, color: Colors.white10)),
                        ),
                        child:
/*----------------------------------------------------------
                Price/quantity and Orderbook side by side
 -----------------------------------------------------------*/
                            Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                flex: 5,
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(right: 4, left: 1),
                                  // LeftSideColumnWidgets View model widget
                                  child: LeftSideColumnWidgets(),
                                )),
                            // Buy Sell Button
                            UIHelper.verticalSpaceSmall,
                            Expanded(
                              flex: 5,
                              child: Container(
                                  // height:
                                  //     MediaQuery.of(context).size.height / 2,
                                  margin: const EdgeInsets.only(left: 3),
                                  child:

/*----------------------------------------------------------
                Orderbook view
 -----------------------------------------------------------*/
                                      // OrderBookView(tickerName: model.tickerName),
                                      !model.dataReady
                                          ? SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2.7,
                                              child: Center(
                                                  child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Container(
                                                          color: white,
                                                          child:
                                                              const CupertinoActivityIndicator()))))
                                          :

/*----------------------------------------------------------------------
                      Vertical Orderbook
----------------------------------------------------------------------*/

                                          Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    // Heading Price
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 5),
                                                        // decoration:
                                                        //     const BoxDecoration(
                                                        //   border: Border(
                                                        //     bottom: BorderSide(
                                                        //         width: 1.0,
                                                        //         color: Colors
                                                        //             .grey),
                                                        //   ),
                                                        // ),
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .price,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6)),
                                                    // Heading Quantity
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 5),
                                                        // decoration:
                                                        //     const BoxDecoration(
                                                        //   border: Border(
                                                        //     bottom: BorderSide(
                                                        //         width: 1.0,
                                                        //         color: Colors
                                                        //             .grey),
                                                        //   ),
                                                        // ),
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .quantity,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6))
                                                  ],
                                                ),
                                                buildVerticalOrderbookColumn(
                                                    model.orderbook.sellOrders,
                                                    false,
                                                    model),
                                                Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8, 0, 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        model.orderbook.buyOrders !=
                                                                    [] &&
                                                                model.orderbook
                                                                        .sellOrders !=
                                                                    []
                                                            ? Text(
                                                                model.orderbook
                                                                    .price
                                                                    .toString(),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline4)
                                                            : Center(
                                                                child: Text(
                                                                    'No Orders',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyText2),
                                                              )
                                                      ],
                                                    )),
                                                buildVerticalOrderbookColumn(
                                                    model.orderbook.buyOrders,
                                                    true,
                                                    model)
                                              ],
                                            )

                                  //  OrderBookView(
                                  //     orderbook: model.orderbook,
                                  //     decimalConfig:
                                  //         model.singlePairDecimalConfig,
                                  //     isVerticalOrderbook: true,
                                  //   )
                                  // buildRightSideOrderbookColumn(
                                  //     context, model),
                                  ),
                            ),
                          ],
                        ),
                      ),

/*----------------------------------------------------------
                My Orders view
 -----------------------------------------------------------*/
                      model.isReloadMyOrders
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.20,
                              margin: const EdgeInsets.all(5),
                              child: const Center(
                                  child: CircularProgressIndicator()))
                          : MyOrdersView(
                              tickerName: model.tickerName,
                            ),
                      //
                    ]),
                    model.isBusy
                        ? model.sharedService.stackFullScreenLoadingIndicator()
                        : Container(),
                  ],
                ),
              ),
            )));
  }

/*----------------------------------------------------------------------
                      Top Buy sell tab row
----------------------------------------------------------------------*/

  Row buildBuySellTabRow(BuySellViewModel model, BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: model.bidOrAsk
                      ? const BorderSide(width: 2.0, color: primaryColor)
                      : BorderSide.none),
            ),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: GestureDetector(
                onTap: () {
                  model.selectBuySellTab(true);
                },
                child: Text(
                  AppLocalizations.of(context).buy,
                  style: TextStyle(
                      color: model.bidOrAsk
                          ? const Color(0XFF871fff)
                          : Colors.white,
                      fontSize: 14.0),
                ))),
        Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: model.bidOrAsk
                      ? BorderSide.none
                      : const BorderSide(width: 2.0, color: Color(0XFF871fff))),
            ),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: GestureDetector(
                onTap: () {
                  model.selectBuySellTab(false);
                },
                child: Text(
                  AppLocalizations.of(context).sell,
                  style: TextStyle(
                      color: model.bidOrAsk
                          ? Colors.white
                          : const Color(0XFF871fff),
                      fontSize: 14.0),
                )))
      ],
    );
  }

/*----------------------------------------------------------------------
                      Cupertino navigation bar
----------------------------------------------------------------------*/

  CupertinoNavigationBar buildCupertinoNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      // trailing: IconButton(
      //   icon: Icon(
      //     Icons.settings,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //     _scaffoldKey.currentState.openEndDrawer();
      //   },
      // ),
      padding: const EdgeInsetsDirectional.only(start: 0),
      leading: CupertinoButton(
        padding: const EdgeInsets.all(0),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      middle: Text(
        pairSymbolWithSlash ?? '',
        style: Theme.of(context).textTheme.headline3,
      ),
      backgroundColor: const Color(0XFF1f2233),
    );
  }
}
/*----------------------------------------------------------------------
                      Orderbook rightside
----------------------------------------------------------------------*/

// /// Using orderDetail here in this buy and sell screen to fill the price
// ///  and quanity in text fields when user click on the order
// class VerticalOrderbook extends StatelessWidget {
//   final String tickerName;
//   VerticalOrderbook({this.tickerName});

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<OrderbookViewModel>.reactive(
//       disposeViewModel: false,
//       fireOnModelReadyOnce: true,

//       // passing tickername in the constructor of the viewmodal so that we can pass it to the streamMap
//       // which is required override
//       viewModelBuilder: () => OrderbookViewModel(tickerName: tickerName),
//       onModelReady: (model) {
//         // model.context = context;
//         model.init();
//       },
//       builder: (context, model, _) => !model.dataReady
//           ? Container(
//               height: MediaQuery.of(context).size.height / 2.7,
//               child: Center(
//                   child: SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: Container(
//                           color: white, child: CupertinoActivityIndicator()))))
//           : Column(
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     // Heading Price
//                     Container(
//                         padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
//                         decoration: const BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(width: 1.0, color: Colors.grey),
//                           ),
//                         ),
//                         child: Text(AppLocalizations.of(context).price,
//                             style: Theme.of(context).textTheme.headline6)),
//                     // Heading Quantity
//                     Container(
//                         padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
//                         decoration: const BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(width: 1.0, color: Colors.grey),
//                           ),
//                         ),
//                         child: Text(AppLocalizations.of(context).quantity,
//                             style: Theme.of(context).textTheme.headline6))
//                   ],
//                 ),
//                 buildVerticalOrderbookColumn(
//                     model.orderbook.sellOrders, false, model),
//                 Container(
//                     padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         model.orderbook.price != 0
//                             ? Text('${model.orderbook.price.toString()}',
//                                 style: Theme.of(context).textTheme.headline4)
//                             : Center(
//                                 child: Text('No Orders',
//                                     style:
//                                         Theme.of(context).textTheme.bodyText2),
//                               )
//                       ],
//                     )),
//                 buildVerticalOrderbookColumn(
//                     model.orderbook.buyOrders, true, model),
//               ],
//             ),
//     );
//   }
// }
/*----------------------------------------------------------------------
                      Order Detail
----------------------------------------------------------------------*/

Column buildVerticalOrderbookColumn(
    List<OrderType> orderArray, final bool bidOrAsk, BuySellViewModel model) {
  // List<OrderType> sellOrders = [];
  debugPrint('OrderArray $bidOrAsk length before ${orderArray.length}');
  if (orderArray.length > 7) orderArray = orderArray.sublist(0, 7);
  if (!bidOrAsk) orderArray = orderArray.reversed.toList();

  debugPrint('OrderArray $bidOrAsk length after ${orderArray.length}');
  return Column(
    children: <Widget>[
      // can try to use listview builder here
      for (var order in orderArray)
        InkWell(
          onTap: () {
            debugPrint(
                'trying filling values ${order.price} --  ${order.quantity}');

            model.fillPriceAndQuantityTextFields(order.price, order.quantity);
            // model.setBusy(true);
            // model.quantityTextController.text =
            //     order.quantity.toStringAsFixed(model.quantityDecimal);
            // model.quantity = order.quantity;
            // model.priceTextController.text =
            //     order.price.toStringAsFixed(model.priceDecimal);
            // model.price = order.price;
            // model.transactionAmount = model.quantity * model.price;
            // model.updateTransFee();
            // model.setBusy(false);
          },
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      order.price.toStringAsFixed(
                          model.singlePairDecimalConfig.priceDecimal),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(bidOrAsk ? 0xFF0da88b : 0xFFe2103c),
                          fontSize: 13.0)),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      color: Color(bidOrAsk ? 0xFF264559 : 0xFF502649),
                      child: Text(
                          NumberUtil.decimalLimiter(order.quantity,
                                  decimalPrecision:
                                      model.singlePairDecimalConfig.qtyDecimal)
                              .toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 13.0)))
                ],
              )),
        )
    ],
  );
}

/*----------------------------------------------------------------------
                      Old Order Detail Widget
----------------------------------------------------------------------*/

// Widget orderDetail(List<OrderType> orderArray, final bool bidOrAsk, model) {
//   // List<OrderType> sellOrders = [];
//   debugPrint('OrderArray length before ${orderArray.length}');
//   orderArray = (orderArray.length > 7)
//       ? orderArray = (orderArray.sublist(0, 7))
//       : orderArray;
//   // if (bidOrAsk) {
//   //   sellOrders = orderArray.reversed.toList();
//   //   orderArray = sellOrders;
//   // }
//   debugPrint('OrderArray length after ${orderArray.length}');
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: <Widget>[
//       for (var order in orderArray)
//         InkWell(
//           onTap: () {
//             model.setBusy(true);
//             model.quantityTextController.text =
//                 order.quantity.toStringAsFixed(model.quantityDecimal);
//             model.quantity = order.quantity;
//             model.priceTextController.text =
//                 order.price.toStringAsFixed(model.priceDecimal);
//             model.price = order.price;
//             model.transactionAmount = model.quantity * model.price;
//             model.updateTransFee();
//             model.setBusy(false);
//           },
//           child: Padding(
//               padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(order.price.toStringAsFixed(model.priceDecimal),
//                       style: TextStyle(
//                           color: Color(bidOrAsk ? 0xFF0da88b : 0xFFe2103c),
//                           fontSize: 13.0)),
//                   Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//                       color: Color(bidOrAsk ? 0xFF264559 : 0xFF502649),
//                       child: Text(
//                           order.quantity.toStringAsFixed(model.quantityDecimal),
//                           style:
//                               TextStyle(color: Colors.white, fontSize: 13.0)))
//                 ],
//               )),
//         )
//     ],
//   );
// }

/*----------------------------------------------------------------------
                      Left Side Column Widgets
----------------------------------------------------------------------*/
class LeftSideColumnWidgets extends ViewModelWidget<BuySellViewModel> {
  // const LeftSideColumnWidgets({
  //   Key key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context, BuySellViewModel model) {
    //  model.priceTextController.text = model.priceFromTradeService.toString();
    // model.quantityTextController.text =
    //     model.quantityFromTradeService.toString();
    return Column(
      children: <Widget>[
        // price text input
        Padding(
          padding: const EdgeInsets.all(5),
          child: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              DecimalTextInputFormatter(
                  decimalRange: model.busy(model.singlePairDecimalConfig)
                      ? 2
                      : model.singlePairDecimalConfig.priceDecimal,
                  activatedNegativeValues: false)
            ],
            onTap: () {
              //  model.priceTextController.text = '';
            },
            onChanged: (value) {
              if (value.isNotEmpty) model.handleTextChanged('price', value);
            },
            maxLines: 1,
            controller: model.priceTextController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).price,
                labelStyle: Theme.of(context).textTheme.headline6),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        // quantity text input
        Padding(
          padding: const EdgeInsets.all(5),
          child: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              DecimalTextInputFormatter(
                  decimalRange: model.busy(model.singlePairDecimalConfig)
                      ? 4
                      : model.singlePairDecimalConfig.qtyDecimal,
                  activatedNegativeValues: false)
            ],
            onTap: () {
              //  model.quantityTextController.text = '';
            },
            onChanged: (value) {
              if (value.isNotEmpty) model.handleTextChanged('quantity', value);
            },
            maxLines: 1,
            controller: model.quantityTextController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).quantity,
                labelStyle: Theme.of(context).textTheme.headline6),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        // Slider
        Slider(
          divisions: 100,
          label:
              '${NumberUtil().truncateDoubleWithoutRouding(model.sliderValue, decimalPrecision: 2).toString()}%',
          activeColor: primaryColor,
          min: 0.0,
          max: 100.0,
          onChanged: (newValue) {
            model.sliderOnchange(newValue);
          },
          value: model.sliderValue,
        ),
        // Transaction Amount text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: Text(
                AppLocalizations.of(context).amount,
                style: const TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            ),
            UIHelper.verticalSpaceSmall,
            // Transaction Amount
            Expanded(
              child: model.bidOrAsk == true
                  ? Text(
                      NumberUtil.decimalLimiter(model.transactionAmount,
                                  decimalPrecision:
                                      model.singlePairDecimalConfig.qtyDecimal)
                              .toString() +
                          " " +
                          model.baseCoinName,
                      textAlign: TextAlign.end,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12.0))
                  : Text(
                      NumberUtil.decimalLimiter(model.transactionAmount,
                                  decimalPrecision:
                                      model.singlePairDecimalConfig.qtyDecimal)
                              .toString() +
                          " " +
                          model.baseCoinName,
                      textAlign: TextAlign.end,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12.0)),
            )
          ],
        ),
        UIHelper.verticalSpaceSmall,
        // Total Balance
        model.isBusy ||
                model.targetCoinExchangeBalance == null ||
                model.baseCoinExchangeBalance == null ||
                model.baseCoinExchangeBalance.unlockedAmount == null ||
                model.targetCoinExchangeBalance.unlockedAmount == null
            ? const Center(child: CupertinoActivityIndicator())
            : BalanceRowWidget(model: model),
        UIHelper.verticalSpaceSmall,
        // kanban gas fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).kanbanGasFee,
              style: const TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5), // padding left to keep some space from the text
              child: Text(
                NumberUtil()
                    .truncateDoubleWithoutRouding(model.kanbanTransFee,
                        decimalPrecision: 4)
                    .toString(),
                style: const TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            )
          ],
        ),
        UIHelper.verticalSpaceSmall,
        // Advance
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).advance,
              style: const TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
            SizedBox(
              height: 20,
              child: Transform.scale(
                alignment: Alignment.centerRight,
                scale: 0.70,
                child: Switch.adaptive(
                    activeColor: primaryColor,
                    value: model.transFeeAdvance,
                    onChanged: (bool v) {
                      model.setBusy(true);
                      model.transFeeAdvance = !model.transFeeAdvance;
                      model.setBusy(false);
                    }),
              ),
            ),
          ],
        ),
        Visibility(
          visible: model.transFeeAdvance,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              children: <Widget>[
                // Kanban gas price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).kanbanGasPrice,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    UIHelper.horizontalSpaceSmall,
                    Expanded(
                        child: TextField(
                            controller: model.kanbanGasPriceTextController,
                            onChanged: (String amount) {
                              model.updateTransFee();
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true), // numnber keyboard
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: grey)),
                                hintText: '0.00000',
                                hintStyle:
                                    Theme.of(context).textTheme.headline6),
                            style: Theme.of(context).textTheme.headline6))
                  ],
                ),
                //   Kanban gas limit
                Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).kanbanGasLimit,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    UIHelper.horizontalSpaceSmall,
                    Expanded(
                        child: TextField(
                      controller: model.kanbanGasLimitTextController,
                      onChanged: (String amount) {
                        model.updateTransFee();
                      },
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true), // numnber keyboard
                      decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: grey)),
                          hintText: '0.00000',
                          hintStyle: Theme.of(context).textTheme.headline6),
                      style: Theme.of(context).textTheme.headline6,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
        UIHelper.verticalSpaceSmall,
        // buy sell button
        SizedBox(
          width: MediaQuery.of(context).size.width / 2.2,
          child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(color: Colors.transparent, width: 2),
                )),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 12.0)),
                backgroundColor: model.bidOrAsk
                    ? MaterialStateProperty.all(const Color(0xFF0da88b))
                    : MaterialStateProperty.all(const Color(0xFFe2103c)),
              ),
              onPressed: () {
                model.checkPass(context);
              },
              child: model.isBusy
                  ? Text(AppLocalizations.of(context).loading,
                      style: Theme.of(context).textTheme.headline4)
                  : Text(
                      model.bidOrAsk
                          ? AppLocalizations.of(context).buy
                          : AppLocalizations.of(context).sell,
                      style: Theme.of(context).textTheme.headline4)),
        )
      ],
    );
  }
}

class BalanceRowWidget extends StatelessWidget {
  const BalanceRowWidget({Key key, this.model}) : super(key: key);
  final BuySellViewModel model;
  @override
  Widget build(BuildContext context) {
    model.showcaseEvent(context);
    return Container(
        child: model.isBusy &&
                model.storageService.isShowCaseView &&
                (model.targetCoinExchangeBalance.unlockedAmount ==
                        Constants.decimalZero ||
                    model.baseCoinExchangeBalance.unlockedAmount < Decimal.one)
            ? Showcase(
                key: model.globalKeyOne,
                description: AppLocalizations.of(context).buySellInstruction1,
                child: buildTransferRow(context, model))
            : buildTransferRow(context, model));
  }

  Row buildTransferRow(BuildContext context, BuySellViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppLocalizations.of(context).balance,
            style: const TextStyle(color: primaryColor, fontSize: 13.0)),
        // First Check if Object is null
        // model.targetCoinExchangeBalance == null ||
        //         model.baseCoinExchangeBalance == null ||  model.baseCoinExchangeBalance.unlockedAmount == null
        //         ||  model.targetCoinExchangeBalance.unlockedAmount == null
        //          ? CupertinoActivityIndicator() :
        //     // If true then to avoid error screen, assign/display 0 in both sell and buy tab

        //     // If false then show the denominator coin balance by again checking buy and sell tab to display currency accordingly

        // model.busy(model.targetCoinExchangeBalance) ||
        //         model.busy(model.baseCoinExchangeBalance) ||
        model.isRefreshBalance
            ? model.refreshBalanceAfterCancellingOrder()
            : Container(
                child: model.bidOrAsk
                    ? Text(
                        NumberUtil.decimalLimiter(
                                    model
                                        .baseCoinExchangeBalance.unlockedAmount,
                                    decimalPrecision: model
                                        .singlePairDecimalConfig.qtyDecimal)
                                .toString() +
                            " " +
                            model.baseCoinName,
                        style: const TextStyle(
                            color: primaryColor, fontSize: 13.0))
                    :
                    // ?  model.targetCoinExchangeBalance.unlockAmount == null?textDemoWidget():
                    Text(
                        NumberUtil.decimalLimiter(
                                    model.targetCoinExchangeBalance
                                        .unlockedAmount,
                                    decimalPrecision: model
                                        .singlePairDecimalConfig.qtyDecimal)
                                .toString() +
                            " " +
                            model.targetCoinName,
                        style: const TextStyle(
                            color: primaryColor, fontSize: 13.0)),
              )
      ],
    );
  }
}
