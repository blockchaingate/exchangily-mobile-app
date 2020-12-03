import 'package:exchangilymobileapp/utils/string_util.dart';

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
    this._ticker = ticker ?? '';
    this._coinType = coinType ?? 0;
    this._unlockedAmount = unlockedAmount ?? 0.0;
    this._lockedAmount = lockedAmount ?? 0.0;
  }

  factory ExchangeBalanceModel.fromJson(Map<String, dynamic> json) {
    String tickerName = coinList.newCoinTypeMap[json['coinType']];
    //print('Ticker Name -- $tickerName --- coin type ${json['coinType']}');

    return ExchangeBalanceModel(
        ticker: tickerName,
        coinType: json['coinType'],
        unlockedAmount: bigNum2Double(json['unlockedAmount']).toDouble(),
        lockedAmount: bigNum2Double(json['lockedAmount']).toDouble());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticker'] = this.ticker;
    data['coinType'] = this.coinType;
    data['unlockedAmount'] = this.unlockedAmount;
    data['lockedAmount'] = this.lockedAmount;

    return data;
  }

  String get ticker => _ticker;
  set ticker(String ticker) {
    this._ticker = ticker;
  }

  int get coinType => _coinType;
  set coinType(int coinType) {
    this._coinType = coinType;
  }

  double get unlockedAmount => _unlockedAmount;
  set unlockedAmount(double unlockedAmount) {
    this._unlockedAmount = unlockedAmount;
  }

  double get lockedAmount => _lockedAmount;
  set lockedAmount(double lockedAmount) {
    this._lockedAmount = lockedAmount;
  }
}

class ExchangeBalanceModelList {
  final List<ExchangeBalanceModel> balances;
  ExchangeBalanceModelList({this.balances});

  factory ExchangeBalanceModelList.fromJson(List<dynamic> parsedJson) {
    List<ExchangeBalanceModel> balances = new List<ExchangeBalanceModel>();
    balances = parsedJson.map((i) => ExchangeBalanceModel.fromJson(i)).toList();
    return new ExchangeBalanceModelList(balances: balances);
  }
}
