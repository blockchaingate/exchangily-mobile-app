import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class ShimmerWalletDashboardLayout extends StatelessWidget {
  const ShimmerWalletDashboardLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 10;
    double width = 50;
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          UIHelper.horizontalSpaceSmall,
          // logo
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.grey),
          ),
          UIHelper.horizontalSpaceSmall,

          /// balance column
          Expanded(
            flex: 3,
            child: Column(children: [
              Container(
                height: height,
                // width: width ,
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: height,
                //  width: width,
                color: Colors.grey,
              ),
              Container(
                height: height,
                //   width: width - 10,
                color: Colors.grey,
              ),
            ]),
          ),
          // usd value
          Expanded(
            flex: 2,
            child: Column(children: [
              Container(
                height: height,
                width: width,
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: height,
                width: width - 15,
                color: Colors.grey,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
