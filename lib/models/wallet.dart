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
  double _lockedBalance;
  double _availableBalance;
  double _usdValue;
  Color _logoColor;
  String _name;
  double _assetsInExchange;

  Map<String, dynamic> toJson() => _itemToJson(this);
  WalletInfo(
      {String tickerName,
      String address,
      double lockedBalance,
      double availableBalance,
      double usdValue,
      Color logoColor,
      String name,
      double assetsInExchange}) {
    this._tickerName = tickerName;
    this._address = address;
    this._lockedBalance = lockedBalance ?? 0;
    this._availableBalance = availableBalance ?? 0;
    this._usdValue = usdValue ?? 0;
    this._logoColor = logoColor;
    this._name = name;
    this._assetsInExchange = assetsInExchange;
  }

  Map<String, dynamic> _itemToJson(WalletInfo walletInfo) {
    return <String, dynamic>{
      'tickerName': walletInfo._tickerName,
      'address': walletInfo._address,
      'lockedBalance': walletInfo._lockedBalance,
      'availableBalance': walletInfo._availableBalance,
      'usdValue': walletInfo._usdValue,
      'logoColor': walletInfo._logoColor,
      'name': walletInfo._name,
      'assetsInExchange': walletInfo._assetsInExchange,
    };
  }
  // WalletInfo.fromJson(Map<String, dynamic> data)
  //     : _tickerName = data['tickerName'],
  //       _address = data['address'],
  //       _lockedBalance = data['lockedBalance'],
  //       _availableBalance = data['availableBalance'],
  //       _usdValue = data['tickerName'],
  //       _logoColor = data['logoColor'],
  //       _name = data['name'],
  //       _assetsInExchange = data['assetsInExchange'];

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

  double get assetsInExchange => _assetsInExchange;
  set assetsInExchange(double assetsInExchange) {
    this._assetsInExchange = assetsInExchange;
  }

  Color get logoColor => _logoColor;

  set logoColor(Color logoColor) {
    this._logoColor = logoColor;
  }
}
