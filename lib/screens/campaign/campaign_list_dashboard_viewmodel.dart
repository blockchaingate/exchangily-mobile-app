import 'dart:io';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart' as CoinUtil;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_v2/campaign_v2_model.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';

class CampaignListDashboardViewModel extends FutureViewModel {
  final log = getLogger('CampaignListDashboardViewModel');
  final apiService = locator<ApiService>();
  final sharedService = locator<SharedService>();
  final walletDatabaseService = locator<WalletDataBaseService>();
  List<CampaignV2> campaigns = [];
  bool isDialogUp = false;
  BuildContext context;
  bool isDUSD = false;
  int gasPrice = environment["chains"]["ETH"]["gasPrice"];
  int gasLimit = environment["chains"]["ETH"]["gasLimitToken"];
  double fee = 0.0;
  String _groupValue;
  get groupValue => _groupValue;

  String exgWalletAddress = '';
  String usdtOfficialAddress = '';
  String dusdOfficialAddress = '';

  String usdtWalletAddress = '';
  double usdtWalletBalance = 0.0;

  String dusdWalletAddress = '';
  double dusdWalletBalance = 0.0;

  @override
  Future futureToRun() {
    return apiService.getCampaignsV2();
  }

  @override
  void onData(data) async {
    campaigns = data;

    await checkCampaignEntryStatus();
    await getExgWalletAddr();
    // setBusy(true);
    usdtOfficialAddress = CoinUtil.getOfficalAddress('USDT', tokenType: 'ETH');
    dusdOfficialAddress = CoinUtil.getOfficalAddress('DUSD');
    log.e(
        'usdtOfficialAddress $usdtOfficialAddress -- dusdOfficialAddress $dusdOfficialAddress');
    // setBusy(false);
  }

