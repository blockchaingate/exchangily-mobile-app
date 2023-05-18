class UserSettings {
  int? _id;
  String? _language;
  String? _theme;
  // List<String> _favWalletCoins;
  // bool _isFavCoinTabSelected;

  UserSettings({
    int? id,
    String? language,
    String? theme,
    //   List<String> favWalletCoins,
    //  bool isFavCoinTabSelected
  }) {
    _id = id;
    _language = language ?? '';
    _theme = theme ?? '';
    // this._favWalletCoins = favWalletCoins;
    // this._isFavCoinTabSelected = isFavCoinTabSelected;
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'language': _language,
        'theme': _theme,
        // 'favWalletCoins': _favWalletCoins,
        // 'isFavCoinTabSelected': _isFavCoinTabSelected
      };

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
        id: json['id'] as int?,
        language: json['language'] as String?,
        theme: json['json'] as String?
        // favWalletCoins: json['favWalletCoins'],
        // isFavCoinTabSelected: json['isFavCoinTabSelected'])
        );
  }

  int? get id => _id;
  set id(int? id) {
    _id = id;
  }

  String? get language => _language;
  set language(String? language) {
    _language = language;
  }

  String? get theme => _theme;
  set theme(String? theme) {
    _theme = theme;
  }

  // bool get isFavCoinTabSelected => _isFavCoinTabSelected;
  // set isFavCoinTabSelected(bool isFavCoinTabSelected) {
  //   this._isFavCoinTabSelected = isFavCoinTabSelected;
  // }
}
