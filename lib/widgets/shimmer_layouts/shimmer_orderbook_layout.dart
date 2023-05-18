import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class ShimmerOrderbookLayout extends StatelessWidget {
  const ShimmerOrderbookLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 15;
    double width = 50;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: height,
              width: width - 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: primaryColor.withAlpha(155),
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
                borderRadius: BorderRadius.circular(2),
                color: primaryColor.withAlpha(155),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
