import 'dart:convert';

import 'package:exchangilymobileapp/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final log = getLogger('LocalStorageService');
  static LocalStorageService _instance;
  static SharedPreferences _preferences;
/*----------------------------------------------------------------------
                Local Storage Keys
----------------------------------------------------------------------*/
  static const String noticeDialogDisplayKey = 'isDialogDisplay';
  static const String showCaseViewKey = 'isShowCaseView';
  static const String appLanguagesKey = 'languages';
  static const String darkModeKey = 'darkmode';
  static const String hKServerKey = 'isHKServer';
  static const String uSServerKey = 'isUSServer';
  static const String walletBalancesBodyKey = 'walletBalancesBody';
  static const String tokenListKey = 'tokenList';
  static const String favWalletCoinsKey = 'favWalletCoinsKey';
  static const String favCoinTabSelectedKey = 'favCoinTabSelectedKey';
  static const String walletDecimalListKey = 'walletDecimalListKey';
  static const String inAppBiometricAuthKey = 'biometricAuthKey';
  static const String cancelBiometricAuthKey = 'cancelbiometricAuthKey';
  static const String phoneProtectedKey = 'phoneProtectedKey';
  static const String appGoneInTheBackgroundKey = 'appGoneInTheBackgroundKey';
  static const String walletVerificationKey = 'walletVerificationKey';
  static const String testingLogStringListKey = 'testingLogStringListKey';
  static const String customTokensKey = 'customTokensKey';
  static const String singleCustomTokenDataKey = 'customTokenDataKey';
  static const String cameraOpenKey = 'CameraOpenKey';
  static const String privacyConsentKey = 'privacyConsentKey';
  static const String tokenListDbUpdateTimeKey = 'tokenListDbUpdateTimeKey';

/*----------------------------------------------------------------------
                  Instance
----------------------------------------------------------------------*/
  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();

    _preferences ??= await SharedPreferences.getInstance();

    return _instance;
  }

  void clearStorage() {
    _preferences.clear();
  }

