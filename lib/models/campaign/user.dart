class User {
  String? _email;
  String? _password;

  User({String? email, String? password}) {
    _email = email;
    _password = password;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _email;
    data['password'] = _password;
    return data;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(email: json['email'], password: json['password']);
  }

  String? get email => _email;
  set email(String? email) {
    _email = email;
  }

  String? get password => _password;
  set password(String? password) {
    _password = password;
  }
}
