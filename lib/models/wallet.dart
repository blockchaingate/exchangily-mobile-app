import 'package:bip32/bip32.dart';
import 'package:flutter/material.dart';

// Wallet Features Model

class WalletFeatureName {
  String name;
  IconData icon;
  String route;
  Color shadowColor;

  WalletFeatureName(this.name, this.icon, this.route, this.shadowColor);
}

class CoinName {
  final String name;
  final CoinUsdValue coinUsdValue;

  const CoinName({this.name, this.coinUsdValue});

  factory CoinName.fromJson(Map<String, dynamic> data) {
    return CoinName(
        name: data['name'],
        coinUsdValue: CoinUsdValue.fromJson(data['coinUsdValue']));
  }
}

class CoinUsdValue {
  final String usd;
  final double value;

  const CoinUsdValue({this.usd, this.value});

  factory CoinUsdValue.fromJson(Map<String, dynamic> data) {
    return CoinUsdValue(usd: data['usd'], value: data['value']);
  }
}

// Wallet Model

class WalletInfo {
  // final int _id;
  String _tickerName;
  String _tokenType;
  String _address;
  // double _lockedBalance;
  double _availableBalance;
  double _usdValue;
//  Color _logoColor;
  String _name;
  double _assetsInExchange;

  WalletInfo(
      {
      //int id,
      String tickerName,
      String tokenType,
      String address,
      //  double lockedBalance,
      double availableBalance,
      double usdValue,
      //   Color logoColor,
      String name,
      double assetsInExchange}) {
    this._tickerName = tickerName;
    this._tokenType = tokenType;
    this._address = address;
    // this._lockedBalance = lockedBalance;
    this._availableBalance = availableBalance;
    this._usdValue = usdValue;
    // this._logoColor = logoColor;
    this._name = name;
    this._assetsInExchange = assetsInExchange ?? 0.0;
  }

  Map<String, dynamic> toJson() => {
        'tickerName': _tickerName,
        'tokenType': _tokenType,
        'address': _address,
        //  'lockedBalance': _lockedBalance,
        'availableBalance': _availableBalance,
        'usdValue': _usdValue,
        //  'logoColor': _logoColor,
        'name': _name,
        'assetsInExchange': _assetsInExchange,
      };

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return new WalletInfo(
        tickerName: json['tickerName'] as String,
        tokenType: json['tokenType'] as String,
        address: json['address'] as String,
        //  lockedBalance: json['lockedBalance'],
        availableBalance: json['availableBalance'] as double,
        usdValue: json['usdValue'] as double,
        //  _logoColor : json['logoColor'],
        name: json['name'] as String,
        assetsInExchange: json['assetsInExchange'] as double);
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

  // double get lockedBalance => _lockedBalance;
  // set lockedBalance(double lockedBalance) {
  //   this._lockedBalance = lockedBalance;
  // }

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

  double get assetsInExchange => _assetsInExchange;
  set assetsInExchange(double assetsInExchange) {
    this._assetsInExchange = assetsInExchange;
  }

  // Color get logoColor => _logoColor;

  // set logoColor(Color logoColor) {
  //   this._logoColor = logoColor;
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

class Test {
  final int id;
  final String name;
  final int age;

  Test({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }
}
