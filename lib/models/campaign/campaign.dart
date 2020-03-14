class Campaign {
  String id;
  String logo;
  DateTime startDate;
  DateTime endDate;
  double minimumEntryAmount;
  Campaign(
      {this.id,
      this.logo,
      this.startDate,
      this.endDate,
      this.minimumEntryAmount});

  Campaign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    minimumEntryAmount = json['minimumEntryAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logo'] = this.logo;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['minimumEntryAmount'] = this.minimumEntryAmount;
    return data;
  }
}
