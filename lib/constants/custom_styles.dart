import 'package:flutter/material.dart';

import 'colors.dart';

TextStyle headText1 = const TextStyle(
    fontSize: 22,
    color: white,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.25);
TextStyle headText2 =
    const TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w300);
TextStyle headText3 = const TextStyle(fontSize: 16, color: white);
TextStyle headText4 =
    const TextStyle(fontSize: 15, color: white, fontWeight: FontWeight.w300);
TextStyle subText1 =
    const TextStyle(fontSize: 14, color: white, fontWeight: FontWeight.w300);
TextStyle headText5 =
    const TextStyle(fontSize: 12.5, color: white, fontWeight: FontWeight.w400);
TextStyle subText2 =
    const TextStyle(fontSize: 10.3, color: grey, fontWeight: FontWeight.w400);
TextStyle bodyText1 =
    const TextStyle(fontSize: 13, color: white, fontWeight: FontWeight.w400);
TextStyle bodyText2 = const TextStyle(fontSize: 13, color: red);
TextStyle headText6 =
    const TextStyle(fontSize: 10.5, color: white, fontWeight: FontWeight.w500);

AppBar customAppBarWithTitle(String title, {Color color = primaryColor}) =>
    AppBar(
      title: Text(
        title,
        style: headText3.copyWith(color: secondaryColor),
      ),
      automaticallyImplyLeading: true,
      backgroundColor: color,
      centerTitle: true,
    );

var shapeRoundBorder = MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: const BorderSide(color: primaryColor)));

var buttonPadding15 =
    MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(15));

var buttonBackgroundColor = MaterialStateProperty.all<Color>(primaryColor);

var generalButtonStyle1 = ButtonStyle(
    shape: shapeRoundBorder,
    backgroundColor: buttonBackgroundColor,
    padding: buttonPadding15);

var outlinedButtonStyles1 = OutlinedButton.styleFrom(
  side: const BorderSide(color: primaryColor),
  padding: const EdgeInsets.all(15.0),
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
      side: const BorderSide(color: primaryColor)),
  textStyle: const TextStyle(color: Colors.white),
);

Decoration circularGradientBoxDecoration() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(25)),
    gradient: LinearGradient(
      colors: [Colors.redAccent, Colors.yellow],
      begin: FractionalOffset.topLeft,
      end: FractionalOffset.bottomRight,
    ),
  );
}

Decoration rectangularGradientBoxDecoration() {
  return const BoxDecoration(
    // borderRadius: BorderRadius.all(Radius.circular(25)),
    gradient: LinearGradient(
      colors: [Colors.redAccent, Colors.yellow],
      begin: FractionalOffset.topLeft,
      end: FractionalOffset.bottomRight,
    ),
  );
}

Decoration roundedBoxDecoration({Color color = primaryColor}) {
  return BoxDecoration(
    color: color,
    borderRadius: const BorderRadius.all(Radius.circular(15)),
  );
}
