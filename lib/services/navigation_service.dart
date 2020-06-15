import 'package:flutter/cupertino.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) async {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  // Enter animation
  Future<dynamic> navigateUsingPushReplacementNamed(String routeName,
      {dynamic arguments}) async {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  // Exit animation
  Future<dynamic> navigateUsingpopAndPushedNamed(String routeName,
      {dynamic arguments}) async {
    return navigatorKey.currentState
        .popAndPushNamed(routeName, arguments: arguments);
  }

  // Push entered route and remove all routes on the stack
  Future<dynamic> navigateUsingPushNamedAndRemoveUntil(
    String routeName,
  ) async {
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  goBack() {
    return navigatorKey.currentState.pop();
  }

  bool isFinalRoute() {
    return navigatorKey.currentState.canPop();
  }
}
