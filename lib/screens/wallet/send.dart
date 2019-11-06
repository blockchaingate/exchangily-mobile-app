import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class SendWalletScreen extends StatelessWidget {
  const SendWalletScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add),
                hintText: 'Wallet Address',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
                decoration: InputDecoration(
                    hintText: '0.00000', labelText: 'Balance:6024849.000 EXG')),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[Text('Gas Fee'), Text('0.000033')],
                ),
                Row(
                  children: <Widget>[
                    Text('Advanced'),
                    ToggleButtons(
                      onPressed: (void t) {
                        print('toggle');
                      },
                      children: <Widget>[],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
