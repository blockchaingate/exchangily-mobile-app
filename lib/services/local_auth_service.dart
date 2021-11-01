import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:overlay_support/overlay_support.dart';

class LocalAuthService {
  final _auth = LocalAuthentication();
  final log = getLogger('LocalAuthService');

  final NavigationService navigationService = locator<NavigationService>();
  final localStorageService = locator<LocalStorageService>();

  bool _isLockedOut = false;
  bool get isLockedOut => _isLockedOut;

  bool _isLockedOutPerm = false;
  bool get isLockedOutPerm => _isLockedOutPerm;

  bool _hasAuthenticated = false;
  bool get hasAuthenticated => _hasAuthenticated;

  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;

  BuildContext context;

  // cancel authentication
  void cancelAuthentication() {
    _auth.stopAuthentication();
  }

  setIsCancelledValueFalse() {
    _isCancelled = false;
  }

  Future<bool> isDeviceSupported() async {
    return _auth.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to access the wallet',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      log.i('isAuthenticated 1 $isAuthenticated');
    } on PlatformException catch (e) {
      // when any type of authentication is not set
      if (e.code == auth_error.notAvailable ||
          e.code == auth_error.notEnrolled ||
          e.code == auth_error.passcodeNotSet) {
        localStorageService.hasCancelledBiometricAuth = false;
        localStorageService.hasInAppBiometricAuthEnabled = false;
        localStorageService.hasPhoneProtectionEnabled = false;
      } else if (e.code == 'auth_in_progress') {
        // auth in progress
      } else if (e.code == auth_error.lockedOut) {
        // Too manu failed attempts and locked out temp
        _isLockedOut = true;
      } else if (e.code == auth_error.permanentlyLockedOut) {
        // Too manu failed attempts and locked out permanently, now required password/pin
        _isLockedOutPerm = true;
      }
      log.e('catch $e');
    }
    //  }
    //else{await _auth.}
    log.i(
        'isAuthenticated $isAuthenticated --  _isLockedOutPerm $_isLockedOutPerm -- _isLockedOut $_isLockedOut --  hasPhoneProtectionEnabled ${localStorageService.hasPhoneProtectionEnabled}');
    return isAuthenticated;
  }

  // checks after authentication
  routeAfterAuthCheck({String routeName = ''}) async {
    if (routeName.isEmpty) navigationService.currentRoute();
    if (routeName == null || routeName.isEmpty) routeName = DashboardViewRoute;
    await authenticate().then((isAuthenticatedSuccess) {
      _hasAuthenticated = isAuthenticatedSuccess;
      if (_hasAuthenticated) {
        navigationService.navigateUsingpopAndPushedNamed(routeName);

        return;
      } else if (!_hasAuthenticated) {
        if (isLockedOut) {
          showSimpleNotification(
              Text('${AppLocalizations.of(context).lockedOutTemp}'),
              position: NotificationPosition.bottom,
              background: red);
        } else if (isLockedOutPerm) {
          showSimpleNotification(
              Text('${AppLocalizations.of(context).lockedOutPerm}'),
              position: NotificationPosition.bottom,
              background: red);
        } else {
          _isCancelled = true;
          if (navigationService.currentRoute() != WalletSetupViewRoute) {
            navigationService
                .navigateUsingpopAndPushedNamed(WalletSetupViewRoute);
            //   Future.delayed(new Duration(seconds: 2), () {
            //     localStorageService.hasCancelledBiometricAuth = false;
            //   });
          }
          // localStorageService.hasCancelledBiometricAuth = true;
        }
      } else {
        if (!localStorageService.hasPhoneProtectionEnabled) {
          showSimpleNotification(
              Text('${AppLocalizations.of(context).pleaseSetupDeviceSecurity}'),
              position: NotificationPosition.bottom,
              background: red);
          navigationService.navigateUsingpopAndPushedNamed(routeName);
          localStorageService.hasCancelledBiometricAuth = false;
        }
      }
    });
  }
}
