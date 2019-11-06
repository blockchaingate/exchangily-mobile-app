import 'package:flutter/material.dart';

class WithdrawToWalletScreen extends StatelessWidget {
  const WithdrawToWalletScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw to Wallet'),
        centerTitle: true,
      ),
    );
  }
}
