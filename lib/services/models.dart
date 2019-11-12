import 'package:flutter/material.dart';

// Wallet Features Model

class WalletFeatures {
  String name;
  IconData icon;
  String route;

  WalletFeatures(this.name, this.icon, this.route);
}

// Wallet Model

class WalletInfo {
  String tickerName;
  String name;
  String address;
  double availableBalance;
  double usdValue;
  Color logoColor;

  WalletInfo(this.tickerName, this.address, this.availableBalance,
      this.usdValue, this.logoColor, this.name);
}
