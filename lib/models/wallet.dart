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
      String tickerName,
      String tokenType,
      String address,
      //  double lockedBalance,
      double availableBalance,
      double usdValue,
      //   Color logoColor,
      String name,
      double assetsInExchange) {
    this._tickerName = tickerName;
    this._tokenType = tokenType;
    this._address = address;
    //   this._lockedBalance = lockedBalance ?? 0.0;
    this._availableBalance = availableBalance;
    this._usdValue = usdValue;
    // this._logoColor = logoColor;
    this._name = name;
    this._assetsInExchange = assetsInExchange;
  }

  Map<String, dynamic> toJson() => {
        'tickerName': _tickerName,
        'tokenType': _tokenType,
        'address': _address,
        //   'lockedBalance': _lockedBalance ?? 0.0,
        'availableBalance': _availableBalance,
        'usdValue': _usdValue,
        //  'logoColor': _logoColor,
        'name': _name,
        'assetsInExchange': _assetsInExchange,
      };

  WalletInfo.fromJson(Map<String, dynamic> data)
      : _tickerName = data['tickerName'] as String,
        _tokenType = data['tokenType'] as String,
        _address = data['address'] as String,
        //   _lockedBalance = data['lockedBalance'] ?? 0.0,
        _availableBalance = data['availableBalance'] as double,
        _usdValue = data['useValue'] as double,
        //  _logoColor = data['logoColor'],
        _name = data['name'] as String,
        _assetsInExchange = data['assetsInExchange'] as double;

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
  WalletInfoList(this.wallets);

  WalletInfoList.fromJson(Map<String, dynamic> json)
      : wallets = json['wallets'] != null
            ? List<WalletInfo>.from(json['wallets'])
            : null;

  Map<String, dynamic> toJson() => {'wallets': wallets};
}
