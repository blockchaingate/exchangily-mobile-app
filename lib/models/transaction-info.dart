class TransactionInfo {
  int _id;
  String _tickerName;
  String _address;
  double _amount;
  String _date;
  String _txid;
  int _status;

  TransactionInfo(
      {int id,
      String tickerName,
      String address,
      double amount,
      String date,
      String txid,
      int status}) {
    this._id = id;
    this._tickerName = tickerName ?? '';
    this._address = address ?? '';
    this._amount = amount ?? 0.0;
    this._date = date ?? '';
    this._txid = txid ?? '';
    this._status = status ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'tickerName': _tickerName,
        'address': _address,
        'amount': _amount,
        'date': _date,
        'txid': _txid,
        'status': _status
      };

  factory TransactionInfo.fromJson(Map<String, dynamic> json) {
    return new TransactionInfo(
        id: json['id'] as int,
        tickerName: json['tickerName'] as String,
        address: json['address'] as String,
        amount: json['amount'] as double,
        date: json['date'] as String,
        txid: json['txid'],
        status: json['status']);
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

  set name(String date) {
    this._date = date;
  }

  String get txid => _txid;

  set txid(String txid) {
    this._txid = txid;
  }

  int get status => _status;
  set status(int status) {
    this._status = status;
  }
}
