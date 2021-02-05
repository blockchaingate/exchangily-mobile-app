import 'dart:io';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/bindpay/bindpay_viewmodel.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class BindpayView extends StatelessWidget {
  const BindpayView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PersistentBottomSheetController persistentBottomSheetController;
    return ViewModelBuilder<BindpayViewmodel>.reactive(
      viewModelBuilder: () => BindpayViewmodel(),
      onModelReady: (model) {
        model.context = context;
        model.init();
      },
      builder: (context, model, _) => WillPopScope(
        onWillPop: () async {
          model.onBackButtonPressed();
          return new Future(() => false);
        },
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              print('Close keyboard');
              // persistentBottomSheetController.closed
              //     .then((value) => print(value));
              if (model.isShowBottomSheet) {
                Navigator.pop(context);
                model.setBusy(true);
                model.isShowBottomSheet = false;
                model.setBusy(false);
                print('Close bottom sheet');
              }
            },
            child: Container(
              color: secondaryColor,
              margin: EdgeInsets.only(top: 40),
              child: Stack(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      height: 80,
                      width: 105,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: primaryColor.withAlpha(175),
                                width: 4.0,
                              ),
                              left: BorderSide(
                                  color: secondaryColor.withAlpha(175),
                                  width: 12.0),
                              right: BorderSide(
                                  color: secondaryColor.withAlpha(175),
                                  width: 12.0))),
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/images/bindpay/bindpay.png',
                        color: white,
                      )),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
/*----------------------------------------------------------------------------------------------------
                                        Coin list dropdown
----------------------------------------------------------------------------------------------------*/

//                       InkWell(
//                         onTap: () {
// model.test();
//                         },
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('Choose Coin'),
//                               Icon(Icons.arrow_drop_down)
//                             ]),
//                       ),
                      Platform.isIOS
                          ? CoinListBottomSheetFloatingActionButton(
                              model: model)
                          // Container(
                          //     color: walletCardColor,
                          //     child: CupertinoPicker(
                          //         diameterRatio: 1.3,
                          //         offAxisFraction: 5,
                          //         scrollController: model.scrollController,
                          //         itemExtent: 50,
                          //         onSelectedItemChanged: (int newValue) {
                          //           model.updateSelectedTickernameIOS(newValue);
                          //         },
                          //         children: [
                          //           for (var i = 0; i < model.coins.length; i++)
                          //             Container(
                          //               margin: EdgeInsets.only(left: 10),
                          //               child: Row(
                          //                 children: [
                          //                   Text(
                          //                       model.coins[i]['tickerName']
                          //                           .toString(),
                          //                       style: Theme.of(context)
                          //                           .textTheme
                          //                           .headline5),
                          //                   UIHelper.horizontalSpaceSmall,
                          //                   Text(
                          //                     model.coins[i]['quantity']
                          //                         .toString(),
                          //                     style: Theme.of(context)
                          //                         .textTheme
                          //                         .headline5
                          //                         .copyWith(color: grey),
                          //                   )
                          //                 ],
                          //               ),
                          //             ),
                          //           //    })
                          //           model.coins.length > 0
                          //               ? Container()
                          //               : SizedBox(
                          //                   width: double.infinity,
                          //                   child: Center(
                          //                     child: Text(
                          //                       AppLocalizations.of(context)
                          //                           .insufficientBalance,
                          //                       style: Theme.of(context)
                          //                           .textTheme
                          //                           .bodyText2,
                          //                     ),
                          //                   ),
                          //                 ),
                          //         ]),
                          //   )
                          : Container(
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                    color: model.exchangeBalances.isEmpty
                                        ? Colors.transparent
                                        : primaryColor,
                                    style: BorderStyle.solid,
                                    width: 0.50),
                              ),
                              child: DropdownButton(
                                  underline: SizedBox.shrink(),
                                  elevation: 5,
                                  isExpanded: true,
                                  icon: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.arrow_drop_down),
                                  ),
                                  iconEnabledColor: primaryColor,
                                  iconDisabledColor:
                                      model.exchangeBalances.isEmpty
                                          ? secondaryColor
                                          : grey,
                                  iconSize: 30,
                                  hint: Padding(
                                    padding: model.exchangeBalances.isEmpty
                                        ? EdgeInsets.all(0)
                                        : const EdgeInsets.only(left: 10.0),
                                    child: model.exchangeBalances.isEmpty
                                        ? ListTile(
                                            dense: true,
                                            leading: Icon(
                                              Icons.account_balance_wallet,
                                              color: red,
                                              size: 18,
                                            ),
                                            title: Text(
                                                AppLocalizations.of(context)
                                                    .noCoinBalance,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2),
                                            subtitle: Text(
                                                AppLocalizations.of(context)
                                                    .transferFundsToExchangeUsingDepositButton,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2))
                                        : Text(
                                            AppLocalizations.of(context)
                                                .selectCoin,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                  ),
                                  value: model.tickerName,
                                  onChanged: (newValue) {
                                    model.updateSelectedTickername(newValue);
                                  },
                                  items: model.exchangeBalances.map(
                                    (coin) {
                                      return DropdownMenuItem(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: [
                                              Text(coin.ticker.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                              UIHelper.horizontalSpaceSmall,
                                              Text(
                                                coin.unlockedAmount.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    .copyWith(
                                                        color: grey,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        value: coin.ticker,
                                      );
                                    },
                                  ).toList()),
                            ),

/*----------------------------------------------------------------------------------------------------
                                        Receiver Address textfield
----------------------------------------------------------------------------------------------------*/

                      UIHelper.verticalSpaceSmall,
                      TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  tooltip:
                                      AppLocalizations.of(context).scanBarCode,
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: white,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    model.scanBarcode();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  }),
                              suffixIcon: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.content_paste,
                                    color: green,
                                    size: 18,
                                  ),
                                  onPressed: () => model.contentPaste()),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0XFF871fff), width: 0.5)),
                              hintText:
                                  AppLocalizations.of(context).recieveAddress,
                              hintStyle: Theme.of(context).textTheme.headline5),
                          controller: model.addressController,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontWeight: FontWeight.bold)),

