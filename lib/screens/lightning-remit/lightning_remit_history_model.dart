import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

class LightningRemitHistoryModel {
  String type;
  int time;
  String coin;
  Decimal amount;
  int status;
  String txid;

  LightningRemitHistoryModel({
    this.type,
    this.time,
    this.coin,
    this.amount,
    this.status,
    this.txid,
  });

  factory LightningRemitHistoryModel.fromJson(Map<String, dynamic> json) {
    return LightningRemitHistoryModel(
      type: json['type'] as String,
      time: json['time'] as int,
      coin: json['coin'] as String,
      amount: NumberUtil.parseNumStringToDecimal(json['amount'].toString()),
      status: json['status'] as int,
      txid: json['txid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'time': time,
      'coin': coin,
      'amount': amount,
      'status': status,
      'txid': txid,
    };
  }
}
