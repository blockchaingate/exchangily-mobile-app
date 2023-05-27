import 'package:exchangilymobileapp/utils/string_util.dart';

class LightningRemitTransferModel {
  String? type;
  String? date;
  String? coin;
  double? amount;
  int? status;
  String? txid;

  LightningRemitTransferModel({
    this.type,
    this.date,
    this.coin,
    this.amount,
    this.status,
    this.txid,
  });

  factory LightningRemitTransferModel.fromJson(Map<String, dynamic> json) {
    var time = json['time'] as int;

    return LightningRemitTransferModel(
      type: json['type'] as String,
      date: StringUtil.localDateFromMilliseconds(time, removeLast4Chars: true),
      coin: json['coin'] as String,
      amount: double.parse(json['amount'].toString()),
      status: json['status'] as int,
      txid: json['txid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'date': date,
      'coin': coin,
      'amount': amount,
      'status': status,
      'txid': txid,
    };
  }
}

class LightningRemitHistoryModel {
  int pageNum;
  int totalCount;
  List<LightningRemitTransferModel> history;

  LightningRemitHistoryModel({
    this.pageNum = 0,
    this.totalCount = 0,
    this.history = const [],
  });

  factory LightningRemitHistoryModel.fromJson(Map<String, dynamic> json) {
    var historyList = json['history'] as List<dynamic>;
    List<LightningRemitTransferModel> mappedHistory = historyList
        .map((e) => LightningRemitTransferModel.fromJson(e))
        .toList();
    return LightningRemitHistoryModel(
      pageNum: json['pageNum'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      history: mappedHistory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageNum': pageNum,
      'totalCount': totalCount,
      'history': history,
    };
  }
}
