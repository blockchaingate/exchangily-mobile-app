class Campaign {
  String? _id;
  String? _name;
  String? _logoUrl;
  DateTime? _startDate;
  DateTime? _endDate;
  double? _minPay;

  Campaign(
      {String? id,
      String? name,
      String? logoUrl,
      DateTime? startDate,
      DateTime? endDate,
      double? minPay}) {
    _id = id ?? '5e7e6a1601a0961bbabb36c9';
    _name = name;
    _logoUrl = logoUrl;
    _startDate = startDate;
    _endDate = endDate;
    _minPay = minPay;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['logo'] = _logoUrl;
    data['startDate'] = _startDate;
    data['endDate'] = _endDate;
    data['minimumEntryAmount'] = _minPay;
    return data;
  }

  String? get id => _id;

  set id(String? id) {
    _id = id;
  }

  String get name => name;

  set name(String? name) {
    _name = name;
  }

  String get logoUrl => logoUrl;

  set logoUrl(String? logoUrl) {
    _logoUrl = logoUrl;
  }

  DateTime get startDate => startDate;
  set startDate(DateTime? startDate) {
    _startDate = startDate;
  }

  DateTime get endDate => endDate;
  set endDate(DateTime? startDate) {
    _endDate = endDate;
  }

  double get minPay => minPay;

  set minPay(double? name) {
    _minPay = minPay;
  }
}
