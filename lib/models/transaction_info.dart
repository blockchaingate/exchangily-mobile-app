class TransactionInfo {
  String _id;
  String _tickerName;
  String _address;
  int _amount;
  String _dateCreated;
  String _txid;
  String _status;
  double _quantity;

  TransactionInfo(
      {String id,
      String tickerName,
      String address,
      int amount,
      String dateCreated,
      String txid,
      String status,
      double quantity}) {
    this._id = id;
    this._tickerName = tickerName ?? '';
    this._address = address ?? '';
    this._amount = amount ?? 0;
    this._dateCreated = dateCreated ?? '';
    this._txid = txid ?? '';
    this._status = status ?? 0;
    this._quantity = quantity ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this._id;
    data['tickerName'] = this._tickerName;
    data['address'] = this._address;
    data['amount'] = this._amount;
    data['dateCreated'] = this._dateCreated;
    data['txid'] = this._txid;
    data['status'] = this._status;
    data['quantity'] = this._quantity;
    return data;
  }

  factory TransactionInfo.fromJson(Map<String, dynamic> json) {
    return TransactionInfo(
        id: json['id'] as String,
        tickerName: json['tickerName'] as String,
        address: json['address'] as String,
        amount: json['amount'],
        dateCreated: json['dateCreated'] as String,
        txid: json['txid'],
        status: json['status'],
        quantity: json['quantity']);
  }

  String get id => _id;

  set id(String id) {
    this._id = id;
  }

  String get tickerName => _tickerName;

  set tickerName(String tickerName) {
    this._tickerName = tickerName;
  }

  String get address => _address;

  set address(String address) {
    this._address = address;
  }

  int get amount => _amount;

  set amount(int amount) {
    this._amount = amount;
  }

  String get dateCreated => _dateCreated;

  set dateCreated(String dateCreated) {
    this._dateCreated = dateCreated;
  }

  String get txid => _txid;

  set txid(String txid) {
    this._txid = txid;
  }

  String get status => _status;
  set status(String status) {
    this._status = status;
  }

  double get quantity => _quantity;
  set quantity(double quantity) {
    this._quantity = quantity;
  }
}

class TransactionInfoList {
  final List<TransactionInfo> transactions;
  TransactionInfoList({this.transactions});

  factory TransactionInfoList.fromJson(List<dynamic> parsedJson) {
    List<TransactionInfo> transactions = new List<TransactionInfo>();
    transactions = parsedJson.map((i) => TransactionInfo.fromJson(i)).toList();
    return new TransactionInfoList(transactions: transactions);
  }
}
