import 'package:exchangilymobileapp/utils/number_util.dart';

class MemberProfile {
  String _membership;
  String _walletExgAddress;
  int _referralCode;
  double _totalValue;
  double _totalQuantities;

  MemberProfile(
      {String membership,
      String walletExgAddress,
      int referralCode,
      String dateCreated,
      double totalValue,
      double totalQuantities}) {
    this._membership = membership ?? '';
    this._walletExgAddress = walletExgAddress ?? '';
    this._referralCode = referralCode;
    this._totalValue = totalValue ?? 0.0;
    this._totalQuantities = totalQuantities ?? 0.0;
  }

  Map<String, dynamic> toJson() => {
        'membership': _membership,
        'walletExgAddress': _walletExgAddress,
        'referralCode': _referralCode,
        'totalValue': _totalValue,
        'totalQuantities': _totalQuantities
      };

  factory MemberProfile.fromJson(Map<String, dynamic> json) {
    return new MemberProfile(
      membership: json['membership'] as String,
      walletExgAddress: json['walletExgAddress'] as String,
      referralCode: json['referralCode'] as int,
      totalValue: json['totalValue'].toDouble(),
      totalQuantities: json['totalQuantities'].toDouble(),
    );
  }

  String get membership => _membership;

  set membership(String membership) {
    this._membership = membership;
  }

  String get walletExgAddress => _walletExgAddress;

  set walletExgAddress(String walletExgAddress) {
    this._walletExgAddress = walletExgAddress;
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
