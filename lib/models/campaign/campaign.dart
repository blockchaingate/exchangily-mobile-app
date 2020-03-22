class Campaign {
  String id;
  String name;
  String logoUrl;
  DateTime startDate;
  DateTime endDate;
  double minPay;
  Campaign(
      {this.id,
      this.name,
      this.logoUrl,
      this.startDate,
      this.endDate,
      this.minPay});

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
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logoUrl;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['minimumEntryAmount'] = this.minPay;
    return data;
  }


  String get _id => id;

  set _id(String id) {
    this.id = id;
  }

  String get _name => name;

  set _name(String name) {
    this.name = name;
  }
}