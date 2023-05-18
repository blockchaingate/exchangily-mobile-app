class CampaignOrder {
  String? _orderId;
  String? _memberId;
  String? _orderNumber;
  String? _walletAdd; // Wallet EXG address
  String? _status;
  String? _txId;
  double? _quantity;
  String? _paymentType;
  String? _note;
  String? _officialNote;
  bool? _active;
  String? _createdTime;
  double? _price;
  double? _payableAmount;

  CampaignOrder(
      {
      //    String orderId,
      String? memberId,
      //   String orderNumber,
      String? walletAdd, // Wallet EXG address
      //   String status,
      String? txId,
      double? quantity,
      String? paymentType,
      //  String note,
      //  String officialNote,
      //  bool active,
      //  String createdTime,
      double? price,
      double? payableAmount}) {
    // this._orderId = orderId ?? '';
    _memberId = memberId;
    //  this._orderNumber = orderNumber ?? '';
    _walletAdd = walletAdd; // Wallet EXG addres=s
    //  this._status = status ?? '';
    _txId = txId;
    _quantity = quantity;
    _paymentType = paymentType;
    //  this._note = note ?? '';
    //  this._officialNote = officialNote ?? '';
    //  this._active = active ?? false;
    //  this._createdTime = createdTime ?? '';
    _price = price;
    _payableAmount = payableAmount;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //  data['orderId'] = this._orderId;
    data['memberId'] = _memberId;
    // data['orderNumber'] = this._orderNumber;
    data['walletAdd'] = _walletAdd;
    //  data['status'] = this._status;
    data['txId'] = _txId;
    data['quantity'] = _quantity;
    data['paymentType'] = _paymentType;
    // data['note'] = this._note;
    // data['officialNote'] = this._officialNote;
    // data['active'] = this._active;
    // data['createdTime'] = this._createdTime;
    data['price'] = _price;
    data['payableAmount'] = _payableAmount;
    return data;
  }

  factory CampaignOrder.fromJson(Map<String, dynamic> json) {
    return CampaignOrder(
        //  orderId: json['orderId'],
        memberId: json['memberId'],
        //  orderNumber: json['orderNumber'],
        walletAdd: json['walletAdd'],
        //   status: json['status'],
        txId: json['txId'],
        quantity: json['quantity'],
        paymentType: json['paymentType'],
        // note: json['note'],
        // officialNote: json['officialNote'],
        // active: json['active'],
        // createdTime: json['createdTime'],
        price: json['price'],
        payableAmount: json['payableAmount']);
  }

  // String get orderId => _orderId;
  // set orderId(String orderId) {
  //   this._orderId = orderId;
  // }

  String? get memberId => _memberId;
  set memberId(String? memberId) {
    _memberId = memberId;
  }

  // String get orderNumber => _orderNumber;
  // set orderNumber(String orderNumber) {
  //   this._orderNumber = orderNumber;
  // }

  String? get walletAdd => _walletAdd;
  set walletAdd(String? walletAdd) {
    _walletAdd = walletAdd;
  }

  // String get status => _status;
  // set status(String status) {
  //   this._status = status;
  // }

  String? get txId => _txId;
  set txId(String? txId) {
    _txId = txId;
  }

  double? get quantity => _quantity;
  set quantity(double? quantity) {
    _quantity = quantity;
  }

  String? get paymentType => _paymentType;
  set paymentType(String? paymentType) {
    _paymentType = paymentType;
  }

  // String get note => _note;
  // set note(String note) {
  //   this._note = note;
  // }

  // String get officialNote => _officialNote;
  // set officialNote(String officialNote) {
  //   this._officialNote = officialNote;
  // }

  // bool get active => _active;
  // set active(bool active) {
  //   this._active = active;
  // }

  // String get createdTime => _createdTime;
  // set createdTime(String createdTime) {
  //   this._createdTime = createdTime;
  // }

  double? get price => _price;
  set price(double? price) {
    _price = price;
  }

  double? get payableAmount => _payableAmount;
  set payableAmount(double? payableAmount) {
    _payableAmount = payableAmount;
  }
}
