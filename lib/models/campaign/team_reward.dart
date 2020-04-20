class CampaignTeamReward {
  String _id;
  List<String> _members;
  double _totalValue;
  double _totalQuantities;

  CampaignTeamReward(
      {String id,
      double totalValue,
      double totalQuantities,
      double totalRewardQuantities,
      List<String> members,
      double totalRewardNextQuantities}) {
    this.id = id ?? '';
    this._totalValue = totalValue ?? 0.0;
    this._totalQuantities = totalQuantities ?? 0.0;

    this.members = members ?? '';
  }

  factory CampaignTeamReward.fromJson(Map<String, dynamic> json) {
    var teamFromJson = json["members"];
// List<String> teamList = new List<String>.from(teamFromJson);
    List<String> teamList = teamFromJson.cast<String>();
    return CampaignTeamReward(
        id: json["id"] as String,
        members: teamList,
        totalValue: json["totalValue"].toDouble(),
        totalQuantities: json["totalQuantities"].toDouble());
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "totalValue": this._totalValue,
        "totalQuantities": this._totalQuantities,
        "members": this.members,
      };

  double get totalValue => _totalValue;
  set totalValue(double totalValue) {
    this._totalValue = totalValue;
  }

  List<String> get members => _members;
  set members(List<String> members) {
    this._members = members;
  }

  double get totalQuantities => _totalQuantities;
  set totalQuantities(double totalQuantities) {
    this._totalQuantities = totalQuantities;
  }

  String get id => _id;
  set id(String id) {
    this._id = id;
  }
}

class CampaignTeamRewardList {
  final List<CampaignTeamReward> rewards;
  CampaignTeamRewardList({this.rewards});

  factory CampaignTeamRewardList.fromJson(List<dynamic> parsedJson) {
    List<CampaignTeamReward> rewards = new List<CampaignTeamReward>();
    rewards = parsedJson.map((i) => CampaignTeamReward.fromJson(i)).toList();
    return new CampaignTeamRewardList(rewards: rewards);
  }
}
