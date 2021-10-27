import 'package:exchangilymobileapp/logger.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LocalAuthService {
  final _auth = LocalAuthentication();
  final log = getLogger('LocalAuthService');
  bool _isProtectionEnabled = false;

  bool get isProtectionEnabled => _isProtectionEnabled;

  bool _isLockedOut = false;
  bool get isLockedOut => _isLockedOut;

  bool _isLockedOutPerm = false;
  bool get isLockedOutPerm => _isLockedOutPerm;

  // cancel authentication
  void cancelAuthentication() {
    _auth.stopAuthentication();
  }

  Future<bool> authenticate() async {
    bool isAuthenticated = false;
    // bool isBiometricSecurityAvailable =
    //     await _auth.canCheckBiometrics.then((value) => value);
    //  if (isBiometricSecurityAvailable) {
    try {
      isAuthenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to access the wallet',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      //    .then((value) => isAuthenticated = value);
      _isProtectionEnabled = true;
      log.i('isAuthenticated 1 $isAuthenticated');
    } on PlatformException catch (e) {
      // when any type of authentication is not set
      if (e.code == auth_error.notAvailable ||
          e.code == auth_error.notEnrolled ||
          e.code == auth_error.passcodeNotSet) {
        _isProtectionEnabled = false;
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
        'isAuthenticated $isAuthenticated --  _isLockedOutPerm $_isLockedOutPerm -- _isLockedOut $_isLockedOut --  _isProtectionEnabled $_isProtectionEnabled');
    return isAuthenticated;
  }
}
