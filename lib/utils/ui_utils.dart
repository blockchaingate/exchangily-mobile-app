/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/enums/device_screen_type.dart';
import 'package:flutter/cupertino.dart';

DeviceScreenType getDeviceType(MediaQueryData mediaQueryData) {
//  var orientation = mediaQueryData.orientation;

  // Fixed Device width (changes with orientation)
  //double deviceWidth = 0;

  // if(orientation == Orientation.landscape) {
  //   deviceWidth = mediaQueryData.size.height;
  // } else {
  //   deviceWidth = mediaQueryData.size.width;
  // }

  //Above is the old logic
  double deviceWidth = mediaQueryData.size.shortestSide;

  if (deviceWidth > 950) {
    return DeviceScreenType.Desktop;
  }
  if (deviceWidth > 600) {
    return DeviceScreenType.Tablet;
  }

  return DeviceScreenType.Mobile;
}
