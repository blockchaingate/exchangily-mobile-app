class CampaignV2 {
  List<dynamic> levelRewardRate;
  List<dynamic> rules;
  List<dynamic> jurisdictions;
  int id;
  int status;
  String lastUpdated;
  String dateCreated;
  List<LocalizeText> sloganLan;
  List<LocalizeText> descLan;
  String avatarUrl;
  String imageUrl;
  String name;
  List<LocalizeText> titleLan;
  List<dynamic> subTitleLan;
  List<dynamic> grade;
  bool hasJoined;

  CampaignV2(
      {this.levelRewardRate,
      this.rules,
      this.jurisdictions,
      this.id,
      this.status,
      this.lastUpdated,
      this.dateCreated,
      this.sloganLan,
      this.descLan,
      this.avatarUrl,
      this.imageUrl,
      this.name,
      this.titleLan,
      this.subTitleLan,
      this.grade,
      this.hasJoined});

  factory CampaignV2.fromJson(Map<String, dynamic> json) {
    List<LocalizeText> sloganLanTextList = [];
    var sloganLanTextListJson = json['sloganLan'] as List;
    if (sloganLanTextListJson != null)
      sloganLanTextList =
          sloganLanTextListJson.map((e) => LocalizeText.fromJson(e)).toList();

    return CampaignV2(
      levelRewardRate: json['levelRewardRate'] as List<dynamic>,
      rules: json['rules'] as List<dynamic>,
      jurisdictions: json['jurisdictions'] as List<dynamic>,
      id: json['_id'] as int,
      status: json['status'] as int,
      lastUpdated: json['lastUpdated'] as String,
      dateCreated: json['dateCreated'] as String,
      sloganLan: sloganLanTextList,
      descLan: (json['descLan'] as List)
          .map((e) => e == null ? null : LocalizeText.fromJson(e))
          .toList(),
      avatarUrl: json['avatarUrl'] as String,
      imageUrl: json['imageUrl'] as String,
      name: json['name'] as String,
      titleLan: (json['titleLan'] as List<dynamic>)
          ?.map((e) => e == null ? null : LocalizeText.fromJson(e))
          ?.toList(),
      subTitleLan: json['subTitleLan'] as List<dynamic>,
      grade: json['grade'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelRewardRate': levelRewardRate,
      'rules': rules,
      'jurisdictions': jurisdictions,
      '_id': id,
      'status': status,
      'lastUpdated': lastUpdated,
      'dateCreated': dateCreated,
      'sloganLan': sloganLan?.map((e) => e?.toJson())?.toList(),
      'descLan': descLan?.map((e) => e?.toJson())?.toList(),
      'avatarUrl': avatarUrl,
      'imageUrl': imageUrl,
      'name': name,
      'titleLan': titleLan?.map((e) => e?.toJson())?.toList(),
      'subTitleLan': subTitleLan,
      'grade': grade,
      'hasJoined': hasJoined
    };
  }
}

class CampaignList {
  final List<CampaignV2> campaignV2List;
  CampaignList({this.campaignV2List});

  factory CampaignList.fromJson(List<dynamic> parsedJson) {
    List<CampaignV2> campaignV2List = [];
    campaignV2List = parsedJson.map((i) => CampaignV2.fromJson(i)).toList();
    return new CampaignList(campaignV2List: campaignV2List);
  }
}

class LocalizeText {
  String lan;
  String text;

  LocalizeText({this.lan, this.text});

  factory LocalizeText.fromJson(Map<String, dynamic> json) {
    return LocalizeText(
      lan: json['lan'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lan': lan,
      'text': text,
    };
  }
}
