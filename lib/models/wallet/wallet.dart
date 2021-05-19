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
  int _id;
  String _name;
  String _tickerName;
  String _tokenType;
  String _address;
  double _lockedBalance;
  double _availableBalance;
  double _usdValue;
  double _inExchange;
  //PairDecimalConfig _pairDecimalConfig;

  WalletInfo({
    int id,
    String tickerName,
    String tokenType,
    String address,
    double lockedBalance,
    double availableBalance,
    double usdValue,
    String name,
    double inExchange,
    //PairDecimalConfig pairDecimalConfig
  }) {
    this._id = id;
    this._tickerName = tickerName;
    this._tokenType = tokenType;
    this._address = address;
    this._lockedBalance = lockedBalance ?? 0.0;
    this._availableBalance = availableBalance ?? 0.0;
    this._usdValue = usdValue ?? 0.0;
    this._name = name;
    this._inExchange = inExchange ?? 0.0;
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

    return new WalletInfo(
      id: json['id'] as int,
      tickerName: json['tickerName'] as String,
      tokenType: json['tokenType'] as String,
      address: json['address'] as String,
      lockedBalance: json['lockedBalance'],
      availableBalance: json['availableBalance'] as double,
      usdValue: json['usdValue'] as double,
      name: json['name'] as String,
      inExchange: json['inExchange'] as double,
      //  pairDecimalConfig:
      //   PairDecimalConfig.fromJson(json['pairDecimalConfig'])
    );
  }

  // To json

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['tickerName'] = this._tickerName;
    data['tokenType'] = this._tokenType;
    data['address'] = this._address;
    data['lockedBalance'] = this._lockedBalance;
    data['availableBalance'] = this._availableBalance;
    data['usdValue'] = this._usdValue;
    data['name'] = this._name;
    data['inExchange'] = this._inExchange;
    // if (this._pairDecimalConfig != null) {
    //   data['pairDecimalConfig'] = this._pairDecimalConfig.toJson();
    // }
    return data;
  }

  int get id => _id;

  set id(int id) {
    this._id = id;
  }

  String get tickerName => _tickerName;

  set tickerName(String tickerName) {
    this._tickerName = tickerName;
  }

  String get tokenType => _tokenType;

  set tokenType(String tokenType) {
    this._tokenType = tokenType;
  }

  String get address => _address;

  set address(String address) {
    this._address = address;
  }

  double get lockedBalance => _lockedBalance;
  set lockedBalance(double lockedBalance) {
    this._lockedBalance = lockedBalance;
  }

  double get availableBalance => _availableBalance;

  set availableBalance(double availableBalance) {
    if (availableBalance.isNegative)
      this._availableBalance = 0.0;
    else
      this._availableBalance = availableBalance;
  }

  double get usdValue => _usdValue;

  set usdValue(double usdValue) {
    if (usdValue.isNegative)
      this._usdValue = 0.0;
    else
      this._usdValue = usdValue;
  }

  String get name => _name;

  set name(String name) {
    this._name = name;
  }

  double get inExchange => _inExchange;
  set inExchange(double inExchange) {
    this._inExchange = inExchange;
  }

  // PairDecimalConfig get pairDecimalConfig => _pairDecimalConfig;
  // set pairDecimalConfig(PairDecimalConfig pairDecimalConfig) {
  //   this._pairDecimalConfig = pairDecimalConfig;
  // }
}

class WalletInfoList {
  final List<WalletInfo> wallets;
  WalletInfoList({this.wallets});

  factory WalletInfoList.fromJson(List<dynamic> parsedJson) {
    List<WalletInfo> wallets = [];
    wallets = parsedJson.map((i) => WalletInfo.fromJson(i)).toList();
    return new WalletInfoList(wallets: wallets);
  }
}
