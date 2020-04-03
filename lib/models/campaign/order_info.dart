class OrderInfo {
  String _id;
  String _dateCreated;
  String _txid;
  String _status;
  double _quantity;

  OrderInfo(
      {String id,
      String dateCreated,
      String txid,
      String status,
      double quantity}) {
    this._id = id;
    this._dateCreated = dateCreated ?? '';
    this._txid = txid ?? '';
    this._status = status ?? '';
    this._quantity = quantity;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this._id;
    data['dateCreated'] = this._dateCreated;
    data['txid'] = this._txid;
    data['status'] = this._status;
    data['quantity'] = this._quantity;
    return data;
  }

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
        id: json['id'] as String,
        dateCreated: json['dateCreated'] as String,
        txid: json['txid'],
        status: json['status'],
        quantity: json['quantity']);
  }

  String get id => _id;

  set id(String id) {
    this._id = id;
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

class OrderInfoList {
  final List<OrderInfo> orders;
  OrderInfoList({this.orders});

  factory OrderInfoList.fromJson(List<dynamic> parsedJson) {
    List<OrderInfo> orders = new List<OrderInfo>();
    orders = parsedJson.map((i) => OrderInfo.fromJson(i)).toList();
    return new OrderInfoList(orders: orders);
  }
}
