class OrderInfo {
  String? _id;
  String? _dateCreated;
  String? _txId;
  String? _status;
  double? _quantity;

  OrderInfo(
      {String? id,
      String? dateCreated,
      String? txId,
      String? status,
      double? quantity}) {
    this.id = id;
    _dateCreated = dateCreated ?? '';
    _txId = txId ?? '';
    _status = status ?? '';
    _quantity = quantity;
  }

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
        id: json['_id'] as String?,
        dateCreated: json['dateCreated'] as String?,
        txId: json['txId'],
        status: json['status'],
        quantity: json['quantity'].toDouble());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _id;
    data['dateCreated'] = _dateCreated;
    data['txid'] = _txId;
    data['status'] = _status;
    data['quantity'] = _quantity;
    return data;
  }

  String? get id => _id;

  set id(String? id) {
    _id = id;
  }

  String? get dateCreated => _dateCreated;

  set dateCreated(String? dateCreated) {
    _dateCreated = dateCreated;
  }

  String? get txId => _txId;

  set txId(String? txid) {
    _txId = txid;
  }

  String? get status => _status;
  set status(String? status) {
    _status = status;
  }

  double? get quantity => _quantity;
  set quantity(double? quantity) {
    _quantity = quantity;
  }
}

class OrderInfoList {
  final List<OrderInfo>? orders;
  OrderInfoList({this.orders});

  factory OrderInfoList.fromJson(List<dynamic> parsedJson) {
    List<OrderInfo> orders = <OrderInfo>[];
    orders = parsedJson.map((i) => OrderInfo.fromJson(i)).toList();
    return OrderInfoList(orders: orders);
  }
}
