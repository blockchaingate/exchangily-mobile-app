class StarOrder {
  String _walletAdd; // Wallet EXG address

  String _status;
  // 0: waiting for payment,
  // 1: payment made,
  // 3: payment confirmed,
  // 4: completed - coins sent,
  // 5: cancelled, 6: suspended
  int _campaignId;
  double _amount;
  String _currency;
  String _referral;
  DateTime _dateUpdated;
  DateTime _dateCreated;

  StarOrder(
      {String walletAdd,
      String status,
      int campaignId,
      double amount,
      String currency,
      String referral,
      DateTime dateUpdated,
      DateTime dateCreated}) {
    this._walletAdd = walletAdd;
    this._status = status ?? '';
    this._amount = amount ?? 0.0;
    this._currency = currency;
    this._dateUpdated = dateUpdated;
    this._dateCreated = dateCreated;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['walletAdd'] = this._walletAdd;
    data['status'] = this._status;
    data['campaignId'] = this._campaignId;
    data['amount'] = this._amount;
    data['currency'] = this._currency;
    data['referral'] = this._referral;
    data["dateUpdated"] = this._dateUpdated;
    data["dateCreated"] = this._dateCreated;
    return data;
  }

  factory StarOrder.fromJson(Map<String, dynamic> json) {
    return new StarOrder(
        walletAdd: json['walletAdd'],
        status: json['status'],
        campaignId: json['campaignId'],
        amount: json['amount'],
        currency: json['currency'],
        dateUpdated: json['dateUpdated'],
        dateCreated: json['dateCreated']);
  }

  String get walletAdd => _walletAdd;
  set walletAdd(String walletAdd) {
    this._walletAdd = walletAdd;
  }

  String get status => _status;
  set status(String status) {
    this._status = status;
  }

  int get campaignId => _campaignId;
  set campaignId(int campaignId) {
    this._campaignId = campaignId;
  }

  String get currency => _currency;
  set currency(String currency) {
    this._currency = currency;
  }

  String get referral => _referral;
  set referral(String referral) {
    this._referral = referral;
  }

  double get amount => _amount;
  set amount(double amount) {
    this._amount = amount;
  }

  DateTime get dateUpdated => _dateUpdated;
  set dateUpdated(DateTime dateUpdated) {
    this._dateUpdated = dateUpdated;
  }

  DateTime get dateCreated => _dateCreated;
  set dateCreated(DateTime dateCreated) {
    this._dateCreated = dateCreated;
  }
}