/*----------------------------------------------------------------------------------------------------
                                        Transfer amount textfield
----------------------------------------------------------------------------------------------------*/

                      UIHelper.verticalSpaceSmall,
                      TextField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0XFF871fff), width: 0.5)),
                              hintText:
                                  AppLocalizations.of(context).enterAmount,
                              hintStyle: Theme.of(context).textTheme.headline5),
                          controller: model.amountController,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontWeight: FontWeight.bold)),
                      UIHelper.verticalSpaceMedium,
/*----------------------------------------------------------------------------------------------------
                                        Transfer - Receive Button Row
----------------------------------------------------------------------------------------------------*/

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration:
                                  model.sharedService.gradientBoxDecoration(),
                              child: FlatButton(
                                textColor: Colors.white,
                                onPressed: () {
                                  model.isBusy
                                      ? print('busy')
                                      : model.transfer();
                                },
                                child: Text(
                                    AppLocalizations.of(context).tranfser,
                                    style:
                                        Theme.of(context).textTheme.headline4),
                              ),
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,

/*----------------------------------------------------------------------------------------------------
                                            Receive Button
----------------------------------------------------------------------------------------------------*/

                          Expanded(
                            child: OutlineButton(
                              borderSide: BorderSide(color: primaryColor),
                              padding: EdgeInsets.all(15),
                              color: primaryColor,
                              textColor: Colors.white,
                              onPressed: () {
                                model.isBusy
                                    ? print('busy')
                                    : model.showBarcode();
                              },
                              child: Text(AppLocalizations.of(context).receive,
                                  style: Theme.of(context).textTheme.headline4),
                            ),
                          ),
                          IconButton(
                            //  borderSide: BorderSide(color: primaryColor),
                            padding: EdgeInsets.all(15),
                            color: primaryColor,
                            // textColor: Colors.white,
                            onPressed: () async {
                              await model.getBindpayTxs();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TxHistoryView(
                                          transactionHistory:
                                              model.transactionHistory)));
                            },
                            icon: Icon(Icons.history, color: white, size: 24),
                            // child: Text('History',
                            //     style: Theme.of(context).textTheme.headline4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

