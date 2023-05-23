import 'package:flutter/material.dart';

class CustomSeparator extends StatelessWidget {
  final double height;
  final Color color;

  const CustomSeparator({this.height = 3, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = height;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: Container(
                    width: dashWidth,
                    height: dashHeight,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle
                            // child: Widget(),
                            )));
          }),
        );
      },
    );
  }
}
