import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class ShimmerMarketPairsLayout extends StatelessWidget {
  const ShimmerMarketPairsLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 14;
    double width = 50;
    return Container(
      // decoration:
      //  BoxDecoration(border: Border.all(width: 0.2, color: Colors.grey)),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIHelper.horizontalSpaceSmall,

          /// balance column
          Expanded(
            flex: 2,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.grey,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: height,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    height: height,
                    width: width - 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.grey,
                    ),
                  ),
                ]),
          ),
          // usd value
          Expanded(
            flex: 2,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.grey,
                    ),
                  ),
                ]),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: height,
              width: width - 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: height,
              width: width - 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
