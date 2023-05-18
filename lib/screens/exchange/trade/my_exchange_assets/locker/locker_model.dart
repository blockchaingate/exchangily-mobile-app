import 'package:decimal/decimal.dart';

class LockerModel {
  String? sId;
  String? id;
  String? address;
  String? user;
  int? coinType;
  Decimal? amount;
  int? releaseBlock;
  String? createBy;
  String? tickerName;

  LockerModel(
      {this.sId,
      this.id,
      this.address,
      this.user,
      this.coinType,
      this.amount,
      this.releaseBlock,
      this.createBy,
      this.tickerName = ''});

  LockerModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    address = json['address'];
    user = json['user'];
    coinType = json['coinType'];
    amount = Decimal.parse(json['amount'].toString());
    releaseBlock = json['releaseBlock'];
    createBy = json['createBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['address'] = this.address;
    data['user'] = this.user;
    data['coinType'] = this.coinType;
    data['amount'] = this.amount;
    data['releaseBlock'] = this.releaseBlock;
    data['createBy'] = this.createBy;
    data['tickerName'] = this.tickerName;
    return data;
  }
}

class LockerModelList {
  final List<LockerModel>? lockers;
  LockerModelList({this.lockers});

  factory LockerModelList.fromJson(List<dynamic> parsedJson) {
    List<LockerModel> lockers = [];
    lockers = parsedJson.map((i) => LockerModel.fromJson(i)).toList();
    return LockerModelList(lockers: lockers);
  }
}
