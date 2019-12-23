import 'package:flutter/cupertino.dart';

class UIHelper {
  // Vertical Spacing
  static const double _VerticalSpaceSmall = 10.0;
  static const double _VerticalSpaceMedium = 20.0;
  static const double _VerticalSpaceLarge = 50.0;

  // Horizontal Spacing
  static const double _HorizontalSpaceSmall = 10.0;
  static const double _HorizontalSpaceMedium = 20.0;
  static const double _HorizontalSpaceLarge = 50.0;

  static const Widget verticalSpaceSmall =
      SizedBox(height: _VerticalSpaceSmall);
  static const Widget verticalSpaceMedium =
      SizedBox(height: _VerticalSpaceMedium);
  static const Widget verticalSpaceLarge =
      SizedBox(height: _VerticalSpaceLarge);

  static const Widget horizontalSpaceSmall =
      SizedBox(height: _HorizontalSpaceSmall);
  static const Widget horizontalSpaceMedium =
      SizedBox(height: _HorizontalSpaceMedium);
  static const Widget horizontalSpaceLarge =
      SizedBox(height: _HorizontalSpaceLarge);
}