/*----------------------------------------------------------------------------------------------------
                                        Stack loading container
----------------------------------------------------------------------------------------------------*/

                model.isBusy
                    ? Align(
                        alignment: Alignment.center,
                        child: model.sharedService
                            .stackFullScreenLoadingIndicator())
                    : Container()
              ]),
            ),
          ),
          bottomNavigationBar: BottomNavBar(count: 2),
        ),
      ),
    );
  }
}

class CoinListBottomSheetFloatingActionButton extends StatelessWidget {
  const CoinListBottomSheetFloatingActionButton({Key key, this.model})
      : super(key: key);
  final BindpayViewmodel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: FloatingActionButton(
          backgroundColor: secondaryColor,
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            width: 400,
            height: 220,
            //  color: secondaryColor,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: model.exchangeBalances.isEmpty
                    ? Text(AppLocalizations.of(context).noCoinBalance)
                    : Text(
                        //model.tickerName == ''
                        // ? AppLocalizations.of(context).selectCoin
                        // :
                        model.tickerName),
              ),
              Text(model.quantity == 0.0 ? '' : model.quantity.toString()),
              model.exchangeBalances.isNotEmpty
                  ? Icon(Icons.arrow_drop_down)
                  : Container()
            ]),
          ),
          onPressed: () {
            if (model.exchangeBalances.isNotEmpty)
              model.coinListBottomSheet(context);
          }),
    );
  }
}

// transaction history

class TxHistoryView extends StatelessWidget {
  final transactionHistory;

  TxHistoryView({this.transactionHistory});
  @override
  Widget build(BuildContext context) {
    SharedService sharedService = locator<SharedService>();
    /*----------------------------------------------------------------------
                    Copy Order
----------------------------------------------------------------------*/

    copyAddress(String txId) {
      Clipboard.setData(new ClipboardData(text: txId));
      sharedService.alertDialog(AppLocalizations.of(context).transactionId,
          AppLocalizations.of(context).copiedSuccessfully,
          isWarning: false);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).transactionHistory,
            style: Theme.of(context).textTheme.headline3),
        backgroundColor: secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(4.0),
            child: Column(
              children: <Widget>[
                for (var transaction in transactionHistory.reversed)
                  Card(
                    elevation: 4,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      color: walletCardColor,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('${transaction.tickerName}',
                                    style:
                                        Theme.of(context).textTheme.subtitle2),
                                // icon
                                Icon(
                                  Icons.arrow_upward,
                                  size: 24,
                                  color: sellPrice,
                                ),

                                Text(
                                  AppLocalizations.of(context).bindpay,
                                  style: Theme.of(context).textTheme.subtitle2,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          Container(
                            // width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: Text('${transaction.txId}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                  ),
                                ),
                                Visibility(
                                  visible: transaction.txId != '',
                                  child: RichText(
                                    text: TextSpan(
                                        text: AppLocalizations.of(context)
                                            .taphereToCopyTxId,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .copyWith(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: primaryColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            copyAddress(transaction.txId);
                                          }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    transaction.date.substring(0, 19),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          UIHelper.horizontalSpaceSmall,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations.of(context).quantity,
                                  style: Theme.of(context).textTheme.subtitle2),
                              Text(
                                transaction.quantity.toStringAsFixed(
                                    // model
                                    //   .decimalConfig
                                    //   .quantityDecimal
                                    2),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w400),
                              )
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
