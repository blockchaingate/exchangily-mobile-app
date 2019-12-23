import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _height = 90.0;

  String title;
  Color color;

  CustomAppBar({this.color, this.title})
      : assert(title != null),
        assert(color != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(color: color),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white,
            letterSpacing: 2,
            fontSize: 30,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_height);
}
