class CampaignDashboard {
  String? level;
  double? totalInvestment;
  double? totalReward;
  double? refferals;

  CampaignDashboard(
      {this.level, this.refferals, this.totalInvestment, this.totalReward});

  CampaignDashboard.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    totalInvestment = json['totalInvestment'];
    totalReward = json['totalReward'];
    refferals = json['refferals'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = level;
    data['totalInvestment'] = totalInvestment;
    data['totalReward'] = totalReward;
    data['refferals'] = refferals;
    return data;
  }
}
