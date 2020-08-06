class MemberProfile {
  String _id; // this is actually member id
  String _membership;
  String _walletAddress;
  int _referralCode;
  double _totalValue;
  double _totalQuantities;

  MemberProfile(
      {String id,
      String membership,
      String walletAddress,
      int referralCode,
      String dateCreated,
      double totalValue,
      double totalQuantities}) {
    this._id = id;
    this._membership = membership ?? '';
    this._walletAddress = walletAddress ?? '';
    this._referralCode = referralCode;
    this._totalValue = totalValue ?? 0.0;
    this._totalQuantities = totalQuantities ?? 0.0;
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'membership': _membership,
        'walletAddress': _walletAddress,
        'referralCode': _referralCode,
        'totalValue': _totalValue,
        'totalQuantities': _totalQuantities
      };

  factory MemberProfile.fromJson(Map<String, dynamic> json) {
    return new MemberProfile(
      id: json['id'] as String,
      membership: json['membership'] as String,
      walletAddress: json['walletAddress'] as String,
      referralCode: json['referralCode'] as int,
      totalValue: json['totalValue'].toDouble(),
      totalQuantities: json['totalQuantities'].toDouble(),
    );
  }

  String get id => _id;

  set id(String id) {
    this._id = id;
  }

  String get membership => _membership;

  set membership(String membership) {
    this._membership = membership;
  }

  String get walletAddress => _walletAddress;

  set walletAddress(String walletAddress) {
    this._walletAddress = walletAddress;
  }

  int get referralCode => _referralCode;

  set referralCode(int referralCode) {
    this._referralCode = referralCode;
  }

  double get totalValue => _totalValue;

  set totalValue(double totalValue) {
    this._totalValue = totalValue;
  }

  double get totalQuantities => _totalQuantities;

  set totalQuantities(double totalQuantities) {
    this._totalQuantities = totalQuantities;
  }
}
