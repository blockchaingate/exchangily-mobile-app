import 'package:exchangilymobileapp/enums/device_screen_type.dart';
import 'package:exchangilymobileapp/responsive/responsive_widget_builder.dart';
import 'package:flutter/material.dart';

class ScreenTypeLayout extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  const ScreenTypeLayout({Key? key, this.mobile, this.desktop, this.tablet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidgetBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
          if (tablet != null) {
            return tablet;
          }
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.Desktop) {
          if (desktop != null) {
            return desktop;
          }
        }
        return mobile;
      },
    );
  }
}
