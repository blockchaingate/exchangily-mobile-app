class StarPayment {
  String _orderId;
  // 0: waiting for payment,
  // 1: payment made,
  // 3: payment confirmed,
  // 4: completed - coins sent,
  // 5: cancelled, 6: suspended
  String _status;

  double _amount;
  String _currency;
  String _paymentMethod;
  String _txId;
  DateTime _dateUpdated;
  DateTime _dateCreated;

  StarPayment(
      {String orderId,
      String status,
      double amount,
      String currency,
      String paymentMethod,
      String txId,
      DateTime dateUpdated,
      DateTime dateCreated}) {
    this._orderId = orderId ?? '';
    this._status = status ?? '';
    this._amount = amount ?? 0.0;
    this._currency = currency;
    this._paymentMethod = paymentMethod;
    this._txId = txId ?? '';
    this._dateUpdated = dateUpdated;
    this._dateCreated = dateCreated;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this._orderId;
    data['status'] = this._status;
    data['amount'] = this._amount;
    data['currency'] = this._currency;
    data['paymentMethod'] = this._paymentMethod;
    data['transactionId'] = this._txId;
    data["dateUpdated"] = this._dateUpdated;
    data["dateCreated"] = this._dateCreated;
    return data;
  }

  factory StarPayment.fromJson(Map<String, dynamic> json) {
    return new StarPayment(
        orderId: json['orderId'],
        status: json['status'],
        amount: json['amount'],
        currency: json['currency'],
        paymentMethod: json['paymentMethod'],
        txId: json['transactionId'],
        dateUpdated: json['dateUpdated'],
        dateCreated: json['dateCreated']);
  }

  String get orderId => _orderId;
  set orderId(String orderId) {
    this._orderId = orderId;
  }

  String get status => _status;
  set status(String status) {
    this._status = status;
  }

  String get currency => _currency;
  set currency(String currency) {
    this._currency = currency;
  }

  String get paymentMethod => _paymentMethod;
  set paymentMethod(String paymentMethod) {
    this._paymentMethod = paymentMethod;
  }

  String get txId => _txId;
  set txId(String txid) {
    this._txId = txid;
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
