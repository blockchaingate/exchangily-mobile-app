import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_order.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/payment_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../localizations.dart';
import '../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/shared/ui_helpers.dart';

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
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            UIHelper.verticalSpaceLarge,
                            // Amount text and input row
                            Container(
                              width: MediaQuery.of(context).size.width - 100,
                              child: Row(children: <Widget>[
                                // Expanded(
                                //     flex: 2,
                                //     child: Text(
                                //       AppLocalizations.of(context).amount,
                                //       style: Theme.of(context).textTheme.headline5,
                                //     )),
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
                                          contentPadding: EdgeInsets.only(
                                              top: 35.0,
                                              bottom: 1.0,
                                              left: 15.0,
                                              right: 14.0),
                                          isDense: true,
                                          prefix: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
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
                                            model.busy
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
                                              .quantity,
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
                              width: MediaQuery.of(context).size.width - 100,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context).paymentType,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                    textAlign: TextAlign.start,
                                  ),
                                  // Row that contains both radio buttons
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          UIHelper.horizontalSpaceSmall,
                                          // USD radio button row
                                          Row(
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

                            // On USD radio button select show Bank details container
                            Container(
                              // cannot give padding here as it shows empty container when no radio button selected
                              color: globals.walletCardColor.withAlpha(100),
                              width: MediaQuery.of(context).size.width - 100,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)
                                                .bankName,
                                            textAlign: TextAlign.start,
                                          ),
                                          Text('Key Bank')
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(AppLocalizations.of(context)
                                              .routingNumber),
                                          Text('041001039')
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(AppLocalizations.of(context)
                                                  .bankAccount +
                                              ' #'),
                                          Text('350211024087')
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
                              width: MediaQuery.of(context).size.width - 75,
                              child: Visibility(
                                visible: model.groupValue == 'USDT',
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        'USDT ' +
                                            AppLocalizations.of(context)
                                                .recieveAddress,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      UIHelper.verticalSpaceSmall,
                                      Text(
                                          '0xae397cfc8f67c46d533b844bfff25ad5ae89e63a',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      UIHelper.verticalSpaceSmall,
                                      //Selected Wallet Balance row
                                      model.groupValue != '' &&
                                              model.groupValue != 'USD' &&
                                              model.walletInfo != null
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
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
                              width: MediaQuery.of(context).size.width - 100,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(AppLocalizations.of(context).date,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          Expanded(
                              flex: 2,
                              child: Text(AppLocalizations.of(context).quantity,
                                  style:
                                      Theme.of(context).textTheme.bodyText1)),
                          Expanded(
                            flex: 1,
                            child: Text(AppLocalizations.of(context).status,
                                style: Theme.of(context).textTheme.bodyText1),
                          )
                        ],
                      ),
                      UIHelper.verticalSpaceSmall,
                      // model.busy == true
                      //     ? SizedBox(
                      //         height: 220,
                      //         child: ListView.builder(
                      //           scrollDirection: Axis.vertical,
                      //           itemCount: 8,
                      //           shrinkWrap: true,
                      //           itemBuilder: (context, index) {
                      //             return Container(
                      //               color: model.evenOrOddColor(index),
                      //               padding: EdgeInsets.all(5.0),
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceAround,
                      //                 children: <Widget>[
                      //                   Shimmer.fromColors(
                      //                       baseColor: globals.red,
                      //                       highlightColor: globals.white,
                      //                       child: Text(
                      //                           AppLocalizations.of(context)
                      //                               .loading))
                      //                 ],
                      //               ),
                      //             );
                      //           },
                      //         ))
                      //   :
                      model.busy
                          ? Shimmer.fromColors(
                              baseColor: globals.primaryColor,
                              highlightColor: globals.white,
                              child: Text(
                                AppLocalizations.of(context).loading,
                                style: Theme.of(context).textTheme.bodyText2,
                              ))
                          : model.orderInfoList != null
                              ? Container(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: model.orderInfoList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.all(8.0),
                                        color: model.evenOrOddColor(index),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 3,
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
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  model.updateOrder(
                                                      model.orderInfoList[index]
                                                          .id,
                                                      index);
                                                },
                                                child: Text(
                                                    model.uiOrderStatusList[
                                                        index],
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                      Divider(color: globals.grey)
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
