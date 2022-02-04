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
  String _chainName;

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
      String tag,
      String chainName}) {
    _id = id;
    _tickerName = tickerName ?? '';
    _address = address ?? '';
    _amount = amount ?? 0.0;
    _date = date ?? '';
    _tickerChainTxId = tickerChainTxId ?? '';
    _kanbanTxId = kanbanTxId ?? '';
    _tickerChainTxStatus = tickerChainTxStatus ?? '';
    _kanbanTxStatus = kanbanTxStatus ?? '';
    _quantity = quantity ?? 0.0;
    _tag = tag ?? '';
    _chainName = chainName ?? '';
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
        'tag': _tag,
        'chainName': _chainName
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
        tag: json['tag'],
        chainName: json['chainName']);
  }

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  String get tickerName => _tickerName;

  set tickerName(String tickerName) {
    _tickerName = tickerName;
  }

  String get address => _address;

  set address(String address) {
    _address = address;
  }

  double get amount => _amount;

  set amount(double amount) {
    _amount = amount;
  }

  String get date => _date;

  set date(String date) {
    _date = date;
  }

  String get tickerChainTxId => _tickerChainTxId;

  set tickerChainTxId(String tickerChainTxId) {
    _tickerChainTxId = tickerChainTxId;
  }

  String get kanbanTxId => _kanbanTxId;

  set kanbanTxId(String kanbanTxId) {
    _kanbanTxId = kanbanTxId;
  }

  String get tickerChainTxStatus => _tickerChainTxStatus;
  set tickerChainTxStatus(String tickerChainTxStatus) {
    _tickerChainTxStatus = tickerChainTxStatus;
  }

  String get kanbanTxStatus => _kanbanTxStatus;
  set kanbanTxStatus(String kanbanTxStatus) {
    _kanbanTxStatus = kanbanTxStatus;
  }

  double get quantity => _quantity;
  set quantity(double quantity) {
    _quantity = quantity;
  }

  String get tag => _tag;

  set tag(String tag) {
    _tag = tag;
  }

  String get chainName => _chainName;

  set chainName(String chainName) {
    _chainName = chainName;
  }
}

class TransactionHistoryList {
  final List<TransactionHistory> transactions;
  TransactionHistoryList({this.transactions});

  factory TransactionHistoryList.fromJson(List<dynamic> parsedJson) {
    List<TransactionHistory> transactions = <TransactionHistory>[];
    transactions =
        parsedJson.map((i) => TransactionHistory.fromJson(i)).toList();
    return TransactionHistoryList(transactions: transactions);
  }
}
