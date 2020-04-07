// class CampaignReward {
//   List<Personal> personal;

//   CampaignReward({
//     this.personal,
//   });

//   factory CampaignReward.fromJson(Map<String, dynamic> json) => CampaignReward(
//         personal: List<Personal>.from(
//             json["personal"].map((x) => Personal.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "personal": List<dynamic>.from(personal.map((x) => x.toJson())),
//       };
// }

class CampaignReward {
  int _level;
  var _totalValue; // my investment value
  var _totalQuantities; // my total tokens bought
  var _totalRewardQuantities;
  int _totalAccounts; // number of childrens
  var _totalRewardNextQuantities; // suggest user to buy more token to get more rewards

  CampaignReward(
      {int level,
      var totalValue,
      var totalQuantities,
      var totalRewardQuantities,
      int totalAccounts,
      var totalRewardNextQuantities}) {
    this._level = level;
    this._totalValue = totalValue;
    this._totalQuantities = totalQuantities;
    this._totalRewardQuantities = totalRewardQuantities;
    this._totalAccounts = totalAccounts;
    this._totalRewardNextQuantities = totalRewardNextQuantities;
  }

  factory CampaignReward.fromJson(Map<String, dynamic> json) => CampaignReward(
        level: json["level"] as int,
        totalValue: json["totalValue"],
        totalQuantities: json["totalQuantities"],
        totalRewardQuantities: json["totalRewardQuantities"],
        totalAccounts: json["totalAccounts"],
        totalRewardNextQuantities: json["totalRewardNextQuantities"],
      );

  Map<String, dynamic> toJson() => {
        "level": this._level,
        "totalValue": this._totalValue,
        "totalQuantities": this._totalQuantities,
        "totalRewardQuantities": this._totalRewardQuantities,
        "totalAccounts": this._totalAccounts,
        "totalRewardNextQuantities": this._totalRewardNextQuantities,
      };

  get totalValue => _totalValue;
  set totalValue(var totalValue) {
    this._totalValue = totalValue;
  }

  get totalQuantities => _totalQuantities;
  set totalQuantities(var totalQuantities) {
    this._totalQuantities = totalQuantities;
  }

  get totalRewardQuantities => _totalRewardQuantities;
  set totalRewardQuantities(var totalRewardQuantities) {
    this._totalRewardQuantities = totalRewardQuantities;
  }

  get totalRewardNextQuantities => _totalRewardNextQuantities;
  set totalRewardNextQuantities(var totalRewardNextQuantities) {
    this._totalRewardNextQuantities = totalRewardNextQuantities;
  }

  int get level => _level;
  set level(int level) {
    this._level = level;
  }

  int get totalAccounts => _totalAccounts;
  set totalAccounts(int totalAccounts) {
    this._totalAccounts = totalAccounts;
  }
}

class CampaignRewardList {
  final List<CampaignReward> rewards;
  CampaignRewardList({this.rewards});

  factory CampaignRewardList.fromJson(List<dynamic> parsedJson) {
    List<CampaignReward> rewards = new List<CampaignReward>();
    rewards = parsedJson.map((i) => CampaignReward.fromJson(i)).toList();
    return new CampaignRewardList(rewards: rewards);
  }
}
