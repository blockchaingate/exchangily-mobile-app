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

class TokenModel {
  int _id;
  int _decimal;
  String _coinName;
  String _chainName;
  String _tickerName;
  int _tokenType;
  String _contract;
  String _minWithdraw;
  String _feeWithdraw;

  TokenModel(
      {int id,
      int decimal,
      String coinName,
      String tickerName,
      String chainName,
      int tokenType,
      String contract,
      String minWithdraw,
      String feeWithdraw}) {
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

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    var mw = json['minWithdraw'];
    String minWithdraw = mw.toString();

    var fw = json['feeWithdraw'];
    String feeWithdraw = fw.toString();

    return new TokenModel(
        decimal: json['decimal'] as int,
        tickerName: json['tickerName'] as String,
        coinName: json['coinName'] as String,
        chainName: json['chainName'] as String,
        tokenType: json['type'] as int,
        contract: json['contract'] as String,
        minWithdraw: minWithdraw,
        feeWithdraw: feeWithdraw);
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

  void clear() {
    this._id = null;
    this._decimal = null;
    this._coinName = '';
    this._chainName = '';
    this._tickerName = '';
    this._tokenType = null;
    this._contract = '';
    this._minWithdraw = '';
    this._feeWithdraw = '';
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

  int get coinType => _tokenType;

  set coinType(int tokenType) {
    this._tokenType = tokenType;
  }

  String get contract => _contract;

  set contract(String contract) {
    this._contract = contract;
  }

  String get minWithdraw => _minWithdraw;

  set minWithdraw(String minWithdraw) {
    this._minWithdraw = minWithdraw;
  }

  String get feeWithdraw => _feeWithdraw;

  set feeWithdraw(String feeWithdraw) {
    this._feeWithdraw = feeWithdraw;
  }
}

class TokenList {
  final List<TokenModel> tokens;
  TokenList({this.tokens});

  factory TokenList.fromJson(List<dynamic> parsedJson) {
    List<TokenModel> tokens = [];
    tokens = parsedJson.map((i) => TokenModel.fromJson(i)).toList();
    return new TokenList(tokens: tokens);
  }
}
