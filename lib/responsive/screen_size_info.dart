import 'package:exchangilymobileapp/enums/device_screen_type.dart';
import 'package:flutter/cupertino.dart';

class ScreenSizeInfo {
  final DeviceScreenType? deviceScreenType;
  final Size? screenSize;
  final Size? localWidgetSize;
  ScreenSizeInfo(
      {this.deviceScreenType, this.screenSize, this.localWidgetSize});

  @override
  String toString() {
    return 'DeviceType:$deviceScreenType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}
