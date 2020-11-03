class ExchangeBalanceModel {
  double unlockedAmount;
  double lockedAmount;

  ExchangeBalanceModel({double unlockedAmount, double lockedAmount});

  factory ExchangeBalanceModel.fromJson(Map<String, dynamic> json) {
    return ExchangeBalanceModel(
        unlockedAmount: json['unlockedAmount'] ?? 0.0,
        lockedAmount: json['lockedAmount'] ?? 0.0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unlockedAmount'] = this.unlockedAmount;
    data['lockedAmount'] = this.lockedAmount;

    return data;
  }
}
