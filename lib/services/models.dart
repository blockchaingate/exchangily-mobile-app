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
  String name;
  String address;
  double availableBalance;
  double usdValue;

  WalletInfo(this.name, this.address, this.availableBalance, this.usdValue);
}
