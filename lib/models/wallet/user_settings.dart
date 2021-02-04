class UserSettings {
  int _id;
  String _language;
  String _theme;

  UserSettings({int id, String language, String theme}) {
    this._id = id;
    this._language = language ?? '';
    this._theme = theme ?? '';
  }

  Map<String, dynamic> toJson() =>
      {'id': _id, 'language': _language, 'theme': _theme};

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return new UserSettings(
        id: json['id'] as int,
        language: json['language'] as String,
        theme: json['json'] as String);
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
}
