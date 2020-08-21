import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/payment_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../localizations.dart';
import '../../shared/globals.dart' as globals;

class CampaignPaymentScreen extends StatelessWidget {
  const CampaignPaymentScreen({Key key}) : super(key: key);

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
            title: Text(AppLocalizations.of(context).payment,
                style: Theme.of(context).textTheme.headline3)),
        // Scaffold body container
        body: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                model.isConfirming
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[CircularProgressIndicator()],
                        ),
                      )
                    :
                    // 1st container row Amount and payment type
                    Container(
                        width: MediaQuery.of(context).size.width - 70,
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            UIHelper.verticalSpaceLarge,
                            // Amount text and input row
                            Container(
                              child: Row(children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: SizedBox(
                                    height: 50,
                                    child: TextField(
                                      maxLines: 2,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.ltr,
                                      style: model.checkSendAmount
                                          // && model.amountDouble <= bal
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline5
                                          : Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: globals.red),
                                      onChanged: (value) {
                                        model.checkAmount(value);
                                      },
                                      controller:
                                          model.sendAmountTextController,
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: globals.primaryColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(
                                                  width: .5,
                                                  color: globals.grey)),
                                          isDense: true,
                                          prefix: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                // dropdownColor:
                                                //     globals.primaryColor,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
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
                                                onChanged: (newValue) async {
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
                                            Text(AppLocalizations.of(context)
                                                .tokenQuantity),
                                            model.busy && model.isTokenCalc
                                                ? SizedBox(
                                                    width: 10,
                                                    height: 10,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 0.5,
                                                    ))
                                                : Text(model
                                                    .tokenPurchaseQuantity
                                                    .toStringAsFixed(3))
                                          ]),
                                          filled: true,
                                          fillColor: globals.walletCardColor,
                                          hintText: AppLocalizations.of(context)
                                              .amount,
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(color: globals.white54),
                                          border: OutlineInputBorder(
                                              gapPadding: 1,
                                              borderSide: BorderSide(
                                                  color: globals.white))),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      cursorColor: globals.primaryColor,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
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
                                        AppLocalizations.of(context)
                                            .paymentType,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  // Row that contains both radio buttons
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                      .headline6),
                                              Radio(
                                                  activeColor:
                                                      globals.primaryColor,
                                                  onChanged: (value) {
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
                                                      .headline6),
                                              Radio(
                                                  focusColor: globals.white54,
                                                  activeColor:
                                                      globals.primaryColor,
                                                  onChanged: (t) {
                                                    model.radioButtonSelection(
                                                        t);
                                                  },
                                                  groupValue: model.groupValue,
                                                  value: 'USDT'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // On select USDT show fee
                            model.transportationFee == 0.0
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.all(3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(AppLocalizations.of(context)
                                            .gasFee),
                                        UIHelper.horizontalSpaceSmall,
                                        Text(
                                            model.transportationFee.toString() +
                                                '\ ETH'),
                                      ],
                                    )),

                            // On USD radio button select show Bank details container
                            Container(
                              // cannot give padding here as it shows empty container when no radio button selected
                              color: globals.walletCardColor.withAlpha(100),

                              child: Visibility(
                                visible: model.groupValue == 'USD',
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)
                                                .bankWireDetails,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
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
                                              AppLocalizations.of(context)
                                                  .bankName,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Expanded(
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
                                            child: Text(
                                                AppLocalizations.of(context)
                                                    .routingNumber),
                                          ),
                                          Expanded(
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
                                                AppLocalizations.of(context)
                                                        .bankAccount +
                                                    ' #'),
                                          ),
                                          Expanded(
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
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .recieveAddress,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      UIHelper.verticalSpaceSmall,
                                      isProduction
                                          ? Text(model.prodUsdtWalletAddress)
                                          : Text(model.testUsdtWalletAddress,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2),
                                      UIHelper.verticalSpaceSmall,
                                      //Selected Wallet Balance row
                                      model.groupValue != '' &&
                                              model.groupValue != 'USD' &&
                                              model.walletInfo != null
                                          ? Container(
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Expanded(
                                                        flex: 6,
                                                        child: Center(
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                        context)
                                                                    .available +
                                                                model.walletInfo
                                                                    .tickerName +
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .balance,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                        )),
                                                    Expanded(
                                                        flex: 5,
                                                        child: Center(
                                                          child: Text(
                                                            '${model.walletInfo.availableBalance}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                        )),
                                                  ]),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            UIHelper.verticalSpaceSmall,
                            Visibility(
                                visible: model.hasErrorMessage,
                                child: Text(model.errorMessage,
                                    style:
                                        Theme.of(context).textTheme.bodyText2)),
                            UIHelper.verticalSpaceSmall,
                            // Button row container
                            Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: RaisedButton(
                                          padding: EdgeInsets.all(0),
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: globals.primaryColor,
                                                  width: 2)),
                                          color: globals.secondaryColor,
                                          child: Text(
                                            AppLocalizations.of(context).cancel,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
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
                                          ? RaisedButton(
                                              padding: EdgeInsets.all(0),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .confirm,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5),
                                              onPressed: () {})
                                          : RaisedButton(
                                              padding: EdgeInsets.all(0),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .confirm,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5),
                                              onPressed: () {
                                                //  model.getCampaignOrdeList();
                                                model.checkFields(context);
                                                // model.createCampaignOrder(
                                                //     '0x41d9b291469c7d9046e8154b04b3d6e1e76c910bba9fce6acf73298d79984cfd',
                                                //     15511);
                                                // if (model.exgWalletAddress != null &&
                                                //     model.exgWalletAddress != '') {
                                                //   model.getCampaignOrdeList();
                                                // } else {
                                                //   model.getExgWalletAddr();
                                                //   print(
                                                //       'Exg wallet address was missing, so getting it now');
                                                // }
                                              },
                                            ),
                                    )
                                  ]),
                            )
                          ],
                        ),
                      ),
                UIHelper.verticalSpaceSmall,

                // 2nd contianer row Order info

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                      color: globals.walletCardColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                          child: Text(
                              AppLocalizations.of(context).orderInformation,
                              style: Theme.of(context).textTheme.headline4)),
                      UIHelper.verticalSpaceSmall,
                      Container(
                        //  padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            UIHelper.horizontalSpaceSmall,
                            Expanded(
                              flex: 2,
                              child: Text(AppLocalizations.of(context).date,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(
                                    AppLocalizations.of(context).quantity,
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodyText1)),
                            Expanded(
                              flex: 1,
                              child: Text(AppLocalizations.of(context).status,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1),
                            )
                          ],
                        ),
                      ),
                      UIHelper.verticalSpaceSmall,
                      model.busy && !model.isTokenCalc
                          ? Shimmer.fromColors(
                              baseColor: globals.primaryColor,
                              highlightColor: globals.white,
                              child: Text(
                                AppLocalizations.of(context).loading,
                                style: Theme.of(context).textTheme.bodyText2,
                              ))
                          : model.orderInfoList != null
                              ? Container(
                                  height: model.orderInfoContainerHeight,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: model.orderInfoList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.all(8.0),
                                        color: model.evenOrOddColor(index),
                                        child: InkWell(
                                          onTap: () {
                                            model.updateOrder(
                                                model.orderInfoList[index].id,
                                                model.orderInfoList[index]
                                                    .quantity
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
                                                        .dateCreated,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                              ),
                                              UIHelper.horizontalSpaceSmall,
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                    model.orderInfoList[index]
                                                        .quantity
                                                        .toStringAsFixed(3),
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
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
                                                            .bodyText1),
                                                    Icon(Icons.info_outline,
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
                              : Container(
                                  child: Text(AppLocalizations.of(context)
                                      .serverError)),
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
