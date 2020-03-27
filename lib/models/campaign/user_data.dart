class CampaignUserData {
  int _id;
  String _email;
  String _token;
  String _referralCode;
  String _dateCreated;
  double _parentDiscount;
  double _totalUSDMadeByChildren;
  double _totalTokensPurchased;
  double _pointsEarned;

  CampaignUserData(
      {int id,
      String email,
      String token,
      String referralCode,
      double parentDiscount,
      String dateCreated,
      double totalUSDMadeByChildren,
      double totalTokensPurchased,
      double pointsEarned}) {
    this._id = id;
    this._email = email;
    this._token = token;
    this._referralCode = referralCode ?? '';
    this._parentDiscount = parentDiscount ?? 0.0;
    this._dateCreated = dateCreated ?? '';
    this._totalUSDMadeByChildren = totalUSDMadeByChildren ?? 0.0;
    this._totalTokensPurchased = totalTokensPurchased ?? 0.0;
    this._pointsEarned = pointsEarned ?? 0.0;
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'email': _email,
        'token': _token,
        'referralCode': _referralCode,
        'parentDiscount': _parentDiscount,
        'dateCreated': _dateCreated,
        'totalUSDMadeByChildren': _totalUSDMadeByChildren,
        'totalTokensPurchased': _totalTokensPurchased,
        'pointsEarned': _pointsEarned
      };

  factory CampaignUserData.fromJson(Map<String, dynamic> json) {
    return new CampaignUserData(
        id: json['id'] as int,
        email: json['email'] as String,
        token: json['token'] as String,
        referralCode: json['referralCode'],
        parentDiscount: json['parentDiscount'] as double,
        dateCreated: json['dateCreated'] as String,
        totalUSDMadeByChildren: json['totalUSDMadeByChildren'],
        totalTokensPurchased: json['totalTokensPurchased'],
        pointsEarned: json['pointsEarned']);
  }

  int get id => _id;

  set id(int id) {
    this._id = id;
  }

  String get email => _email;

  set tickerName(String email) {
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

  double get parentDiscount => _parentDiscount;

  set parentDiscount(double parentDiscount) {
    this._parentDiscount = parentDiscount;
  }

  String get dateCreated => _dateCreated;

  set name(String dateCreated) {
    this._dateCreated = dateCreated;
  }

  double get totalUSDMadeByChildren => _totalUSDMadeByChildren;

  set totalUSDMadeByChildren(double totalUSDMadeByChildren) {
    this._totalUSDMadeByChildren = totalUSDMadeByChildren;
  }

  double get totalTokensPurchased => _totalTokensPurchased;

  set totalTokensPurchased(double totalTokensPurchased) {
    this._totalTokensPurchased = totalTokensPurchased;
  }

  double get pointsEarned => _pointsEarned;

  set pointsEarned(double pointsEarned) {
    this._pointsEarned = pointsEarned;
  }
}
