import 'package:bip32/bip32.dart';
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

// Coin type
class CoinType {
  String tickerName;
  BIP32 childType;

  CoinType(this.tickerName, this.childType);
}

// Class Wallet

class Wallet {
  String id;
  String name;
  String pwdHash;
  String pinHash;
  String encryptedSeed;
  String encryptedMnemonic;
  DateTime dateCreated;
  DateTime lastUpdated;
}

// My Coin
