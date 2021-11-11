import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LocalAuthService {
  final log = getLogger('LocalAuthService');

  final NavigationService navigationService = locator<NavigationService>();
  final localStorageService = locator<LocalStorageService>();

  final _auth = LocalAuthentication();

  bool _isLockedOut = false;
  bool get isLockedOut => _isLockedOut;

  bool _isLockedOutPerm = false;
  bool get isLockedOutPerm => _isLockedOutPerm;

  bool _hasAuthorized = false;
  bool get hasAuthorized => _hasAuthorized;

  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;

  bool _authInProgress = false;
  bool get authInProgress => _authInProgress;

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

  Future<bool> canCheckBiometrics() async {
    return _auth.canCheckBiometrics;
  }

  // Authenticate
  Future<bool> authenticateApp() async {
    _hasAuthorized = false;
    _authInProgress = true;

    try {
      await _auth
          .authenticate(
        localizedReason: 'Authenticate to access the wallet',
        useErrorDialogs: true,
        stickyAuth: true,
      )
          .then((res) {
        _hasAuthorized = res;
        localStorageService.hasPhoneProtectionEnabled = true;
        localStorageService.hasCancelledBiometricAuth = false;
        _authInProgress = false;
        localStorageService.hasAppGoneInTheBackgroundKey = false;
        log.i('_hasAuthorized  $_hasAuthorized');
      });
    } on PlatformException catch (e) {
      // when any type of authentication is not set
      if (e.code == auth_error.notAvailable ||
          e.code == auth_error.notEnrolled ||
          e.code == auth_error.passcodeNotSet) {
        localStorageService.hasCancelledBiometricAuth = false;
        localStorageService.hasInAppBiometricAuthEnabled = false;
        localStorageService.hasPhoneProtectionEnabled = false;
      } else if (e.code == 'auth_in_progress') {
        _authInProgress = true;
        return false;
      } else if (e.code == auth_error.lockedOut) {
        // Too manu failed attempts and locked out temp

        _isCancelled = false;
        _isLockedOut = true;
      } else if (e.code == auth_error.permanentlyLockedOut) {
        // Too manu failed attempts and locked out permanently, now required password/pin
        _isLockedOutPerm = true;
      }
      _authInProgress = false;
      log.e('catch $e');
    }

    if (!isLockedOut && !isLockedOutPerm && !_hasAuthorized) {
      _isCancelled = true;
      if (navigationService.currentRoute() != WalletSetupViewRoute) {
        navigationService.navigateUsingpopAndPushedNamed(WalletSetupViewRoute);
      }
    }

    log.i(
        '_hasAuthenticated $_hasAuthorized --  _isLockedOutPerm $_isLockedOutPerm -- _isLockedOut $_isLockedOut --  hasPhoneProtectionEnabled ${localStorageService.hasPhoneProtectionEnabled}');
    return _hasAuthorized;
  }
}
