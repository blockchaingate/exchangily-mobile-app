class StarReferral {
  String _id; //wallet FAB or EXG address as _id, unique
  String _parentId; // Referral wallet EXG address
  DateTime _dateUpdated;
  DateTime _dateCreated;

  StarReferral(
      {String id,
      String parentId,
      DateTime dateUpdated,
      DateTime dateCreated}) {
    this._id = id;
    this._parentId = parentId;
    this._dateUpdated = dateUpdated;
    this._dateCreated = dateCreated;
  }

  factory StarReferral.fromJson(Map<String, dynamic> json) {
    return new StarReferral(
      id: json['id'],
      parentId: json['memberId']['parentId'],
      dateUpdated: json['dateUpdated'],
      dateCreated: json['dateCreated'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this._id;
    data["parentId"] = this._parentId;
    data["dateUpdated"] = this._dateUpdated;
    data["dateCreated"] = this._dateCreated;
    return data;
  }

  String get id => _id;

  set id(String id) {
    this._id = id;
  }

  String get parentId => _parentId;

  set parentId(String parentId) {
    this._parentId = parentId;
  }

  DateTime get dateUpdated => _dateUpdated;
  set dateUpdated(DateTime dateUpdated) {
    this._dateUpdated = dateUpdated;
  }

  DateTime get dateCreated => _dateCreated;
  set dateCreated(DateTime dateCreated) {
    this._dateCreated = dateCreated;
  }
}

class StarReferralList {
  final List<StarReferral> starReferralsList;
  StarReferralList({this.starReferralsList});

  factory StarReferralList.fromJson(List<dynamic> parsedJson) {
    List<StarReferral> starReferralsListFromApi = [];
    starReferralsListFromApi =
        parsedJson.map((i) => StarReferral.fromJson(i)).toList();
    return new StarReferralList(starReferralsList: starReferralsListFromApi);
  }
}
