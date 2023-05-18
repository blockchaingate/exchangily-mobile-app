class AppUser {
  double? _parentDiscount;
  double? _totalUSDMadeByChildren;
  double? _totalTokensPurchased;
  double? _pointsEarned;
  String? _userId;

  AppUser(
      {double? parentDiscount,
      double? totalUSDMadeByChildren,
      double? totalTokensPurchased,
      double? pointsEarned,
      String? userId}) {
    _parentDiscount = parentDiscount ?? 0.0;
    _totalUSDMadeByChildren = totalUSDMadeByChildren ?? 0.0;
    _totalTokensPurchased = totalTokensPurchased ?? 0.0;
    _pointsEarned = pointsEarned ?? 0.0;
    _userId = userId;
  }

  Map<String, dynamic> toJson() => {
        'parentDiscount': _parentDiscount,
        'totalUSDMadeByChildren': _totalUSDMadeByChildren,
        'totalTokensPurchased': _totalTokensPurchased,
        'pointsEarned': _pointsEarned,
        'userId': _userId
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
        parentDiscount: json['parentDiscount'] as double?,
        totalUSDMadeByChildren: json['totalUSDMadeByChildren'],
        totalTokensPurchased: json['totalTokensPurchased'],
        pointsEarned: json['pointsEarned'],
        userId: json['userId']);
  }
  double? get parentDiscount => _parentDiscount;

  set parentDiscount(double? parentDiscount) {
    _parentDiscount = parentDiscount;
  }

  double? get totalUSDMadeByChildren => _totalUSDMadeByChildren;

  set totalUSDMadeByChildren(double? totalUSDMadeByChildren) {
    _totalUSDMadeByChildren = totalUSDMadeByChildren;
  }

  double? get totalTokensPurchased => _totalTokensPurchased;

  set totalTokensPurchased(double? totalTokensPurchased) {
    _totalTokensPurchased = totalTokensPurchased;
  }

  double? get pointsEarned => _pointsEarned;

  set pointsEarned(double? pointsEarned) {
    _pointsEarned = pointsEarned;
  }

  String? get userId => _userId;
  set userId(String? userId) {
    _userId = userId;
  }
}
