/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/material.dart';

// Wallet Features Model

class WalletFeatureName {
  String name;
  IconData icon;
  String route;
  Color shadowColor;

  WalletFeatureName(this.name, this.icon, this.route, this.shadowColor);
}

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
      {this.coin,
      this.balance,
      this.unconfirmedBalance,
      this.lockBalance,
      this.usdValue,
      this.depositErr,
      this.unlockedExchangeBalance,
      this.lockedExchangeBalance});

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
    var res = WalletBalanceV2(
        coin: json['c'] ?? '',
        balance: json['b'] != null
            ? NumberUtil.parseStringToDecimal(json['b'].toString())
            : Constants.decimalZero,
        unconfirmedBalance: json['ub'] != null
            ? NumberUtil.parseStringToDecimal(json['ub'].toString())
            : Constants.decimalZero,
        lockBalance: json['lb'] != null
            ? NumberUtil.parseStringToDecimal(json['lb'])
            : Constants.decimalZero,
        usdValue: json["u"] != null
            ? NumberUtil.parseStringToDecimal(json["u"].toString())
            : Constants.decimalZero,
        depositErr: depositErrList,
        unlockedExchangeBalance: json['ul'] != null
            ? NumberUtil.parseStringToDecimal(json['ul'])
            : Constants.decimalZero,
        lockedExchangeBalance: json['l'] != null
            ? NumberUtil.parseStringToDecimal(json['l'])
            : Constants.decimalZero);
    return res;
  }

// To json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coin'] = coin;
    data['balance'] = balance;
    data['unconfirmedBalance'] = unconfirmedBalance;
    data['lockBalance'] = lockBalance;
    data['usdValue'] = usdValue;
    if (depositErr != null) {
      data['depositErr'] = depositErr.map((v) => v.toJson()).toList();
    }
    data['unlockedExchangeBalance'] = unlockedExchangeBalance;
    data['lockedExchangeBalance'] = lockedExchangeBalance;

    return data;
  }

  Decimal totalWalletBalanceInUsd() {
    return (balance + lockBalance) * usdValue;
  }
}

class WalletBalanceListV2 {
  final List<WalletBalanceV2> walletBalances;
  WalletBalanceListV2({this.walletBalances});

  factory WalletBalanceListV2.fromJson(List<dynamic> parsedJson) {
    List<WalletBalanceV2> balanceList = [];
    balanceList = parsedJson.map((i) => WalletBalanceV2.fromJson(i)).toList();
    for (var element in balanceList) {
      debugPrint('single wallet:  - ${element.toJson()}');
    }

    return WalletBalanceListV2(walletBalances: balanceList);
  }
}

// Wallet Model

class AppWallet extends WalletBalanceV2 {
  int id;
  String name;
  String tickerName;
  String tokenType;
  String address;
  int decimalLimit;

  AppWallet({
    balance,
    unconfirmedBalance,
    lockBalance,
    usdValue,
    depositErr,
    unlockedExchangeBalance,
    lockedExchangeBalance,
    this.id,
    this.tickerName = '',
    this.tokenType = '',
    this.address = '',
    this.name = '',
    this.decimalLimit = 6,
  }) : super(
            coin: tickerName,
            balance: balance ?? Constants.decimalZero,
            unconfirmedBalance: unconfirmedBalance ?? Constants.decimalZero,
            lockBalance: lockBalance ?? Constants.decimalZero,
            usdValue: usdValue ?? Constants.decimalZero,
            unlockedExchangeBalance:
                unlockedExchangeBalance ?? Constants.decimalZero,
            lockedExchangeBalance:
                lockedExchangeBalance ?? Constants.decimalZero);

