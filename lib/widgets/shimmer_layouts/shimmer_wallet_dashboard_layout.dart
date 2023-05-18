import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWalletDashboardLayout extends StatelessWidget {
  const ShimmerWalletDashboardLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 10;
    double width = 50;
    return Shimmer.fromColors(
      baseColor: white,
      highlightColor: primaryColor,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UIHelper.horizontalSpaceSmall,
            // logo
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.grey),
            ),

            /// balance column
            Expanded(
              flex: 1,
              child: Column(children: [
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                ),
                // Container(
                //   height: height,
                //   //   width: width - 10,
                //   color: Colors.grey,
                // ),
              ]),
            ),
            UIHelper.horizontalSpaceMedium,
            // usd value
            Expanded(
              flex: 2,
              child: Column(children: [
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  height: height,
                  width: width - 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
