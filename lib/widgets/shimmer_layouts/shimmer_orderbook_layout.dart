import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class ShimmerOrderbookLayout extends StatelessWidget {
  const ShimmerOrderbookLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 14;
    double width = 50;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: height,
              width: width - 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Colors.grey,
              ),
            ),
          ),
          UIHelper.horizontalSpaceSmall,
          Expanded(
            flex: 2,
            child: Container(
              height: height,
              width: width - 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
