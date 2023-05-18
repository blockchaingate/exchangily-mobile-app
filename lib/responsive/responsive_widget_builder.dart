import 'package:exchangilymobileapp/responsive/screen_size_info.dart';
import 'package:exchangilymobileapp/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class ResponsiveWidgetBuilder extends StatelessWidget {
  final Widget? Function(BuildContext context, ScreenSizeInfo screenSizeInfo)?
      builder;
  const ResponsiveWidgetBuilder({Key? key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      var mediaQuery = MediaQuery.of(context);
      var sizingInformation = ScreenSizeInfo(
          deviceScreenType: getDeviceType(mediaQuery),
          screenSize: mediaQuery.size,
          localWidgetSize:
              Size(boxConstraints.maxWidth, boxConstraints.maxHeight));
      return builder!(context, sizingInformation)!;
    });
  }
}
