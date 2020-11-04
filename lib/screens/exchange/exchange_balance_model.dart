class ExchangeBalanceModel {
  double unlockedAmount;
  double lockedAmount;

  ExchangeBalanceModel({double unlockedAmount, double lockedAmount});

  factory ExchangeBalanceModel.fromJson(Map<String, dynamic> json) {
    return new ExchangeBalanceModel(
        unlockedAmount: json['unlockedAmount'] as double,
        lockedAmount: json['lockedAmount'] as double);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unlockedAmount'] = this.unlockedAmount;
    data['lockedAmount'] = this.lockedAmount;

    return data;
  }
}
