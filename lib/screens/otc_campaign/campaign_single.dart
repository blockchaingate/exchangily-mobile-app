import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_single_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/widgets/customSeparator.dart';
import 'package:exchangilymobileapp/widgets/eventMainContent.dart';
import 'package:exchangilymobileapp/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

class CampaignSingle extends StatelessWidget {
  CampaignSingle(this.eventID);
  final String eventID;
  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignSingleScreenState>(
        onModelReady: (model) async {
          model.context = context;
          model.eventID = eventID;
          await model.initState();
        },
        builder: (context, model, child) => Scaffold(
              body: model.busy
                  ? LoadingGif()
                  : model.hasApiError
                      ? Container(
                          child: Center(
                            child: Text("Connection Error"),
                          ),
                        )
                      : Container(
                          color: HexColor(
                              model.campaignInfoSingle["setting"]["bgColor"]),
                          child: ListView(
                            children: <Widget>[
                              // List of instruction SVG images
                              Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    // height:
                                    //     MediaQuery.of(context).size.width *
                                    //         370 /
                                    //         600,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      alignment: Alignment.topCenter,
                                      image: model.campaignInfoSingle["setting"]
                                                  ["bgImage"]
                                              .startsWith("http")
                                          ? NetworkImage(model
                                                  .campaignInfoSingle["setting"]
                                              ["bgImage"])
                                          : AssetImage(
                                              model.campaignInfoSingle[
                                                  "setting"]["bgImage"],
                                            ),
                                      fit: BoxFit.contain,
                                    )),
                                    child: Container(
                                        margin: EdgeInsets.only(top: 100),
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                60,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  60,
                                              constraints:
                                                  BoxConstraints(maxHeight: 30),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  model.campaignInfoSingle[model
                                                          .lang]["title"]["up"]
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  60,
                                              height: 60,
                                              child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: GradientText(
                                                      model.campaignInfoSingle[
                                                              model.lang]
                                                          ["title"]["main"],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Color(0xffffffff),
                                                            Color(0xffb7ccfe),
                                                            Color(0xffb9a9f9),
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter),
                                                      textAlign:
                                                          TextAlign.center)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30, vertical: 7),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          60)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff000066),
                                                        shape: BoxShape.circle),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    model.campaignInfoSingle[
                                                            model.lang]["title"]
                                                        ["label"],
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff000066),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        letterSpacing: 1,
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff000066),
                                                        shape: BoxShape.circle),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                  Positioned(
                                    top: 5,
                                    left: 5,
                                    child: IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  )
                                ],
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
                                    decoration: BoxDecoration(
                                      color: Color(0xff3d3da1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        model.campaignInfoSingle[model.lang]
                                            ["title"]["leading"],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: CustomSeparator(
                                      color: Color(0xff353487),
                                      height: 20,
                                    ),
                                  ),
                                ]),
                              ),
                              // content rows
                              EventMainContent(
                                  model.campaignInfoSingle[model.lang]["body"]),

                              SizedBox(height: 50),

                              SizedBox(height: 50),
                            ],
                          ),
                        ),
            ));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
