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

class Token {
  int _decimal;
  String _name;
  String _tickerName;
  String _tokenType;
  String _contract;
  int _minWithdraw;
  int _feeWithdraw;

  Token(
      {int decimal,
      String name,
      String tickerName,
      String tokenType,
      String contract,
      int minwithdraw,
      int feewithdraw}) {
    this._decimal = decimal;
    this._name = name;
    this._tickerName = tickerName;
    this._tokenType = tokenType;
    this._contract = contract;
    this._minWithdraw = _minWithdraw;
    this._feeWithdraw = feewithdraw;
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    // List<PairDecimalConfig> pairDecimalConfigList = [];
    // var pairDecimalConfigJsonAsList = json['pairDecimalConfig'] as List;
    // if (pairDecimalConfigJsonAsList != null) {
    //   pairDecimalConfigList = pairDecimalConfigJsonAsList
    //       .map((e) => PairDecimalConfig.fromJson(e))
    //       .toList();
    // }

    return new Token(
        decimal: json['decimal'] as int,
        tickerName: json['tickerName'] as String,
        tokenType: json['tokenType'] as String,
        contract: json['contract'] as String,
        minwithdraw: json['minwithdraw'],
        feewithdraw: json['feeWithdraw']);
  }

  // To json

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['decimal'] = this._decimal;
    data['tickerName'] = this._tickerName;
    data['tokenType'] = this._tokenType;
    data['contract'] = this._contract;
    data['minwithdraw'] = this._minWithdraw;
    data['feeWithdraw'] = this._feeWithdraw;
    return data;
  }

  int get decimal => _decimal;

  set decimal(int decimal) {
    this._decimal = decimal;
  }

  String get name => _name;

  set name(String name) {
    this.name = name;
  }

  String get tickerName => _tickerName;

  set tickerName(String tickerName) {
    this._tickerName = tickerName;
  }

  String get tokenType => _tokenType;

  set tokenType(String tokenType) {
    this._tokenType = tokenType;
  }

  String get contract => _contract;

  set contract(String contract) {
    this._contract = contract;
  }

  int get minwithdraw => minwithdraw;

  set minwithdraw(int minwithdraw) {
    this.minwithdraw = minwithdraw;
  }

  int get feeWithdraw => feeWithdraw;

  set feeWithdraw(int feeWithdraw) {
    this.feeWithdraw = feeWithdraw;
  }
}

class TokenList {
  final List<Token> tokens;
  TokenList({this.tokens});

  factory TokenList.fromJson(List<dynamic> parsedJson) {
    List<Token> tokens = new List<Token>();
    tokens = parsedJson.map((i) => Token.fromJson(i)).toList();
    return new TokenList(tokens: tokens);
  }
}
