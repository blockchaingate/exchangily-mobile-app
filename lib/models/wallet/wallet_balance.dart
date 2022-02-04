import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_balance.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

class UsdValue {
  double _usd;

  UsdValue({double usd}) {
    _usd = usd ?? 0.0;
  }

  factory UsdValue.fromJson(Map<String, dynamic> json) {
    return UsdValue(usd: json['USD'].toDouble());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USD'] = _usd;
    return data;
  }

  double get usd => _usd;
  set usd(double usd) {
    _usd = usd;
  }
}

/*----------------------------------------------------------------------
                        deposit err
----------------------------------------------------------------------*/

class DepositErr {
  int _coinType;
  String _transactionID;
  double _amount;
  String _v;
  String _r;
  String _s;

  DepositErr(
      {int coinType,
      String transactionID,
      double amount,
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
        amount: json['amount'] != null
            ? NumberUtil().parsedDouble(json['amount'])
            : 0.0,
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

class WalletBalance {
  String _coin;
  double _balance;
  double _unconfirmedBalance;
  double _lockBalance;
  UsdValue _usdValue;
  List<DepositErr> _depositErr;
  double _unlockedExchangeBalance;
  double _lockedExchangeBalance;

  WalletBalance(
      {String coin,
      double balance,
      double unconfirmedBalance,
      double lockBalance,
      UsdValue usdValue,
      List<DepositErr> depositErr,
      double unlockedExchangeBalance,
      double lockedExchangeBalance}) {
    _coin = coin;
    _balance = balance ?? 0.0;
    _unconfirmedBalance = unconfirmedBalance ?? 0.0;
    _lockBalance = lockBalance ?? 0.0;
    _usdValue = usdValue;
    _depositErr = depositErr;
    _unlockedExchangeBalance = unlockedExchangeBalance ?? 0.0;
    _lockedExchangeBalance = lockedExchangeBalance ?? 0.0;
  }

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    List<DepositErr> depositErrList = [];
    var depositErrFromJsonAsList = json['depositErr'] as List;
    if (depositErrFromJsonAsList != null) {
      depositErrList =
          depositErrFromJsonAsList.map((e) => DepositErr.fromJson(e)).toList();
    }

    UsdValue usdVal;
    if (json['usdValue'] != null) {
      usdVal = UsdValue.fromJson(json['usdValue']);
    } else {
      usdVal = UsdValue(usd: 0.0);
    }
    double ub = NumberUtil().parsedDouble(json['unconfirmedBalance']);
    if (ub.isNegative) {
      ub = 0.0;
    }
    return WalletBalance(
      coin: json['coin'],
      balance: json['balance'] != null
          ? (NumberUtil().parsedDouble(json['balance']))
          : 0.0,
      unconfirmedBalance: json['unconfirmedBalance'] != null ? ub : 0.0,
      lockBalance: json['lockBalance'] != null
          ? (NumberUtil().parsedDouble(json['lockBalance']))
          : 0.0,
      usdValue: usdVal,
      depositErr: depositErrList,
      unlockedExchangeBalance: json['unlockedExchangeBalance'] != null
          ? (NumberUtil().parsedDouble(json['unlockedExchangeBalance']))
          : 0.0,
      lockedExchangeBalance: json['lockedExchangeBalance'] != null
          ? (NumberUtil().parsedDouble(json['lockedExchangeBalance']))
          : 0.0,
    );
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

  double balanceInUsd() {
    return balance * usdValue.usd;
  }

  String get coin => _coin;
  set coin(String coin) {
    _coin = coin;
  }

  double get balance => _balance;
  set balance(double balance) {
    _balance = balance;
  }

  double get unconfirmedBalance => _unconfirmedBalance;
  set unconfirmedBalance(double unconfirmedBalance) {
    _unconfirmedBalance = unconfirmedBalance;
  }

  double get lockBalance => _lockBalance;
  set lockBalance(double lockBalance) {
    _lockBalance = lockBalance;
  }

  UsdValue get usdValue => _usdValue;
  set usdValue(UsdValue usdValue) {
    _usdValue = usdValue;
  }

  List<DepositErr> get depositErr => _depositErr;
  set depositErr(List<DepositErr> depositErr) {
    _depositErr = depositErr;
  }

  double get unlockedExchangeBalance => _unlockedExchangeBalance;
  set unlockedExchangeBalance(double unlockedExchangeBalance) {
    _unlockedExchangeBalance = unlockedExchangeBalance;
  }

  double get lockedExchangeBalance => _lockedExchangeBalance;
  set lockedExchangeBalance(double lockedExchangeBalance) {
    _lockedExchangeBalance = lockedExchangeBalance;
  }
}

class WalletBalanceList {
  final List<WalletBalance> walletBalances;
  WalletBalanceList({this.walletBalances});

  factory WalletBalanceList.fromJson(List<dynamic> parsedJson) {
    List<WalletBalance> balanceList = [];
    balanceList = parsedJson.map((i) => WalletBalance.fromJson(i)).toList();
    return WalletBalanceList(walletBalances: balanceList);
  }
}
