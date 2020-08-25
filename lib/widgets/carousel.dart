import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Carousel extends StatelessWidget {
  final List imageData;
  final String lang;
  Carousel({this.imageData, this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.4,
      child: Swiper(
        loop: true,
        autoplay: imageData.length > 1 ? true : false,
        autoplayDelay: 7000,
        // duration: 600,
        pagination: new SwiperPagination(builder: new SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig config) {
          return new DotSwiperPaginationBuilder(
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
                  if (imageData[index].containsKey("route") &&
                      imageData[index]["route"].length > 0) {
                    Navigator.pushNamed(context, imageData[index]["route"],
                        arguments: imageData[index]["arguments"]);
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
    );
  }
}
