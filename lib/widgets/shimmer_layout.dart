import 'dart:ui';

import 'package:exchangilymobileapp/widgets/shimmer_layouts/shimmer_wallet_dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLayout extends StatelessWidget {
  final String layoutType;
  const ShimmerLayout({Key key, this.layoutType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              Widget layout;

              if (layoutType == 'walletDashboard') {
                layout = Shimmer.fromColors(
                    child: ShimmerWalletDashboardLayout(),
                    baseColor: Colors.grey,
                    highlightColor: Colors.white);
              } else if (layoutType == 'markets') {
                layout = Card(
                  child: Container(),
                );
              }
              return layout;
            }));
  }
}
