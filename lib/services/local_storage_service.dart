import 'package:exchangilymobileapp/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final log = getLogger('LocalStorageService');
  static LocalStorageService _instance;
  static SharedPreferences _preferences;
/*----------------------------------------------------------------------
                Local Storage Keys
----------------------------------------------------------------------*/
  static const String ShowCaseViewKey = 'showCaseView';
  static const String AppLanguagesKey = 'languages';
  static const String DarkModeKey = 'darkmode';
  static const String HKServerKey = 'isHKServer';
/*----------------------------------------------------------------------
                  Instance
----------------------------------------------------------------------*/
  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

/*----------------------------------------------------------------------
            Updated _saveToDisk function that handles all types
----------------------------------------------------------------------*/

  void _saveToDisk<T>(String key, T content) {
    print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

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
    log.i('key: $key value: $value');
    return value;
  }

/*----------------------------------------------------------------------
                  Languages getter/setter
----------------------------------------------------------------------*/
  List<String> get languages => _getFromDisk(AppLanguagesKey) ?? List<String>();
  set languages(List<String> appLanguages) =>
      _saveToDisk(AppLanguagesKey, appLanguages);

/*----------------------------------------------------------------------
                Dark mode getter/setter
----------------------------------------------------------------------*/
  bool get darkMode => _getFromDisk(DarkModeKey) ?? false;
  set darkMode(bool value) => _saveToDisk(DarkModeKey, value);

/*----------------------------------------------------------------------
                Showcase View getter/setter
----------------------------------------------------------------------  */
  bool get isShowCaseView => _getFromDisk(ShowCaseViewKey) ?? false;

  set isShowCaseView(bool value) => _saveToDisk(ShowCaseViewKey, value);

/*----------------------------------------------------------------------
                Is HK server getter/setter
----------------------------------------------------------------------  */
  bool get isHKServer => _getFromDisk(HKServerKey) ?? false;

  set isHKServer(bool value) => _saveToDisk(HKServerKey, value);
}
