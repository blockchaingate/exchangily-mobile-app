class CampaignDashboard {
  String level;
  double totalInvestment;
  double totalReward;
  double refferals;

  CampaignDashboard(
      {this.level, this.refferals, this.totalInvestment, this.totalReward});

  CampaignDashboard.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    totalInvestment = json['totalInvestment'];
    totalReward = json['totalReward'];
    refferals = json['refferals'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['totalInvestment'] = this.totalInvestment;
    data['totalReward'] = this.totalReward;
    data['refferals'] = this.refferals;
    return data;
  }
}
