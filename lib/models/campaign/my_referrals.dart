class MyReferrals {
  String _id;
  String _email;
  String _disqualifiedReason;
  bool _disqualified;
  String _parentReferMemberId;
  String _dateCreated;

  MyReferrals(
      {String id,
      String email,
      String disqualifiedReason,
      bool disqualified,
      String parentReferMemberId,
      String dateCreated}) {
    this._id = id;
    this._email = email;
    this._disqualifiedReason = disqualifiedReason;
    this._disqualified = disqualified;
    this._parentReferMemberId = parentReferMemberId;
    this._dateCreated = dateCreated;
  }

  factory MyReferrals.fromJson(Map<String, dynamic> json) {
    return MyReferrals(
      //id: json['id'],
      email: json['memberId']['email'],
      // parentReferMemberId: json['parentReferMemberId'],
      // dateCreated: json['dateCreated'],
      // disqualified: json['disqualified'],
      // disqualifiedReason: json['disqualifiedReason']
    );
  }

  Map<String, dynamic> toJson() => {
        "email": this._email,
      };

  String get id => _id;

  set id(String id) {
    this._id = id;
  }

  String get email => _email;

  set email(String email) {
    this._email = email;
  }

  bool get disqualified => _disqualified;

  set disqualified(bool disqualified) {
    this._disqualified = disqualified;
  }

  String get disqualifiedReason => _disqualifiedReason;

  set disqualifiedReason(String disqualifiedReason) {
    this._disqualifiedReason = disqualifiedReason;
  }
}

class MyReferralsList {
  final List<MyReferrals> myReferralsList;
  MyReferralsList({this.myReferralsList});

  factory MyReferralsList.fromJson(List<dynamic> parsedJson) {
    List<MyReferrals> myReferralsList = new List<MyReferrals>();
    myReferralsList = parsedJson.map((i) => MyReferrals.fromJson(i)).toList();
    return new MyReferralsList(myReferralsList: myReferralsList);
  }
}
