import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/instructions_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/customSeparator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;

class CampaignInstructionScreen extends StatelessWidget {
  const CampaignInstructionScreen({Key key, this.newPage = false})
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
          print("is newpage: $newPage");
          if (newPage)
            // Navigator.pushReplacementNamed(context, '/mainNav', arguments: 1);
            model.navigationService.goBack();
          return new Future(() => true);
        },
        child: SafeArea(
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              width: 250,
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
            backgroundColor: Color(0xff000066),
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
                                      .copyWith(color: globals.primaryColor))),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: <Widget>[
                      // List of instruction SVG images
                      Container(
                        height: MediaQuery.of(context).size.width * 370 / 600,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(
                            "assets/images/img/CampaignHeader.png",
                          ),
                          fit: BoxFit.contain,
                        )),
                        child: Container(
                            margin: EdgeInsets.only(top: 100),
                            height: 150,
                            width: MediaQuery.of(context).size.width - 60,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 60,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "10 MILLION EQUITY TOKEN GIVE AWAY",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 60,
                                  child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: GradientText("INVITATION",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1),
                                          gradient: LinearGradient(
                                              colors: [
                                                Color(0xffffffff),
                                                Color(0xffb7ccfe),
                                                Color(0xffb9a9f9),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter),
                                          textAlign: TextAlign.center)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 7),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                            color: Color(0xff000066),
                                            shape: BoxShape.circle),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "WAITING FOR YOU",
                                        style: TextStyle(
                                            color: Color(0xff000066),
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1,
                                            fontSize: 16),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                            color: Color(0xff000066),
                                            shape: BoxShape.circle),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                      //title area
                      Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        // padding: EdgeInsets.symmetric(horizontal:10),
                        child: Stack(children: [
                          Container(
                            margin: EdgeInsetsDirectional.only(top: 8),
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            // width: double.infinity,
                            // height: 50,
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: 30, vertical: 7),
                            decoration: BoxDecoration(
                              color: Color(0xff3d3da1),
                            ),
                            child: Center(
                              child: Text(
                                "About the Campaign",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: CustomSeparator(
                              color: Color(0xff353487),
                              height: 20,
                            ),
                          ),
                        ]),
                      ),
                      // content rows
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color(0xff3d3da1),
                          // border:
                          //     Border.all(color: Color(0xbb3f4df1),width: 3)
                        ),
                        child: Column(
                            children: model.eventContent.map((e) {
                          if (e["type"] == "row") {
                            return ContentRow(e["title"], e["text"]);
                          } else if (e["type"] == "form") {
                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ContentForm(e["content"][0]),
                                    SizedBox(width: 5),
                                    ContentForm(e["content"][1]),
                                    SizedBox(width: 5),
                                    ContentForm(e["content"][2])
                                  ]),
                            );
                          } else {
                            return Container(
                                // child: Widget(),
                                );
                          }
                        }).toList()),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(start: 30, end: 30),
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        width: MediaQuery.of(context).size.width - 60,
                        // width: double.infinity,
                        // height: 50,
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: 30, vertical: 7),
                        decoration: BoxDecoration(
                          color: Color(0xff3d3da1),
                        ),
                        child: Column(
                          children: [
                            CustomSeparator(
                              color: Color(0xff131359),
                            ),
                            SizedBox(height: 30),
                            Center(
                              child: InkWell(
                                child: Text(
                                  "More information about this campaign",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: (){
                                  
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),

                      SizedBox(height: 50),
                      // Enter button container

                      // Container(
                      //   width: 250,
                      //   child: RaisedButton(
                      //     padding: EdgeInsets.all(0),
                      //     child: Text(
                      //         AppLocalizations.of(context)
                      //             .tapHereToEnterInCampaign,
                      //         style: Theme.of(context).textTheme.headline4),
                      //     onPressed: () {
                      //       Navigator.pushNamed(context, '/campaignLogin');
                      //     },
                      //   ),
                      // ),
                      // UIHelper.verticalSpaceSmall,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class ContentRow extends StatelessWidget {
  ContentRow(this.title, this.text);
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSeparator(
            color: Color(0xff131359),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20)
        ]);
  }
}

class ContentForm extends StatelessWidget {
  ContentForm(this.info);
  final Map info;
  // final String icon;
  // final String title;
  // final String text;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xff000066), borderRadius: BorderRadius.circular(5)),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                color: Color(0xff3d3da1).withOpacity(0.5),
                child: Center(
                    child: Text(
                  info["price"],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
              ),
              SizedBox(height: 20),
              Image.asset(
                info["icon"],
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              // CustomSeparator(
              //   color: Color(0xff131359),
              // ),
              SizedBox(height: 20),
              Text(
                info["title"],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                color: Color(0xff3d3da1).withOpacity(0.5),
                child: Center(
                    child: Text(
                  info["tier1"],
                  style: TextStyle(color: Colors.white, fontSize: 9),
                )),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  info["reword1"],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  info["client1"] + " referral",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                color: Color(0xff3d3da1).withOpacity(0.5),
                child: Center(
                    child: Text(
                  info["tier2"],
                  style: TextStyle(color: Colors.white, fontSize: 9),
                )),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  info["reword2"],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  info["client2"] + " referral",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                color: Color(0xff3d3da1).withOpacity(0.5),
                child: Center(
                    child: Text(
                  info["tier3"],
                  style: TextStyle(color: Colors.white, fontSize: 9),
                )),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  info["reword3"],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  info["client3"] + " referral",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 5),
            ]),
      ),
    );
  }
}
