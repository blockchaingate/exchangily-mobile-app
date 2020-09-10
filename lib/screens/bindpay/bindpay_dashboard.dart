import 'package:flutter/material.dart';

class BindpayDashboardView extends StatelessWidget {
  const BindpayDashboardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bindpay'), centerTitle: true),
      body: Container(
        child: Center(
          child: Text('BINDPAY'),
        ),
      ),
    );
  }
}