/*----------------------------------------------------------------------
            Updated _saveToDisk function that handles all types
----------------------------------------------------------------------*/

  void _saveToDisk<T>(String key, T content) {
    debugPrint(
        '(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

/*----------------------------------------------------------------------
                Get data from disk
----------------------------------------------------------------------*/

  dynamic _getFromDisk(String key) {
    var value = _preferences.get(key);
    // log.i('key: $key value: $value');

    return value;
  }

  int getStoredListLength(String jsonStringData) {
    int objLength = 0;
    var obj = jsonDecode(jsonStringData) as List;
    if (obj != null) {
      objLength = obj.length;
      log.w('getStoredListLength $objLength');
    }
    return objLength;
  }

  String get tokenListDBUpdateTime =>
      _getFromDisk(tokenListDbUpdateTimeKey) ?? '';
  set tokenListDBUpdateTime(String value) =>
      _saveToDisk(tokenListDbUpdateTimeKey, value);

  bool get hasPrivacyConsent => _getFromDisk(privacyConsentKey) ?? false;
  set hasPrivacyConsent(bool value) => _saveToDisk(privacyConsentKey, value);

  // is camera open

  bool get isCameraOpen => _getFromDisk(cameraOpenKey) ?? false;
  set isCameraOpen(bool value) => _saveToDisk(cameraOpenKey, value);

  // Custom token Data

  String get customTokenData => _getFromDisk(singleCustomTokenDataKey) ?? '';

  set customTokenData(String value) =>
      _saveToDisk(singleCustomTokenDataKey, value);

  // Custom tokens

  String get customTokens => _getFromDisk(customTokensKey) ?? '';

  set customTokens(String value) => _saveToDisk(customTokensKey, value);

/*----------------------------------------------------------------------
                testing log string list
----------------------------------------------------------------------  */
  String get testingLogStringList =>
      _getFromDisk(testingLogStringListKey) ?? '';

  set testingLogStringList(String value) =>
      _saveToDisk(testingLogStringListKey, value);

/*----------------------------------------------------------------------
                walelt verification
----------------------------------------------------------------------*/
  bool get hasWalletVerified => _getFromDisk(walletVerificationKey) ?? false;
  set hasWalletVerified(bool value) =>
      _saveToDisk(walletVerificationKey, value);

/*----------------------------------------------------------------------
                Wallet Decimal List
----------------------------------------------------------------------  */
  String get walletDecimalList => _getFromDisk(walletDecimalListKey) ?? '';

  set walletDecimalList(String value) =>
      _saveToDisk(walletDecimalListKey, value);

/*----------------------------------------------------------------------
                  Languages getter/setter
----------------------------------------------------------------------*/
  String get language => _getFromDisk(appLanguagesKey);
  set language(String appLanguage) => _saveToDisk(appLanguagesKey, appLanguage);

/*----------------------------------------------------------------------
                Dark mode getter/setter
----------------------------------------------------------------------*/
  bool get isDarkMode => _getFromDisk(darkModeKey) ?? false;
  set isDarkMode(bool value) => _saveToDisk(darkModeKey, value);

/*----------------------------------------------------------------------
                Biometric auth getter/setter
----------------------------------------------------------------------*/
  bool get hasAppGoneInTheBackgroundKey =>
      _getFromDisk(appGoneInTheBackgroundKey) ?? false;
  set hasAppGoneInTheBackgroundKey(bool value) =>
      _saveToDisk(appGoneInTheBackgroundKey, value);

  bool get hasPhoneProtectionEnabled =>
      _getFromDisk(phoneProtectedKey) ?? false;
  set hasPhoneProtectionEnabled(bool value) =>
      _saveToDisk(phoneProtectedKey, value);

  bool get hasInAppBiometricAuthEnabled =>
      _getFromDisk(inAppBiometricAuthKey) ?? false;
  set hasInAppBiometricAuthEnabled(bool value) =>
      _saveToDisk(inAppBiometricAuthKey, value);

// is cancel biometric authentication
  bool get hasCancelledBiometricAuth =>
      _getFromDisk(cancelBiometricAuthKey) ?? false;
  set hasCancelledBiometricAuth(bool value) =>
      _saveToDisk(cancelBiometricAuthKey, value);

/*----------------------------------------------------------------------
                Notice Dialog getter/setter
----------------------------------------------------------------------  */
  bool get isNoticeDialogDisplay =>
      _getFromDisk(noticeDialogDisplayKey) ?? false;

  set isNoticeDialogDisplay(bool value) =>
      _saveToDisk(noticeDialogDisplayKey, value);

/*----------------------------------------------------------------------
                Showcase View getter/setter
----------------------------------------------------------------------  */
  bool get isShowCaseView => _getFromDisk(showCaseViewKey) ?? false;

  set isShowCaseView(bool value) => _saveToDisk(showCaseViewKey, value);

/*----------------------------------------------------------------------
                Is HK server getter/setter
----------------------------------------------------------------------  */
  bool get isHKServer => _getFromDisk(hKServerKey) ?? false;

  set isHKServer(bool value) => _saveToDisk(hKServerKey, value);

/*----------------------------------------------------------------------
                Is USD server getter/setter
----------------------------------------------------------------------  */
  bool get isUSServer => _getFromDisk(uSServerKey) ?? false;

  set isUSServer(bool value) => _saveToDisk(uSServerKey, value);

/*----------------------------------------------------------------------
                Wallet balance body
----------------------------------------------------------------------  */
  String get walletBalancesBody => _getFromDisk(walletBalancesBodyKey) ?? '';

  set walletBalancesBody(String value) =>
      _saveToDisk(walletBalancesBodyKey, value);

/*----------------------------------------------------------------------
                Fav wallet coins
----------------------------------------------------------------------  */
  String get favWalletCoins => _getFromDisk(favWalletCoinsKey) ?? '';

  set favWalletCoins(String value) => _saveToDisk(favWalletCoinsKey, value);

/*----------------------------------------------------------------------
                    Token List
----------------------------------------------------------------------  */
  List<String> get tokenList => _getFromDisk(tokenListKey) ?? false;

  set tokenList(List<String> value) => _saveToDisk(tokenListKey, value);

/*----------------------------------------------------------------------
                Showcase View getter/setter
----------------------------------------------------------------------  */
  bool get isFavCoinTabSelected => _getFromDisk(favCoinTabSelectedKey) ?? false;

  set isFavCoinTabSelected(bool value) =>
      _saveToDisk(favCoinTabSelectedKey, value);
}
