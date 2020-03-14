class CampaignRefferals {
  String id;
  double refferals;
  double name;
  double paid;

  CampaignRefferals({this.id, this.refferals, this.name, this.paid});

  CampaignRefferals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    paid = json['paid'];
    refferals = json['refferals'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['paid'] = this.paid;
    data['refferals'] = this.refferals;
    return data;
  }
}
