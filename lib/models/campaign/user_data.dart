class CampaignUserData {
  int _id;
  String _email;
  String _token;
  String _referralCode;
  String _dateCreated;
  String _memberId;
// AppUser appUser;
  CampaignUserData(
      {int id,
      String email,
      String token,
      String referralCode,
      String dateCreated,
      String memberId}) {
    this._id = id;
    this._email = email;
    this._token = token;
    this._referralCode = referralCode ?? '';
    this._dateCreated = dateCreated ?? '';

    this._memberId = memberId;
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'email': _email,
        'token': _token,
        'referralCode': _referralCode,
        'dateCreated': _dateCreated,
        'memberId': _memberId
      };

  factory CampaignUserData.fromJson(Map<String, dynamic> json) {
    return new CampaignUserData(
        id: json['id'] as int,
        email: json['email'] as String,
        token: json['token'] as String,
        referralCode: json['referralCode'],
        dateCreated: json['dateCreated'] as String,
        memberId: json['memberId']);
  }

  int get id => _id;

  set id(int id) {
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

  String get referralCode => _referralCode;

  set referralCode(String referralCode) {
    this._referralCode = referralCode;
  }

  String get dateCreated => _dateCreated;

  set dateCreated(String dateCreated) {
    this._dateCreated = dateCreated;
  }

  String get memberId => _memberId;
  set memberId(String memberId) {
    this._memberId = memberId;
  }
}
