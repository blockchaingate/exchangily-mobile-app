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
  String coin;
  Decimal balance;
  Decimal unconfirmedBalance;
  Decimal lockBalance;
  Decimal usdValue;
  List<DepositErr> depositErr;
  Decimal unlockedExchangeBalance;
  Decimal lockedExchangeBalance;

  WalletBalanceV2(
      {String coin,
      Decimal balance,
      Decimal unconfirmedBalance,
      Decimal lockBalance,
      Decimal usdValue,
      List<DepositErr> depositErr,
      Decimal unlockedExchangeBalance,
      Decimal lockedExchangeBalance});

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
    data['coin'] = coin;
    data['balance'] = balance;
    data['unconfirmedBalance'] = unconfirmedBalance;
    data['lockBalance'] = lockBalance;
    if (usdValue != null) {
      data['usdValue'] = usdValue.toJson();
    }
    if (depositErr != null) {
      data['depositErr'] = depositErr.map((v) => v.toJson()).toList();
    }
    data['unlockedExchangeBalance'] = unlockedExchangeBalance;
    data['lockedExchangeBalance'] = lockedExchangeBalance;
    return data;
  }

  Decimal balanceInUsd() {
    return balance * usdValue;
  }
}

class WalletBalanceListV2 {
  final List<WalletBalanceV2> walletBalances;
  WalletBalanceListV2({this.walletBalances});

  factory WalletBalanceListV2.fromJson(List<dynamic> parsedJson) {
    List<WalletBalanceV2> balanceList = [];
    balanceList = parsedJson.map((i) => WalletBalanceV2.fromJson(i)).toList();
    return WalletBalanceListV2(walletBalances: balanceList);
  }
}
