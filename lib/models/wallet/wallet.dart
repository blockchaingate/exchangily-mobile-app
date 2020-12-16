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

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:flutter/material.dart';

// Wallet Features Model

class WalletFeatureName {
  String name;
  IconData icon;
  String route;
  Color shadowColor;

  WalletFeatureName(this.name, this.icon, this.route, this.shadowColor);
}

// Pair decimal config

class PairDecimalConfig {
  String _name;
  int _priceDecimal;
  int _qtyDecimal;

  PairDecimalConfig({
    String name,
    int priceDecimal,
    int qtyDecimal,
  }) {
    this._priceDecimal = priceDecimal ?? 0;
    this._qtyDecimal = qtyDecimal ?? 0;

    this._name = name;
  }

  Map<String, dynamic> toJson() => {
        'priceDecimal': _priceDecimal,
        'qtyDecimal': _qtyDecimal,
        'name': _name,
      };

  factory PairDecimalConfig.fromJson(Map<String, dynamic> json) {
    return new PairDecimalConfig(
        priceDecimal: json['priceDecimal'],
        qtyDecimal: json['qtyDecimal'],
        name: json['name']);
  }

  int get priceDecimal => _priceDecimal;
  set priceDecimal(int priceDecimal) {
    this._priceDecimal = priceDecimal;
  }

  int get qtyDecimal => _qtyDecimal;

  set qtyDecimal(int qtyDecimal) {
    this._qtyDecimal = qtyDecimal;
  }

  String get name => _name;

  set name(String name) {
    this._name = name;
  }
}

class PairDecimalConfigList {
  final List<PairDecimalConfig> pairList;
  PairDecimalConfigList({this.pairList});

  factory PairDecimalConfigList.fromJson(List<dynamic> parsedJson) {
    List<PairDecimalConfig> pairList = new List<PairDecimalConfig>();
    pairList = parsedJson.map((i) => PairDecimalConfig.fromJson(i)).toList();
    return new PairDecimalConfigList(pairList: pairList);
  }
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
  PairDecimalConfig _pairDecimalConfig;

  WalletInfo(
      {int id,
      String tickerName,
      String tokenType,
      String address,
      double lockedBalance,
      double availableBalance,
      double usdValue,
      String name,
      double inExchange,
      PairDecimalConfig pairDecimalConfig}) {
    this._id = id;
    this._tickerName = tickerName;
    this._tokenType = tokenType;
    this._address = address;
    this._lockedBalance = lockedBalance ?? 0.0;
    this._availableBalance = availableBalance ?? 0.0;
    this._usdValue = usdValue ?? 0.0;
    this._name = name;
    this._inExchange = inExchange ?? 0.0;
    this._pairDecimalConfig = pairDecimalConfig;
  }

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    PairDecimalConfig pairDecimalConfig;
    return WalletInfo(
        id: json['id'] as int,
        tickerName: json['tickerName'] as String,
        tokenType: json['tokenType'] as String,
        address: json['address'] as String,
        lockedBalance: json['lockedBalance'],
        availableBalance: json['availableBalance'] as double,
        usdValue: json['usdValue'] as double,
        name: json['name'] as String,
        inExchange: json['inExchange'] as double,
        pairDecimalConfig: pairDecimalConfig);
  }

// todo: create new wallet balances model

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

    //   data['pairDecimalConfig'] = this._pairDecimalConfig.toJson();

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
    this._availableBalance = availableBalance;
  }

  double get usdValue => _usdValue;

  set usdValue(double usdValue) {
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
    List<WalletInfo> wallets = new List<WalletInfo>();
    wallets = parsedJson.map((i) => WalletInfo.fromJson(i)).toList();
    return new WalletInfoList(wallets: wallets);
  }
}
