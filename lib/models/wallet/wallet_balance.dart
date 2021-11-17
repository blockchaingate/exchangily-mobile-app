import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';

class UsdValue {
  double _usd;

  UsdValue({double usd}) {
    this._usd = usd ?? 0.0;
  }

  factory UsdValue.fromJson(Map<String, dynamic> json) {
    return UsdValue(usd: json['USD'].toDouble());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['USD'] = this._usd;
    return data;
  }

  double get usd => _usd;
  set usd(double usd) {
    this._usd = usd;
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
    this._coinType = coinType;
    this._transactionID = transactionID;
    this._amount = amount ?? 0.0;
    this._v = v;
    this._r = r;
    this._s = s;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coinType'] = this._coinType;
    data['transactionID'] = this._transactionID;
    data['amount'] = this._amount;
    data['v'] = this._v;
    data['r'] = this._r;
    data['s'] = this._s;
    return data;
  }
}

/*----------------------------------------------------------------------
                    Wallet Balance
----------------------------------------------------------------------*/

class WalletBalance {
  static final log = getLogger('WalletBalance');

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
    this._coin = coin;
    this._balance = balance ?? 0.0;
    this._unconfirmedBalance = unconfirmedBalance ?? 0.0;
    this._lockBalance = lockBalance ?? 0.0;
    this._usdValue = usdValue;
    this._depositErr = depositErr;
    this._unlockedExchangeBalance = unlockedExchangeBalance ?? 0.0;
    this._lockedExchangeBalance = lockedExchangeBalance ?? 0.0;
  }

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    List<DepositErr> depositErrList = [];
    var depositErrFromJsonAsList = json['depositErr'] as List;
    if (depositErrFromJsonAsList != null) {
      depositErrList =
          depositErrFromJsonAsList.map((e) => DepositErr.fromJson(e)).toList();
    }

    var usdVal;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coin'] = this._coin;
    data['balance'] = this._balance;
    data['unconfirmedBalance'] = this._unconfirmedBalance;
    data['lockBalance'] = this._lockBalance;
    if (this._usdValue != null) {
      data['usdValue'] = this._usdValue.toJson();
    }
    if (this._depositErr != null) {
      data['depositErr'] = this._depositErr.map((v) => v.toJson()).toList();
    }
    data['unlockedExchangeBalance'] = this._unlockedExchangeBalance;
    data['lockedExchangeBalance'] = this._lockedExchangeBalance;
    return data;
  }

  String get coin => _coin;
  set coin(String coin) {
    this._coin = coin;
  }

  double get balance => _balance;
  set balance(double balance) {
    this._balance = balance;
  }

  double get unconfirmedBalance => _unconfirmedBalance;
  set unconfirmedBalance(double unconfirmedBalance) {
    this._unconfirmedBalance = unconfirmedBalance;
  }

  double get lockBalance => _lockBalance;
  set lockBalance(double lockBalance) {
    this._lockBalance = lockBalance;
  }

  UsdValue get usdValue => _usdValue;
  set usdValue(UsdValue usdValue) {
    this._usdValue = usdValue;
  }

  List<DepositErr> get depositErr => _depositErr;
  set depositErr(List<DepositErr> depositErr) {
    this._depositErr = depositErr;
  }

  double get unlockedExchangeBalance => _unlockedExchangeBalance;
  set unlockedExchangeBalance(double unlockedExchangeBalance) {
    this._unlockedExchangeBalance = unlockedExchangeBalance;
  }

  double get lockedExchangeBalance => _lockedExchangeBalance;
  set lockedExchangeBalance(double lockedExchangeBalance) {
    this._lockedExchangeBalance = lockedExchangeBalance;
  }
}

class WalletBalanceList {
  final List<WalletBalance> walletBalances;
  WalletBalanceList({this.walletBalances});

  factory WalletBalanceList.fromJson(List<dynamic> parsedJson) {
    List<WalletBalance> balanceList = [];
    balanceList = parsedJson.map((i) => WalletBalance.fromJson(i)).toList();
    return new WalletBalanceList(walletBalances: balanceList);
  }
}
