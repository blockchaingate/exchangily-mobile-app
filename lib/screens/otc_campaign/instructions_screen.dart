import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/instructions_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/campaign_single.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:exchangilymobileapp/widgets/loading_animation.dart';
import 'package:exchangilymobileapp/widgets/web_page.dart';
import 'package:exchangilymobileapp/widgets/web_view_widget.dart';
import 'package:exchangilymobileapp/widgets/youtube.dart';
import 'package:exchangilymobileapp/widgets/youtube_list_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CampaignInstructionScreen extends StatelessWidget {
  const CampaignInstructionScreen({Key? key, this.newPage = true})
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

              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Container(
                // decoration: BoxDecoration(
                //     color: white.withOpacity(.90),
                //     borderRadius: BorderRadius.circular(25),
                //     border: Border.all(
                //         color: primaryColor.withAlpha(145), width: 1.5)),
                constraints: const BoxConstraints(minWidth: 250),
                margin:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              model.sharedService!.launchInBrowser(
                                  Uri.parse(exchangilyAnnouncementUrl));
                            },
                          text: FlutterI18n.translate(context, "visitWebsite"),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.web,
                          size: 16,
                        ),
                      )
                    ],
                  ),
                  onPressed: () => model.sharedService!
                      .launchInBrowser(Uri.parse(exchangilyAnnouncementUrl)),
                ),
              ),
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
                      ? Center(
                          child: Text(
                            "${FlutterI18n.translate(context, "serverBusy")}...",
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : model.campaignInfoList!.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.event,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      FlutterI18n.translate(
                                          context, "noEventNote"),
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    UIHelper.verticalSpaceSmall,
                                    UIHelper.divider,
                                    UIHelper.verticalSpaceMedium,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              textStyle: const TextStyle(
                                                  color: white,
                                                  fontWeight: FontWeight.w400),
                                              side: const BorderSide(
                                                  color: primaryColor,
                                                  width: 1)),
                                          child: Row(
                                            children: [
                                              Text(
                                                FlutterI18n.translate(
                                                    context, "announcements"),
                                                style: TextStyle(color: white),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0, bottom: 5.0),
                                                child: Icon(
                                                  FontAwesomeIcons.bullhorn,
                                                  size: 16,
                                                  color: white,
                                                ),
                                              )
                                            ],
                                          ),
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => const WebViewWidget(
                                                      exchangilyAnnouncementUrl,
                                                      'Exchangily Announcements'))),
                                        ),
                                        UIHelper.horizontalSpaceSmall,
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor),
                                          child: Row(
                                            children: [
                                              Text(FlutterI18n.translate(
                                                  context, "blog")),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0, bottom: 5.0),
                                                child: Icon(
                                                  FontAwesomeIcons.blog,
                                                  size: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const WebViewWidget(
                                                          exchangilyBlogUrl,
                                                          'Exchangily Blogs'))),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 60),
                              itemCount: model.campaignInfoList!.length,
                              itemBuilder: (context, index) {
                                if (model.campaignInfoList![index]["status"] ==
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
                                            if (!model.campaignInfoList![index]
                                                .containsKey("type")) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CampaignSingle(model
                                                              .campaignInfoList![
                                                          index]["id"]),
                                                ),
                                              );
                                            } else {
                                              debugPrint("Event type: " +
                                                  model.campaignInfoList![index]
                                                      ["type"]);

                                              switch (
                                                  model.campaignInfoList![index]
                                                      ["type"]) {
                                                case "flutterPage":
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CampaignSingle(model
                                                                  .campaignInfoList![
                                                              index]["id"]),
                                                    ),
                                                  );
                                                  break;
                                                case "webPage":
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          WebViewPage(
                                                        url:
                                                            model.campaignInfoList![
                                                                        index]
                                                                    [model.lang]
                                                                ["url"],
                                                        title:
                                                            model.campaignInfoList![
                                                                        index]
                                                                    [model.lang]
                                                                ["title"],
                                                      ),
                                                    ),
                                                  );
                                                  break;
                                                case "youtube":
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          YoutubePage(
                                                        videoObj: model
                                                                .campaignInfoList![
                                                            index][model.lang],
                                                      ),
                                                    ),
                                                  );
                                                  break;
                                                case "youtubeList":
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          YoutubeListPage(
                                                        videoObj: model
                                                                .campaignInfoList![
                                                            index][model.lang],
                                                      ),
                                                    ),
                                                  );
                                                  break;
                                                default:
                                                  return;
                                              }
                                            }
                                          },

                                          // onTap: () {
                                          //   if (!model.campaignInfoList![index]
                                          //       .containsKey("type")) {
                                          //     Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             builder: (context) =>
                                          //                 CampaignSingle(model
                                          //                         .campaignInfoList![
                                          //                     index]["id"])));
                                          //   } else {
                                          //     debugPrint("Event type: " +
                                          //         model.campaignInfoList![index]
                                          //             ["type"]);

                                          //     switch (
                                          //         model.campaignInfoList![index]
                                          //             ["type"]) {
                                          //       case "flutterPage":
                                          //         return Navigator.push(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //                 builder: (context) =>
                                          //                     CampaignSingle(
                                          //                         model.campaignInfoList![
                                          //                                 index]
                                          //                             ["id"])));
                                          //       case "webPage":
                                          //         return Navigator.push(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //                 builder:
                                          //                     (context) =>
                                          //                         WebViewPage(
                                          //                           url: model.campaignInfoList![
                                          //                                   index]
                                          //                               [model
                                          //                                   .lang]["url"],
                                          //                           title: model
                                          //                                   .campaignInfoList![index]
                                          //                               [model
                                          //                                   .lang]["title"],
                                          //                         )));
                                          //       // case "video":
                                          //       //   return Navigator.push(
                                          //       //       context,
                                          //       //       MaterialPageRoute(
                                          //       //           builder: (context) =>
                                          //       //               VideoPage(
                                          //       //                   videoObj: model
                                          //       //                               .campaignInfoList[
                                          //       //                           index]
                                          //       //                       [model
                                          //       //                           .lang])));
                                          //       //   break;
                                          //       case "youtube":
                                          //         return Navigator.push(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //                 builder: (context) =>
                                          //                     YoutubePage(
                                          //                         videoObj: model
                                          //                                     .campaignInfoList![
                                          //                                 index]
                                          //                             [model
                                          //                                 .lang])));
                                          //       case "youtubeList":
                                          //         return Navigator.push(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //                 builder: (context) =>
                                          //                     YoutubeListPage(
                                          //                         videoObj: model
                                          //                                     .campaignInfoList![
                                          //                                 index]
                                          //                             [model
                                          //                                 .lang])));
                                          //       default:
                                          //         return null;
                                          //     }
                                          //   }
                                          // },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: walletCardColor,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                AspectRatio(
                                                  aspectRatio: 2.5 / 1,
                                                  child: CacheImage(
                                                    model.campaignInfoList![
                                                        index]["coverImage"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                          model.campaignInfoList![
                                                                          index]
                                                                      [
                                                                      model
                                                                          .lang]
                                                                  ["title"] ??
                                                              '',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displaySmall!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                          model.campaignInfoList![
                                                                              index]
                                                                          [model
                                                                              .lang]
                                                                      [
                                                                      "startDate"] +
                                                                  " - " +
                                                                  model.campaignInfoList![
                                                                              index]
                                                                          [model
                                                                              .lang]
                                                                      [
                                                                      "endDate"] ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                          model.campaignInfoList![
                                                                          index]
                                                                      [
                                                                      model
                                                                          .lang]
                                                                  ["desc"] ??
                                                              '',
                                                          maxLines: 4,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
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
