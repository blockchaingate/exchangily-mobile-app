import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/otc_campaign/campaign_single.dart';
import 'package:exchangilymobileapp/widget_state/carousel_state.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:exchangilymobileapp/widgets/video_page.dart';
import 'package:exchangilymobileapp/widgets/web_page.dart';
import 'package:exchangilymobileapp/widgets/youtube.dart';
import 'package:exchangilymobileapp/widgets/youtube_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Carousel extends StatelessWidget {
  final List imageData;
  final String lang;
  const Carousel({this.imageData, this.lang});

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CarouselWidgetState>(
        onModelReady: (model) async {
          model.context = context;
          await model.initState();
        },
        builder: (context, model, child) => SizedBox(
              height: MediaQuery.of(context).size.width * 0.45,
              child: Swiper(
                loop: true,
                autoplay: imageData.length > 1 ? true : false,
                autoplayDelay: 7000,
                // duration: 600,
                pagination: SwiperPagination(builder: SwiperCustomPagination(
                    builder: (BuildContext context, SwiperPluginConfig config) {
                  return const DotSwiperPaginationBuilder(
                          color: Colors.white38,
                          activeColor: Colors.white,
                          size: 8.0,
                          activeSize: 8.0)
                      .build(context, config);
                })),
                itemBuilder: (BuildContext context, int index) {
                  String imgUrl = lang == "en"
                      ? imageData[index]["url"]
                      : imageData[index]["urlzh"];
                  return InkWell(
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        child: CacheImage(
                          imgUrl,
                          fit: BoxFit.fill,
                        ),
                        onTap: () {
                          // debugPrint("Event type: " + imageData[index]["type"]);

                          if (!imageData[index].containsKey("type")) {
                            imageData[index].containsKey("route") &&
                                    imageData[index]["route"].length > 0
                                ? Navigator.pushNamed(
                                    context, imageData[index]["route"],
                                    arguments: imageData[index]["arguments"])
                                : null;
                          } else {
                            switch (imageData[index]["type"]) {
                              case "flutterPage":
                                return imageData[index].containsKey("route") &&
                                        imageData[index]["route"].length > 0
                                    ? Navigator.pushNamed(
                                        context, imageData[index]["route"],
                                        arguments: imageData[index]
                                            ["arguments"])
                                    : null;
                                break;
                              case "webPage":
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewPage(
                                              url: imageData[index][model.lang]
                                                  ["url"],
                                              title: imageData[index]
                                                  [model.lang]["title"],
                                            )));
                                break;
                              // case "video":
                              //   return Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => VideoPage(
                              //               videoObj: imageData[index]
                              //                   [model.lang])));
                              //   break;
                              case "youtube":
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YoutubePage(
                                            videoObj: imageData[index]
                                                [model.lang])));
                                break;
                              case "youtubeList":
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YoutubeListPage(
                                            videoObj: imageData[index]
                                                [model.lang])));
                                break;
                              default:
                                return null;
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
                itemCount: imageData.length,
                viewportFraction: (MediaQuery.of(context).size.width - 20) /
                    MediaQuery.of(context).size.width,
                scale: 0.90,
              ),
            ));
  }
}