  factory AppWallet.fromJson(Map<String, dynamic> json) {
    return AppWallet(
      id: json['id'] as int,
      tickerName: json['tickerName'] as String,
      tokenType: json['tokenType'] as String,
      address: json['address'] as String,
      name: json['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tickerName'] = tickerName;
    data['tokenType'] = tokenType;
    data['address'] = address;
    data['name'] = name;
    data['decimalLimit'] = decimalLimit;
    data['coin'] = coin;
    data['balance'] = balance;
    data['unconfirmedBalance'] = unconfirmedBalance;
    data['lockBalance'] = lockBalance;
    data['usdValue'] = usdValue;
    if (depositErr != null) {
      data['depositErr'] = depositErr.map((v) => v.toJson()).toList();
    }
    data['unlockedExchangeBalance'] = unlockedExchangeBalance;
    data['lockedExchangeBalance'] = lockedExchangeBalance;

    // }
    return data;
  }
}

// class WalletInfo {
//   int _id;
//   String _name;
//   String _tickerName;
//   String _tokenType;
//   String _address;
//   double _lockedBalance;
//   double _availableBalance;
//   double _usdValue;
//   double _inExchange;
//   //PairDecimalConfig _pairDecimalConfig;

//   WalletInfo(
//       {int id,
//       String tickerName,
//       String tokenType,
//       String address,
//       double lockedBalance,
//       double availableBalance,
//       double usdValue,
//       String name,
//       double inExchange
//       //PairDecimalConfig pairDecimalConfig
//       }) {
//     _id = id;
//     _tickerName = tickerName;
//     _tokenType = tokenType;
//     _address = address;
//     _lockedBalance = lockedBalance ?? 0.0;
//     _availableBalance = availableBalance ?? 0.0;
//     _usdValue = usdValue ?? 0.0;
//     _name = name;
//     _inExchange = inExchange ?? 0.0;
//     // this._pairDecimalConfig = pairDecimalConfig ?? new PairDecimalConfig();
//   }

//   factory WalletInfo.fromJson(Map<String, dynamic> json) {
//     // List<PairDecimalConfig> pairDecimalConfigList = [];
//     // var pairDecimalConfigJsonAsList = json['pairDecimalConfig'] as List;
//     // if (pairDecimalConfigJsonAsList != null) {
//     //   pairDecimalConfigList = pairDecimalConfigJsonAsList
//     //       .map((e) => PairDecimalConfig.fromJson(e))
//     //       .toList();
//     // }
//     double ab = json['availableBalance'] as double;

//     return WalletInfo(
//       id: json['id'] as int,
//       tickerName: json['tickerName'] as String,
//       tokenType: json['tokenType'] as String,
//       address: json['address'] as String,
//       lockedBalance: json['lockedBalance'],
//       availableBalance: ab,
//       usdValue: json['usdValue'] as double,
//       name: json['name'] as String,
//       inExchange: json['inExchange'] as double,

//       //  pairDecimalConfig:
//       //   PairDecimalConfig.fromJson(json['pairDecimalConfig'])
//     );
//   }

//   // To json

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = _id;
//     data['tickerName'] = _tickerName;
//     data['tokenType'] = _tokenType;
//     data['address'] = _address;
//     data['lockedBalance'] = _lockedBalance;
//     data['availableBalance'] = _availableBalance;
//     data['usdValue'] = _usdValue;
//     data['name'] = _name;
//     data['inExchange'] = _inExchange;
//     // if (this._pairDecimalConfig != null) {
//     //   data['pairDecimalConfig'] = this._pairDecimalConfig.toJson();
//     // }
//     return data;
//   }

//   int get id => _id;

//   set id(int id) {
//     _id = id;
//   }

//   String get tickerName => _tickerName;

//   set tickerName(String tickerName) {
//     _tickerName = tickerName;
//   }

//   String get tokenType => _tokenType;

//   set tokenType(String tokenType) {
//     _tokenType = tokenType;
//   }

//   String get address => _address;

//   set address(String address) {
//     _address = address;
//   }

//   double get lockedBalance => _lockedBalance;
//   set lockedBalance(double lockedBalance) {
//     _lockedBalance = lockedBalance;
//   }

//   double get availableBalance => _availableBalance;

//   set availableBalance(double availableBalance) {
//     if (availableBalance.isNegative) {
//       _availableBalance = 0.0;
//     } else {
//       _availableBalance = availableBalance;
//     }
//   }

//   double get usdValue => _usdValue;

//   set usdValue(double usdValue) {
//     if (usdValue.isNegative) {
//       _usdValue = 0.0;
//     } else {
//       _usdValue = usdValue;
//     }
//   }

//   String get name => _name;

//   set name(String name) {
//     _name = name;
//   }

//   double get inExchange => _inExchange;
//   set inExchange(double inExchange) {
//     _inExchange = inExchange;
//   }

//   // PairDecimalConfig get pairDecimalConfig => _pairDecimalConfig;
//   // set pairDecimalConfig(PairDecimalConfig pairDecimalConfig) {
//   //   this._pairDecimalConfig = pairDecimalConfig;
//   // }

//   // double getTotalBalance() {
//   //   return availableBalance + unconfirmedBalance;
//   // }
// }

// class WalletInfoList {
//   final List<WalletInfo> wallets;
//   WalletInfoList({this.wallets});

//   factory WalletInfoList.fromJson(List<dynamic> parsedJson) {
//     List<WalletInfo> wallets = [];
//     wallets = parsedJson.map((i) => WalletInfo.fromJson(i)).toList();
//     return WalletInfoList(wallets: wallets);
//   }
// }
