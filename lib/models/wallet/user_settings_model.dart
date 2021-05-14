class UserSettings {
  int _id;
  String _language;
  String _theme;
  Map<String, String> _walletBalancesBody;
  List<String> _favWalletCoins;

  UserSettings(
      {int id,
      String language,
      String theme,
      Map<String, String> walletBalancesBody,
      List<String> favWalletCoins}) {
    this._id = id;
    this._language = language ?? '';
    this._theme = theme ?? '';
    this._walletBalancesBody = walletBalancesBody;
    this._favWalletCoins = favWalletCoins;
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'language': _language,
        'theme': _theme,
        'walletBalancesBody': _walletBalancesBody,
        'favWalletCoins': _favWalletCoins
      };

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return new UserSettings(
        id: json['id'] as int,
        language: json['language'] as String,
        theme: json['json'] as String,
        walletBalancesBody: json['walletBalancesBody'],
        favWalletCoins: json['favWalletCoins']);
  }

  int get id => _id;
  set id(int id) {
    this._id = id;
  }

  String get language => _language;
  set language(String language) {
    this._language = language;
  }

  String get theme => _theme;
  set theme(String theme) {
    this._theme = theme;
  }

  Map<String, String> get walletBalancesBody => _walletBalancesBody;
  set walletBalancesBody(Map<String, String> walletBalancesBody) {
    this._walletBalancesBody = walletBalancesBody;
  }
}
