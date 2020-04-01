class CampaignUserData {
  String _id;
  String _email;
  String _token;
  int _referralCode;

  CampaignUserData(
      {String id,
      String email,
      String token,
      int referralCode,
      String dateCreated}) {
    this._id = id;
    this._email = email;
    this._token = token;
    this._referralCode = referralCode ?? '';
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'email': _email,
        'token': _token,
        'referralCode': _referralCode
      };

  factory CampaignUserData.fromJson(Map<String, dynamic> json) {
    return new CampaignUserData(
        id: json['id'] as String,
        email: json['email'] as String,
        token: json['token'] as String,
        referralCode: json['referralCode'] as int);
  }

  String get id => _id;

  set id(String id) {
    this._id = id;
  }

  String get email => _email;

  set email(String email) {
    this._email = email;
  }

  String get token => _token;

  set token(String address) {
    this._token = token;
  }

  int get referralCode => _referralCode;

  set referralCode(int referralCode) {
    this._referralCode = referralCode;
  }
}
