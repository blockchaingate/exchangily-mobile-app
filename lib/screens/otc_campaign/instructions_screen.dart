import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/instructions_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/campaign_single.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:exchangilymobileapp/widgets/loading_animation.dart';
import 'package:exchangilymobileapp/widgets/video_page.dart';
import 'package:exchangilymobileapp/widgets/web_page.dart';
import 'package:exchangilymobileapp/widgets/youtube.dart';
import 'package:exchangilymobileapp/widgets/youtube_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          model.onBackButtonPressed();
          return Future(() => false);
        },
        child: SafeArea(
          child: Scaffold(
              // appBar: AppBar(title: Text("instruction")),

              // floatingActionButtonLocation:
              //     FloatingActionButtonLocation.centerDocked,
              // floatingActionButton: Container(
              //   decoration: BoxDecoration(
              //       color: white.withOpacity(.90),
              //       borderRadius: BorderRadius.circular(25),
              //       border: Border.all(
              //           color: primaryColor.withAlpha(145), width: 1.5)),
              //   constraints: BoxConstraints(minWidth: 250),
              //   margin: EdgeInsets.symmetric(horizontal: 60, vertical: 80),
              //   child: FlatButton(
              //     //   borderSide: BorderSide(color: primaryColor),
              //     // color: primaryColor,
              //     padding: EdgeInsets.all(0),
              //     child: Text(
              //         AppLocalizations.of(context).tapHereToEnterInCampaign,
              //         style: Theme.of(context).textTheme.headline5.copyWith(
              //             color: primaryColor, fontWeight: FontWeight.bold)),
              //     onPressed: () {
              //       model.busy
              //           ? print('loading...')
              //           : Navigator.pushNamed(context, '/campaignLogin');
              //     },
              //   ),
              // ),
              key: key,
              body: model.busy
                  ? const LoadingGif()

                  // Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Container(
                  //         child: Center(
                  //           child: Shimmer.fromColors(
                  //               baseColor: globals.primaryColor,
                  //               highlightColor: globals.grey,
                  //               child: Text(
                  //                   AppLocalizations.of(context)
                  //                       .checkingAccountDetails,
                  //                   style: Theme.of(context)
                  //                       .textTheme
                  //                       .bodyText1
                  //                       .copyWith(
                  //                           color: globals.primaryColor))),
                  //         ),
                  //       ),
                  //     ],
                  //   )
                  : model.hasApiError
                      ? Container(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)
                                      .serverBusy
                                      .toString() +
                                  "...",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : model.campaignInfoList.isEmpty
                          ? Center(
                              child: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.event,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'No Event',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                                  // Text(AppLocalizations.of(context).event),

                                  ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 60),
                              itemCount: model.campaignInfoList.length,
                              itemBuilder: (context, index) {
                                if (model.campaignInfoList[index]["status"] ==
                                        "active"
                                    //     &&
                                    // model.campaignInfoList[index]
                                    //     .containsKey("type")
                                    ) {
                                  return Container(
                                      // height: 100,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: InkWell(
                                          onTap: () {
                                            if (!model.campaignInfoList[index]
                                                .containsKey("type")) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CampaignSingle(model
                                                                  .campaignInfoList[
                                                              index]["id"])));
                                            } else {
                                              print("Event type: " +
                                                  model.campaignInfoList[index]
                                                      ["type"]);

                                              switch (
                                                  model.campaignInfoList[index]
                                                      ["type"]) {
                                                case "flutterPage":
                                                  return Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CampaignSingle(
                                                                  model.campaignInfoList[
                                                                          index]
                                                                      ["id"])));
                                                  break;
                                                case "webPage":
                                                  return Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  WebViewPage(
                                                                    url: model.campaignInfoList[
                                                                            index]
                                                                        [model
                                                                            .lang]["url"],
                                                                    title: model
                                                                            .campaignInfoList[index]
                                                                        [model
                                                                            .lang]["title"],
                                                                  )));
                                                  break;
                                                // case "video":
                                                //   return Navigator.push(
                                                //       context,
                                                //       MaterialPageRoute(
                                                //           builder: (context) =>
                                                //               VideoPage(
                                                //                   videoObj: model
                                                //                               .campaignInfoList[
                                                //                           index]
                                                //                       [model
                                                //                           .lang])));
                                                //   break;
                                                case "youtube":
                                                  return Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              YoutubePage(
                                                                  videoObj: model
                                                                              .campaignInfoList[
                                                                          index]
                                                                      [model
                                                                          .lang])));
                                                  break;
                                                case "youtubeList":
                                                  return Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              YoutubeListPage(
                                                                  videoObj: model
                                                                              .campaignInfoList[
                                                                          index]
                                                                      [model
                                                                          .lang])));
                                                  break;
                                                default:
                                                  return null;
                                              }
                                            }
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
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(10),
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
                                                                      [
                                                                      model
                                                                          .lang]
                                                                  ["title"] ??
                                                              '',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline3
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                          model.campaignInfoList[
                                                                              index]
                                                                          [model
                                                                              .lang]
                                                                      [
                                                                      "startDate"] +
                                                                  " - " +
                                                                  model.campaignInfoList[
                                                                              index]
                                                                          [model
                                                                              .lang]
                                                                      [
                                                                      "endDate"] ??
                                                              '',
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                          model.campaignInfoList[
                                                                          index]
                                                                      [
                                                                      model
                                                                          .lang]
                                                                  ["desc"] ??
                                                              '',
                                                          maxLines: 4,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
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
                                } else {
                                  return Container();
                                }
                              },
                            ),
              bottomNavigationBar: BottomNavBar(count: 3)),
        ),
      ),
    );
  }
}
