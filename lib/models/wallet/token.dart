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

class Token {
  int _id;
  int _decimal;
  String _coinName;
  String _chainName;
  String _tickerName;
  int _tokenType;
  String _contract;
  int _minWithdraw;
  int _feeWithdraw;

  Token(
      {int id,
      int decimal,
      String coinName,
      String tickerName,
      String chainName,
      int tokenType,
      String contract,
      int minWithdraw,
      int feeWithdraw}) {
    this._id = id;
    this._decimal = decimal;
    this._coinName = coinName;
    this._chainName = chainName;
    this._tickerName = tickerName;
    this._tokenType = tokenType;
    this._contract = contract;
    this._minWithdraw = minWithdraw;
    this._feeWithdraw = feeWithdraw;
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
        coinName: json['coinName'] as String,
        chainName: json['chainName'] as String,
        tokenType: json['type'] as int,
        contract: json['contract'] as String,
        minWithdraw: json['minWithdraw'],
        feeWithdraw: json['feeWithdraw']);
  }

  // To json

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['decimal'] = this._decimal;
    data['tickerName'] = this._tickerName;
    data['coinName'] = this._coinName;
    data['chainName'] = this._chainName;
    data['type'] = this._tokenType;
    data['contract'] = this._contract;
    data['minWithdraw'] = this._minWithdraw;
    data['feeWithdraw'] = this._feeWithdraw;
    return data;
  }

  int get id => _id;

  set id(int id) {
    this._id = id;
  }

  int get decimal => _decimal;

  set decimal(int decimal) {
    this._decimal = decimal;
  }

  String get coinName => _coinName;

  set coinName(String coinName) {
    this._coinName = coinName;
  }

  String get chainName => _chainName;

  set chainName(String chainName) {
    this._chainName = chainName;
  }

  String get tickerName => _tickerName;

  set tickerName(String tickerName) {
    this._tickerName = tickerName;
  }

  int get tokenType => _tokenType;

  set tokenType(int tokenType) {
    this._tokenType = tokenType;
  }

  String get contract => _contract;

  set contract(String contract) {
    this._contract = contract;
  }

  int get minWithdraw => _minWithdraw;

  set minWithdraw(int minWithdraw) {
    this._minWithdraw = minWithdraw;
  }

  int get feeWithdraw => _feeWithdraw;

  set feeWithdraw(int feeWithdraw) {
    this._feeWithdraw = feeWithdraw;
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
