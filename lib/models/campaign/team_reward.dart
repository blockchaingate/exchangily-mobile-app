class TeamReward {
  String? _id;
  List<String>? _members;
  double? _totalValue;
  double? _totalQuantities;

  TeamReward(
      {String? id,
      double? totalValue,
      double? totalQuantities,
      double? totalRewardQuantities,
      List<String>? members,
      double? totalRewardNextQuantities}) {
    this.id = id ?? '';
    _totalValue = totalValue ?? 0.0;
    _totalQuantities = totalQuantities ?? 0.0;

    this.members = members ?? '' as List<String>?;
  }

  factory TeamReward.fromJson(Map<String, dynamic> json) {
    var teamFromJson = json["members"];
// List<String> teamList = new List<String>.from(teamFromJson);
    List<String>? teamList = teamFromJson.cast<String>();
    return TeamReward(
        id: json["id"] as String?,
        members: teamList,
        totalValue: json["totalValue"].toDouble(),
        totalQuantities: json["totalQuantities"].toDouble());
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalValue": _totalValue,
        "totalQuantities": _totalQuantities,
        "members": members,
      };

  double? get totalValue => _totalValue;
  set totalValue(double? totalValue) {
    _totalValue = totalValue;
  }

  List<String>? get members => _members;
  set members(List<String>? members) {
    _members = members;
  }

  double? get totalQuantities => _totalQuantities;
  set totalQuantities(double? totalQuantities) {
    _totalQuantities = totalQuantities;
  }

  String? get id => _id;
  set id(String? id) {
    _id = id;
  }
}

class TeamRewardList {
  final List<TeamReward>? rewards;
  TeamRewardList({this.rewards});

  factory TeamRewardList.fromJson(List<dynamic> parsedJson) {
    List<TeamReward> rewards = <TeamReward>[];
    rewards = parsedJson.map((i) => TeamReward.fromJson(i)).toList();
    return TeamRewardList(rewards: rewards);
  }
}
