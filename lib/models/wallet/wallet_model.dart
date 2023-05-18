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

import 'package:flutter/material.dart';

// Wallet Features Model

class WalletFeatureName {
  String name;
  IconData icon;
  String route;
  Color shadowColor;

  WalletFeatureName(this.name, this.icon, this.route, this.shadowColor);
}

// Wallet Model

class WalletInfo {
  int? _id;
  String? _name;
  String? _tickerName;
  String? _tokenType;
  String? _address;
  double? _lockedBalance;
  double? _availableBalance;
  double? _usdValue;
  double? _inExchange;
  //PairDecimalConfig _pairDecimalConfig;

  WalletInfo(
      {int? id,
      String? tickerName,
      String? tokenType,
      String? address,
      double? lockedBalance,
      double? availableBalance,
      double? usdValue,
      String? name,
      double? inExchange
      //PairDecimalConfig pairDecimalConfig
      }) {
    _id = id;
    _tickerName = tickerName;
    _tokenType = tokenType;
    _address = address;
    _lockedBalance = lockedBalance ?? 0.0;
    _availableBalance = availableBalance ?? 0.0;
    _usdValue = usdValue ?? 0.0;
    _name = name;
    _inExchange = inExchange ?? 0.0;
    // this._pairDecimalConfig = pairDecimalConfig ?? new PairDecimalConfig();
  }

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    // List<PairDecimalConfig> pairDecimalConfigList = [];
    // var pairDecimalConfigJsonAsList = json['pairDecimalConfig'] as List;
    // if (pairDecimalConfigJsonAsList != null) {
    //   pairDecimalConfigList = pairDecimalConfigJsonAsList
    //       .map((e) => PairDecimalConfig.fromJson(e))
    //       .toList();
    // }
    double? ab = json['availableBalance'] as double?;

    return WalletInfo(
      id: json['id'] as int?,
      tickerName: json['tickerName'] as String?,
      tokenType: json['tokenType'] as String?,
      address: json['address'] as String?,
      lockedBalance: json['lockedBalance'],
      availableBalance: ab,
      usdValue: json['usdValue'] as double?,
      name: json['name'] as String?,
      inExchange: json['inExchange'] as double?,

      //  pairDecimalConfig:
      //   PairDecimalConfig.fromJson(json['pairDecimalConfig'])
    );
  }

  // To json

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['tickerName'] = _tickerName;
    data['tokenType'] = _tokenType;
    data['address'] = _address;
    data['lockedBalance'] = _lockedBalance;
    data['availableBalance'] = _availableBalance;
    data['usdValue'] = _usdValue;
    data['name'] = _name;
    data['inExchange'] = _inExchange;
    // if (this._pairDecimalConfig != null) {
    //   data['pairDecimalConfig'] = this._pairDecimalConfig.toJson();
    // }
    return data;
  }

  int? get id => _id;

  set id(int? id) {
    _id = id;
  }

  String? get tickerName => _tickerName;

  set tickerName(String? tickerName) {
    _tickerName = tickerName;
  }

  String? get tokenType => _tokenType;

  set tokenType(String? tokenType) {
    _tokenType = tokenType;
  }

  String? get address => _address;

  set address(String? address) {
    _address = address;
  }

  double? get lockedBalance => _lockedBalance;
  set lockedBalance(double? lockedBalance) {
    _lockedBalance = lockedBalance;
  }

  double get availableBalance => _availableBalance!;

  set availableBalance(double availableBalance) {
    if (availableBalance.isNegative) {
      _availableBalance = 0.0;
    } else {
      _availableBalance = availableBalance;
    }
  }

  double get usdValue => _usdValue!;

  set usdValue(double usdValue) {
    if (usdValue.isNegative) {
      _usdValue = 0.0;
    } else {
      _usdValue = usdValue;
    }
  }

  String? get name => _name;

  set name(String? name) {
    _name = name;
  }

  double? get inExchange => _inExchange;
  set inExchange(double? inExchange) {
    _inExchange = inExchange;
  }

  // PairDecimalConfig get pairDecimalConfig => _pairDecimalConfig;
  // set pairDecimalConfig(PairDecimalConfig pairDecimalConfig) {
  //   this._pairDecimalConfig = pairDecimalConfig;
  // }

  // double getTotalBalance() {
  //   return availableBalance + unconfirmedBalance;
  // }
}

class WalletInfoList {
  final List<WalletInfo>? wallets;
  WalletInfoList({this.wallets});

  factory WalletInfoList.fromJson(List<dynamic> parsedJson) {
    List<WalletInfo> wallets = [];
    wallets = parsedJson.map((i) => WalletInfo.fromJson(i)).toList();
    return WalletInfoList(wallets: wallets);
  }
}
