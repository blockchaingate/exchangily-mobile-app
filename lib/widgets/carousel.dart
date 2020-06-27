import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Carousel extends StatelessWidget {
  final List<Map> imageData;
  Carousel({this.imageData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.4,
      child: Swiper(
        loop: true,
        autoplay: imageData.length > 1 ? true : false,
        itemBuilder: (BuildContext context, int index) {
          String imgUrl = imageData[index]["imgUrl"];
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
                    Navigator.pushNamed(context, imageData[index]["route"],arguments: true);
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
