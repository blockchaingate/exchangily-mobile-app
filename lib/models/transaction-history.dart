class TransactionHistory {
  int _id;
  String _tickerName;
  String _address;
  double _amount;
  String _date;

  TransactionHistory(
      {int id, String tickerName, String address, double amount, String date}) {
    this._id = id;
    this._tickerName = tickerName;
    this._address = address;
    this._amount = amount ?? 0.0;
    this._date = date;
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'tickerName': _tickerName,
        'address': _address,
        'amount': _amount,
        'date': _date,
      };

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return new TransactionHistory(
        id: json['id'] as int,
        tickerName: json['tickerName'] as String,
        address: json['address'] as String,
        amount: json['amount'] as double,
        date: json['date'] as String);
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
}
