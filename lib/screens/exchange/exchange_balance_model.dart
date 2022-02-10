import 'package:exchangilymobileapp/service_locator.dart';

import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import '../../environments/coins.dart' as coinList;

class ExchangeBalanceModel {
  String _ticker;
  int _coinType;
  double _unlockedAmount;
  double _lockedAmount;

  ExchangeBalanceModel(
      {String ticker,
      int coinType,
      double unlockedAmount,
      double lockedAmount}) {
    _ticker = ticker ?? '';
    _coinType = coinType ?? 0;
    _unlockedAmount = unlockedAmount ?? 0.0;
    _lockedAmount = lockedAmount ?? 0.0;
  }

  factory ExchangeBalanceModel.fromJson(Map<String, dynamic> json) {
    var type = json['coinType'];
    String tickerName = '';
    if (type != null) {
      tickerName = coinList.newCoinTypeMap[type];
      debugPrint(
          'Ticker Name -- $tickerName --- coin type ${json['coinType']}');
    }

    return ExchangeBalanceModel(
        ticker: tickerName,
        coinType: json['coinType'],
        unlockedAmount: bigNum2Double(json['unlockedAmount']).toDouble(),
        lockedAmount: bigNum2Double(json['lockedAmount']).toDouble());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticker'] = ticker;
    data['coinType'] = coinType;
    data['unlockedAmount'] = unlockedAmount;
    data['lockedAmount'] = lockedAmount;

    return data;
  }

  String get ticker => _ticker;
  set ticker(String ticker) {
    _ticker = ticker;
  }

  int get coinType => _coinType;
  set coinType(int coinType) {
    _coinType = coinType;
  }

  double get unlockedAmount => _unlockedAmount;
  set unlockedAmount(double unlockedAmount) {
    _unlockedAmount = unlockedAmount;
  }

  double get lockedAmount => _lockedAmount;
  set lockedAmount(double lockedAmount) {
    _lockedAmount = lockedAmount;
  }
}

class ExchangeBalanceModelList {
  final List<ExchangeBalanceModel> balances;
  ExchangeBalanceModelList({this.balances});

  factory ExchangeBalanceModelList.fromJson(List<dynamic> parsedJson) {
    List<ExchangeBalanceModel> balances = <ExchangeBalanceModel>[];
    balances = parsedJson.map((i) => ExchangeBalanceModel.fromJson(i)).toList();
    return ExchangeBalanceModelList(balances: balances);
  }
}
