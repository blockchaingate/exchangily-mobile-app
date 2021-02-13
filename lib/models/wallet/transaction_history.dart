class TransactionHistory {
  int _id;
  String _tickerName;
  String _address;
  double _amount;
  String _date;
  String _tickerChainTxId;
  String _kanbanTxId;
  String _tickerChainTxStatus; // for deposit look for this one first
  String _kanbanTxStatus; // for withdraw look for this one first
  double _quantity;
  String _tag;

  TransactionHistory(
      {int id,
      String tickerName,
      String address,
      double amount,
      String date,
      String tickerChainTxId,
      String kanbanTxId,
      String tickerChainTxStatus,
      String kanbanTxStatus,
      double quantity,
      String tag}) {
    this._id = id;
    this._tickerName = tickerName ?? '';
    this._address = address ?? '';
    this._amount = amount ?? 0.0;
    this._date = date ?? '';
    this._tickerChainTxId = tickerChainTxId ?? '';
    this._kanbanTxId = kanbanTxId ?? '';
    this._tickerChainTxStatus = tickerChainTxStatus ?? '';
    this._kanbanTxStatus = kanbanTxStatus ?? '';
    this._quantity = quantity ?? 0.0;
    this._tag = tag ?? '';
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'tickerName': _tickerName,
        'address': _address,
        'amount': _amount,
        'date': _date,
        'tickerChainTxId': _tickerChainTxId,
        'kanbanTxId': _kanbanTxId,
        'tickerChainTxStatus': _tickerChainTxStatus,
        'kanbanTxStatus': _kanbanTxStatus,
        'quantity': _quantity,
        'tag': _tag
      };

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
        id: json['id'],
        tickerName: json['tickerName'] as String,
        address: json['address'] as String,
        amount: json['amount'],
        date: json['date'] as String,
        tickerChainTxId: json['tickerChainTxId'],
        kanbanTxId: json['kanbanTxId'],
        tickerChainTxStatus: json['tickerChainTxStatus'],
        kanbanTxStatus: json['kanbanTxStatus'],
        quantity: json['quantity'],
        tag: json['tag']);
  }

  int get id => _id;

  set id(int id) {
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

  String get tickerChainTxId => _tickerChainTxId;

  set tickerChainTxId(String tickerChainTxId) {
    this._tickerChainTxId = tickerChainTxId;
  }

  String get kanbanTxId => _kanbanTxId;

  set kanbanTxId(String kanbanTxId) {
    this._kanbanTxId = kanbanTxId;
  }

  String get tickerChainTxStatus => _tickerChainTxStatus;
  set tickerChainTxStatus(String tickerChainTxStatus) {
    this._tickerChainTxStatus = tickerChainTxStatus;
  }

  String get kanbanTxStatus => _kanbanTxStatus;
  set kanbanTxStatus(String kanbanTxStatus) {
    this._kanbanTxStatus = kanbanTxStatus;
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
