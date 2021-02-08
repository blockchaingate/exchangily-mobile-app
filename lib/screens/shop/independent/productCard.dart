import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key key, this.img, this.title, this.price})
      : super(key: key);
  final String img;
  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CacheImage(
                img,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: TextStyle(
                color: Color(
                  0xffffffff,
                ),
                fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '\$' + price.toString(),
            style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 20),
          ),
        ],
      ),
    );
  }
}
