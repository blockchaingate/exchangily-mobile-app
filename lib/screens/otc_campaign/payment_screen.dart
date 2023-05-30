import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/payment_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/globals.dart' as globals;

class CampaignPaymentScreen extends StatelessWidget {
  const CampaignPaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignPaymentScreenState>(
      onModelReady: (model) {
        model.context = context;
        model.initState();
      },
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            title: Text(FlutterI18n.translate(context, "payment"),
                style: Theme.of(context).textTheme.displaySmall)),
        // Scaffold body container
        body: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                model.isConfirming
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[CircularProgressIndicator()],
                        ),
                      )
                    :
                    // 1st container row Amount and payment type
                    Container(
                        width: MediaQuery.of(context).size.width - 70,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            UIHelper.verticalSpaceLarge,
                            // Amount text and input row
                            Row(children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: 50,
                                  child: TextField(
                                    maxLines: 2,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.ltr,
                                    style: model.checkSendAmount
                                        // && model.amountDouble <= bal
                                        ? Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                        : Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(color: globals.red),
                                    onChanged: (value) {
                                      model.checkAmount(value);
                                    },
                                    controller: model.sendAmountTextController,
                                    decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: globals.primaryColor)),
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide(
                                                width: .5,
                                                color: globals.grey)),
                                        isDense: true,
                                        prefix: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 18.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              // dropdownColor:
                                              //     globals.primaryColor,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                              isDense: true,
                                              value: model.selectedCurrency,
                                              items: model.currencies
                                                  .map((currency) {
                                                return DropdownMenuItem(
                                                    value: currency,
                                                    child: Center(
                                                      child: Text(currency),
                                                    ));
                                              }).toList(),
                                              onChanged:
                                                  (dynamic newValue) async {
                                                model.selectedCurrency =
                                                    newValue;
                                                await model.checkAmount(model
                                                    .sendAmountTextController
                                                    .text);
                                              },
                                            ),
                                          ),
                                        ),
                                        suffix: Column(children: [
                                          Text(FlutterI18n.translate(
                                              context, "tokenQuantity")),
                                          model.busy && model.isTokenCalc
                                              ? const SizedBox(
                                                  width: 10,
                                                  height: 10,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 0.5,
                                                  ))
                                              : Text(model
                                                  .tokenPurchaseQuantity!
                                                  .toStringAsFixed(3))
                                        ]),
                                        filled: true,
                                        fillColor: globals.walletCardColor,
                                        hintText: FlutterI18n.translate(
                                            context, "amount"),
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(color: globals.white54),
                                        border: const OutlineInputBorder(
                                            gapPadding: 1,
                                            borderSide: BorderSide(
                                                color: globals.white))),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    cursorColor: globals.primaryColor,
                                  ),
                                ),
                              ),
                            ]),
                            // Payment type container row
                            Container(
                              color: globals.primaryColor.withAlpha(100),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        FlutterI18n.translate(
                                            context, "paymentType"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  // Row that contains both radio buttons
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        UIHelper.horizontalSpaceSmall,
                                        // USD radio button row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('USD',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                            Radio(
                                                activeColor:
                                                    globals.primaryColor,
                                                onChanged: (dynamic value) {
                                                  model.radioButtonSelection(
                                                      value);
                                                },
                                                groupValue: model.groupValue,
                                                value: 'USD'),
                                          ],
                                        ),

                                        // USDT radio button row
                                        Row(
                                          children: <Widget>[
                                            Text('USDT',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                            Radio(
                                                focusColor: globals.white54,
                                                activeColor:
                                                    globals.primaryColor,
                                                onChanged: (dynamic t) {
                                                  model.radioButtonSelection(t);
                                                },
                                                groupValue: model.groupValue,
                                                value: 'USDT'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // On select USDT show fee
                            model.transportationFee == 0.0
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(FlutterI18n.translate(
                                            context, "gasFee")),
                                        UIHelper.horizontalSpaceSmall,
                                        Text('${model.transportationFee} ETH'),
                                      ],
                                    )),

                            // On USD radio button select show Bank details container
                            Container(
                              // cannot give padding here as it shows empty container when no radio button selected
                              color: globals.walletCardColor.withAlpha(100),

                              child: Visibility(
                                visible: model.groupValue == 'USD',
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            FlutterI18n.translate(
                                                context, "bankWireDetails"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                        ],
                                      ),
                                      UIHelper.verticalSpaceSmall,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              FlutterI18n.translate(
                                                  context, "bankName"),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Text('Key Bank',
                                                textAlign: TextAlign.start),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Text(FlutterI18n.translate(
                                                context, "routingNumber")),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Text('041001039'),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                                '${FlutterI18n.translate(context, "bankAccount")} #'),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Text('350211024087'),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // On USDT radio button select show usdt address container
                            Container(
                              // cannot give padding here as it shows empty container when no radio button selected
                              color: globals.walletCardColor.withAlpha(100),

                              child: Visibility(
                                visible: model.groupValue == 'USDT',
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        FlutterI18n.translate(
                                            context, "receiveAddress"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      UIHelper.verticalSpaceSmall,
                                      isProduction
                                          ? Text(model.prodUsdtWalletAddress)
                                          : Text(model.testUsdtWalletAddress,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall),
                                      UIHelper.verticalSpaceSmall,
                                      //Selected Wallet Balance row
                                      model.groupValue != '' &&
                                              model.groupValue != 'USD'
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                  Expanded(
                                                      flex: 6,
                                                      child: Center(
                                                        child: Text(
                                                          FlutterI18n.translate(
                                                                  context, "available") +
                                                              model
                                                                  .walletBalances
                                                                  .coin! +
                                                              FlutterI18n
                                                                  .translate(
                                                                      context,
                                                                      "balance"),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 5,
                                                      child: Center(
                                                        child: Text(
                                                          '${model.walletBalances.balance}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                        ),
                                                      )),
                                                ])
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            UIHelper.verticalSpaceSmall,
                            Visibility(
                                visible: model.hasErrorMessage,
                                child: Text(model.errorMessage!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium)),
                            UIHelper.verticalSpaceSmall,
                            // Button row container
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(0),
                                          backgroundColor:
                                              globals.secondaryColor,
                                          shape: const StadiumBorder(
                                            side: BorderSide(
                                                color: globals.primaryColor,
                                                width: 2),
                                          ),
                                        ),
                                        child: Text(
                                          FlutterI18n.translate(
                                              context, "cancel"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                  // Confirm button

                                  Expanded(
                                    flex: 4,
                                    child: model.busy
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(0),
                                              backgroundColor:
                                                  globals.secondaryColor,
                                              shape: const StadiumBorder(
                                                side: BorderSide(
                                                    color: globals.primaryColor,
                                                    width: 2),
                                              ),
                                            ),
                                            child: Text(
                                              FlutterI18n.translate(
                                                  context, "confirm"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                            onPressed: () {},
                                          )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0)),
                                            child: Text(
                                                FlutterI18n.translate(
                                                    context, "confirm"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall),
                                            onPressed: () {
                                              model.checkFields(context);
                                            },
                                          ),
                                  )
                                ])
                          ],
                        ),
                      ),
                UIHelper.verticalSpaceSmall,

                // 2nd contianer row Order info

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(
                      color: globals.walletCardColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                          child: Text(
                              FlutterI18n.translate(
                                  context, "orderInformation"),
                              style:
                                  Theme.of(context).textTheme.headlineMedium)),
                      UIHelper.verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          UIHelper.horizontalSpaceSmall,
                          Expanded(
                            flex: 2,
                            child: Text(FlutterI18n.translate(context, "date"),
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  FlutterI18n.translate(context, "quantity"),
                                  textAlign: TextAlign.start,
                                  style:
                                      Theme.of(context).textTheme.bodyLarge)),
                          Expanded(
                            flex: 1,
                            child: Text(
                                FlutterI18n.translate(context, "status"),
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodyLarge),
                          )
                        ],
                      ),
                      UIHelper.verticalSpaceSmall,
                      model.busy && !model.isTokenCalc
                          ? Shimmer.fromColors(
                              baseColor: globals.primaryColor,
                              highlightColor: globals.white,
                              child: Text(
                                FlutterI18n.translate(context, "loading"),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ))
                          : model.orderInfoList != null
                              ? SizedBox(
                                  height: model.orderInfoContainerHeight,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: model.orderInfoList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: model.evenOrOddColor(index),
                                        child: InkWell(
                                          onTap: () {
                                            model.updateOrder(
                                                model.orderInfoList[index].id,
                                                model.orderInfoList[index]
                                                    .quantity!
                                                    .toStringAsFixed(3));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                    model.orderInfoList[index]
                                                        .dateCreated!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge),
                                              ),
                                              UIHelper.horizontalSpaceSmall,
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                    model.orderInfoList[index]
                                                        .quantity!
                                                        .toStringAsFixed(3),
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge),
                                              ),
                                              UIHelper.horizontalSpaceSmall,
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                        model.uiOrderStatusList[
                                                            index],
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge),
                                                    const Icon(
                                                        Icons.info_outline,
                                                        size: 8,
                                                        color: globals.grey),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Text(FlutterI18n.translate(
                                  context, "serverError")),
                    ],
                  ),
                )
              ]),
        ),
        // bottomNavigationBar: BottomNavBar(count: 3),
      ),
    );
  }
}
