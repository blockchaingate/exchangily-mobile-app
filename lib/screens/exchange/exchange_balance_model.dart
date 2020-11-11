import 'package:exchangilymobileapp/utils/string_util.dart';

class ExchangeBalanceModel {
  double _unlockedAmount;
  double _lockedAmount;

  ExchangeBalanceModel({double unlockedAmount, double lockedAmount}) {
    this._unlockedAmount = unlockedAmount ?? 0.0;
    this._lockedAmount = lockedAmount ?? 0.0;
  }

  factory ExchangeBalanceModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return ExchangeBalanceModel(
        unlockedAmount: bigNum2Double(json['unlockedAmount']).toDouble(),
        lockedAmount: bigNum2Double(json['lockedAmount']).toDouble());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unlockedAmount'] = this.unlockedAmount;
    data['lockedAmount'] = this.lockedAmount;

    return data;
  }

  double get unlockedAmount => _unlockedAmount;
  set unlockedAmount(double unlockedAmount) {
    this._unlockedAmount = unlockedAmount;
  }

  double get lockedAmount => _lockedAmount;
  set lockedAmount(double lockedAmount) {
    this._lockedAmount = lockedAmount;
  }
}
