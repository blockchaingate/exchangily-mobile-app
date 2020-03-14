class CampaignReward {
  String level;
  double refferals;
  double totalAmount;
  double reward;

  CampaignReward({this.level, this.refferals, this.totalAmount, this.reward});

  CampaignReward.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    totalAmount = json['totalAmount'];
    reward = json['reward'];
    refferals = json['refferals'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['totalAmount'] = this.totalAmount;
    data['reward'] = this.reward;
    data['refferals'] = this.refferals;
    return data;
  }
}
