import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_order.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/payment_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
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
            title:
                Text('Payment', style: Theme.of(context).textTheme.headline3)),
        // Scaffold body container
        body: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // 1st container row Amount and payment type
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    UIHelper.horizontalSpaceLarge,
                    // Amount text and input row
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Row(children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Text(
                              'Amount',
                              style: Theme.of(context).textTheme.headline5,
                            )),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            //  width: 50,
                            height: 45,
                            child: TextField(
                              style: model.checkSendAmount
                                  // && model.amountDouble <= bal
                                  ? Theme.of(context).textTheme.headline5
                                  : Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(color: globals.red),
                              onChanged: (value) {
                                model.checkAmount(value);
                              },
                              controller: model.sendAmountTextController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: globals.white,
                                  isDense: true,
                                  hintText: 'Enter the amount',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: globals.primaryColor),
                                  border: OutlineInputBorder(
                                      gapPadding: 1,
                                      borderSide:
                                          BorderSide(color: globals.white))),
                              keyboardType: TextInputType.number,
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
                            'Payment Type',
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.start,
                          ),
                          // Row that contains both radio buttons
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // USD radio button row
                                  Row(
                                    children: <Widget>[
                                      Text('USD',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Radio(
                                          activeColor: globals.primaryColor,
                                          onChanged: (value) {
                                            model.radioButtonSelection(value);
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
                                          activeColor: globals.primaryColor,
                                          onChanged: (t) {
                                            model.radioButtonSelection(t);
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Bank Details',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Bank Name',
                                    textAlign: TextAlign.start,
                                  ),
                                  Text('Key Bank')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Routing Numnber'),
                                  Text('041001039')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Bank Account #'),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'USDT Recieve Address',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              UIHelper.horizontalSpaceSmall,
                              Text('0xae397cfc8f67c46d533b844bfff25ad5ae89e63a',
                                  style: Theme.of(context).textTheme.bodyText1),
                              UIHelper.horizontalSpaceSmall,
                              //Selected Wallet Balance row
                              model.groupValue != '' &&
                                      model.groupValue != 'USD' &&
                                      model.walletInfo != null
                                  ? Container(
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 6,
                                                child: Center(
                                                  child: Text(
                                                    'Available ${model.walletInfo.tickerName} Balance',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                )),
                                            Expanded(
                                                flex: 5,
                                                child: Center(
                                                  child: Text(
                                                    '${model.walletInfo.availableBalance}',
                                                    style: Theme.of(context)
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

                    UIHelper.horizontalSpaceSmall,
                    Visibility(
                        visible: model.errorMessage != '',
                        child: model.busy == true
                            ? Text('Loading...')
                            : Text(model.errorMessage,
                                style: Theme.of(context).textTheme.bodyText2)),
                    UIHelper.horizontalSpaceSmall,
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
                                padding: const EdgeInsets.only(right: 5.0),
                                child: RaisedButton(
                                  padding: EdgeInsets.all(0),
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                          color: globals.primaryColor,
                                          width: 2)),
                                  color: globals.secondaryColor,
                                  child: Text(
                                    AppLocalizations.of(context).cancel,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/campaignDashboard');
                                  },
                                ),
                              ),
                            ),
                            // Confirm button
                            Expanded(
                              flex: 4,
                              child: RaisedButton(
                                padding: EdgeInsets.all(0),
                                child: Text(
                                    AppLocalizations.of(context).confirm,
                                    style:
                                        Theme.of(context).textTheme.headline5),
                                onPressed: () {
                                  //  model.checkFields(context);
                                  // model.createCampaignOrder(
                                  //     '0x41d9b291469c7d9046e8154b04b3d6e1e76c910bba9fce6acf73298d79984cfd',
                                  //     15511);
                                  if (model.exgWalletAddress != null &&
                                      model.exgWalletAddress != '') {
                                    model.getCampaignOrdeList();
                                  } else {
                                    model.getExgWalletAddr();
                                    print(
                                        'Exg wallet address was missing, so getting it now');
                                  }
                                },
                              ),
                            )
                          ]),
                    )
                  ],
                ),
              ),

              // 2nd contianer row Order info
              Container(
                margin: EdgeInsets.all(10.0),
                color: globals.walletCardColor,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Center(
                        child: Text('Order Information',
                            style: Theme.of(context).textTheme.headline4)),
                    UIHelper.horizontalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Time Stamp',
                            style: Theme.of(context).textTheme.bodyText1),
                        Text('Amount',
                            style: Theme.of(context).textTheme.bodyText1),
                        Text('Status',
                            style: Theme.of(context).textTheme.bodyText1)
                      ],
                    ),
                    UIHelper.horizontalSpaceSmall,
                    model.busy == true
                        ? SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: 8,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: model.evenOrOddColor(index),
                                  padding: EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                              child: Shimmer.fromColors(
                                            baseColor: globals.red,
                                            highlightColor: globals.white,
                                            child: Text('2020-03-15',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                          ))),
                                      Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                              child: Shimmer.fromColors(
                                            baseColor: globals.red,
                                            highlightColor: globals.white,
                                            child: Text('1550',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                          ))),
                                      Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                              child: Shimmer.fromColors(
                                            baseColor: globals.red,
                                            highlightColor: globals.white,
                                            child: Text('1',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                          )))
                                    ],
                                  ),
                                );
                              },
                            ))
                        : SizedBox(
                            height: MediaQuery.of(context).size.height - 510,
                            child: model.transactionInfoList != null
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: model.transactionInfoList.length,
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
                                                  model
                                                      .transactionInfoList[
                                                          index]
                                                      .dateCreated,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                  model
                                                      .transactionInfoList[
                                                          index]
                                                      .amount
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                  model
                                                      .transactionInfoList[
                                                          index]
                                                      .status,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
                          ),
                    Divider(color: globals.grey)
                  ],
                ),
              )
            ]),
        // bottomNavigationBar: BottomNavBar(count: 3),
      ),
    );
  }
}
