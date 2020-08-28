import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/instructions_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/campaign_single.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:exchangilymobileapp/widgets/customSeparator.dart';
import 'package:exchangilymobileapp/widgets/eventMainContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;

class CampaignInstructionScreen extends StatelessWidget {
  const CampaignInstructionScreen({Key key, this.newPage = true})
      : super(key: key);
  final bool newPage;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignInstructionsScreenState>(
      onModelReady: (model) async {
        model.context = context;
        await model.initState();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.navigationService.goBack();
          return new Future(() => true);
        },
        child: SafeArea(
          child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Container(
                constraints: BoxConstraints(
                  minWidth:250
                ),
                margin: EdgeInsets.symmetric(horizontal:30),
                child: RaisedButton(
                  padding: EdgeInsets.all(0),
                  child: Text(
                      AppLocalizations.of(context).tapHereToEnterInCampaign,
                      style: Theme.of(context).textTheme.headline4),
                  onPressed: () {
                    Navigator.pushNamed(context, '/campaignLogin');
                  },
                ),
              ),
              // backgroundColor: Color(0xff000066),
              // backgroundColor: Color(0xff000000),
              appBar: newPage
                  ? AppBar(
                      centerTitle: true,
                      leading: newPage
                          ? IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                model.navigationService.goBack();
                              })
                          : Container(),
                      title: Text(
                          AppLocalizations.of(context).campaignInstructions,
                          style: Theme.of(context).textTheme.headline3))
                  : null,
              key: key,
              body: model.busy
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: Shimmer.fromColors(
                                baseColor: globals.primaryColor,
                                highlightColor: globals.grey,
                                child: Text(
                                    AppLocalizations.of(context)
                                        .checkingAccountDetails,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color: globals.primaryColor))),
                          ),
                        ),
                      ],
                    )
                  : model.hasApiError
                      ? Container(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)
                                      .serverBusy
                                      .toString() +
                                  "...",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : model.campaignInfoList == null
                          ? Container(
                              child: model.sharedService.loadingIndicator())
                          : ListView.builder(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 60),
                              itemCount: model.campaignInfoList.length,
                              itemBuilder: (context, index) {
                                if (model.campaignInfoList[index]["status"] ==
                                    "active")
                                  return Container(
                                      // height: 100,
                                      width: double.infinity,
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CampaignSingle(model
                                                                .campaignInfoList[
                                                            index]["id"])));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: walletCardColor,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                AspectRatio(
                                                  aspectRatio: 2.5 / 1,
                                                  child: CacheImage(
                                                    model.campaignInfoList[
                                                        index]["coverImage"],
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                          model.campaignInfoList[
                                                                      index]
                                                                  [model.lang]
                                                              ["title"],
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline2
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                          model.campaignInfoList[
                                                                          index]
                                                                      [
                                                                      model
                                                                          .lang]
                                                                  [
                                                                  "startDate"] +
                                                              " - " +
                                                              model.campaignInfoList[
                                                                          index]
                                                                      [
                                                                      model
                                                                          .lang]
                                                                  ["endDate"],
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                          model.campaignInfoList[
                                                                      index]
                                                                  [model.lang]
                                                              ["desc"],
                                                          maxLines: 4,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xffeeeeee),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                                else
                                  return Container();
                              })),
        ),
      ),
    );
  }
}
