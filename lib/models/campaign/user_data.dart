class CampaignUserData {
  String? _id; // this is actually member id
  String? _email;
  String? _token;
  int? _referralCode;

  CampaignUserData(
      {String? id,
      String? email,
      String? token,
      int? referralCode,
      String? dateCreated}) {
    _id = id;
    _email = email ?? '';
    _token = token ?? '';
    _referralCode = referralCode ?? -1;
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'email': _email,
        'token': _token,
        'referralCode': _referralCode
      };

  factory CampaignUserData.fromJson(Map<String, dynamic> json) {
    return CampaignUserData(
        id: json['id'] as String?,
        email: json['email'] as String?,
        token: json['token'] as String?,
        referralCode: json['referralCode'] as int?);
  }

  String? get id => _id;

  set id(String? id) {
    _id = id;
  }

  String? get email => _email;

  set email(String? email) {
    _email = email;
  }

  String? get token => _token;

  set token(String? address) {
    _token = token;
  }

  int? get referralCode => _referralCode;

  set referralCode(int? referralCode) {
    _referralCode = referralCode;
  }
}
