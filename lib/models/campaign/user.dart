class User {
  String _email;
  String _password;

  User({String email, String password}) {
    this._email = email;
    this._password = password;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this._email;
    data['password'] = this._password;
    return data;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(email: json['email'], password: json['password']);
  }

  String get email => _email;
  set email(String email) {
    this._email = email;
  }

  String get password => _password;
  set password(String password) {
    this._password = password;
  }
}
