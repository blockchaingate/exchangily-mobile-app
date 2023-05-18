import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/widgets.dart';
import '../../environments/coins.dart' as coin_list;

class ExchangeBalanceModel {
  String? ticker;
  int? coinType;
  double? unlockedAmount;
  double? lockedAmount;

  ExchangeBalanceModel(
      {this.ticker, this.coinType, this.unlockedAmount, this.lockedAmount});

  factory ExchangeBalanceModel.fromJson(Map<String, dynamic> json) {
    var type = json['coinType'];

    String? tickerName = '';
    if (type != null) {
      tickerName = coin_list.newCoinTypeMap[type];
      debugPrint(
          'ExchangeBalanceModel - Ticker Name -- $tickerName --- coin type ${json['coinType']}');
    }

    ExchangeBalanceModel exchangeBalanceModel = ExchangeBalanceModel(
        ticker: tickerName ?? '',
        coinType: json['coinType'],
        unlockedAmount: bigNum2Double(json['unlockedAmount']).toDouble(),
        lockedAmount: bigNum2Double(json['lockedAmount']).toDouble());

    return exchangeBalanceModel;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticker'] = ticker;
    data['coinType'] = coinType;
    data['unlockedAmount'] = unlockedAmount;
    data['lockedAmount'] = lockedAmount;

    return data;
  }
}

class ExchangeBalanceModelList {
  final List<ExchangeBalanceModel>? balances;
  ExchangeBalanceModelList({this.balances});

  factory ExchangeBalanceModelList.fromJson(List<dynamic> parsedJson) {
    List<ExchangeBalanceModel> balances = <ExchangeBalanceModel>[];
    balances = parsedJson.map((i) => ExchangeBalanceModel.fromJson(i)).toList();
    return ExchangeBalanceModelList(balances: balances);
  }
}
