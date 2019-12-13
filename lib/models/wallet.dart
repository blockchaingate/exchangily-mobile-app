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

// Wallet Model

class WalletInfo {
  String _tickerName;
  String _address;
  double _availableBalance;
  double _usdValue;
  Color _logoColor;
  String _name;

  WalletInfo(
      {String tickerName,
      String address,
      double availableBalance,
      double usdValue,
      Color logoColor,
      String name}) {
    this._tickerName = tickerName;
    this._address = address;
    this._availableBalance = availableBalance ?? 0;
    this._usdValue = usdValue ?? 0;
    this._logoColor = logoColor;
    this._name = name;
  }

  String get tickerName => _tickerName;

  set ticketName(String tickerName) {
    this._tickerName = tickerName;
  }

  String get address => _address;

  set address(String address) {
    this._address = address;
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

  Color get logoColor => _logoColor;

  set logoColor(Color logoColor) {
    this._logoColor = logoColor;
  }
}
