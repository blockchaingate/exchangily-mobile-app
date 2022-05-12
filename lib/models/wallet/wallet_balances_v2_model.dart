import 'package:decimal/decimal.dart';

/*----------------------------------------------------------------------
                        deposit err
----------------------------------------------------------------------*/

class DepositErr {
  int _coinType;
  String _transactionID;
  Decimal _amount;
  String _v;
  String _r;
  String _s;

  DepositErr(
      {int coinType,
      String transactionID,
      Decimal amount,
      String v,
      String r,
      String s}) {
    _coinType = coinType;
    _transactionID = transactionID;
    _amount = amount ?? 0.0;
    _v = v;
    _r = r;
    _s = s;
  }

  factory DepositErr.fromJson(Map<String, dynamic> json) {
    return DepositErr(
        coinType: json['coinType'],
        transactionID: json['transactionID'],
        amount: json['amount'] != null ? Decimal.parse(json['amount']) : 0.0,
        v: json['v'],
        r: json['r'],
        s: json['s']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coinType'] = _coinType;
    data['transactionID'] = _transactionID;
    data['amount'] = _amount;
    data['v'] = _v;
    data['r'] = _r;
    data['s'] = _s;
    return data;
  }
}

/*----------------------------------------------------------------------
                    Wallet Balance
----------------------------------------------------------------------*/

class WalletBalanceV2 {
  String _coin;
  Decimal _balance;
  Decimal _unconfirmedBalance;
  Decimal _lockBalance;
  Decimal _usdValue;
  List<DepositErr> _depositErr;
  Decimal _unlockedExchangeBalance;
  Decimal _lockedExchangeBalance;

  WalletBalanceV2(
      {String coin,
      Decimal balance,
      Decimal unconfirmedBalance,
      Decimal lockBalance,
      Decimal usdValue,
      List<DepositErr> depositErr,
      Decimal unlockedExchangeBalance,
      Decimal lockedExchangeBalance}) {
    _coin = coin;
    _balance = balance ?? 0.0;
    _unconfirmedBalance = unconfirmedBalance ?? 0.0;
    _lockBalance = lockBalance ?? 0.0;
    _usdValue = usdValue ?? Decimal.zero;
    _depositErr = depositErr;
    _unlockedExchangeBalance = unlockedExchangeBalance ?? 0.0;
    _lockedExchangeBalance = lockedExchangeBalance ?? 0.0;
  }

  factory WalletBalanceV2.fromJson(Map<String, dynamic> json) {
    List<DepositErr> depositErrList = [];
    var depositErrFromJsonAsList = json['de'] as List;
    if (depositErrFromJsonAsList != null) {
      depositErrList =
          depositErrFromJsonAsList.map((e) => DepositErr.fromJson(e)).toList();
    }
// {
// 			"coin": => c,
// 			"balance": => b,
// 			"unconfirmedBalance":  => ub,
// 			"lockBalance":  => lb
// 			"lockers": => ls,
// 			"usdValue": => u,
// 			"depositErr":=> de,
// 			"unlockedExchangeBalance":=> ul,
// 			"lockedExchangeBalance": => l
// 		},
    return WalletBalanceV2(
        coin: json['c'],
        balance: (Decimal.parse(json['b'])),
        unconfirmedBalance: Decimal.parse(json['ub']),
        lockBalance: (Decimal.parse(json['lb'])),
        usdValue: Decimal.parse(json["u"].toString()),
        depositErr: depositErrList,
        unlockedExchangeBalance: Decimal.parse(json['ul']),
        lockedExchangeBalance: Decimal.parse(json['ul']));
  }

// To json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coin'] = _coin;
    data['balance'] = _balance;
    data['unconfirmedBalance'] = _unconfirmedBalance;
    data['lockBalance'] = _lockBalance;
    if (_usdValue != null) {
      data['usdValue'] = _usdValue.toJson();
    }
    if (_depositErr != null) {
      data['depositErr'] = _depositErr.map((v) => v.toJson()).toList();
    }
    data['unlockedExchangeBalance'] = _unlockedExchangeBalance;
    data['lockedExchangeBalance'] = _lockedExchangeBalance;
    return data;
  }

  Decimal balanceInUsd() {
    return _balance * _usdValue;
  }
}

class WalletBalanceList {
  final List<WalletBalanceV2> walletBalances;
  WalletBalanceList({this.walletBalances});

  factory WalletBalanceList.fromJson(List<dynamic> parsedJson) {
    List<WalletBalanceV2> balanceList = [];
    balanceList = parsedJson.map((i) => WalletBalanceV2.fromJson(i)).toList();
    return WalletBalanceList(walletBalances: balanceList);
  }
}
