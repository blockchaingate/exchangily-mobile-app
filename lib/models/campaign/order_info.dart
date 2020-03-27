class OrderInfo {
  int _id;
  DateTime _timeStamp;
  double _amount;
  String _status;

  OrderInfo({int id, DateTime timeStamp, String status, double amount}) {
    this._id = id;
    this._timeStamp = timeStamp;
    this._status = status;
    this._amount = amount;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['timeStamp'] = this._timeStamp;
    data['status'] = this._status;
    data['amount'] = this._amount;
    return data;
  }

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return new OrderInfo(
        id: json['id'],
        timeStamp: json['timeStamp'],
        status: json['status'],
        amount: json['amount']);
  }

  int get id => _id;

  set id(int id) {
    this._id = id;
  }

  DateTime get timeStamp => _timeStamp;
  set timeStamp(DateTime timeStamp) {
    this._timeStamp = timeStamp;
  }

  String get status => _status;
  set status(String status) {
    this._status = status;
  }

  double get amount => _amount;
  set amount(double amount) {
    this._amount = amount;
  }
}
