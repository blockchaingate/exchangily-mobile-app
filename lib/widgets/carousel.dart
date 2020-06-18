import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Carousel extends StatelessWidget {
  final List<Map> imageData;
  Carousel({this.imageData});

  // final List<Map> images = [
  //   {"imgUrl": "https://images.unsplash.com/photo-1451187580459-43490279c0fa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1052&q=80"},
  //   {"imgUrl": "https://s27389.pcdn.co/wp-content/uploads/2020/03/three-new-ways-doing-business-enabled-blockchain.jpeg"},
  //   {"imgUrl": "https://assets.weforum.org/report/image/wM-N1S6t0HWgbv1IOS24C78jNLctPTn2CV9HxoUhRro.PNG"},
  // ];

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
              child: CacheImage(
                imgUrl,
                fit: BoxFit.fill,
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
