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
  String coinName;
  String address;
  double availableBalance;
  double usdValue;
  Color logoColor;

  WalletInfo(this.coinName, this.address, this.availableBalance, this.usdValue,
      this.logoColor);
}
