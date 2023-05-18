import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/routes.dart';
import 'package:flutter/cupertino.dart';

class NavigationService {
  final log = getLogger('NavigationService');
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) async {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  // Enter animation
  Future<dynamic> navigateUsingPushReplacementNamed(String routeName,
      {dynamic arguments}) async {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  // Exit animation
  Future<dynamic> navigateUsingpopAndPushedNamed(String routeName,
      {dynamic arguments}) async {
    return navigatorKey.currentState!
        .popAndPushNamed(routeName, arguments: arguments);
  }

  // Push entered route and remove all routes on the stack
  Future<dynamic> navigateUsingPushNamedAndRemoveUntil(
    String routeName,
  ) async {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  goBack() {
    return navigatorKey.currentState!.pop();
  }

  bool isFinalRoute() {
    return navigatorKey.currentState!.canPop();
  }

  String? currentRoute() {
    log.i('RouteGenerator.lastRoute = ${RouteGenerator.lastRoute}');
    return RouteGenerator.lastRoute;
  }

  void pushNamedIfNotCurrent(String routeName, {Object? arguments}) {
    if (!isCurrent(routeName)) {
      navigateUsingPushReplacementNamed(routeName, arguments: arguments);
    }
  }

  bool isCurrent(String routeName) {
    bool isCurrent = false;
    navigatorKey.currentState?.popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}