  void init() {
    _groupValue = 'USDT';
    getWalletBalance();
  }

/*----------------------------------------------------------------------
                    Get Single wallet balance
----------------------------------------------------------------------*/
  getWalletBalance() async {
    setBusy(true);
    // get USDT wallet address
    if (usdtWalletAddress.isEmpty)
      await walletDatabaseService
          .getBytickerName('USDT')
          .then((wallet) => usdtWalletAddress = wallet.address);
    log.i('usdtWalletAddress $usdtWalletAddress');
    // get DUSD wallet address
    if (dusdWalletAddress.isEmpty)
      await walletDatabaseService
          .getBytickerName('DUSD')
          .then((wallet) => dusdWalletAddress = wallet.address);
    log.i('dusdWalletAddress $dusdWalletAddress');
    String fabAddress = await sharedService.getFABAddressFromWalletDatabase();

    // Get single wallet balance
    await apiService
        .getSingleWalletBalance(fabAddress, groupValue,
            groupValue == 'USDT' ? usdtWalletAddress : dusdWalletAddress)
        .then((walletBalance) {
      if (walletBalance != null) {
        log.w(walletBalance[0].balance);
        groupValue == 'USDT'
            ? usdtWalletBalance = walletBalance[0].balance
            : dusdWalletBalance = walletBalance[0].balance;
      }
    }).catchError((err) {
      log.e(err);
      setBusy(false);
      throw Exception(err);
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Check Campaign Entry Status
----------------------------------------------------------------------*/

  checkCampaignEntryStatus() async {
    setBusy(true);
    String exgAddress = '';
    await walletDatabaseService
        .getBytickerName('EXG')
        .then((res) => exgAddress = res.address);
    campaigns.forEach((campaign) async {
      await apiService
          .getCampaignsEntryStatus(campaign.id, exgAddress)
          .then((res) {
        log.w('checkCampaignEntryStatus res $res');
        setBusy(true);
        if (res != null) {
          campaign.hasJoined = true;
        }
        setBusy(false);
      });
    });
  }

/*----------------------------------------------------------------------
                    Get exg wallet address
----------------------------------------------------------------------*/

  getExgWalletAddr() async {
    // Get coin details which we are making transaction through like USDT
    exgWalletAddress = await sharedService.getExgAddressFromWalletDatabase();

    log.i('Exg wallet address $exgWalletAddress');
  }

/*----------------------------------------------------------------------
                Radio button selection
----------------------------------------------------------------------*/

  radioButtonSelection(value) async {
    setBusy(true);
    print(value);
    //  orderInfoContainerHeight = 510;
    fee = 0.0;
    _groupValue = value;
    fee = gasPrice * gasLimit / 1e9;

    FocusScope.of(context).requestFocus(FocusNode());

    setBusy(false);
  }

/*----------------------------------------------------------------------
                Tx Detail Dialog
----------------------------------------------------------------------*/
  placeOrderDialog(int campaignId) {
    print('lll');
    setBusy(true);
    isDialogUp = true;
    log.i('placeOrderDialog isDialogUp ${isDialogUp}');
    setBusy(false);

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Platform.isIOS
                ? Theme(
                    data: ThemeData.dark(),
                    child: CupertinoAlertDialog(
                      title: Container(
                        child: Center(
                            child: Text(
                          '${AppLocalizations.of(context).orderDetails}',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              color: primaryColor, fontWeight: FontWeight.w500),
                        )),
                      ),
                      content: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            UIHelper.verticalSpaceSmall,
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Amount',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.blue),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '2000 USD',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Pay by:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.blue),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Radio(
                                        // title: Text('USDT'),
                                        groupValue: null,
                                        value: null,
                                        onChanged: (Null value) {},
                                      ),
                                      // RadioListTile(
                                      //   title: Text('DUSD'),
                                      //   groupValue: null,
                                      //   value: null,
                                      //   onChanged: (Null value) {},
                                      // ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.only(left: 5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                child: Text(
                                  AppLocalizations.of(context).confirm,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : AlertDialog(
                    titlePadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.all(5.0),
                    elevation: 5,
                    backgroundColor: walletCardColor.withOpacity(0.85),
                    title: Container(
                      padding: EdgeInsets.all(10.0),
                      color: secondaryColor.withOpacity(0.5),
                      child: Center(
                          child: Text(
                              '${AppLocalizations.of(context).orderDetails}')),
                    ),
                    titleTextStyle: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.bold),
                    contentTextStyle: TextStyle(color: grey),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        UIHelper.verticalSpaceSmall,
                        Row(
                          children: [
                            UIHelper.horizontalSpaceSmall,
                            UIHelper.horizontalSpaceSmall,
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Amount:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.blue),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                '2000 USD',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),

                        // Payment type container row
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                AppLocalizations.of(context).paymentType,
                                style: Theme.of(context).textTheme.headline5,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Row that contains both radio buttons
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  UIHelper.horizontalSpaceSmall,
                                  // USD radio button row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('DUSD',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Radio(
                                          activeColor: primaryColor,
                                          onChanged: (value) {
                                            state(() {
                                              radioButtonSelection(value);
                                              //   contentText = "Changed Content of Dialog";
                                            });
                                          },
                                          groupValue: groupValue,
                                          value: 'DUSD'),
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
                                          focusColor: white54,
                                          activeColor: primaryColor,
                                          onChanged: (value) {
                                            state(() {
                                              radioButtonSelection(value);
                                              //   contentText = "Changed Content of Dialog";
                                            });
                                          },
                                          groupValue: groupValue,
                                          value: 'USDT'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Balance row
                        Row(
                          children: [
                            UIHelper.horizontalSpaceSmall,
                            UIHelper.horizontalSpaceSmall,
                            Expanded(
                              flex: 2,
                              child: Text(
                                '$groupValue ${AppLocalizations.of(context).balance}:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.blue),
                              ),
                            ),
                            UIHelper.horizontalSpaceMedium,
                            Expanded(
                              flex: 3,
                              child: Text(
                                groupValue == 'USDT'
                                    ? usdtWalletBalance.toString()
                                    : dusdWalletBalance.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),

                        // Official address
                        UIHelper.verticalSpaceSmall,
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .officialAddress,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.w500)),
                                ),
                                Text(groupValue == 'DUSD'
                                    ? dusdOfficialAddress
                                    : usdtOfficialAddress),
                              ],
                            )),
                        UIHelper.verticalSpaceSmall,
                        Center(
                          child: TextButton(
                            onPressed: () {
                              setBusy(true);
                              Navigator.of(context).pop();
                              isDialogUp = false;
                              setBusy(false);
                            },
                            child: Text(
                              AppLocalizations.of(context).confirm,
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        )
                      ],
                    ));
          });
        });
  }

  @override
  void onError(error) {
    log.e('error $error');
  }
}
