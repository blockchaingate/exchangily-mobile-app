import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

Color getTextColor(Color backgroundColor) {
  // Calculate the brightness of the background color
  double brightness = backgroundColor.red * 0.299 +
      backgroundColor.green * 0.587 +
      backgroundColor.blue * 0.114;

  // Return black for bright colors and white for dark colors
  return brightness > 150 ? Colors.black : Colors.white;
}

ThemeData kThemeData(
    {required bool isDark, Color backgroundColor = primaryColor}) {
  Color blackOrWhite = isDark ? white : black;
  return ThemeData(
    brightness: isDark ? Brightness.dark : Brightness.light,
    appBarTheme: AppBarTheme(
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    ),
    // added unselectedWidgetColor to update inactive radio button's color
    unselectedWidgetColor: blackOrWhite,
    disabledColor: grey.withAlpha(100),
    primaryColor: primaryColor,
    hintColor: blackOrWhite,
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: blackOrWhite),
        hintStyle: TextStyle(color: blackOrWhite),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: blackOrWhite,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: blackOrWhite, width: 0.5))),
    cardColor: isDark ? walletCardColor : white,
    canvasColor: isDark ? secondaryColor : white,
    colorScheme: isDark
        ? ColorScheme.dark()
        : ColorScheme.light(
            secondary: secondaryColor,
          ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: blackOrWhite,
      indicatorColor: blackOrWhite,
      indicatorSize: TabBarIndicatorSize.tab,
      // indicatorColor: primaryColor,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all<Color>(primaryColor),
      trackColor: MaterialStateProperty.all<Color>(white),
      overlayColor: MaterialStateProperty.all<Color>(yellow),
      trackOutlineColor:
          MaterialStateProperty.all<Color>(isDark ? white : secondaryColor),
    ),
    radioTheme: RadioThemeData(
        fillColor: isDark
            ? MaterialStateProperty.all<Color>(primaryColor)
            : MaterialStateProperty.all<Color>(grey)),
    buttonTheme: const ButtonThemeData(
        minWidth: double.infinity,
        buttonColor: primaryColor,
        padding: EdgeInsets.all(15),
        shape: StadiumBorder(),
        textTheme: ButtonTextTheme.primary),
    fontFamily: 'Roboto',
    textTheme: TextTheme(
        labelLarge: TextStyle(
            fontSize: 14,
            color: isDark ? white : getTextColor(backgroundColor)),
        labelMedium: TextStyle(fontSize: 12, color: isDark ? white : black),
        labelSmall: TextStyle(fontSize: 10, color: isDark ? white : black),
        displayLarge: TextStyle(
            fontSize: 22,
            color: blackOrWhite,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.25),
        displayMedium: TextStyle(
            fontSize: 20,
            color: blackOrWhite,
            letterSpacing: 1,
            height: 1.5,
            fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 18, color: isDark ? white : black),
        headlineLarge: TextStyle(
            fontSize: 18, color: blackOrWhite, fontWeight: FontWeight.w300),
        headlineMedium: TextStyle(
            fontSize: 15, color: blackOrWhite, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(
            fontSize: 12.5, color: blackOrWhite, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(
            fontSize: 12, color: blackOrWhite, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(
            fontSize: 11, color: blackOrWhite, fontWeight: FontWeight.w500),
        titleSmall:
            TextStyle(fontSize: 10.3, color: grey, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(
            fontSize: 13, color: blackOrWhite, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(
            fontSize: 10.5, color: blackOrWhite, fontWeight: FontWeight.w500),
        bodySmall: TextStyle(
            fontSize: 8.5, color: blackOrWhite, fontWeight: FontWeight.w400)),
  );
}

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
