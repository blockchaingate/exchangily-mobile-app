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
  int? _id;
  int? _decimal;
  String? _coinName;
  String? _chainName;
  String? _tickerName;
  int? _tokenType;
  String? _contract;
  String? _minWithdraw;
  String? _feeWithdraw;

  TokenModel(
      {int? id,
      int? decimal,
      String? coinName,
      String? tickerName,
      String? chainName,
      int? tokenType,
      String? contract,
      String? minWithdraw,
      String? feeWithdraw}) {
    _id = id;
    _decimal = decimal;
    _coinName = coinName;
    _chainName = chainName;
    _tickerName = tickerName;
    _tokenType = tokenType;
    _contract = contract;
    _minWithdraw = minWithdraw;
    _feeWithdraw = feeWithdraw;
  }

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    var mw = json['minWithdraw'];
    String minWithdraw = mw.toString();

    var fw = json['feeWithdraw'];
    String feeWithdraw = fw.toString();

    return TokenModel(
        decimal: json['decimal'] as int?,
        tickerName: json['tickerName'] as String?,
        coinName: json['coinName'] as String?,
        chainName: json['chainName'] as String?,
        tokenType: json['type'] as int?,
        contract: json['contract'] as String?,
        minWithdraw: minWithdraw,
        feeWithdraw: feeWithdraw);
  }

  // To json

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['decimal'] = _decimal;
    data['tickerName'] = _tickerName;
    data['coinName'] = _coinName;
    data['chainName'] = _chainName;
    data['type'] = _tokenType;
    data['contract'] = _contract;
    data['minWithdraw'] = _minWithdraw;
    data['feeWithdraw'] = _feeWithdraw;
    return data;
  }

  void clear() {
    _id = null;
    _decimal = null;
    _coinName = '';
    _chainName = '';
    _tickerName = '';
    _tokenType = null;
    _contract = '';
    _minWithdraw = '';
    _feeWithdraw = '';
  }

  int? get id => _id;

  set id(int? id) {
    _id = id;
  }

  int? get decimal => _decimal;

  set decimal(int? decimal) {
    _decimal = decimal;
  }

  String? get coinName => _coinName;

  set coinName(String? coinName) {
    _coinName = coinName;
  }

  String? get chainName => _chainName;

  set chainName(String? chainName) {
    _chainName = chainName;
  }

  String? get tickerName => _tickerName;

  set tickerName(String? tickerName) {
    _tickerName = tickerName;
  }

  int? get coinType => _tokenType;

  set coinType(int? tokenType) {
    _tokenType = tokenType;
  }

  String? get contract => _contract;

  set contract(String? contract) {
    _contract = contract;
  }

  String? get minWithdraw => _minWithdraw;

  set minWithdraw(String? minWithdraw) {
    _minWithdraw = minWithdraw;
  }

  String? get feeWithdraw => _feeWithdraw;

  set feeWithdraw(String? feeWithdraw) {
    _feeWithdraw = feeWithdraw;
  }
}

class TokenList {
  final List<TokenModel>? tokens;
  TokenList({this.tokens});

  factory TokenList.fromJson(List<dynamic> parsedJson) {
    List<TokenModel> tokens = [];
    tokens = parsedJson.map((i) => TokenModel.fromJson(i)).toList();
    return TokenList(tokens: tokens);
  }
}
