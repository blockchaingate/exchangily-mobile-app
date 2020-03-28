class AppUser {
  double _parentDiscount;
  double _totalUSDMadeByChildren;
  double _totalTokensPurchased;
  double _pointsEarned;
  String _userId;

  AppUser(
      {double parentDiscount,
      double totalUSDMadeByChildren,
      double totalTokensPurchased,
      double pointsEarned,
      String userId}) {
    this._parentDiscount = parentDiscount ?? 0.0;
    this._totalUSDMadeByChildren = totalUSDMadeByChildren ?? 0.0;
    this._totalTokensPurchased = totalTokensPurchased ?? 0.0;
    this._pointsEarned = pointsEarned ?? 0.0;
    this._userId = userId;
  }

  Map<String, dynamic> toJson() => {
        'parentDiscount': _parentDiscount,
        'totalUSDMadeByChildren': _totalUSDMadeByChildren,
        'totalTokensPurchased': _totalTokensPurchased,
        'pointsEarned': _pointsEarned,
        'userId': _userId
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return new AppUser(
        parentDiscount: json['parentDiscount'] as double,
        totalUSDMadeByChildren: json['totalUSDMadeByChildren'],
        totalTokensPurchased: json['totalTokensPurchased'],
        pointsEarned: json['pointsEarned'],
        userId: json['userId']);
  }
  double get parentDiscount => _parentDiscount;

  set parentDiscount(double parentDiscount) {
    this._parentDiscount = parentDiscount;
  }

  double get totalUSDMadeByChildren => _totalUSDMadeByChildren;

  set totalUSDMadeByChildren(double totalUSDMadeByChildren) {
    this._totalUSDMadeByChildren = totalUSDMadeByChildren;
  }

  double get totalTokensPurchased => _totalTokensPurchased;

  set totalTokensPurchased(double totalTokensPurchased) {
    this._totalTokensPurchased = totalTokensPurchased;
  }

  double get pointsEarned => _pointsEarned;

  set pointsEarned(double pointsEarned) {
    this._pointsEarned = pointsEarned;
  }

  String get userId => _userId;
  set userId(String userId) {
    this._userId = userId;
  }
}
