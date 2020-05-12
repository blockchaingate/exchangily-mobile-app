class TransactionHistory {
  String _id;
  String _tickerName;
  String _address;
  double _amount;
  String _date;
  String _txid;
  String _status;
  double _quantity;
  String _tag;

  TransactionHistory(
      {String id,
      String tickerName,
      String address,
      double amount,
      String date,
      String txid,
      String status,
      double quantity,
      String tag}) {
    this._id = id ?? '';
    this._tickerName = tickerName ?? '';
    this._address = address ?? '';
    this._amount = amount ?? 0.0;
    this._date = date ?? '';
    this._txid = txid ?? '';
    this._status = status ?? '';
    this._quantity = quantity ?? 0.0;
    this._tag = tag ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this._id;
    data['tickerName'] = this._tickerName;
    data['address'] = this._address;
    data['amount'] = this._amount;
    data['date'] = this._date;
    data['txid'] = this._txid;
    data['status'] = this._status;
    data['quantity'] = this._quantity;
    data['tag'] = this._tag;
    return data;
  }

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
        id: json['id'] as String,
        tickerName: json['tickerName'] as String,
        address: json['address'] as String,
        amount: json['amount'],
        date: json['date'] as String,
        txid: json['txid'],
        status: json['status'],
        quantity: json['quantity'],
        tag: json['tag']);
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

  double get amount => _amount;

  set amount(double amount) {
    this._amount = amount;
  }

  String get date => _date;

  set date(String date) {
    this._date = date;
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

  String get tag => _tag;

  set tag(String tag) {
    this._tag = tag;
  }
}

class TransactionHistoryList {
  final List<TransactionHistory> transactions;
  TransactionHistoryList({this.transactions});

  factory TransactionHistoryList.fromJson(List<dynamic> parsedJson) {
    List<TransactionHistory> transactions = new List<TransactionHistory>();
    transactions =
        parsedJson.map((i) => TransactionHistory.fromJson(i)).toList();
    return new TransactionHistoryList(transactions: transactions);
  }
}
