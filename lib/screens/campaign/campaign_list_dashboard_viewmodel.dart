import 'dart:io';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
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

  @override
  Future futureToRun() {
    return apiService.getCampaignsV2();
  }

  @override
  void onData(data) async {
    campaigns = data;
    log.i('campaigns ${campaigns[1].imageUrl}');

    await checkCampaignEntryStatus();

    log.i('campaign entry ${campaigns[1].hasJoined}');
  }

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
                            '${AppLocalizations.of(context).transactionDetails}')),
                  ),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontWeight: FontWeight.bold),
                  contentTextStyle: TextStyle(color: grey),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      UIHelper.verticalSpaceMedium,
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
                            style: TextStyle(color: red),
                          ),
                        ),
                      )
                    ],
                  ));
        });
  }

  @override
  void onError(error) {
    log.e('error $error');
  }
}
