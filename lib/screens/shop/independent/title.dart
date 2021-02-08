import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            //  text Capitalization
            "${title[0].toUpperCase()}${title.substring(1)}",
            style: TextStyle(color: Color(0xffffffff), fontSize: 20),
          ),
        ],
      ),
    );
  }
}
