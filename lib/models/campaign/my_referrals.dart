class MyReferrals {
  String? _id;
  String? _email;
  String? _disqualifiedReason;
  bool? _disqualified;
  String? _parentReferMemberId;
  String? _dateCreated;

  MyReferrals(
      {String? id,
      String? email,
      String? disqualifiedReason,
      bool? disqualified,
      String? parentReferMemberId,
      String? dateCreated}) {
    _id = id;
    _email = email;
    _disqualifiedReason = disqualifiedReason;
    _disqualified = disqualified;
    _parentReferMemberId = parentReferMemberId;
    _dateCreated = dateCreated;
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
        "email": _email,
      };

  String? get id => _id;

  set id(String? id) {
    _id = id;
  }

  String? get email => _email;

  set email(String? email) {
    _email = email;
  }

  bool? get disqualified => _disqualified;

  set disqualified(bool? disqualified) {
    _disqualified = disqualified;
  }

  String? get disqualifiedReason => _disqualifiedReason;

  set disqualifiedReason(String? disqualifiedReason) {
    _disqualifiedReason = disqualifiedReason;
  }
}

class MyReferralsList {
  final List<MyReferrals>? myReferralsList;
  MyReferralsList({this.myReferralsList});

  factory MyReferralsList.fromJson(List<dynamic> parsedJson) {
    List<MyReferrals> myReferralsList = <MyReferrals>[];
    myReferralsList = parsedJson.map((i) => MyReferrals.fromJson(i)).toList();
    return MyReferralsList(myReferralsList: myReferralsList);
  }
}
