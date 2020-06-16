import 'package:flutter/material.dart';

class BuySellView extends StatelessWidget {
  const BuySellView({Key key, this.bidOrAsk, this.pair}) : super(key: key);
  final bool bidOrAsk;
  final String pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('in buy sell'),
    );
  }
}
