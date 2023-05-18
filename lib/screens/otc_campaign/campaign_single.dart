import 'package:exchangilymobileapp/screen_state/otc_campaign/campaign_single_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/share/share.dart';
import 'package:exchangilymobileapp/widgets/customSeparator.dart';
import 'package:exchangilymobileapp/widgets/eventMainContent.dart';
import 'package:exchangilymobileapp/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CampaignSingle extends StatelessWidget {
  const CampaignSingle(this.eventID);
  final String? eventID;
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
                  ? const LoadingGif()
                  : model.hasApiError
                      ? Container(
                          child: const Center(
                            child: Text("Connection Error"),
                          ),
                        )
                      : Container(
                          color: HexColor(
                              model.campaignInfoSingle!["setting"]["bgColor"]),
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
                                      image: (model.campaignInfoSingle!["setting"]
                                                  ["bgImage"]
                                              .startsWith("http")
                                          ? NetworkImage(model
                                                  .campaignInfoSingle!["setting"]
                                              ["bgImage"])
                                          : AssetImage(
                                              model.campaignInfoSingle![
                                                  "setting"]["bgImage"],
                                            )) as ImageProvider<Object>,
                                      fit: BoxFit.contain,
                                    )),
                                    child: Container(
                                        margin: const EdgeInsets.only(top: 100),
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
                                              constraints: const BoxConstraints(
                                                  maxHeight: 30),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  model.campaignInfoSingle![model
                                                          .lang]["title"]["up"]
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  60,
                                              height: 60,
                                              child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: GradientText(
                                                    model.campaignInfoSingle![
                                                            model.lang]["title"]
                                                        ["main"],
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1),
                                                    textAlign: TextAlign.center,
                                                    colors: const [
                                                      Color(0xffffffff),
                                                      Color(0xffb7ccfe),
                                                      Color(0xffb9a9f9),
                                                    ],
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 7),
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
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Color(
                                                                0xff000066),
                                                            shape: BoxShape
                                                                .circle),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    model.campaignInfoSingle![
                                                            model.lang]["title"]
                                                        ["label"],
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xff000066),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        letterSpacing: 1,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Color(
                                                                0xff000066),
                                                            shape: BoxShape
                                                                .circle),
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
                                        icon: const Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                        icon: const Icon(Icons.share,
                                            color: Colors.white),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Share()));
                                        }),
                                  )
                                ],
                              ),
                              //title area
                              Container(
                                height: 60,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                // padding: EdgeInsets.symmetric(horizontal:10),
                                child: Stack(children: [
                                  Container(
                                    margin: const EdgeInsetsDirectional.only(
                                        top: 8),
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xff3d3da1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        model.campaignInfoSingle![model.lang]
                                            ["title"]["leading"],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: const CustomSeparator(
                                      color: Color(0xff353487),
                                      height: 20,
                                    ),
                                  ),
                                ]),
                              ),
                              // content rows
                              EventMainContent(
                                  model.campaignInfoSingle![model.lang]["body"]),

                              const SizedBox(height: 50),

                              const SizedBox(height: 50),
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
