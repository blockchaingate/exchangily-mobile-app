import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:exchangilymobileapp/screens/announcement/anncounceList.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WalletDashboardTotalBalanceWidget extends StatelessWidget {
  const WalletDashboardTotalBalanceWidget({Key key, this.model})
      : super(key: key);
  final WalletDashboardViewModel model;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
          bottom: -20,
          child: Card(
            elevation: model.elevation,
            color: isProduction ? walletCardColor : red.withAlpha(200),
            child: Container(
              //duration: Duration(milliseconds: 250),
              width: 270,
              //model.totalBalanceContainerWidth,
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  //Announcement Widget
                  model.announceList == null || model.announceList.length < 1
                      ? Image.asset(
                          'assets/images/wallet-page/dollar-sign.png',
                          width: 40,
                          height: 40,
                          color: iconBackgroundColor, // image background color
                          fit: BoxFit.cover,
                        )
                      : Stack(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              child: Center(
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: InkWell(
                                      onTap: () {
                                        if (!model.hasApiError)
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AnnouncementList()))
                                              .then((value) {
                                            model.updateAnnce();
                                          });
                                        else
                                          print("API has error");
                                      },
                                      child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: iconBackgroundColor,
                                          ),
                                          child: Icon(Icons.mail_outline,
                                              color: walletCardColor)),
                                    )),
                              ),
                            ),
                            model.unreadMsgNum < 1
                                ? Container()
                                : Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red),
                                      child: Center(
                                        child: Text(
                                          // model
                                          //     .announceList
                                          //     .length
                                          //     .toString(),
                                          model.unreadMsgNum.toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ))
                          ],
                        ), //Announcement Widget end
                  UIHelper.horizontalSpaceSmall,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).totalBalance,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontWeight: FontWeight.w400)),
                        UIHelper.verticalSpaceSmall,
                        model.isBusy
                            ? Shimmer.fromColors(
                                baseColor: primaryColor,
                                highlightColor: white,
                                child: Text(
                                  '${model.totalUsdBalance} USD',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            : Text('${model.totalUsdBalance} USD',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        await model.refreshBalance();
                      },
                      child: model.isBusy
                          ? Container(
                              margin: EdgeInsets.only(left: 3.0),
                              child: SizedBox(
                                child: model.sharedService.loadingIndicator(),
                                width: 16,
                                height: 16,
                              ),
                            )
                          : Icon(
                              Icons.refresh,
                              color: white,
                              size: 28,
                            ))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
