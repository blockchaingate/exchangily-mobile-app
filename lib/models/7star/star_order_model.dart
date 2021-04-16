class StarOrder {
  String _walletAdd; // Wallet EXG address

  // 0: waiting for payment,
  // 1: payment made,
  // 3: payment confirmed,
  // 4: completed - coins sent,
  // 5: cancelled, 6: suspended
  String _status;

  double _amount;
  String _currency;
  DateTime _dateUpdated;
  DateTime _dateCreated;

  StarOrder(
      {String walletAdd,
      String status,
      double amount,
      String currency,
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
    data['amount'] = this._amount;
    data['currency'] = this._currency;
    data["dateUpdated"] = this._dateUpdated;
    data["dateCreated"] = this._dateCreated;
    return data;
  }

  factory StarOrder.fromJson(Map<String, dynamic> json) {
    return new StarOrder(
        walletAdd: json['walletAdd'],
        status: json['status'],
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

  String get currency => _currency;
  set currency(String currency) {
    this._currency = currency;
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
