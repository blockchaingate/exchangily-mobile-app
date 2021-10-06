import 'package:exchangilymobileapp/logger.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LocalAuthService {
  final _auth = LocalAuthentication();
  final log = getLogger('LocalAuthService');
  bool _isProtectionEnabled = false;

  bool get isProtectionEnabled => _isProtectionEnabled;

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
      if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
        _isProtectionEnabled = false;
      }
      log.e('catch $e');
    }
    //  }
    //else{await _auth.}
    log.i('isAuthenticated $isAuthenticated');
    return isAuthenticated;
  }
}
