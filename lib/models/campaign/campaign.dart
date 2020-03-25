class Campaign {
  String _id;
  String _name;
  String _logoUrl;
  DateTime _startDate;
  DateTime _endDate;
  double _minPay;

  Campaign(
      {String id,
      String name,
      String logoUrl,
      DateTime startDate,
      DateTime endDate,
      double minPay}) {
    this._id = id;
    this._name = name;
    this._logoUrl = logoUrl;
    this._startDate = startDate;
    this._endDate = endDate;
    this._minPay = minPay;
  }

  Campaign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logoUrl = json['logo'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    minPay = json['minimumEntryAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['logo'] = this._logoUrl;
    data['startDate'] = this._startDate;
    data['endDate'] = this._endDate;
    data['minimumEntryAmount'] = this._minPay;
    return data;
  }

  String get id => _id;

  set id(String id) {
    this._id = id;
  }

  String get name => name;

  set name(String name) {
    this._name = name;
  }

  String get logoUrl => logoUrl;

  set logoUrl(String logoUrl) {
    this._logoUrl = logoUrl;
  }

  DateTime get startDate => startDate;
  set startDate(DateTime startDate) {
    this._startDate = startDate;
  }

  DateTime get endDate => endDate;
  set endDate(DateTime startDate) {
    this._endDate = endDate;
  }

  double get minPay => minPay;

  set minPay(double name) {
    this._minPay = minPay;
  }
}
