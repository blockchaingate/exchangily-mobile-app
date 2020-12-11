import 'package:exchangilymobileapp/shared/carousel/corousel_viewmodel.dart';
import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:exchangilymobileapp/widgets/video_page.dart';
import 'package:exchangilymobileapp/widgets/web_page.dart';
import 'package:exchangilymobileapp/widgets/youtube.dart';
import 'package:exchangilymobileapp/widgets/youtube_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:stacked/stacked.dart';

class CarouselView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => CarouselViewmodel(),
      onModelReady: (model) {
        model.init();
      },
      builder: (BuildContext context, CarouselViewmodel model, child) => !model
                  .dataReady ||
              model.isBusy
          ? Center(child: model.sharedService.loadingIndicator())
          : Container(
              height: MediaQuery.of(context).size.width * 0.4,
              child: Swiper(
                loop: true,
                autoplay: model.images.length > 1 ? true : false,
                autoplayDelay: 7000,
                // duration: 600,
                pagination: new SwiperPagination(builder:
                    new SwiperCustomPagination(builder:
                        (BuildContext context, SwiperPluginConfig config) {
                  return new DotSwiperPaginationBuilder(
                          color: Colors.white38,
                          activeColor: Colors.white,
                          size: 8.0,
                          activeSize: 8.0)
                      .build(context, config);
                })),
                itemBuilder: (BuildContext context, int index) {
                  String imgUrl = model.lang == "en"
                      ? model.images[index]["url"]
                      : model.images[index]["urlzh"];
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
                          // print("Event type: " + model.images[index]["type"]);

                          if (!model.images[index].containsKey("type")) {
                            model.images[index].containsKey("route") &&
                                    model.images[index]["route"].length > 0
                                ? Navigator.pushNamed(
                                    context, model.images[index]["route"],
                                    arguments: model.images[index]["arguments"])
                                : null;
                          } else {
                            switch (model.images[index]["type"]) {
                              case "flutterPage":
                                return model.images[index]
                                            .containsKey("route") &&
                                        model.images[index]["route"].length > 0
                                    ? Navigator.pushNamed(
                                        context, model.images[index]["route"],
                                        arguments: model.images[index]
                                            ["arguments"])
                                    : null;
                                break;
                              case "webPage":
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewPage(
                                              url: model.images[index]
                                                  [model.lang]["url"],
                                              title: model.images[index]
                                                  [model.lang]["title"],
                                            )));
                                break;
                              case "video":
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoPage(
                                            videoObj: model.images[index]
                                                [model.lang])));
                                break;
                              case "youtube":
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YoutubePage(
                                            videoObj: model.images[index]
                                                [model.lang])));
                                break;
                              case "youtubeList":
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YoutubeListPage(
                                            videoObj: model.images[index]
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
                itemCount: model.images.length,
                viewportFraction: (MediaQuery.of(context).size.width - 20) /
                    MediaQuery.of(context).size.width,
                scale: 0.90,
              ),
            ),
    );
  }
}
