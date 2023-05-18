import 'package:exchangilymobileapp/models/campaign/my_referrals.dart';

class CampaignReward {
  int? _level;
  List<String?>? _users;
  double? _totalValue; // my investment value
  double? _totalQuantities; // my total tokens bought
  double? _totalRewardQuantities;
  int? _totalAccounts; // number of childrens
  double?
      _totalRewardNextQuantities; // suggest user to buy more token to get more rewards

  CampaignReward(
      {int? level,
      List<String?>? users,
      double? totalValue,
      double? totalQuantities,
      double? totalRewardQuantities,
      int? totalAccounts,
      double? totalRewardNextQuantities}) {
    _level = level ?? 0;
    _totalValue = totalValue ?? 0.0;
    _totalQuantities = totalQuantities ?? 0.0;
    _totalRewardQuantities = totalRewardQuantities ?? 0.0;
    _totalAccounts = totalAccounts ?? 0;
    _totalRewardNextQuantities = totalRewardNextQuantities ?? 0.0;
    _users = users;
  }

  factory CampaignReward.fromJson(Map<String, dynamic> json) {
    List usersFromJson = json["users"] as List;
    MyReferralsList myReferralsList = MyReferralsList.fromJson(usersFromJson);

    return CampaignReward(
        level: json["level"] as int?,

        /// Currently i need email for referrals but i can return whole user object as
        /// i mapped it as in MyRefferal model
        users: myReferralsList.myReferralsList!.map((e) => e.email).toList(),
        totalValue: json["totalValue"].toDouble(),
        totalQuantities: json["totalQuantities"].toDouble(),
        totalRewardQuantities: json["totalRewardQuantities"].toDouble(),
        totalAccounts: json["totalAccounts"] as int?,
        totalRewardNextQuantities:
            json["totalRewardNextQuantities"].toDouble());
  }

  Map<String, dynamic> toJson() => {
        "level": _level,
        'users': _users,
        "totalValue": _totalValue,
        "totalQuantities": _totalQuantities,
        "totalRewardQuantities": _totalRewardQuantities,
        "totalAccounts": _totalAccounts,
        "totalRewardNextQuantities": _totalRewardNextQuantities,
      };

  double? get totalValue => _totalValue;
  set totalValue(double? totalValue) {
    _totalValue = totalValue;
  }

  List<String?>? get users => _users;
  set users(List<String?>? users) {
    _users = users;
  }

  double? get totalQuantities => _totalQuantities;
  set totalQuantities(double? totalQuantities) {
    _totalQuantities = totalQuantities;
  }

  double? get totalRewardQuantities => _totalRewardQuantities;
  set totalRewardQuantities(double? totalRewardQuantities) {
    _totalRewardQuantities = totalRewardQuantities;
  }

  double? get totalRewardNextQuantities => _totalRewardNextQuantities;
  set totalRewardNextQuantities(double? totalRewardNextQuantities) {
    _totalRewardNextQuantities = totalRewardNextQuantities;
  }

  int? get level => _level;
  set level(int? level) {
    _level = level;
  }

  int? get totalAccounts => _totalAccounts;
  set totalAccounts(int? totalAccounts) {
    _totalAccounts = totalAccounts;
  }
}

class CampaignRewardList {
  final List<CampaignReward>? rewards;
  CampaignRewardList({this.rewards});

  factory CampaignRewardList.fromJson(List<dynamic> parsedJson) {
    List<CampaignReward> rewards = <CampaignReward>[];
    rewards = parsedJson.map((i) => CampaignReward.fromJson(i)).toList();
    return CampaignRewardList(rewards: rewards);
  }
}
